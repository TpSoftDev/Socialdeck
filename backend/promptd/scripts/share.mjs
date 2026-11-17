// IA: One terminal starts our authenticated PC API and its temporary HTTPS tunnel.
// Keep this process running during team testing. Ctrl+C or the stop script closes sharing.
import { existsSync, readFileSync, writeFileSync, unlinkSync, mkdirSync, openSync, closeSync } from 'node:fs';
import { spawn } from 'node:child_process';
import { randomUUID } from 'node:crypto';
import { resolve4 } from 'node:dns/promises';
import { fileURLToPath } from 'node:url';
import { startHost } from '../functions/host/start.mjs';
const base = new URL('../', import.meta.url);
for (const path of ['functions/.env.local', 'functions/.secret.local', '.host.local']) {
  const file = new URL(path, base);
  if (existsSync(file)) process.loadEnvFile(fileURLToPath(file));
}
const directory = new URL('.share.local/', base);
const connection = new URL('connection.json', directory);
const stopFile = new URL('stop.request', directory);
const lockFile = new URL('host.lock', directory);
const runId = randomUUID();
let host, tunnel, poll, stopping = false, lockHeld = false;
async function stop(code = 0) {
  if (stopping) return;
  stopping = true; clearInterval(poll);
  // IA: Let in-flight reviews save before closing the tunnel and database.
  try { if (host) await host.close(); } finally { tunnel?.kill(); }
  if (existsSync(connection)) {
    try { if (JSON.parse(readFileSync(connection, 'utf8')).runId === runId) unlinkSync(connection); } catch {}
  }
  if (lockHeld && existsSync(lockFile)) {
    try { if (JSON.parse(readFileSync(lockFile, 'utf8')).runId === runId) unlinkSync(lockFile); } catch {}
  }
  if (host || lockHeld) console.log('PC AI sharing stopped. Your Party data remains in Firebase.');
  process.exitCode = code;
}
process.on('SIGINT', () => void stop());
process.on('SIGTERM', () => void stop());
try {
  mkdirSync(directory, { recursive: true });
  // IA: Double-clicking Start must not create a second tunnel or overwrite its stop control.
  if (existsSync(lockFile)) {
    const previous = JSON.parse(readFileSync(lockFile, 'utf8'));
    let alive = true;
    try { process.kill(previous.pid, 0); } catch (error) { if (error.code === 'ESRCH') alive = false; }
    if (alive) throw Error('PC AI sharing is already running. Use the existing link or Stop it first.');
    unlinkSync(lockFile);
  }
  const lock = openSync(lockFile, 'wx');
  writeFileSync(lock, JSON.stringify({ pid: process.pid, runId })); closeSync(lock); lockHeld = true;
  host = await startHost({ stateDirectory: directory });
  const localOrigin = `http://127.0.0.1:${host.server.address().port}`;
  mkdirSync(directory, { recursive: true });
  if (existsSync(stopFile)) unlinkSync(stopFile);
  // IA: The tunnel needs no provider credentials. Do not pass the AI key to its process.
  const tunnelEnv = { ...process.env };
  for (const key of Object.keys(tunnelEnv)) if (/API_KEY|SECRET|TOKEN|PASSWORD/i.test(key)) delete tunnelEnv[key];
  const command = process.env.PROMPTD_CLOUDFLARED || 'cloudflared';
  tunnel = spawn(command, ['--no-autoupdate', 'tunnel', '--url', localOrigin, '--protocol', 'auto'], { windowsHide: true, env: tunnelEnv, stdio: ['ignore', 'pipe', 'pipe'] });
  let published = false, buffer = '';
  const announce = chunk => {
    buffer = (buffer + chunk.toString()).slice(-12000);
    const url = buffer.match(/https:\/\/[a-z0-9]+(?:-[a-z0-9]+)+\.trycloudflare\.com/)?.[0];
    if (url && !published) {
      published = true;
      const instructions = `flutter run --dart-define=PROMPTD_SERVER_URL=${url}`;
      writeFileSync(connection, JSON.stringify({ url, projectId: process.env.PROMPTD_AUTH_PROJECT || 'socialdeck-dev', runId, pid: process.pid, startedAt: new Date().toISOString(), status: 'connecting', teammateCommand: instructions }, null, 2));
      console.log(`Tunnel address assigned: ${url}. Checking the public connection...`);
      // IA: A URL alone does not mean the tunnel works. Verify it before calling it ready.
      void (async () => {
        const until = Date.now() + 90000;
        let lastIssue = 'not connected';
        while (Date.now() < until && !stopping) {
          try {
            // IA: Wait for public DNS before HTTP to avoid Windows caching a new name as missing.
            await resolve4(new URL(url).hostname);
            const response = await fetch(`${url}/health`, { signal: AbortSignal.timeout(4000) });
            lastIssue = `HTTP ${response.status}`;
            if (response.ok && (await response.json()).service === 'promptd-host') {
              const saved = JSON.parse(readFileSync(connection, 'utf8'));
              if (saved.runId !== runId || stopping) return;
              writeFileSync(connection, JSON.stringify({ ...saved, status: 'ready' }, null, 2));
              console.log(`\nAI sharing is READY: ${url}\n\nTeammates run from the app folder:\n${instructions}\n\nKeep this window and your PC running. Sign in normally in Socialdeck.\nThis temporary URL changes after restarting sharing.\nStop: Ctrl+C, or scripts/stop-promptd-share.ps1.\n`);
              return;
            }
          } catch (error) { lastIssue = error.cause?.code || error.code || error.name; }
          console.log(`Waiting for public connection: ${lastIssue}`);
          await new Promise(resolve => setTimeout(resolve, 3000));
        }
        if (!stopping) { console.error('The public tunnel is not reachable. Check the tunnel connection before sharing this link.'); await stop(1); }
      })();
    }
    // Infrastructure messages only. Requests and credentials are never logged here.
    const lines = chunk.toString().split('\n').filter(line => /ERR|Registered tunnel connection/.test(line));
    for (const line of lines) console.log(line.trim());
  };
  tunnel.stdout.on('data', announce); tunnel.stderr.on('data', announce);
  tunnel.once('error', error => { console.error(error.code === 'ENOENT' ? 'cloudflared is missing. Install it or set PROMPTD_CLOUDFLARED in .host.local.' : 'The tunnel could not start.'); void stop(1); });
  tunnel.once('exit', () => { if (!stopping) { console.error('The sharing tunnel stopped. Restart the launcher to get a new link.'); void stop(1); } });
  poll = setInterval(() => {
    if (existsSync(stopFile) && readFileSync(stopFile, 'utf8').trim() === runId) { unlinkSync(stopFile); void stop(); }
  }, 1000);
  console.log(`PC AI API is running at ${localOrigin}. Starting secure sharing...`);
} catch (error) { console.error(`Cannot start PC AI sharing: ${error.message}`); await stop(1); }
