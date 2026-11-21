import {initializeApp} from 'firebase-admin/app';
import {getFirestore, FieldValue} from 'firebase-admin/firestore';
import {onCall, HttpsError} from 'firebase-functions/v2/https';
import {finalizeRound} from './finalize.js';
import {ScoringError} from './scoring.js';
initializeApp();
// IA: Clients request finalization, but never provide scores or vote counts.
export const finalizePromptdRound = onCall({region: 'us-central1',
  maxInstances: 3, timeoutSeconds: 30}, async request => {
  try {
    return await finalizeRound(getFirestore(), request.auth?.uid, request.data,
      () => FieldValue.serverTimestamp());
  } catch (error) {
    if (error instanceof ScoringError) throw new HttpsError(error.code, error.message);
    console.error('Leaderboard finalization failed', error.code ?? error.name);
    throw new HttpsError('internal', 'Could not finalize results. Try again.');
  }
});
