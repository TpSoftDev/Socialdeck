// Provider- and database-independent orchestration. All mutations are atomic.
import { createHash, randomUUID } from 'node:crypto';
import config from '../shared/config.json' with { type: 'json' };
import { normalizeFeedback, feedbackDelta } from './feedback.mjs';
import { validate, validateProfile, validateBatch } from './validation.mjs';
import { fail, PromptError } from './errors.mjs';
const digest = value => createHash('sha256').update(JSON.stringify(value)).digest('hex');
const zero = () => ({ personal: 0, energy: 0, intensity: 0, novelty: 0 });
const publicSession = s => ({ contractVersion: 1, id: s.id, profile: s.profile, base: s.base, adaptive: s.adaptive, effective: s.effective, prompts: s.prompts, feedback: s.feedback, generation: s.generation });
const leaseMs = 120000;

export class PromptService {
  constructor({ store, provider, clock = Date.now, dailyLimit = 100 }) { this.store = store; this.provider = provider; this.clock = clock; this.dailyLimit = dailyLimit; }
  authorize(uid) { if (!uid) fail('unauthenticated', 'Sign in to test prompts.'); }
  own(s, uid) { if (!s || s.owner !== uid) fail('permission-denied', 'This prompt session is not available to your account.'); }
  async generate(uid, data, more = false) {
    this.authorize(uid); validate(more ? 'nextRequest' : 'generationRequest', data);
    if (!more) validateProfile(data.profile);
    const id = more ? data.sessionId : digest([uid, data.requestId]).slice(0, 32);
    const sessionKey = `promptdSessions/${id}`;
    const requestKey = `promptdRequests/${digest([uid, data.requestId])}`;
    const limitKey = `promptdLimits/${digest(uid)}`;
    const recentKey = `promptdRecent/${digest(uid)}`;
    const fingerprint = digest([more ? 'next' : 'examples', data]);
    const token = randomUUID();
    const now = this.clock();
    const claim = await this.store.transact([sessionKey, requestKey, limitKey, recentKey], values => {
      const [existing, request, usage, recent] = values;
      if (request && request.fingerprint !== fingerprint) fail('invalid-argument', 'This request ID was already used for different data.');
      if (request?.response) return { result: { cached: request.response } };
      if (request?.until > now) fail('aborted', 'This request is still running. Retry shortly.');
      if (more) this.own(existing, uid);
      if (existing?.lock?.until > now) fail('aborted', 'This session is busy. Please retry shortly.');
      if (more && existing.prompts.some(p => !existing.feedback.some(f => f.promptId === p.id))) fail('failed-precondition', 'Review all five prompts before asking for more.');
      if (more && existing.history.length >= 50) fail('resource-exhausted', 'This test session has reached 50 prompts. Adjust setup to start a new session.');
      const day = new Date(now).toISOString().slice(0, 10);
      const count = usage?.day === day ? usage.count : 0;
      if (count >= this.dailyLimit || (usage && now - usage.lastAt < 2000)) fail('resource-exhausted', 'Prompt generation limit reached. Please try again later.');
      const base = more ? existing.base : structuredClone(config.styles[data.profile.styleLevel].base);
      const s = more ? structuredClone(existing) : { id, owner: uid, profile: data.profile, base, adaptive: zero(), effective: structuredClone(base), prompts: [], feedback: [], history: [], priorPrompts: recent?.texts ?? [] };
      s.profile = { safeMode: true, averageAge: null, ...s.profile };
      s.lock = { token, until: now + leaseMs };
      return { result: { session: s }, writes: [s, { fingerprint, token, until: now + leaseMs }, { day, count: count + 1, lastAt: now }] };
    });
    if (claim.cached) return claim.cached;
    const s = claim.session;
    try {
      const kept = more && data.replaceRejected ? s.prompts.filter(p => s.feedback.some(f => f.promptId === p.id && f.accepted)) : [];
      const needed = 5 - kept.length;
      if (!needed) fail('failed-precondition', 'All five prompts are already accepted.');
      if (s.history.length + needed > 50) fail('resource-exhausted', 'This test session has reached its prompt limit. Adjust setup to start a new session.');
      const generated = await this.generateValidated(s, needed);
      s.prompts = [...kept, ...generated.texts.map((text, index) => ({ id: randomUUID(), text, ...(generated.topicTags ? { topics: generated.topicTags[index] } : {}) }))];
      s.history.push(...generated.texts);
      s.generation = generated.metadata;
      delete s.lock;
      const response = publicSession(s);
      validate('session', response);
      return await this.store.transact([sessionKey, requestKey, recentKey], ([current, request, recent]) => {
        if (current?.lock?.token !== token || request?.token !== token) fail('aborted', 'A newer request replaced this one. Retry to recover its result.');
        return { result: response, writes: [s, { fingerprint, response }, { texts: [...new Set([...(recent?.texts ?? []), ...generated.texts])].slice(-100) }] };
      });
    } catch (error) {
      await this.store.transact([sessionKey, requestKey], ([current, request]) => {
        if (current?.lock?.token !== token || request?.token !== token) return { result: null };
        delete current.lock;
        return { result: null, writes: [current, { fingerprint, until: 0 }] };
      });
      throw error;
    }
  }
  async generateValidated(s, count = 5) {
    const start = this.clock();
    const previousPrompts = [...new Set([...(s.priorPrompts ?? []), ...s.history])];
    const feedback = s.feedback.map(f => ({ text: f.text, accepted: f.accepted, reasons: f.reasons ?? (f.reason ? [f.reason] : []), explanation: f.explanation }));
    const context = structuredClone({ count, profile: s.profile, effective: s.effective, previousPrompts, feedback: [...feedback.filter(f => f.accepted), ...feedback.filter(f => !f.accepted)] });
    // Leave time for persistence and the callable's 90-second deadline.
    const remaining = () => Math.max(0, 80000 - (this.clock() - start));
    for (let attempt = 0; attempt < 3; attempt++) {
      if (!remaining()) break;
      try {
        const candidate = await this.provider.generate(structuredClone(context), { timeoutMs: remaining() });
        // A repair must not throw away cards that already passed review.
        const texts = Array.isArray(candidate) && candidate.length === count ? candidate.map((text, i) => context.revision?.keep?.[i] ?? text) : candidate;
        try { validateBatch(texts, s.profile, previousPrompts, count); }
        catch (error) { context.revision = { issues: ['structure_or_repetition_or_boundary'], corrections: [{ detail: error.message }], rejectedPrompts: Array.isArray(texts) ? texts : [] }; throw error; }
        if (!remaining()) break;
        const review = await this.provider.review(structuredClone(context), texts, { timeoutMs: remaining() });
        const approved = review === true || review?.approved === true;
        if (!approved) {
          const corrections = review?.corrections ?? [];
          const bad = new Set(corrections.map(c => c.index));
          const canKeep = corrections.length > 0 && corrections.every(c => Number.isInteger(c.index) && c.index >= 0 && c.index < count);
          const keep = canKeep ? Object.fromEntries(texts.map((text, index) => [index, text]).filter(([index]) => !bad.has(index))) : {};
          context.revision = { issues: review?.issues ?? ['contextual_validation'], corrections, rejectedPrompts: texts, keep };
          throw new PromptError('invalid-provider-response', 'The prompts did not pass contextual validation.');
        }
        // IA: Keep reviewed topic metadata with this exact text; accepted cards retain both.
        return { texts, topicTags: review?.topicTags, metadata: { source: this.provider.source ?? 'gemini', model: this.provider.model, thinking: this.provider.thinking ?? 'low', latencyMs: this.clock() - start, reason: '' } };
      } catch (error) {
        if (!(error instanceof PromptError)) throw error;
        if (error.code === 'failed-precondition') throw error;
        if (['provider-rate-limited', 'provider-timeout', 'provider-unavailable'].includes(error.code)) break;
      }
    }
    // Generic backup cards cannot preserve this group's tone, boundaries and feedback.
    fail('unavailable', 'We could not make fresh prompts that fit your group and feedback. Please try again. Your saved feedback has been kept.');
  }

