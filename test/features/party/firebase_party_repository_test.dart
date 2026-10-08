// -----------------------------------------------------------------------------
// firebase_party_repository_test.dart
// Run the real Dart repository with recording Firebase dependencies. These tests
// check its reads/writes; the separate emulator suite checks server enforcement.
// -----------------------------------------------------------------------------
// Test-only SDK doubles record calls without connecting to Firebase.
// ignore_for_file: subtype_of_sealed_class
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/features/party/data/firebase_party_repository.dart';
import 'package:socialdeck/features/party/data/party_firestore_mapper.dart';
import 'package:socialdeck/features/party/domain/party_failure.dart';
import 'package:socialdeck/features/party/domain/party_models.dart';

class TestUser implements User {
  TestUser(this.uid);
  @override
  final String uid;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TestAuth implements FirebaseAuth {
  TestAuth(String uid) : currentUser = TestUser(uid);
  @override
  User? currentUser;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class RecordedWrite {
  RecordedWrite(this.path, this.data, this.options);
  final String path;
  final Map<String, dynamic>? data;
  final SetOptions? options;
}

class RecordingFirestore implements FirebaseFirestore {
  final documents = <String, Map<String, dynamic>>{};
  final reads = <String>[];
  final writes = <RecordedWrite>[];
  Future<void> Function(String path)? beforeRead;

  @override
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      TestCollection(path);
  @override
  Future<T> runTransaction<T>(
    TransactionHandler<T> handler, {
    Duration timeout = const Duration(seconds: 30),
    int maxAttempts = 5,
  }) => handler(RecordingTransaction(this));
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TestCollection implements CollectionReference<Map<String, dynamic>> {
  TestCollection(this.path);
  @override
  final String path;
  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) =>
      TestDocument('${this.path}/$path');
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TestDocument implements DocumentReference<Map<String, dynamic>> {
  TestDocument(this.path);
  @override
  final String path;
  @override
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      TestCollection('${this.path}/$path');
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TestSnapshot<T> implements DocumentSnapshot<T> {
  TestSnapshot(this.path, this.value);
  final String path;
  final T? value;
  @override
  String get id => path.split('/').last;
  @override
  bool get exists => value != null;
  @override
  T? data() => value;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class RecordingTransaction implements Transaction {
  RecordingTransaction(this.db);
  final RecordingFirestore db;
  @override
  Future<DocumentSnapshot<T>> get<T>(DocumentReference<T> ref) async {
    db.reads.add(ref.path);
    await db.beforeRead?.call(ref.path);
    return TestSnapshot<T>(ref.path, db.documents[ref.path] as T?);
  }

  @override
  Transaction set<T>(DocumentReference<T> ref, T data, [SetOptions? options]) {
    db.writes.add(
      RecordedWrite(ref.path, data as Map<String, dynamic>, options),
    );
    return this;
  }

  @override
  Transaction update(DocumentReference ref, Map<String, dynamic> data) {
    db.writes.add(RecordedWrite(ref.path, data, null));
    return this;
  }

  @override
  Transaction delete(DocumentReference ref) {
    db.writes.add(RecordedWrite(ref.path, null, null));
    return this;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Matcher fails(PartyError code) =>
    throwsA(isA<PartyFailure>().having((e) => e.code, 'code', code));

void main() {
  late RecordingFirestore db;
  late TestAuth auth;
  late FirebasePartyRepository repository;
  setUp(() {
    db = RecordingFirestore();
    auth = TestAuth('host');
    repository = FirebasePartyRepository(
      uid: 'host',
      firestore: db,
      auth: auth,
    );
    db.documents['parties/123456'] = PartyFirestoreMapper.toMap(
      Party(
        id: '123456',
        hostId: 'host',
        members: {
          'host': const PartyMember(uid: 'host', name: 'Host'),
          'guest': const PartyMember(uid: 'guest', name: 'Guest'),
        },
      ),
    );
  });

  test('identical identity, host, and game avoid redundant writes', () async {
    await repository.updateIdentity('123456', 'Host', null);
    await repository.promoteHost('123456', 'host');
    await repository.selectGame('123456', null);
    expect(db.writes, isEmpty);
  });

  test('identity update merges only the changed member', () async {
    await repository.updateIdentity('123456', 'Alex', 'cat');
    final write = db.writes.single;
    expect(write.options!.merge, isTrue);
    expect(write.data!.keys.toSet(), {'updatedAt', 'members'});
    final members = write.data!['members'] as Map;
    expect(members.keys, ['host']);
    expect(members['host']['name'], 'Alex');
    expect(
      db.documents['parties/123456']!['members']['guest']['name'],
      'Guest',
    );
  });

  test(
    'missing game rejects selection before reading card documents',
    () async {
      await expectLater(
        repository.selectCards('123456', ['card1']),
        fails(PartyError.noGame),
      );
      expect(db.reads, ['parties/123456']);
      expect(db.writes, isEmpty);
    },
  );

  test(
    'invalid join name is rejected before making any database reads',
    () async {
      await expectLater(
        repository.joinParty('123456', ' '),
        fails(PartyError.invalidInput),
      );
      expect(db.reads, isEmpty);
    },
  );

  test(
    'an old repository cannot submit after the signed-in account changes',
    () async {
      auth.currentUser = TestUser('another-user');
      await expectLater(
        repository.createParty('Alex'),
        fails(PartyError.unauthenticated),
      );
      expect(db.reads, isEmpty);
      expect(db.writes, isEmpty);
    },
  );

  test('invitation IDs support a full 128-character user ID', () async {
    final uid = List.filled(128, 'u').join();
    final invitationId = '123456_$uid';
    repository = FirebasePartyRepository(
      uid: uid,
      firestore: db,
      auth: TestAuth(uid),
    );
    db.documents['partyInvitations/$invitationId'] = {
      'recipientId': uid,
      'partyId': '123456',
      'status': 'pending',
    };
    await repository.declineInvitation(invitationId);
    expect(db.writes.single.path, 'partyInvitations/$invitationId');
    expect(db.writes.single.data, {'status': 'declined'});
  });

  test('card selection uses a frozen copy of the caller list', () async {
    final game = const PartyGame();
    db.documents['parties/123456']!['game'] = PartyFirestoreMapper.gameToMap(
      game,
    );
    db.documents['users/host/partyCards/original'] = {
      'deckId': 'deck',
      'imageUrl': 'https://example.invalid/original.jpg',
    };
    final gate = Completer<void>();
    db.beforeRead = (path) async {
      if (path == 'parties/123456') await gate.future;
    };
    final ids = ['original'];
    final pending = repository.selectCards('123456', ids);
    ids[0] = 'changed-while-loading';
    gate.complete();
    await pending;
    expect(db.reads, contains('users/host/partyCards/original'));
    expect(
      db.reads,
      isNot(contains('users/host/partyCards/changed-while-loading')),
    );
    final hand = db.writes.singleWhere((w) => w.path.endsWith('/hands/host'));
    expect((hand.data!['cards'] as List).single['id'], 'original');
  });

  test(
    'kick writes member removal, session release, and hand deletion together',
    () async {
      await repository.kickPlayer('123456', 'guest');
      expect(db.writes.take(3).map((w) => w.path).toSet(), {
        'parties/123456',
        'partySessions/guest',
        'parties/123456/hands/guest',
      });
      final patch = db.writes.first.data!;
      expect((patch['members'] as Map).keys, ['guest']);
      expect(db.writes[1].data, {'partyId': null});
      expect(db.writes[2].data, isNull);
    },
  );
}
