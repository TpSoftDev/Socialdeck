// IA: Verify the public PC wrapper, private persistent sessions and unchanged AI workflow.
import test from 'node:test';
import assert from 'node:assert/strict';
import { once } from 'node:events';
import { randomUUID } from 'node:crypto';
import { mkdtempSync, rmSync, rmdirSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { LocalStore } from '../host/local-store.mjs';
import { createHostServer, createTokenVerifier } from '../host/server.mjs';
import { PromptService } from '../src/service.mjs';
const projectId = 'socialdeck-dev';
const claims = uid => ({ uid, aud: projectId, iss: `https://securetoken.google.com/${projectId}`, firebase: { sign_in_provider: 'google.com' } });
const profile = { contractVersion: 1, groupTypes: ['close_friends'], groupNote: '', groupDescription: 'College friends', styleLevel: 'bold', moreOf: ['funny'], moreOfNote: '', lessOf: [], lessOfNote: '', safeMode: true, averageAge: 22 };
const request = () => ({ contractVersion: 1, requestId: randomUUID(), mode: 'examples', count: 5, profile });
async function setup(t, options = {}) {
  const store = options.store ?? new LocalStore(':memory:');
  const service = options.service ?? { generate: async () => ({ marker: 'generated' }), feedback: async () => ({ marker: 'feedback' }) };
  const verifyToken = options.verifyToken ?? (async token => { if (!['alice', 'bob'].includes(token)) throw Error('Bad token'); return claims(token); });
  const server = createHostServer({ store, service, verifyToken, projectId, ...options });
  server.listen(0, '127.0.0.1'); await once(server, 'listening');
  t.after(async () => { server.closeAllConnections(); await new Promise(resolve => server.close(resolve)); store.close(); });
  const base = `http://127.0.0.1:${server.address().port}`;
  return { store, server, base, post: (route, data, token = 'alice') => fetch(`${base}/${route}`, { method: 'POST', headers: { 'Content-Type': 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) }, body: JSON.stringify({ data }) }) };
}
test('PC wrapper requires real-account claims and denies missing/bad/anonymous/wrong-project tokens', async t => {
  let calls = 0;
  const { post } = await setup(t, { service: { generate: async () => { calls++; } }, verifyToken: async token => {
    if (token === 'bad') throw Error('bad signature');
    if (token === 'anonymous') return { ...claims('anon'), firebase: { sign_in_provider: 'anonymous' } };
    if (token === 'other-project') return { ...claims('x'), aud: 'other-project' };
    return claims(token);
  } });
  for (const token of ['', 'bad', 'anonymous', 'other-project']) assert.equal((await post('generatePromptExamples', request(), token)).status, 401);
  assert.equal(calls, 0);
});
test('PC wrapper enforces optional tester list and exposes no files/admin endpoints', async t => {
  const { post, base } = await setup(t, { allowedUids: ['alice'] });
  assert.equal((await post('getPromptConfiguration', { contractVersion: 1 }, 'bob')).status, 403);
  assert.equal((await post('getPromptConfiguration', { contractVersion: 1 })).status, 200);
  for (const path of ['/.secret.local', '/src/index.mjs', '/__admin', '/shutdown']) assert.equal((await fetch(base + path)).status, 404);
  assert.deepEqual(await (await fetch(base + '/health')).json(), { service: 'promptd-host', status: 'ok' });
});
test('PC wrapper rejects invalid requests before generation and hides internal errors', async t => {
  const { post } = await setup(t, { service: { generate: async () => { throw Error('private-provider-key-and-profile'); } } });
  assert.equal((await post('generatePromptExamples', {})).status, 400);
  const response = await post('generatePromptExamples', request());
  assert.equal(response.status, 500);
  assert.equal((await response.text()).includes('private-provider'), false);
});
test('PC-wide daily budget applies across accounts while feedback remains available', async t => {
  const { post } = await setup(t, { dailyLimit: 1 });
  assert.equal((await post('generatePromptExamples', request())).status, 200);
  assert.equal((await post('generatePromptExamples', request(), 'bob')).status, 429);
  assert.equal((await post('submitPromptFeedback', { test: true })).status, 200);
});
test('PC concurrency cap recovers after a slow generation finishes', async t => {
  let release, entered;
  const wait = new Promise(resolve => { entered = resolve; });
  const service = { generate: () => { entered(); return new Promise(resolve => { release = resolve; }); } };
  const { post } = await setup(t, { maxConcurrent: 1, service });
  const first = post('generatePromptExamples', request()); await wait;
  assert.equal((await post('generatePromptExamples', request(), 'bob')).status, 429);
  release({ ok: true }); assert.equal((await first).status, 200);
  service.generate = async () => ({ ok: true });
  assert.equal((await post('generatePromptExamples', request(), 'bob')).status, 200);
});
test('SQLite store preserves records across reopening, rolls back and expires records', () => {
  const dir = mkdtempSync(join(tmpdir(), 'promptd-store-test-'));
  const file = join(dir, 'sessions.sqlite'); let now = 1000;
  let store = new LocalStore(file, () => now);
  try {
    store.transact(['a'], () => ({ result: null, writes: [{ approved: ['same text'] }] }));
    assert.throws(() => store.transact(['a', 'b'], () => ({ result: null, writes: [{ approved: [] }, undefined] })));
    store.close(); store = new LocalStore(file, () => now);
    assert.deepEqual(store.transact(['a'], ([value]) => ({ result: value })), { approved: ['same text'] });
    now += 86400001; store.cleanup();
    assert.equal(store.transact(['a'], ([value]) => ({ result: value })), null);
  } finally {
    store.close();
    for (const suffix of ['', '-wal', '-shm']) rmSync(file + suffix, { force: true });
    rmdirSync(dir);
  }
});
test('real Firebase verifier rejects unsigned tokens and refuses auth-emulator mode', async () => {
  const old = process.env.FIREBASE_AUTH_EMULATOR_HOST;
  try {
    process.env.FIREBASE_AUTH_EMULATOR_HOST = 'localhost:9099';
    assert.throws(() => createTokenVerifier(projectId), /real Firebase/);
    delete process.env.FIREBASE_AUTH_EMULATOR_HOST;
    const verify = createTokenVerifier(projectId);
    const encode = value => Buffer.from(JSON.stringify(value)).toString('base64url');
    await assert.rejects(verify(`${encode({ alg: 'none' })}.${encode(claims('forged'))}.`));
  } finally { if (old === undefined) delete process.env.FIREBASE_AUTH_EMULATOR_HOST; else process.env.FIREBASE_AUTH_EMULATOR_HOST = old; }
});
test('PC API generates five, replaces only rejected one, caches retries and isolates players', async t => {
  let now = Date.now();
  const store = new LocalStore(':memory:', () => now);
  const texts = ['A sandwich with an ambitious filling.', 'Sunlight making a window look cinematic.', 'A forgotten souvenir from a memorable trip.', 'A tiny plant thriving in an unexpected place.', 'A colorful mural on an ordinary street.'];
  let generated = 0;
  const provider = { model: 'test-model', generate: async context => { generated++; return context.count === 1 ? ['A snack arranged like a masterpiece.'] : texts; }, review: async (_, candidate) => ({ approved: true, topicTags: candidate.map(() => ['Campus life']) }) };
  const service = new PromptService({ store, provider, clock: () => now });
  const { post } = await setup(t, { store, service, clock: () => now, dailyLimit: 2 });
  const data = request();
  const first = (await (await post('generatePromptExamples', data)).json()).result;
  assert.equal(first.prompts.length, 5);
  for (let i = 0; i < 5; i++) {
    const response = await post('submitPromptFeedback', { contractVersion: 1, requestId: randomUUID(), sessionId: first.id, promptId: first.prompts[i].id, accepted: i < 4, reasons: i < 4 ? [] : ['too_generic'], explanation: i < 4 ? '' : 'More specific.' });
    assert.equal(response.status, 200);
  }
  now += 3000;
  const replacement = (await (await post('generateNextPrompts', { contractVersion: 1, requestId: randomUUID(), sessionId: first.id, count: 5, replaceRejected: true })).json()).result;
  assert.deepEqual(replacement.prompts.slice(0, 4), first.prompts.slice(0, 4));
  assert.notEqual(replacement.prompts[4].id, first.prompts[4].id);
  assert.deepEqual(replacement.prompts[4].topics, ['Campus life']);
  assert.equal((await post('generatePromptExamples', data)).status, 200);
  assert.equal(generated, 2);
  assert.equal((await post('submitPromptFeedback', { contractVersion: 1, requestId: randomUUID(), sessionId: first.id, promptId: first.prompts[0].id, accepted: true, reasons: [], explanation: '' }, 'bob')).status, 403);
});
