// -----------------------------------------------------------------------------
// party_rules.test.cjs
// Real Firestore emulator checks for atomic membership and server permissions.
// Uses a demo project only. No production credentials or deployment are needed.
// -----------------------------------------------------------------------------
const { before, after, beforeEach, test } = require('node:test');
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const { resolve } = require('node:path');
const { initializeTestEnvironment, assertSucceeds, assertFails } =
  require('@firebase/rules-unit-testing');
const { doc, setDoc, getDoc, getDocs, collection, updateDoc, writeBatch,
  serverTimestamp, runTransaction, arrayUnion, query, where } = require('firebase/firestore');

let env;
const id = '123456';
const member = name => ({
  name, characterId: null, cardCount: 0, selectionRevision: -1, ready: false,
});
const game = {
  id: 'promptd', rounds: 3, requiredCards: 7, mixCards: false,
  safeMode: false,
};
const db = uid => env.authenticatedContext(uid).firestore();
const partyRef = client => doc(client, 'parties', id);
const sessionRef = (client, uid) => doc(client, 'partySessions', uid);
const handRef = (client, uid) => doc(client, 'parties', id, 'hands', uid);

before(async () => {
  const address = (process.env.FIRESTORE_EMULATOR_HOST || '127.0.0.1:8085').split(':');
  env = await initializeTestEnvironment({
    projectId: process.env.PARTY_TEST_PROJECT || 'demo-socialdeck-party',
    firestore: {
      host: address[0], port: Number(address[1]),
      // Allow the same Party checks to verify a combined candidate.
      rules: readFileSync(process.env.PARTY_RULES_FILE ||
        resolve(__dirname, '../../firestore.party.rules'), 'utf8'),
    },
  });
});
beforeEach(async () => env.clearFirestore());
after(async () => { if (env) await env.cleanup(); });

async function create(client = db('host'), uid = 'host') {
  const batch = writeBatch(client);
  batch.set(partyRef(client), {
    hostId: uid, phase: 'lobby', revision: 0, game: null,
    memberIds: [uid], members: { [uid]: member(uid) },
    createdAt: serverTimestamp(), updatedAt: serverTimestamp(),
  });
  batch.set(sessionRef(client, uid), { partyId: id });
  await batch.commit();
}
async function join(client, uid) {
  return runTransaction(client, async tx => {
    const session = await tx.get(sessionRef(client, uid));
    const snapshot = await tx.get(partyRef(client));
    if (session.data()?.partyId) throw Error('already joined');
    const p = snapshot.data();
    tx.set(partyRef(client), {
      memberIds: arrayUnion(uid), members: { [uid]: member(uid) },
      updatedAt: serverTimestamp(),
    }, { merge: true });
    tx.set(sessionRef(client, uid), { partyId: id });
  });
}
async function chooseGame(client = db('host')) {
  await updateDoc(partyRef(client), {
    game: { ...game }, revision: 1, updatedAt: serverTimestamp(),
  });
}
async function select(client, uid, count = 7, { mixed = false, duplicate = false } = {}) {
  const batch = writeBatch(client);
  batch.set(doc(client, 'users', uid, 'partyDecks', 'deck'), { name: 'Deck' });
  batch.set(doc(client, 'users', uid, 'partyDecks', 'other'), { name: 'Other' });
  await batch.commit();
  const cards = Array.from({ length: count }, (_, i) => ({
    id: 'card' + (duplicate ? 0 : i),
    deckId: mixed && i > 0 ? 'other' : 'deck',
    imageUrl: 'https://example.invalid/' + (duplicate ? 0 : i) + '.jpg',
  }));
  for (const c of cards) {
    await setDoc(doc(client, 'users', uid, 'partyCards', c.id),
      { deckId: c.deckId, imageUrl: c.imageUrl });
  }
  const p = (await getDoc(partyRef(client))).data();
  const update = writeBatch(client);
  update.set(handRef(client, uid), { cards, revision: p.revision });
  update.update(partyRef(client), {
    members: { ...p.members, [uid]: { ...p.members[uid],
      cardCount: count, selectionRevision: p.revision, ready: false } },
    updatedAt: serverTimestamp(),
  });
  return update.commit();
}
async function ready(client, uid) {
  const p = (await getDoc(partyRef(client))).data();
  return updateDoc(partyRef(client), {
    members: { ...p.members, [uid]: { ...p.members[uid], ready: true } },
    updatedAt: serverTimestamp(),
  });
}

