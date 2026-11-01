// IA: Expose only authenticated Prompt'd calls, never Firebase emulator/admin ports.
import { createServer } from 'node:http';
import { createHash } from 'node:crypto';
import { initializeApp, getApps } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { PromptError, fail } from '../src/errors.mjs';
import { validate, validateProfile } from '../src/validation.mjs';
import config from '../shared/config.json' with { type: 'json' };
const routes = new Set(['getPromptConfiguration', 'generatePromptExamples', 'generateNextPrompts', 'submitPromptFeedback']);
const statuses = { 'invalid-argument': 400, unauthenticated: 401, 'permission-denied': 403, 'not-found': 404, aborted: 409, 'already-exists': 409, 'failed-precondition': 400, 'resource-exhausted': 429, unavailable: 503 };
const digest = value => createHash('sha256').update(JSON.stringify(value)).digest('hex');
export function createTokenVerifier(projectId) {
  // IA: A public tunnel must verify real signatures; emulator tokens are not trusted.
  if (process.env.FIREBASE_AUTH_EMULATOR_HOST || !projectId || projectId.startsWith('demo-')) {
    throw Error('PC sharing requires real Firebase Authentication, not an auth emulator.');
  }
  const name = `promptd-host-${projectId}`;
  const app = getApps().find(a => a.name === name) ?? initializeApp({ projectId }, name);
  return token => getAuth(app).verifyIdToken(token);
}
function reply(res, status, data) {
  res.writeHead(status, { 'Content-Type': 'application/json', 'Cache-Control': 'no-store', 'X-Content-Type-Options': 'nosniff' });
  res.end(JSON.stringify(data));
}
async function bodyOf(req) {
  if (!/^application\/json(?:;|$)/i.test(req.headers['content-type'] || '')) fail('invalid-argument', 'Send JSON data.');
  let bytes = 0; const chunks = [];
  for await (const chunk of req) {
    bytes += chunk.length;
    if (bytes > 65536) fail('invalid-argument', 'Request is too large.');
    chunks.push(chunk);
  }
  let body;
  try { body = JSON.parse(Buffer.concat(chunks).toString('utf8')); } catch { fail('invalid-argument', 'Invalid JSON.'); }
  if (!body || typeof body !== 'object' || Array.isArray(body) || Object.keys(body).length !== 1 || !Object.hasOwn(body, 'data')) fail('invalid-argument', 'Send one callable data object.');
  return body.data;
}
export function createHostServer({ service, store, verifyToken, projectId, allowedUids = [], dailyLimit = 100, maxConcurrent = 3, clock = Date.now }) {
  let generating = 0;
  const allowed = new Set(allowedUids);
  const server = createServer(async (req, res) => {
    let claimed = false;
    try {
      if (req.method === 'GET' && req.url === '/health') return reply(res, 200, { service: 'promptd-host', status: 'ok' });
      const route = req.url?.slice(1);
      if (req.method !== 'POST' || !routes.has(route)) return reply(res, 404, { error: { status: 'NOT_FOUND', message: 'Not found.' } });
      const bearer = /^Bearer ([^\s]+)$/.exec(req.headers.authorization || '');
      if (!bearer) fail('unauthenticated', 'Sign into Socialdeck first.');
      let user;
      try { user = await verifyToken(bearer[1]); } catch { fail('unauthenticated', 'Sign in again before using AI setup.'); }
      if (!user?.uid || user.aud !== projectId || user.iss !== `https://securetoken.google.com/${projectId}` || !user.firebase?.sign_in_provider || user.firebase.sign_in_provider === 'anonymous') fail('unauthenticated', 'Use your Socialdeck account.');
      if (allowed.size && !allowed.has(user.uid)) fail('permission-denied', 'This account is not enabled for this test server.');
      const data = await bodyOf(req);
      if (route === 'getPromptConfiguration') {
        validate('configurationRequest', data);
        return reply(res, 200, { result: { contractVersion: 1, groups: config.groups, more: config.more, less: config.less, styles: Object.fromEntries(Object.entries(config.styles).map(([id, { label, desc, icon }]) => [id, { label, desc, icon }])), reasons: config.reasons } });
      }
      let result;
      if (route === 'submitPromptFeedback') result = await service.feedback(user.uid, data);
      else {
        const more = route === 'generateNextPrompts';
        validate(more ? 'nextRequest' : 'generationRequest', data);
        if (!more) validateProfile(data.profile);
        if (generating >= maxConcurrent) fail('resource-exhausted', 'The shared AI server is busy. Retry shortly; your reviews are kept.');
        // IA: One shared PC budget protects the host's key across all signed-in testers.
        // Cached replies do not spend another allowance; failed generation attempts do.
        const day = new Date(clock()).toISOString().slice(0, 10);
        store.transact([`hostBudget/${day}`, `promptdRequests/${digest([user.uid, data.requestId])}`], ([budget, previous]) => {
          if (previous?.response) return { result: null };
          if ((budget?.count ?? 0) >= dailyLimit) fail('resource-exhausted', 'The shared AI server has reached its daily testing limit.');
          return { result: null, writes: [{ count: (budget?.count ?? 0) + 1 }] };
        });
        generating++; claimed = true;
        result = await service.generate(user.uid, data, more);
      }
      reply(res, 200, { result });
    } catch (error) {
      // IA: Never return provider responses, keys, user tokens or internal file paths.
      const code = error instanceof PromptError && statuses[error.code] ? error.code : 'internal';
      // IA: Log only error category/location for host troubleshooting, never payloads or keys.
      if (code === 'internal') console.error('Promptd host error', error.code || error.name, error.stack?.split('\n').slice(1, 3).join(' '));
      if (!res.headersSent && !res.destroyed) reply(res, statuses[code] || 500, { error: { status: code.replaceAll('-', '_').toUpperCase(), message: code === 'internal' ? 'The AI service could not complete this request. Retry shortly.' : error.message } });
    } finally { if (claimed) generating--; }
  });
  server.requestTimeout = 15000;
  server.headersTimeout = 10000;
  server.setTimeout(100000, socket => socket.destroy());
  server.maxConnections = 50;
  return server;
}
