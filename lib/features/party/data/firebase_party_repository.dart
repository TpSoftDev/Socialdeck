// -----------------------------------------------------------------------------
// firebase_party_repository.dart
// Firestore persistence for shared Party state. Transactions serialize competing
// joins, host changes, selections and start requests. This repository is bound
// to one authenticated user; server rules remain the authorization authority.
// -----------------------------------------------------------------------------
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/party_failure.dart';
import '../domain/party_models.dart';
import '../domain/party_policy.dart';
import '../domain/party_repository.dart';
import 'party_firestore_mapper.dart';
import 'party_firebase_errors.dart';

class FirebasePartyRepository implements PartyRepository {
  FirebasePartyRepository({
    required this.uid,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    Random? random,
  }) : _db = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _random = random ?? Random.secure();

  final String uid;
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  final Random _random;

  DocumentReference<Map<String, dynamic>> _party(String id) =>
      _db.collection('parties').doc(PartyPolicy.cleanCode(id));
  DocumentReference<Map<String, dynamic>> _session(String userId) =>
      _db.collection('partySessions').doc(userId);
  DocumentReference<Map<String, dynamic>> _hand(String id, String userId) =>
      _party(id).collection('hands').doc(userId);

  void _signedIn() =>
      requireParty(_auth.currentUser?.uid == uid, PartyError.unauthenticated);

  // Invitation IDs include the six-digit code plus the recipient UID.
  static void _documentId(String id, {int maxLength = 128}) => requireParty(
    id.isNotEmpty &&
        id.length <= maxLength &&
        !id.contains('/') &&
        id != '.' &&
        id != '..',
    PartyError.invalidInput,
  );

  /// Check the account and turn backend errors into Party errors.
  Future<T> _run<T>(Future<T> Function() action) async {
    try {
      _signedIn();
      return await action();
    } catch (error, stack) {
      Error.throwWithStackTrace(PartyFirebaseErrors.map(error), stack);
    }
  }

  Stream<T> _stream<T>(Stream<T> source) => PartyFirebaseErrors.stream(source);

  /// Load the snapshot that the transaction will validate.
  Future<Party> _read(Transaction tx, String id) async {
    final snapshot = await tx.get(_party(id));
    requireParty(snapshot.exists, PartyError.notFound);
    return PartyFirestoreMapper.fromMap(snapshot.id, snapshot.data()!);
  }

  /// Send only changed fields and leave other players' data alone.
  void _write(Transaction tx, Party before, Party after) {
    final data = <String, dynamic>{'updatedAt': FieldValue.serverTimestamp()};
    if (before.hostId != after.hostId) data['hostId'] = after.hostId;
    if (before.phase != after.phase) data['phase'] = after.phase.name;
    if (before.revision != after.revision) {
      data['revision'] = after.revision;
      data['game'] = after.game == null
          ? null
          : PartyFirestoreMapper.gameToMap(after.game!);
    }
    final beforeIds = before.members.keys.toSet();
    final afterIds = after.members.keys.toSet();
    final added = afterIds.difference(beforeIds);
    final removed = beforeIds.difference(afterIds);
    if (added.isNotEmpty) {
      data['memberIds'] = FieldValue.arrayUnion(added.toList());
    }
    if (removed.isNotEmpty) {
      data['memberIds'] = FieldValue.arrayRemove(removed.toList());
    }
    final changes = <String, dynamic>{};
    for (final key in beforeIds.union(afterIds)) {
      if (before.members[key] != after.members[key]) {
        changes[key] = after.members.containsKey(key)
            ? PartyFirestoreMapper.memberToMap(after.members[key]!)
            : FieldValue.delete();
      }
    }
    if (changes.isNotEmpty) data['members'] = changes;
    if (data.length == 1) return; // Nothing changed; avoid a redundant write.
    // Merge only changed members; atomic array transforms preserve concurrent
    // joins. The transaction still validates the complete snapshot first.
    tx.set(_party(after.id), data, SetOptions(merge: true));
  }

  /// Read, validate, and write as one atomic operation.
  Future<void> _mutate(String id, Party Function(Party) transition) => _run(
    () => _db.runTransaction((tx) async {
      final current = await _read(tx, id);
      _write(tx, current, transition(current));
    }),
  );

  @override
  Stream<String?> watchActivePartyId() {
    _signedIn();
    return _stream(
      _session(
        uid,
      ).snapshots().map((s) => s.data()?['partyId'] as String?).distinct(),
    );
  }