test('create requires atomic session claim and authentication', async () => {
  await assertFails(create(env.unauthenticatedContext().firestore()));
  const client = db('host');
  await assertSucceeds(create(client));
  assert.equal((await getDoc(sessionRef(client, 'host'))).data().partyId, id);
  await assertFails(setDoc(doc(client, 'parties', '654321'), {
    ...(await getDoc(partyRef(client))).data(),
    createdAt: serverTimestamp(), updatedAt: serverTimestamp(),
  }));
});

test('join updates membership and session together; lobby cannot be enumerated', async () => {
  await create();
  const guest = db('guest');
  await assertSucceeds(join(guest, 'guest'));
  assert.equal((await getDoc(partyRef(guest))).data().memberIds.length, 2);
  await assertFails(getDocs(collection(db('outsider'), 'parties')));
  await assertFails(setDoc(sessionRef(guest, 'guest'), { partyId: '999999' }));
});

test('concurrent joins keep both members', async () => {
  await create();
  await Promise.all([join(db('one'), 'one'), join(db('two'), 'two')]);
  const members = (await getDoc(partyRef(db('host')))).data().memberIds;
  assert.deepEqual(new Set(members), new Set(['host', 'one', 'two']));
});

test('non-host cannot choose game, promote, or disband', async () => {
  await create();
  const guest = db('guest');
  await join(guest, 'guest');
  await assertFails(chooseGame(guest));
  await assertFails(updateDoc(partyRef(guest), {
    hostId: 'guest', updatedAt: serverTimestamp(),
  }));
  await assertFails(updateDoc(partyRef(guest), {
    phase: 'closed', updatedAt: serverTimestamp(),
  }));
});

test('host transfer revokes old rights and permits successive transfer and kick by the new host', async () => {
  const host = db('host'), guest = db('guest'), third = db('third');
  await create(host); await join(guest, 'guest'); await join(third, 'third');
  const promote = (client, target) => updateDoc(partyRef(client), {
    hostId: target, updatedAt: serverTimestamp(),
  });
  const kick = async (client, target) => {
    const p = (await getDoc(partyRef(client))).data();
    const batch = writeBatch(client);
    const members = { ...p.members };
    delete members[target];
    batch.update(partyRef(client), { members,
      memberIds: p.memberIds.filter(uid => uid !== target), updatedAt: serverTimestamp() });
    batch.set(sessionRef(client, target), { partyId: null });
    batch.delete(handRef(client, target));
    return batch.commit();
  };
  await assertSucceeds(promote(host, 'guest'));
  await assertFails(promote(host, 'third'));
  await assertFails(kick(host, 'third'));
  await assertSucceeds(promote(guest, 'third'));
  await assertFails(promote(guest, 'host'));
  await assertSucceeds(kick(third, 'guest'));
  assert.equal((await getDoc(partyRef(third))).data().hostId, 'third');
  assert.equal((await getDoc(sessionRef(guest, 'guest'))).data().partyId, null);
});

test('ready requires real selections; hands are private even from the host', async () => {
  await create();
  const guest = db('guest');
  await join(guest, 'guest');
  await chooseGame();
  await assertFails(ready(guest, 'guest'));
  await assertSucceeds(select(guest, 'guest'));
  await assertSucceeds(ready(guest, 'guest'));
  await assertFails(getDoc(handRef(db('host'), 'guest')));
  await assertFails(getDoc(handRef(db('outsider'), 'guest')));
  await assertSucceeds(getDoc(handRef(guest, 'guest')));
});

test('mixed-deck hands are allowed but duplicate cards are rejected', async () => {
  await create();
  await chooseGame(db('host'));
  await assertSucceeds(select(db('host'), 'host', 7, { mixed: true }));
  await assertFails(select(db('host'), 'host', 7, { duplicate: true }));
  await assertSucceeds(select(db('host'), 'host'));
});

