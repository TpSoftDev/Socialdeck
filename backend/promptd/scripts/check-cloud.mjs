// IA: Stop before uploading if shared testing has no users or could reuse a teammate's secret.
// Parse exactly as our pinned Firebase CLI does. Never print env values or credentials.
import { readFileSync, existsSync } from 'node:fs';
import { createRequire } from 'node:module';
const require = createRequire(import.meta.url);
const { parseStrict } = require('firebase-tools/lib/functions/env');
try {
  const file = new URL('../functions/.env.socialdeck-dev', import.meta.url);
  if (!existsSync(file)) throw Error('Copy cloud.env.example to functions/.env.socialdeck-dev and configure team tester UIDs first.');
  const base = new URL('../functions/.env', import.meta.url);
  const env = { ...(existsSync(base) ? parseStrict(readFileSync(base, 'utf8')) : {}), ...parseStrict(readFileSync(file, 'utf8')) };
  if (Object.keys(env).some(key => /API_KEY$|TOKEN$|PASSWORD$|PRIVATE_KEY$/i.test(key))) {
    throw Error('Keep credentials out of .env files. Store the provider key in Secret Manager.');
  }
  const secrets = { openai: 'PROMPTD_OPENAI_API_KEY', gemini: 'PROMPTD_GEMINI_API_KEY' };
  if (!secrets[env.PROMPT_PROVIDER] || env.PROMPTD_API_KEY_SECRET !== secrets[env.PROMPT_PROVIDER]) {
    throw Error('Select a supported provider and its Promptd-only secret name from cloud.env.example.');
  }
  const model = env.PROMPT_PROVIDER === 'openai' ? env.OPENAI_MODEL : env.GEMINI_MODEL;
  if (!model?.trim()) throw Error('Set the selected provider model before deployment.');
  const testers = (env.PROMPTD_TESTER_UIDS || '').split(',').map(x => x.trim()).filter(Boolean);
  if (!testers.length || testers.some(uid => uid.includes('REPLACE_') || uid.includes('@') || uid.length > 128)) {
    throw Error('Set real Firebase Authentication UIDs in PROMPTD_TESTER_UIDS; email addresses are not UIDs.');
  }
  if (env.PROMPTD_ENFORCE_APP_CHECK !== 'false') throw Error('App Check client wiring is not included yet; use false for this team test deployment.');
  console.log(`Cloud configuration checked: ${new Set(testers).size} allowed tester(s). No secret values printed.`);
} catch (error) {
  console.error(`Cloud deployment not ready: ${error.message}`);
  process.exitCode = 1;
}
