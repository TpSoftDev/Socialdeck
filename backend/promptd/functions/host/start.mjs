// IA: Start the existing prompt logic on the host PC; model instructions are unchanged.
import { mkdirSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { PromptService } from '../src/service.mjs';
import { createPromptProvider, providerSettings } from '../src/provider.mjs';
import { LocalStore } from './local-store.mjs';
import { createHostServer, createTokenVerifier } from './server.mjs';
export async function startHost({ stateDirectory, port = 0 }) {
  const projectId = process.env.PROMPTD_AUTH_PROJECT || 'socialdeck-dev';
  const verifyToken = createTokenVerifier(projectId);
  const selected = providerSettings(process.env.PROMPT_PROVIDER || 'openai');
  const apiKey = process.env[selected.secret];
  if (!apiKey || apiKey.startsWith('replace-')) throw Error('Set the provider key in functions/.secret.local on this PC first.');
  mkdirSync(stateDirectory, { recursive: true });
  const store = new LocalStore(fileURLToPath(new URL('sessions.sqlite', stateDirectory)));
  const provider = createPromptProvider({ name: selected.name, apiKey, model: process.env[selected.modelEnv] || selected.defaultModel, thinking: 'low' });
  const dailyLimit = Number(process.env.PROMPTD_HOST_DAILY_LIMIT || 100);
  if (!Number.isInteger(dailyLimit) || dailyLimit < 1 || dailyLimit > 1000) { store.close(); throw Error('PROMPTD_HOST_DAILY_LIMIT must be an integer between 1 and 1000.'); }
  const server = createHostServer({ service: new PromptService({ store, provider }), store, verifyToken, projectId, dailyLimit, allowedUids: (process.env.PROMPTD_TESTER_UIDS || '').split(',').map(x => x.trim()).filter(Boolean) });
  // IA: Let Windows choose an unused loopback port so existing dev servers keep working.
  try { await new Promise((resolve, reject) => { server.once('error', reject); server.listen(port, '127.0.0.1', resolve); }); }
  catch (error) { store.close(); throw error; }
  const cleanup = setInterval(() => store.cleanup(), 3600000); cleanup.unref();
  let closing;
  return { server, close() {
    return closing ??= (async () => {
      clearInterval(cleanup);
      const force = setTimeout(() => server.closeAllConnections(), 95000); force.unref();
      await new Promise(resolve => server.close(resolve));
      clearTimeout(force); store.close();
    })();
  } };
}
