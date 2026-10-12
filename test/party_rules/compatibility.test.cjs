// Compare existing permissions before/after adding Party. All data is synthetic.
const { before, after, test } = require('node:test');
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const { initializeTestEnvironment } = require('@firebase/rules-unit-testing');
const { doc, setDoc, getDocFromServer: getDoc, getDocsFromServer: getDocs, updateDoc, deleteDoc, collection,
  query, where, documentId } = require('firebase/firestore');

const environments = [];
before(async () => {
  for (const [label, file] of [
    ['baseline', process.env.FIREBASE_BASELINE_RULES],
    ['combined', process.env.PARTY_RULES_FILE],
  ]) {
    assert.ok(file, 'Supply both the deployed baseline and combined candidate');
    environments.push([label, await initializeTestEnvironment({
      projectId: `demo-socialdeck-compat-${label}`,
      firestore: { host: '127.0.0.1', port: 8085,
        rules: readFileSync(file, 'utf8') },
    })]);
  }
});
after(async () => {
  for (const [, env] of environments) await env.cleanup();
});

const privateProfile = { username: 'Owner', email: 'owner@example.invalid',
  onboardingComplete: true, displayName: 'Private profile' };
const publicProfile = { username: 'Owner', username_insensitive: 'owner',
  email: 'owner@example.invalid' };
const alternatePublicProfile = { username: 'Owner',
  email: 'owner@example.invalid', onboardingComplete: true };
const fixture = {
  'users/owner': privateProfile,
  'users/public': publicProfile,
  'users/publicAlt': alternatePublicProfile,
  'users/privateSub/notes/note': { private: true },
  'test_decks/deck': { name: 'Original deck', ownerId: 'owner' },
  'test_decks/deck/cards/card': { imageUrl: 'https://example.invalid/card.jpg' },
  'decks/deck': { name: 'Unapproved collection' },
  'users/owner/partyDecks/deck': { name: 'Party deck', favorite: true },
  'users/owner/partyCards/card': { deckId: 'deck', imageUrl: 'https://example.invalid/card.jpg' },
};

const cases = [];
const add = (name, actor, allow, run, seed = fixture) =>
  cases.push({ name, actor, allow, run, seed });
const get = path => db => getDoc(doc(db, path));
const create = (path, value = { value: true }) => db => setDoc(doc(db, path), value);
const update = path => db => updateDoc(doc(db, path), { updated: true });
const remove = path => db => deleteDoc(doc(db, path));

for (const actor of ['owner', 'peer', null]) {
  const label = actor || 'anonymous';
  add(`${label}: private profile read`, actor, actor === 'owner', get('users/owner'));
  add(`${label}: profile update`, actor, actor === 'owner', update('users/owner'));
  add(`${label}: profile deletion`, actor, actor === 'owner', remove('users/owner'));
  add(`${label}: profile creation`, actor, actor === 'owner', create('users/owner', privateProfile), {});
  // These public email reads already exist in the deployed baseline.
  add(`${label}: limited public profile read`, actor, true, get('users/public'));
  add(`${label}: alternate public profile read`, actor, true, get('users/publicAlt'));
  add(`${label}: public profile becomes private when extra fields are present`, actor, false,
    get('users/public'), { 'users/public': { ...publicProfile, privateNote: 'secret' } });
  add(`${label}: public profile write denied`, actor, false, update('users/public'));
  // Characterize an existing concern: the emulator allows this query under
  // the deployed hasOnly() read rule, including the private fixture fields.
  add(`${label}: existing unrestricted users query behavior is preserved`, actor, true,
    async db => {
      const result = await getDocs(collection(db, 'users'));
      assert.deepEqual(result.docs.find(d => d.id === 'owner')?.data(), privateProfile);
    });
  add(`${label}: unknown collection read denied`, actor, false, get('decks/deck'));
  add(`${label}: unknown collection write denied`, actor, false, create('decks/new'));
  add(`${label}: deck read`, actor, actor !== null, get('test_decks/deck'));
  add(`${label}: deck query`, actor, actor !== null, db => getDocs(collection(db, 'test_decks')));
  add(`${label}: deck create`, actor, actor !== null, create('test_decks/new'));
  add(`${label}: deck update`, actor, actor !== null, update('test_decks/deck'));
  add(`${label}: deck deletion`, actor, actor !== null, remove('test_decks/deck'));
  add(`${label}: deck subcollection read stays denied`, actor, false,
    get('test_decks/deck/cards/card'));
  add(`${label}: deck subcollection write stays denied`, actor, false,
    create('test_decks/deck/cards/new'));
}
add('owner can query only their own profile document', 'owner', true,
  db => getDocs(query(collection(db, 'users'), where(documentId(), '==', 'owner'))));
add('owner profile permission does not grant unrelated subcollection reads', 'privateSub', false,
  get('users/privateSub/notes/note'));
add('owner profile permission does not grant unrelated subcollection writes', 'privateSub', false,
  create('users/privateSub/notes/new'));

// Public parent profiles must never make the Party catalog public.
for (const actor of ['peer', null]) {
  for (const sub of ['partyDecks', 'partyCards']) {
    const path = `users/owner/${sub}/${sub === 'partyDecks' ? 'deck' : 'card'}`;
    add(`${actor || 'anonymous'} cannot read ${sub} under a public profile`, actor, false,
      get(path), { ...fixture, 'users/owner': publicProfile });
    add(`${actor || 'anonymous'} cannot write ${sub}`, actor, false, update(path));
    add(`${actor || 'anonymous'} cannot list ${sub}`, actor, false,
      db => getDocs(collection(db, 'users', 'owner', sub)));
  }
}

for (const c of cases) {
  test(c.name, async () => {
    for (const [label, env] of environments) {
      await env.clearFirestore();
      await env.withSecurityRulesDisabled(async ctx => {
        const db = ctx.firestore();
        await Promise.all(Object.entries(c.seed).map(([path, value]) => setDoc(doc(db, path), value)));
      });
      const db = (c.actor ? env.authenticatedContext(c.actor) : env.unauthenticatedContext()).firestore();
      let allowed = true;
      try { await c.run(db); }
      catch (error) {
        // Network, syntax, and emulator errors must fail, not count as a denial.
        assert.equal(error.code, 'permission-denied', `${label}: unexpected error: ${error.message}`);
        allowed = false;
      }
      assert.equal(allowed, c.allow, `${label}: ${c.name}`);
    }
  });
}
