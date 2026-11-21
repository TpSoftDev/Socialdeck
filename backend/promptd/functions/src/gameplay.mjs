// IA: Local-first gameplay orchestration. This is a trusted server API, NOT a public callable.
// A future Start adapter must authorize the host and atomically freeze the real game roster.
import { createHash, randomUUID } from 'node:crypto';
import { validateProfile } from './validation.mjs';
import { fail } from './errors.mjs';
const fingerprint = value => createHash('sha256').update(JSON.stringify(value)).digest('hex');
const key = id => `promptdGameplay/${id}`;
const validId = id => typeof id === 'string' && /^[a-zA-Z0-9_-]{1,100}$/.test(id);

export function buildGameplayJob({ gameId, playerIds, rounds, session }, now = Date.now()) {
  if (!validId(gameId) || !Array.isArray(playerIds) || ![4,6,8].includes(playerIds.length) ||
    playerIds.some(id => !validId(id)) || new Set(playerIds).size !== playerIds.length ||
    !Number.isInteger(rounds) || rounds < 1 || rounds > 5) {
    fail('invalid-argument', 'Use a unique game ID, 4/6/8 distinct players and 1–5 rounds. Odd-player matchmaking is not decided.');
  }
  validateProfile(session.profile);
  if (!session.effective || !Array.isArray(session.feedback) || !Array.isArray(session.history)) fail('invalid-argument', 'A finalized server-owned prompt session is required.');
  // IA: Preview texts/history are exclusions, not playable prompts. Preserve host feedback.
  const frozen = structuredClone({ playerIds, rounds, session: {
    profile: session.profile, effective: session.effective, feedback: session.feedback,
    history: [...new Set([...session.history, ...(session.prompts ?? []).map(p => p.text)])],
    priorPrompts: session.priorPrompts ?? [],
  }});
  const version = fingerprint(frozen);
  return { gameId, version, ...frozen, count: playerIds.length / 2, ready: [], status: 'preparing', createdAt: now, attempts: {}, failureCount: 0 };
}

export class GameplayPrompts {
  constructor({ store, generator, clock = Date.now }) {
    this.store = store; this.generator = generator; this.clock = clock;
  }
  // IA: Call only on Start, with finalized server-owned settings/feedback, never lobby joins.
  async start({ gameId, playerIds, rounds, session }) {
    const job = buildGameplayJob({gameId, playerIds, rounds, session}, this.clock());
    const version = job.version;
    return this.store.transact([key(gameId)], ([existing]) => {
      if (existing) {
        if (existing.version !== version) fail('failed-precondition', 'This game already started with different settings. Use a new game ID.');
        return { result: existing };
      }
      return { result: job, writes: [job] };
    });
  }
  // IA: Private server read: do not expose unrevealed prompts to clients.
  read(gameId) { return this.store.transact([key(gameId)], ([job]) => ({ result: job })); }
  // IA: An explicit server-authorized retry resets the failure limit, not saved rounds.
  async retry(gameId) {
    return this.store.transact([key(gameId)], ([job]) => {
      if (!job) fail('not-found', 'Game not found.');
      if (job.lock?.until > this.clock()) fail('aborted', 'Preparation is still running.');
      if (job.status !== 'failed') fail('failed-precondition', 'This game does not need an explicit retry.');
      job.status = 'preparing'; job.failureCount = 0; delete job.lastError;
      return { result: job, writes: [job] };
    });
  }
  // IA: One durable unit per round. A future Cloud Tasks adapter must await this method
  // and schedule the next unit; never fire-and-forget after a callable returns.
  async prepareNext(gameId) {
    const token = randomUUID();
    const claim = await this.store.transact([key(gameId)], ([job]) => {
      if (!job) fail('not-found', 'Start the game before preparing prompts.');
      if (job.status === 'complete') return { result: { done: true, job } };
      if (job.status === 'failed') fail('failed-precondition', 'Preparation stopped after repeated failures. Explicit retry is required.');
      if (job.lock?.until > this.clock()) fail('aborted', 'This game already has an active preparation worker.');
      const round = job.ready.length + 1;
      job.lock = { token, until: this.clock() + 120000 };
      job.attempts[round] = (job.attempts[round] ?? 0) + 1;
      return { result: { job, round }, writes: [job] };
    });
    if (claim.done) return claim.job;
    const { job, round } = claim;
    const session = structuredClone(job.session);
    session.history.push(...job.ready.flatMap(r => r.prompts.map(p => p.text)));
    try {
      const result = await this.generator.generateValidated(session, job.count);
      return await this.store.transact([key(gameId)], ([current]) => {
        if (current?.lock?.token !== token) fail('aborted', 'A newer worker owns this game.');
        current.ready.push({ round, readyAt: this.clock(), metadata: result.metadata,
          prompts: result.texts.map((text, i) => ({ id: `${gameId}-r${round}-p${i+1}`, text, topics: result.topicTags?.[i] ?? [] })) });
        delete current.lock; delete current.lastError;
        current.failureCount = 0;
        current.status = current.ready.length === current.rounds ? 'complete' : 'preparing';
        return { result: current, writes: [current] };
      });
    } catch (error) {
      await this.store.transact([key(gameId)], ([current]) => {
        if (current?.lock?.token !== token) return { result: null };
        delete current.lock;
        current.lastError = error.code ?? 'internal';
        current.failureCount++;
        if (current.failureCount >= 3) current.status = 'failed';
        return { result: null, writes: [current] };
      });
      throw error;
    }
  }
}
