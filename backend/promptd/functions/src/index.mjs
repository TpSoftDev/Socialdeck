import { initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret, defineString } from 'firebase-functions/params';
import { PromptService } from './service.mjs';
import { providerSettings } from './provider.mjs';
import { createSetupPromptProvider } from './setup-provider.mjs';
import { FirestoreStore } from './firestore-store.mjs';
import { PromptError } from './errors.mjs';
import { authorizedUid } from './access.mjs';
import { validate } from './validation.mjs';
import config from '../shared/config.json' with { type: 'json' };

initializeApp();
// Non-secret env selection is resolved at startup/deployment so only the chosen key is bound.
const selected = providerSettings(process.env.PROMPT_PROVIDER || 'gemini');
// IA: Cloud deployment uses a Prompt'd-only secret, leaving teammates' keys alone.
// Local emulators keep the original provider key names from .secret.local.
const apiKey = defineSecret(process.env.PROMPTD_API_KEY_SECRET || selected.secret);
const model = defineString(selected.modelEnv, { default: selected.defaultModel });
const testers = defineString('PROMPTD_TESTER_UIDS', { default: '' });
const emulator = process.env.FUNCTIONS_EMULATOR === 'true';
const store = new FirestoreStore(getFirestore());
const options = { region: 'us-central1', timeoutSeconds: 90, maxInstances: 3, concurrency: 10, enforceAppCheck: process.env.PROMPTD_ENFORCE_APP_CHECK === 'true' };
function uidOf(request) {
  return authorizedUid(request.auth, { emulator, mode: process.env.PROMPTD_ACCESS_MODE || 'allowlist', testers: testers.value() });
}
// IA: Compact setup is local-demo-only by default; explicit legacy selection preserves rollback.
// Existing cloud defaults remain legacy until a separately approved deployment.
function service(withProvider = false) {
  return new PromptService({ store, provider: withProvider ? createSetupPromptProvider({ strategy: process.env.PROMPTD_SETUP_STRATEGY || (emulator && process.env.GCLOUD_PROJECT === 'demo-socialdeck-gameplay' && selected.name === 'openai' ? 'compact' : 'legacy'), name: selected.name, apiKey: apiKey.value(), model: model.value(), thinking: 'low' }) : null });
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

// IA: New gameplay endpoints are local-emulator-only until integration is approved for deployment.
// No public cloud endpoint is enabled by this source change.
async function localGameAction(request,method){
 if(!emulator||process.env.GCLOUD_PROJECT!=='demo-socialdeck-gameplay')throw new HttpsError('failed-precondition','Gameplay integration is currently enabled only for local testing.');
 const {GameStartService}=await import('./game-start.mjs');
 const data=request.data;
 if(!data||Object.keys(data).some(k=>k!=='partyId'))throw new HttpsError('invalid-argument','Only partyId is accepted.');
 return safe(()=>new GameStartService(getFirestore())[method](uidOf(request),data.partyId));
}
export const startPromptdGame=onCall(options,request=>localGameAction(request,'start'));
export const getPromptdGamePreparation=onCall(options,request=>localGameAction(request,'status'));
export const retryPromptdGamePreparation=onCall(options,request=>localGameAction(request,'retry'));