test('start requires all players ready; changing settings invalidates readiness', async () => {
  const host = db('host'), guest = db('guest');
  await create(host);
  await join(guest, 'guest');
  await chooseGame(host);
  const start = () => updateDoc(partyRef(host), {
    phase: 'playing', updatedAt: serverTimestamp(),
  });
  await assertFails(start());
  await select(host, 'host'); await ready(host, 'host');
  await select(guest, 'guest'); await ready(guest, 'guest');
  await assertSucceeds(updateDoc(partyRef(host), {
    revision: 2, game: { ...game, rounds: 4 }, updatedAt: serverTimestamp(),
  }));
  await assertFails(start());
  await assertFails(ready(guest, 'guest'));
  await select(host, 'host'); await ready(host, 'host');
  await select(guest, 'guest'); await ready(guest, 'guest');
  await assertSucceeds(start());
  await assertFails(join(db('late'), 'late'));
  await assertFails(select(host, 'host'));
});

test('leave must release session atomically; promotion lets former host leave', async () => {
  const host = db('host'), guest = db('guest');
  await create(host); await join(guest, 'guest');
  await assertFails(setDoc(sessionRef(guest, 'guest'), { partyId: null }));
  await updateDoc(partyRef(host), { hostId: 'guest', updatedAt: serverTimestamp() });
  const batch = writeBatch(host);
  batch.update(partyRef(host), {
    members: { guest: member('guest') }, memberIds: ['guest'],
    updatedAt: serverTimestamp(),
  });
  batch.set(sessionRef(host, 'host'), { partyId: null });
  batch.delete(handRef(host, 'host'));
  await assertSucceeds(batch.commit());
});

test('host can kick; removal cannot leave a stale active session', async () => {
  const host = db('host'), guest = db('guest');
  await create(host); await join(guest, 'guest');
  await assertFails(updateDoc(partyRef(host), {
    members: { host: member('host') }, memberIds: ['host'],
    updatedAt: serverTimestamp(),
  }));
  const batch = writeBatch(host);
  batch.update(partyRef(host), {
    members: { host: member('host') }, memberIds: ['host'],
    updatedAt: serverTimestamp(),
  });
  batch.set(sessionRef(host, 'guest'), { partyId: null });
  batch.delete(handRef(host, 'guest'));
  await assertSucceeds(batch.commit());
});

test('disband clears eight sessions atomically within rule access limits', async () => {
  const host = db('host');
  await create(host);
  for (let i = 1; i < 8; i++) await join(db('p' + i), 'p' + i);
  await assertFails(join(db('ninth'), 'ninth'));
  const p = (await getDoc(partyRef(host))).data();
  const batch = writeBatch(host);
  batch.update(partyRef(host), { phase: 'closed', updatedAt: serverTimestamp() });
  for (const uid of p.memberIds) {
    batch.set(sessionRef(host, uid), { partyId: null });
    batch.delete(handRef(host, uid));
  }
  await assertSucceeds(batch.commit());
});

test('only recipient can decline an invitation; outsiders cannot invite', async () => {
  await create();
  const host = db('host'), guest = db('guest');
  const invitation = client => doc(client, 'partyInvitations', id + '_guest');
  const data = {
    partyId: id, senderId: 'host', recipientId: 'guest',
    status: 'pending', createdAt: serverTimestamp(),
  };
  await assertFails(setDoc(invitation(db('outsider')), { ...data, senderId: 'outsider' }));
  await assertSucceeds(setDoc(invitation(host), data));
  await assertFails(updateDoc(invitation(db('outsider')), { status: 'declined' }));
  await assertSucceeds(updateDoc(invitation(guest), { status: 'declined' }));
});

