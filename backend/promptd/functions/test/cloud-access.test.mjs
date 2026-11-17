import test from 'node:test';
import assert from 'node:assert/strict';
import { authorizedUid } from '../src/access.mjs';
const user = { uid: 'alice', token: { firebase: { sign_in_provider: 'google.com' } } };
test('IA: cloud signed-in access rejects missing and anonymous identities', () => {
  assert.throws(() => authorizedUid(null, { mode: 'signed-in' }), { code: 'unauthenticated' });
  assert.throws(() => authorizedUid({ ...user, token: { firebase: { sign_in_provider: 'anonymous' } } }, { mode: 'signed-in' }), { code: 'unauthenticated' });
  assert.equal(authorizedUid(user, { mode: 'signed-in' }), 'alice');
});
test('IA: absent or invalid access configuration fails closed; allowlist is optional', () => {
  assert.throws(() => authorizedUid(user), { code: 'permission-denied' });
  assert.throws(() => authorizedUid(user, { mode: 'typo', testers: 'alice' }), { code: 'permission-denied' });
  assert.throws(() => authorizedUid(user, { testers: 'bob' }), { code: 'permission-denied' });
  assert.equal(authorizedUid(user, { testers: 'alice,bob' }), 'alice');
});