  @override
  Stream<Party?> watchParty(String partyId) {
    _signedIn();
    return _stream(
      _party(partyId).snapshots().map(
        (s) => s.exists ? PartyFirestoreMapper.fromMap(s.id, s.data()!) : null,
      ),
    );
  }

  @override
  Stream<List<PartyEvent>> watchEvents(String partyId) {
    _signedIn();
    return _stream(
      _party(partyId)
          .collection('events')
          .orderBy('createdAt', descending: true)
          .limit(20)
          .snapshots()
          .map(
            (s) => List.unmodifiable(
              s.docs.map(
                (d) => PartyEvent(
                  id: d.id,
                  type: d.data()['type'] as String,
                  name: d.data()['name'] as String,
                ),
              ),
            ),
          ),
    );
  }

  // The rules verify that the matching roster change occurs in this transaction.
  void _event(Transaction tx, Party party, String type, String target) {
    final eventId =
        '${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(1 << 32)}';
    tx.set(_party(party.id).collection('events').doc(eventId), {
      'type': type,
      'actor': uid,
      'target': target,
      'name': party.members[target]!.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<PartyHand?> watchMyHand(String partyId) {
    _signedIn();
    return _stream(
      _hand(partyId, uid).snapshots().map(
        (s) => s.exists ? PartyFirestoreMapper.handFromMap(s.data()!) : null,
      ),
    );
  }

  @override
  Stream<List<PartyInvitation>> watchInvitations() {
    _signedIn();
    return _stream(
      _db
          .collection('partyInvitations')
          .where('recipientId', isEqualTo: uid)
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .map(
            (s) => List.unmodifiable(
              s.docs.map(
                (d) => PartyFirestoreMapper.invitation(d.id, d.data()),
              ),
            ),
          ),
    );
  }

  @override
  Future<String> createParty(String name) => _run(() async {
    final cleanName = PartyPolicy.cleanName(name);
    for (var attempt = 0; attempt < 20; attempt++) {
      final id = (100000 + _random.nextInt(900000)).toString();
      final created = await _db.runTransaction((tx) async {
        final session = await tx.get(_session(uid));
        requireParty(
          session.data()?['partyId'] == null,
          PartyError.alreadyInParty,
        );
        final existing = await tx.get(_party(id));
        // Codes are never reused: stale invitations cannot join a new party.
        if (existing.exists) return false;
        final party = Party(
          id: id,
          hostId: uid,
          members: {uid: PartyMember(uid: uid, name: cleanName)},
        );
        tx.set(_party(id), {
          ...PartyFirestoreMapper.toMap(party),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        tx.set(_session(uid), {'partyId': id});
        return true;
      });
      if (created) return id;
    }
    throw const PartyFailure(PartyError.conflict);
  });

  @override
  Future<String> joinParty(String code, String name, {String? invitationId}) =>
      _run(() async {
        final id = PartyPolicy.cleanCode(code);
        final cleanName = PartyPolicy.cleanName(name);
        if (invitationId != null) _documentId(invitationId, maxLength: 135);
        await _db.runTransaction((tx) async {
          final session = await tx.get(_session(uid));
          requireParty(
            session.data()?['partyId'] == null,
            PartyError.alreadyInParty,
          );
          final current = await _read(tx, id);
          final next = PartyPolicy.join(current, uid, cleanName);
          final inviteRef = invitationId == null
              ? null
              : _db.collection('partyInvitations').doc(invitationId);
          if (inviteRef != null) {
            final invite = await tx.get(inviteRef);
            final data = invite.data();
            requireParty(
              data != null &&
                  data['recipientId'] == uid &&
                  data['partyId'] == id &&
                  data['status'] == 'pending',
              PartyError.invalidInput,
            );
          }
          _write(tx, current, next);
          tx.set(_session(uid), {'partyId': id});
          if (inviteRef != null) tx.update(inviteRef, {'status': 'accepted'});
        });
        return id;
      });

  /// Release membership, the active session, and private cards together.
  Future<void> _remove(String partyId, String target) => _run(() async {
    _documentId(target);
    await _db.runTransaction((tx) async {
      final party = await _read(tx, partyId);
      final next = PartyPolicy.remove(party, uid, target);
      _write(tx, party, next);
      tx.set(_session(target), {'partyId': null});
      tx.delete(_hand(partyId, target));
      if (target != uid) _event(tx, party, 'kicked', target);
    });
  });

  @override
  Future<void> leaveParty(String partyId) => _run(
    () => _db.runTransaction((tx) async {
      final party = await _read(tx, partyId);
      final next = PartyPolicy.leave(party, uid);
      _write(tx, party, next);
      tx.set(_session(uid), {'partyId': null});
      tx.delete(_hand(partyId, uid));
      if (next.hostId != party.hostId) {
        _event(tx, party, 'promoted', next.hostId);
      }
    }),
  );
  @override
  Future<void> kickPlayer(String partyId, String target) =>
      _remove(partyId, target);
  @override
  Future<void> promoteHost(String partyId, String target) => _run(
    () => _db.runTransaction((tx) async {
      final party = await _read(tx, partyId);
      final next = PartyPolicy.promote(party, uid, target);
      _write(tx, party, next);
      if (next.hostId != party.hostId) _event(tx, party, 'promoted', target);
    }),
  );
  @override
  Future<void> updateIdentity(
    String partyId,
    String name,
    String? characterId,
  ) => _mutate(partyId, (p) => PartyPolicy.identity(p, uid, name, characterId));
  @override
  Future<void> selectGame(String partyId, PartyGame? game) =>
      _mutate(partyId, (p) => PartyPolicy.selectGame(p, uid, game));
  @override
  Future<void> setReady(String partyId, bool ready) =>
      _mutate(partyId, (p) => PartyPolicy.setReady(p, uid, ready));
  @override
  Future<void> startGame(String partyId) =>
      _mutate(partyId, (p) => PartyPolicy.start(p, uid));

  @override
  Future<void> disbandParty(String partyId) => _run(
    () => _db.runTransaction((tx) async {
      final party = await _read(tx, partyId);
      _write(tx, party, PartyPolicy.disband(party, uid));
      for (final memberId in party.members.keys) {
        tx.set(_session(memberId), {'partyId': null});
        tx.delete(_hand(partyId, memberId));
      }
    }),
  );

  @override
  Future<void> selectCards(String partyId, List<String> cardIds) => _run(
    () async {
      // Freeze input before awaiting: the UI may edit its selection meanwhile.
      final selectedIds = List<String>.unmodifiable(cardIds);
      requireParty(
        selectedIds.length <= 7 &&
            selectedIds.toSet().length == selectedIds.length,
        PartyError.invalidCards,
      );
      for (final id in selectedIds) {
        _documentId(id);
      }
      await _db.runTransaction((tx) async {
        final party = await _read(tx, partyId);
        // Reject unusable requests before paying for individual card reads.
        PartyPolicy.member(party, uid);
        PartyPolicy.lobby(party);
        requireParty(party.game != null, PartyError.noGame);
        final cards = <PartyCard>[];
        // Read canonical owned cards: callers supply IDs, never arbitrary URLs.
        for (final id in selectedIds) {
          final snapshot = await tx.get(
            _db.collection('users').doc(uid).collection('partyCards').doc(id),
          );
          requireParty(snapshot.exists, PartyError.invalidCards);
          cards.add(PartyFirestoreMapper.card(id, snapshot.data()!));
        }
        final next = PartyPolicy.selectCards(party, uid, cards);
        _write(tx, party, next);
        tx.set(
          _hand(partyId, uid),
          PartyFirestoreMapper.handToMap(
            PartyHand(cards: cards, revision: party.revision),
          ),
        );
      });
    },
  );

  @override
  Future<void> invitePlayer(String partyId, String recipientId) => _run(
    () async {
      _documentId(recipientId);
      requireParty(recipientId != uid, PartyError.invalidInput);
      await _db.runTransaction((tx) async {
        final party = await _read(tx, partyId);
        PartyPolicy.member(party, uid);
        PartyPolicy.lobby(party);
        requireParty(
          !party.members.containsKey(recipientId),
          PartyError.alreadyInParty,
        );
        requireParty(party.members.length < Party.maxPlayers, PartyError.full);
        tx.set(
          _db.collection('partyInvitations').doc('${party.id}_$recipientId'),
          {
            'partyId': party.id,
            'senderId': uid,
            'recipientId': recipientId,
            'status': 'pending',
            'createdAt': FieldValue.serverTimestamp(),
          },
        );
      });
    },
  );

  @override
  Future<void> declineInvitation(String invitationId) => _run(() async {
    _documentId(invitationId, maxLength: 135);
    final ref = _db.collection('partyInvitations').doc(invitationId);
    await _db.runTransaction((tx) async {
      final snapshot = await tx.get(ref);
      requireParty(snapshot.exists, PartyError.notFound);
      requireParty(
        snapshot.data()!['recipientId'] == uid,
        PartyError.forbidden,
      );
      requireParty(
        snapshot.data()!['status'] == 'pending',
        PartyError.invalidInput,
      );
      tx.update(ref, {'status': 'declined'});
    });
  });
}