test('accepting an invite must join the party in the same atomic operation', async () => {
  await create();
  const host = db('host'), guest = db('guest');
  const invitation = client => doc(client, 'partyInvitations', id + '_guest');
  await setDoc(invitation(host), {
    partyId: id, senderId: 'host', recipientId: 'guest',
    status: 'pending', createdAt: serverTimestamp(),
  });
  await assertFails(updateDoc(invitation(guest), { status: 'accepted' }));
  const p = (await getDoc(partyRef(guest))).data();
  const batch = writeBatch(guest);
  batch.update(partyRef(guest), {
    memberIds: [...p.memberIds, 'guest'],
    members: { ...p.members, guest: member('guest') },
    updatedAt: serverTimestamp(),
  });
  batch.set(sessionRef(guest, 'guest'), { partyId: id });
  batch.update(invitation(guest), { status: 'accepted' });
  await assertSucceeds(batch.commit());
});

test('forged counts and changing another player are rejected', async () => {
  await create();
  const guest = db('guest');
  await join(guest, 'guest');
  await chooseGame();
  const p = (await getDoc(partyRef(guest))).data();
  await assertFails(updateDoc(partyRef(guest), {
    members: { ...p.members, guest: { ...p.members.guest,
      cardCount: 7, selectionRevision: 1, ready: true } },
    updatedAt: serverTimestamp(),
  }));
  await assertFails(updateDoc(partyRef(guest), {
    members: { ...p.members, host: { ...p.members.host, name: 'Changed by guest' } },
    updatedAt: serverTimestamp(),
  }));
});

test('eight players can select, ready and start within rule evaluation limits', async () => {
  const host = db('host');
  await create(host);
  for (let i = 1; i < 8; i++) await join(db('p' + i), 'p' + i);
  await chooseGame(host);
  for (const uid of ['host', ...Array.from({ length: 7 }, (_, i) => 'p' + (i + 1))]) {
    await select(db(uid), uid);
    await ready(db(uid), uid);
  }
  await assertSucceeds(updateDoc(partyRef(host), {
    phase: 'playing', updatedAt: serverTimestamp(),
  }));
});

test('pending invitation query filters resolved invitations and protects recipients', async () => {
  await create();
  const host = db('host'), guest = db('guest');
  const invitation = client => doc(client, 'partyInvitations', id + '_guest');
  await setDoc(invitation(host), {
    partyId: id, senderId: 'host', recipientId: 'guest',
    status: 'pending', createdAt: serverTimestamp(),
  });
  const pending = client => query(collection(client, 'partyInvitations'),
    where('recipientId', '==', 'guest'), where('status', '==', 'pending'));
  assert.equal((await assertSucceeds(getDocs(pending(guest)))).size, 1);
  await assertFails(getDocs(pending(db('outsider'))));
  await updateDoc(invitation(guest), { status: 'declined' });
  assert.equal((await assertSucceeds(getDocs(pending(guest)))).size, 0);
});

test('unready player can replace cards without rewriting unchanged lobby metadata', async () => {
  await create();
  const guest = db('guest');
  await join(guest, 'guest');
  await chooseGame();
  await select(guest, 'guest');
  const before = (await getDoc(partyRef(guest))).data();
  const hand = (await getDoc(handRef(guest, 'guest'))).data();
  const replacement = { id: 'replacement', deckId: 'deck',
    imageUrl: 'https://example.invalid/replacement.jpg' };
  await setDoc(doc(guest, 'users', 'guest', 'partyCards', replacement.id),
    { deckId: replacement.deckId, imageUrl: replacement.imageUrl });
  hand.cards[0] = replacement;
  // The repository skips a lobby write when only private card IDs changed.
  await assertSucceeds(setDoc(handRef(guest, 'guest'), hand));
  assert.deepEqual((await getDoc(partyRef(guest))).data(), before);
  assert.equal((await getDoc(handRef(guest, 'guest'))).data().cards[0].id,
    'replacement');
});
test('host leave transfers to earliest remaining join and publishes event atomically', async () => {
  const host = db('host');
  await create(host);
  await join(db('first'), 'first');
  await join(db('second'), 'second');
  const p = (await getDoc(partyRef(host))).data();
  const change = {
    hostId: 'first', memberIds: ['first', 'second'],
    members: { first: p.members.first, second: p.members.second },
    updatedAt: serverTimestamp(),
  };
  await assertFails(updateDoc(partyRef(host), change));
  const batch = writeBatch(host);
  batch.update(partyRef(host), change);
  batch.set(sessionRef(host, 'host'), { partyId: null });
  batch.delete(handRef(host, 'host'));
  batch.set(doc(host, 'parties', id, 'events', 'transfer'), {
    type: 'promoted', actor: 'host', target: 'first', name: 'first',
    createdAt: serverTimestamp(),
  });
  await assertSucceeds(batch.commit());
  assert.equal((await getDoc(partyRef(db('first')))).data().hostId, 'first');
  assert.equal((await getDoc(sessionRef(host, 'host'))).data().partyId, null);
  await assertSucceeds(getDocs(query(collection(db('first'), 'parties', id, 'events'),
    require('firebase/firestore').orderBy('createdAt', 'desc'),
    require('firebase/firestore').limit(20))));
  await assertFails(getDocs(collection(db('outsider'), 'parties', id, 'events')));
});