  async feedback(uid, data) {
    this.authorize(uid); validate('feedbackRequest', data);
    const feedback = normalizeFeedback(data);
    validate('feedback', feedback);
    const sk = `promptdSessions/${data.sessionId}`, rk = `promptdRequests/${digest([uid, data.requestId])}`;
    const fingerprint = digest(['feedback', data.sessionId, feedback]);
    return this.store.transact([sk, rk], ([s, request]) => {
      this.own(s, uid);
      if (request && request.fingerprint !== fingerprint) fail('invalid-argument', 'This request ID was already used for different data.');
      if (request?.response) return { result: request.response };
      if (s.lock?.until > this.clock()) fail('aborted', 'Wait for generation to finish before sending feedback.');
      const prompt = s.prompts.find(p => p.id === feedback.promptId);
      if (!prompt) fail('invalid-argument', 'This prompt is not in the current batch.');
      const old = s.feedback.find(f => f.promptId === prompt.id);
      if (old && digest(normalizeFeedback(old)) !== digest(feedback)) fail('already-exists', 'Feedback was already recorded for this prompt.');
      if (!old) {
        const delta = feedbackDelta(feedback);
        for (const key of Object.keys(s.base)) {
          s.adaptive[key] = Math.max(-3, Math.min(3, s.adaptive[key] + (delta[key] ?? 0)));
          s.effective[key] = Math.max(0, Math.min(3, s.base[key] + s.adaptive[key]));
        }
        s.feedback.push({ ...feedback, text: prompt.text });
      }
      const response = publicSession(s);
      return { result: response, writes: [s, { fingerprint, response }] };
    });
  }
}
