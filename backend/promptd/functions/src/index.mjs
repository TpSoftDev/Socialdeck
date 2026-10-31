import { initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret, defineString } from 'firebase-functions/params';
import { PromptService } from './service.mjs';
import { createPromptProvider, providerSettings } from './provider.mjs';
import { FirestoreStore } from './firestore-store.mjs';
import { PromptError } from './errors.mjs';
import { validate } from './validation.mjs';
import config from '../shared/config.json' with { type: 'json' };

initializeApp();
// Non-secret env selection is resolved at startup/deployment so only the chosen key is bound.
const selected = providerSettings(process.env.PROMPT_PROVIDER || 'gemini');
const apiKey = defineSecret(selected.secret);
const model = defineString(selected.modelEnv, { default: selected.defaultModel });
const testers = defineString('PROMPTD_TESTER_UIDS', { default: '' });
const emulator = process.env.FUNCTIONS_EMULATOR === 'true';
const store = new FirestoreStore(getFirestore());
const options = { region: 'us-central1', timeoutSeconds: 90, maxInstances: 3, concurrency: 10, enforceAppCheck: process.env.PROMPTD_ENFORCE_APP_CHECK === 'true' };
function uidOf(request) {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Sign in to test prompts.');
  const uid = request.auth.uid;
  if (!emulator && !testers.value().split(',').map(x => x.trim()).filter(Boolean).includes(uid)) throw new HttpsError('permission-denied', 'This account has not been added to the team testing allowlist.');
  return uid;
}
function service(withProvider = false) {
  return new PromptService({ store, provider: withProvider ? createPromptProvider({ name: selected.name, apiKey: apiKey.value(), model: model.value(), thinking: 'low' }) : null });
}
async function safe(action) {
  try { return await action(); } catch (error) {
    if (error instanceof HttpsError) throw error;
    const supported = ['invalid-argument','unauthenticated','permission-denied','aborted','already-exists','failed-precondition','resource-exhausted','unavailable'];
    if (error instanceof PromptError && supported.includes(error.code)) throw new HttpsError(error.code, error.message);
    // Never include raw profile text, provider response, tokens, or credentials in logs/errors.
    throw new HttpsError('internal', 'The prompt service could not complete this request. Please retry.');
  }
}
export const getPromptConfiguration = onCall(options, request => safe(async () => {
  uidOf(request); validate('configurationRequest', request.data);
  return { contractVersion: 1, groups: config.groups, more: config.more, less: config.less, styles: Object.fromEntries(Object.entries(config.styles).map(([id, { label, desc, icon }]) => [id, { label, desc, icon }])), reasons: config.reasons };
}));
export const generatePromptExamples = onCall({ ...options, secrets: [apiKey] }, request => safe(() => { const uid = uidOf(request); return service(true).generate(uid, request.data); }));
export const generateNextPrompts = onCall({ ...options, secrets: [apiKey] }, request => safe(() => { const uid = uidOf(request); return service(true).generate(uid, request.data, true); }));
export const submitPromptFeedback = onCall(options, request => safe(() => service().feedback(uidOf(request), request.data)));