test('host cannot skip join order during automatic succession', async () => {
  const host = db('host');
  await create(host);
  await join(db('first'), 'first');
  await join(db('second'), 'second');
  const p = (await getDoc(partyRef(host))).data();
  const batch = writeBatch(host);
  batch.update(partyRef(host), {
    hostId: 'second', memberIds: ['first', 'second'],
    members: { first: p.members.first, second: p.members.second },
    updatedAt: serverTimestamp(),
  });
  batch.set(sessionRef(host, 'host'), { partyId: null });
  await assertFails(batch.commit());
});

test('kick notifications require an actual roster removal; events cannot be forged or edited', async () => {
  const host = db('host');
  await create(host); await join(db('guest'), 'guest');
  const event = doc(host, 'parties', id, 'events', 'kick');
  const data = { type: 'kicked', actor: 'host', target: 'guest', name: 'guest',
    createdAt: serverTimestamp() };
  await assertFails(setDoc(event, data));
  const batch = writeBatch(host);
  batch.update(partyRef(host), {
    memberIds: ['host'], members: { host: member('host') }, updatedAt: serverTimestamp(),
  });
  batch.set(sessionRef(host, 'guest'), { partyId: null });
  batch.delete(handRef(host, 'guest'));
  batch.set(event, data);
  await assertSucceeds(batch.commit());
  await assertFails(updateDoc(event, { name: 'forged' }));
  await assertFails(getDoc(doc(db('guest'), 'parties', id, 'events', 'kick')));
});

test('deck favorite metadata accepts only booleans', async () => {
  const ref = doc(db('host'), 'users', 'host', 'partyDecks', 'favorite');
  await assertSucceeds(setDoc(ref, { name: 'Favorites', favorite: true }));
  await assertFails(updateDoc(ref, { favorite: 'true' }));
  await assertFails(getDoc(doc(db('guest'), 'users', 'host', 'partyDecks', 'favorite')));
});

// Contending clients must never leave orphaned membership/session records.
test('twelve simultaneous joins cannot exceed capacity or claim rejected sessions', async () => {
  await create();
  const names = Array.from({length: 12}, (_, i) => 'race' + i);
  const clients = names.map(db);
  const results = await Promise.allSettled(names.map((uid, i) => join(clients[i], uid)));
  const p = (await getDoc(partyRef(db('host')))).data();
  const accepted = names.filter((_, i) => results[i].status === 'fulfilled');
  assert.ok(accepted.length > 0);
  assert.ok(p.memberIds.length <= 8);
  assert.deepEqual(new Set(p.memberIds), new Set(['host', ...accepted]));
  for (let i = 0; i < names.length; i++) {
    const session = await getDoc(sessionRef(clients[i], names[i]));
    assert.equal(session.data()?.partyId ?? null, accepted.includes(names[i]) ? id : null);
  }
});

test('simultaneous duplicate joins claim one membership only', async () => {
  await create();
  const client = db('duplicate');
  const results = await Promise.allSettled([join(client, 'duplicate'), join(client, 'duplicate')]);
  assert.equal(results.filter(r => r.status === 'fulfilled').length, 1);
  assert.deepEqual((await getDoc(partyRef(db('host')))).data().memberIds, ['host', 'duplicate']);
});

