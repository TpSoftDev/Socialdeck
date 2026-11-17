// IA: Verify local auth and callable wiring without generating prompts or spending model credits.
import assert from 'node:assert/strict';
const project = process.env.GCLOUD_PROJECT || 'demo-socialdeck-promptd';
assert.ok(project.startsWith('demo-'), 'Smoke checks must use a demo emulator project.');
const authHost = process.env.FIREBASE_AUTH_EMULATOR_HOST || '127.0.0.1:9099';
const functionsHost = process.env.PROMPTD_SMOKE_FUNCTIONS_HOST || '127.0.0.1:5001';
for (const host of [authHost, functionsHost]) {
  assert.match(host, /^(127\.0\.0\.1|localhost):[0-9]+$/, 'Local emulators only.');
}
const signup = await fetch(`http://${authHost}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=emulator-only`, {
  method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify({returnSecureToken: true}),
});
assert.equal(signup.status, 200, 'Emulator sign-in must succeed.');
const {idToken} = await signup.json();
assert.ok(idToken);
const endpoint = `http://${functionsHost}/${project}/us-central1/getPromptConfiguration`;
const send = token => fetch(endpoint, {method: 'POST', headers: {
  'Content-Type': 'application/json', ...(token ? {Authorization: `Bearer ${token}`} : {}),
}, body: JSON.stringify({data: {contractVersion: 1}})});
const denied = await send();
assert.equal(denied.status, 401, 'Anonymous callable requests must be denied.');
const reply = await send(idToken);
assert.equal(reply.status, 200, 'Authenticated configuration callable must succeed.');
const {result} = await reply.json();
assert.equal(result.contractVersion, 1);
assert.ok(result.groups && result.styles && result.reasons);
console.log('AI emulator smoke passed: auth, authorization and public contract; no model call.');
