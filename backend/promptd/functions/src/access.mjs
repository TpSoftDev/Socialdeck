import { HttpsError } from 'firebase-functions/v2/https';
// IA: Firebase verifies the token; cloud access still requires a real signed-in account.
// Explicit signed-in mode preserves PC hosting access. Missing config stays allowlist-only.
export function authorizedUid(auth, { emulator = false, mode = 'allowlist', testers = '' } = {}) {
  if (!auth || (!emulator && auth.token?.firebase?.sign_in_provider === 'anonymous')) {
    throw new HttpsError('unauthenticated', 'Sign in to use prompts.');
  }
  if (!emulator && mode !== 'signed-in' &&
      (mode !== 'allowlist' || !testers.split(',').map(x => x.trim()).filter(Boolean).includes(auth.uid))) {
    throw new HttpsError('permission-denied', 'This account has not been enabled for AI.');
  }
  return auth.uid;
}
