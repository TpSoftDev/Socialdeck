import config from '../shared/config.json' with { type: 'json' };
import { fail } from './errors.mjs';

// Keep legacy single-reason clients compatible, with a stable order for retries.
export function normalizeFeedback(input) {
  const reasons = [...(input.reasons ?? (input.reason ? [input.reason] : []))].sort();
  if (input.reason && !reasons.includes(input.reason)) fail('invalid-argument', 'Feedback reasons conflict.');
  return { promptId: input.promptId, accepted: input.accepted, reason: reasons[0] ?? '', reasons, explanation: input.explanation };
}
export function feedbackDelta(feedback) {
  const delta = { personal: 0, energy: 0, intensity: 0, novelty: 0 };
  if (!feedback.accepted) for (const reason of feedback.reasons) {
    for (const [key, amount] of Object.entries(config.adjustments[reason] ?? {})) delta[key] += amount;
  }
  // Several overlapping reasons count as one card, not several votes.
  for (const key of Object.keys(delta)) delta[key] = Math.max(-1, Math.min(1, delta[key]));
  return delta;
}