test('two simultaneous creates by one user persist exactly one party and session', async () => {
  const client = db('host');
  async function createAt(code) {
    return runTransaction(client, async tx => {
      const session = await tx.get(sessionRef(client, 'host'));
      const ref = doc(client, 'parties', code);
      await tx.get(ref);
      if (session.data()?.partyId) throw Error('already joined');
      tx.set(ref, {
        hostId: 'host', phase: 'lobby', revision: 0, game: null,
        memberIds: ['host'], members: { host: member('host') },
        createdAt: serverTimestamp(), updatedAt: serverTimestamp(),
      });
      tx.set(sessionRef(client, 'host'), { partyId: code });
    });
  }
  const codes = ['123456', '654321'];
  const results = await Promise.allSettled(codes.map(createAt));
  assert.equal(results.filter(r => r.status === 'fulfilled').length, 1);
  const active = (await getDoc(sessionRef(client, 'host'))).data().partyId;
  for (const code of codes) {
    assert.equal((await getDoc(doc(client, 'parties', code))).exists(), code === active);
  }
});

test('start racing settings change cannot start with invalidated readiness', async () => {
  const host = db('host'), guest = db('guest');
  await create(host); await join(guest, 'guest'); await chooseGame(host);
  await select(host, 'host'); await select(guest, 'guest');
  await ready(host, 'host'); await ready(guest, 'guest');
  const results = await Promise.allSettled([
    updateDoc(partyRef(host), { phase: 'playing', updatedAt: serverTimestamp() }),
    updateDoc(partyRef(host), { game: { ...game, rounds: 5 }, revision: 2,
      updatedAt: serverTimestamp() }),
  ]);
  assert.equal(results.filter(r => r.status === 'fulfilled').length, 1);
  const p = (await getDoc(partyRef(host))).data();
  if (p.phase === 'playing') {
    assert.equal(p.revision, 1);
    assert.equal(p.game.rounds, 3);
  } else {
    assert.equal(p.phase, 'lobby');
    assert.equal(p.revision, 2);
    await assertFails(updateDoc(partyRef(host), {
      phase: 'playing', updatedAt: serverTimestamp(),
    }));
  }
});

test('stale Ready after a kick cannot restore membership, hand access or session', async () => {
  const host = db('host'), guest = db('guest');
  await create(host); await join(guest, 'guest'); await chooseGame(host);
  await select(guest, 'guest');
  const before = (await getDoc(partyRef(guest))).data();
  const kick = writeBatch(host);
  kick.update(partyRef(host), { memberIds: ['host'], members: { host: before.members.host },
    updatedAt: serverTimestamp() });
  kick.set(sessionRef(host, 'guest'), { partyId: null });
  kick.delete(handRef(host, 'guest'));
  await kick.commit();
  await assertFails(updateDoc(partyRef(guest), {
    members: { ...before.members, guest: { ...before.members.guest, ready: true } },
    updatedAt: serverTimestamp(),
  }));
  await assertFails(getDoc(handRef(guest, 'guest')));
  assert.equal((await getDoc(sessionRef(guest, 'guest'))).data().partyId, null);
  assert.deepEqual((await getDoc(partyRef(host))).data().memberIds, ['host']);
});

test('eight selected hands are deleted with every session on disband', async () => {
  const host = db('host');
  await create(host); await chooseGame(host);
  const uids = ['host', ...Array.from({ length: 7 }, (_, i) => 'p' + i)];
  for (const uid of uids.slice(1)) await join(db(uid), uid);
  for (const uid of uids) await select(db(uid), uid);
  const batch = writeBatch(host);
  batch.update(partyRef(host), { phase: 'closed', updatedAt: serverTimestamp() });
  for (const uid of uids) {
    batch.set(sessionRef(host, uid), { partyId: null });
    batch.delete(handRef(host, uid));
  }
  await assertSucceeds(batch.commit());
  // Inspect only this disposable emulator fixture with rules disabled.
  await env.withSecurityRulesDisabled(async context => {
    for (const uid of uids) {
      assert.equal((await getDoc(handRef(context.firestore(), uid))).exists(), false);
      assert.equal((await getDoc(sessionRef(context.firestore(), uid))).data().partyId, null);
    }
  });
});
