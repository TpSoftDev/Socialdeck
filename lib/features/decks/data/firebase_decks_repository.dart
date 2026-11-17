/*---------------------- firebase_decks_repository.dart ----------------------*/
// Firestore implementation of DecksRepository scoped to one authenticated UID.
// Persists local-reference deck metadata at users/{uid}/decks/{deckId} and
// Quick Pics at users/{uid}/quickPics/main without uploading photos to Storage.
//
// Usage:
//   final repo = FirebaseDecksRepository(uid: user.uid);
//   final decksStream = repo.watchDecks();
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/deck_card_entity.dart';
import '../domain/deck_entity.dart';
import '../domain/decks_failure.dart';
import '../domain/decks_repository.dart';
import '../domain/quick_pics_entity.dart';
import 'decks_firestore_mapper.dart';

//------------------------- FirebaseDecksRepository -------------------------//
class FirebaseDecksRepository implements DecksRepository {
  FirebaseDecksRepository({
    required this.uid,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    math.Random? random,
  }) : _db = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _random = random ?? math.Random();

  //*************************** Dependencies ********************************//
  final String uid;
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;
  final math.Random _random;

  //*************************** Document References *************************//
  DocumentReference<Map<String, dynamic>> get _userDoc =>
      _db.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>> get _decksCollection =>
      _userDoc.collection('decks');

  DocumentReference<Map<String, dynamic>> _deckDoc(String deckId) {
    _validateDocId(deckId);
    return _decksCollection.doc(deckId);
  }

  DocumentReference<Map<String, dynamic>> get _quickPicsDoc =>
      _userDoc.collection('quickPics').doc(QuickPicsEntity.documentId);

  //*************************** Auth & Error Guards *************************//
  void _requireSignedIn() {
    requireDecks(
      _auth.currentUser?.uid == uid,
      DecksError.unauthenticated,
      'Authenticated account does not match repository UID.',
    );
  }

  static void _validateDocId(String id) {
    requireDecks(
      id.trim().isNotEmpty &&
          id.length <= 128 &&
          !id.contains('/') &&
          id != '.' &&
          id != '..',
      DecksError.invalidInput,
      'Invalid Firestore document ID: $id',
    );
  }

  Future<T> _guarded<T>(Future<T> Function() action) async {
    try {
      _requireSignedIn();
      return await action();
    } catch (error, stack) {
      Error.throwWithStackTrace(_mapError(error), stack);
    }
  }

  Stream<T> _guardedStream<T>(Stream<T> source) {
    _requireSignedIn();
    return source.handleError((Object error, StackTrace stack) {
      Error.throwWithStackTrace(_mapError(error), stack);
    });
  }

  static DecksFailure _mapError(Object error) {
    if (error is DecksFailure) return error;
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return DecksFailure(DecksError.permissionDenied, error.message);
        case 'unauthenticated':
          return DecksFailure(DecksError.unauthenticated, error.message);
        case 'not-found':
          return DecksFailure(DecksError.notFound, error.message);
        case 'unavailable':
        case 'deadline-exceeded':
        case 'network-request-failed':
          return DecksFailure(DecksError.network, error.message);
      }
      return DecksFailure(DecksError.unknown, error.message);
    }
    return DecksFailure(DecksError.unknown, error.toString());
  }

  //*************************** Streams *************************************//
  @override
  Stream<List<DeckEntity>> watchDecks() {
    return _guardedStream(
      _decksCollection
          .orderBy('orderIndex')
          .snapshots()
          .map(
            (snapshot) => List<DeckEntity>.unmodifiable(
              snapshot.docs.map(
                (doc) => DecksFirestoreMapper.deckFromMap(doc.id, doc.data()),
              ),
            ),
          ),
    );
  }

  @override
  Stream<QuickPicsEntity> watchQuickPics() {
    return _guardedStream(
      _quickPicsDoc.snapshots().map((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          return QuickPicsEntity();
        }
        return DecksFirestoreMapper.quickPicsFromMap(snapshot.data()!);
      }),
    );
  }

  @override
  Stream<bool> watchIsSocialdeckPlus() {
    return _guardedStream(
      _userDoc.snapshots().map(
        (snapshot) => snapshot.data()?['isSocialdeckPlus'] as bool? ?? false,
      ),
    );
  }

  //*************************** Deck Mutations ******************************//
  @override
  Future<DeckEntity> createDeck({
    required String name,
    required String colorKey,
  }) => _guarded(() async {
    final cleanedName = DeckEntity.cleanName(name);
    final cleanedColor = DeckEntity.cleanColorKey(colorKey);

    final userSnapshot = await _userDoc.get();
    final isPlus = userSnapshot.data()?['isSocialdeckPlus'] as bool? ?? false;

    final existingDecks = await _decksCollection.orderBy('orderIndex').get();
    requireDecks(
      isPlus || existingDecks.docs.length < DeckEntity.freeDeckLimit,
      DecksError.freeDeckLimitReached,
      'Upgrade to Socialdeck+ to create more than ${DeckEntity.freeDeckLimit} decks.',
    );

    final nextOrderIndex = existingDecks.docs.isEmpty
        ? 0
        : ((existingDecks.docs.last.data()['orderIndex'] as num?)?.toInt() ??
                  (existingDecks.docs.length - 1)) +
              1;

    final docRef = _decksCollection.doc();
    final now = DateTime.now();
    final deck = DeckEntity(
      id: docRef.id,
      name: cleanedName,
      colorKey: cleanedColor,
      orderIndex: nextOrderIndex,
      tiltDegrees: generateRestingTiltDegrees(_random),
      createdAt: now,
      updatedAt: now,
    );

    await docRef.set(<String, dynamic>{
      ...DecksFirestoreMapper.deckToMap(deck),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return deck;
  });

  @override
  Future<DeckEntity> updateDeck({
    required String deckId,
    String? name,
    String? colorKey,
    bool? favorited,
  }) => _guarded(() {
    final ref = _deckDoc(deckId);
    return _db.runTransaction((tx) async {
      final snapshot = await tx.get(ref);
      requireDecks(snapshot.exists, DecksError.notFound, 'Deck not found.');

      final existing = DecksFirestoreMapper.deckFromMap(
        snapshot.id,
        snapshot.data()!,
      );
      final updated = existing.copyWith(
        name: name != null ? DeckEntity.cleanName(name) : existing.name,
        colorKey:
            colorKey != null
                ? DeckEntity.cleanColorKey(colorKey)
                : existing.colorKey,
        favorited: favorited ?? existing.favorited,
        updatedAt: DateTime.now(),
      );
      updated.validate();

      tx.update(ref, <String, dynamic>{
        'name': updated.name,
        'colorKey': updated.colorKey,
        'favorited': updated.favorited,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return updated;
    });
  });

  @override
  Future<void> deleteDeck(String deckId) => _guarded(() async {
    final targetRef = _deckDoc(deckId);
    final existingSnapshot = await _decksCollection.orderBy('orderIndex').get();
    final hasTarget = existingSnapshot.docs.any((doc) => doc.id == deckId);
    requireDecks(hasTarget, DecksError.notFound, 'Deck $deckId not found.');

    final batch = _db.batch()..delete(targetRef);
    var nextIndex = 0;
    for (final doc in existingSnapshot.docs) {
      if (doc.id == deckId) continue;
      final currentOrder = (doc.data()['orderIndex'] as num?)?.toInt() ?? 0;
      if (currentOrder != nextIndex) {
        batch.update(doc.reference, <String, dynamic>{
          'orderIndex': nextIndex,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      nextIndex += 1;
    }
    await batch.commit();
  });

  @override
  Future<void> reorderDecks(List<String> orderedDeckIds) => _guarded(() async {
    if (orderedDeckIds.isEmpty) return;
    requireDecks(
      orderedDeckIds.toSet().length == orderedDeckIds.length,
      DecksError.invalidInput,
      'Duplicate deck IDs supplied to reorderDecks.',
    );

    final snapshot = await _decksCollection.get();
    final existingById = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{
      for (final doc in snapshot.docs) doc.id: doc,
    };
    requireDecks(
      orderedDeckIds.length == existingById.length &&
          orderedDeckIds.every(existingById.containsKey),
      DecksError.invalidInput,
      'orderedDeckIds must match existing decks.',
    );

    final batch = _db.batch();
    for (var i = 0; i < orderedDeckIds.length; i++) {
      final doc = existingById[orderedDeckIds[i]]!;
      final currentOrder = (doc.data()['orderIndex'] as num?)?.toInt() ?? -1;
      if (currentOrder != i) {
        batch.update(doc.reference, <String, dynamic>{
          'orderIndex': i,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
    await batch.commit();
  });

  //*************************** Deck Card Mutations *************************//
  @override
  Future<DeckEntity> addCardsToDeck({
    required String deckId,
    required List<NewDeckCardDraft> drafts,
  }) => _guarded(() {
    final ref = _deckDoc(deckId);
    return _db.runTransaction((tx) async {
      final snapshot = await tx.get(ref);
      requireDecks(snapshot.exists, DecksError.notFound, 'Deck not found.');

      final existing = DecksFirestoreMapper.deckFromMap(
        snapshot.id,
        snapshot.data()!,
      );
      if (drafts.isEmpty) return existing;

      requireDecks(
        existing.cards.length + drafts.length <= DeckEntity.maxCards,
        DecksError.deckCardLimitReached,
        'Deck cannot exceed ${DeckEntity.maxCards} cards.',
      );

      final createdCards = drafts.map(_buildCardFromDraft).toList();
      final updated = existing.copyWith(
        cards: <DeckCardEntity>[...existing.cards, ...createdCards],
        updatedAt: DateTime.now(),
      );
      updated.validate();

      tx.update(ref, <String, dynamic>{
        'cards': updated.cards.map(DecksFirestoreMapper.cardToMap).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return updated;
    });
  });

  @override
  Future<DeckEntity> reorderDeckCards({
    required String deckId,
    required List<String> orderedCardIds,
  }) => _guarded(() {
    final ref = _deckDoc(deckId);
    return _db.runTransaction((tx) async {
      final snapshot = await tx.get(ref);
      requireDecks(snapshot.exists, DecksError.notFound, 'Deck not found.');

      final existing = DecksFirestoreMapper.deckFromMap(
        snapshot.id,
        snapshot.data()!,
      );
      final reordered = _reorderCardList(existing.cards, orderedCardIds);
      final updated = existing.copyWith(
        cards: reordered,
        updatedAt: DateTime.now(),
      );
      updated.validate();

      tx.update(ref, <String, dynamic>{
        'cards': updated.cards.map(DecksFirestoreMapper.cardToMap).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return updated;
    });
  });

  @override
  Future<DeckEntity> removeCardsFromDeck({
    required String deckId,
    required Set<String> cardIds,
  }) => _guarded(() {
    final ref = _deckDoc(deckId);
    return _db.runTransaction((tx) async {
      final snapshot = await tx.get(ref);
      requireDecks(snapshot.exists, DecksError.notFound, 'Deck not found.');

      final existing = DecksFirestoreMapper.deckFromMap(
        snapshot.id,
        snapshot.data()!,
      );
      if (cardIds.isEmpty) return existing;

      final filtered =
          existing.cards.where((card) => !cardIds.contains(card.id)).toList();
      final updated = existing.copyWith(
        cards: filtered,
        updatedAt: DateTime.now(),
      );
      updated.validate();

      tx.update(ref, <String, dynamic>{
        'cards': updated.cards.map(DecksFirestoreMapper.cardToMap).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return updated;
    });
  });

  @override
  Future<DeckEntity> updateDeckCardTransform({
    required String deckId,
    required String cardId,
    required double scale,
    required double panX,
    required double panY,
    required double rotation,
  }) => _guarded(() {
    final ref = _deckDoc(deckId);
    return _db.runTransaction((tx) async {
      final snapshot = await tx.get(ref);
      requireDecks(snapshot.exists, DecksError.notFound, 'Deck not found.');

      final existing = DecksFirestoreMapper.deckFromMap(
        snapshot.id,
        snapshot.data()!,
      );
      final index = existing.cards.indexWhere((card) => card.id == cardId);
      requireDecks(index != -1, DecksError.notFound, 'Card $cardId not found.');

      final nextCards = List<DeckCardEntity>.of(existing.cards);
      nextCards[index] = nextCards[index].copyWith(
        scale: scale,
        panX: panX,
        panY: panY,
        rotation: rotation,
      );

      final updated = existing.copyWith(
        cards: nextCards,
        updatedAt: DateTime.now(),
      );
      updated.validate();

      tx.update(ref, <String, dynamic>{
        'cards': updated.cards.map(DecksFirestoreMapper.cardToMap).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return updated;
    });
  });

  //*************************** Quick Pics Mutations ************************//
  @override
  Future<QuickPicsEntity> addCardsToQuickPics(
    List<NewDeckCardDraft> drafts,
  ) => _guarded(() {
    return _db.runTransaction((tx) async {
      final snapshot = await tx.get(_quickPicsDoc);
      final existing =
          (snapshot.exists && snapshot.data() != null)
              ? DecksFirestoreMapper.quickPicsFromMap(snapshot.data()!)
              : QuickPicsEntity();
      if (drafts.isEmpty) return existing;

      requireDecks(
        existing.cards.length + drafts.length <= QuickPicsEntity.maxCards,
        DecksError.quickPicsLimitReached,
        'Quick Pics cannot exceed ${QuickPicsEntity.maxCards} cards.',
      );

      final createdCards = drafts.map(_buildCardFromDraft).toList();
      final updated = existing.copyWith(
        cards: <DeckCardEntity>[...existing.cards, ...createdCards],
        updatedAt: DateTime.now(),
      );
      updated.validate();

      tx.set(_quickPicsDoc, <String, dynamic>{
        ...DecksFirestoreMapper.quickPicsToMap(updated),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return updated;
    });
  });

  @override
  Future<QuickPicsEntity> reorderQuickPics(
    List<String> orderedCardIds,
  ) => _guarded(() {
    return _db.runTransaction((tx) async {
      final snapshot = await tx.get(_quickPicsDoc);
      final existing =
          (snapshot.exists && snapshot.data() != null)
              ? DecksFirestoreMapper.quickPicsFromMap(snapshot.data()!)
              : QuickPicsEntity();

      final reordered = _reorderCardList(existing.cards, orderedCardIds);
      final updated = existing.copyWith(
        cards: reordered,
        updatedAt: DateTime.now(),
      );
      updated.validate();

      tx.set(_quickPicsDoc, <String, dynamic>{
        ...DecksFirestoreMapper.quickPicsToMap(updated),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return updated;
    });
  });

  @override
  Future<QuickPicsEntity> removeCardsFromQuickPics(
    Set<String> cardIds,
  ) => _guarded(() {
    return _db.runTransaction((tx) async {
      final snapshot = await tx.get(_quickPicsDoc);
      final existing =
          (snapshot.exists && snapshot.data() != null)
              ? DecksFirestoreMapper.quickPicsFromMap(snapshot.data()!)
              : QuickPicsEntity();
      if (cardIds.isEmpty) return existing;

      final filtered =
          existing.cards.where((card) => !cardIds.contains(card.id)).toList();
      final updated = existing.copyWith(
        cards: filtered,
        updatedAt: DateTime.now(),
      );
      updated.validate();

      tx.set(_quickPicsDoc, <String, dynamic>{
        ...DecksFirestoreMapper.quickPicsToMap(updated),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return updated;
    });
  });

  //*************************** Entitlements ********************************//
  @override
  Future<void> setSocialdeckPlus(bool enabled) => _guarded(() async {
    await _userDoc.set(
      <String, dynamic>{'isSocialdeckPlus': enabled},
      SetOptions(merge: true),
    );
  });

  //*************************** Private Helpers *****************************//
  DeckCardEntity _buildCardFromDraft(NewDeckCardDraft draft) {
    final generatedId = _decksCollection.doc().id;
    return DeckCardEntity.create(
      id: generatedId,
      localPath: draft.localPath,
      assetId: draft.assetId,
      tiltDegrees: draft.tiltDegrees,
      random: _random,
    );
  }

  static List<DeckCardEntity> _reorderCardList(
    List<DeckCardEntity> current,
    List<String> orderedIds,
  ) {
    final byId = <String, DeckCardEntity>{
      for (final card in current) card.id: card,
    };
    requireDecks(
      orderedIds.length == byId.length &&
          orderedIds.toSet().length == byId.length &&
          orderedIds.every(byId.containsKey),
      DecksError.invalidInput,
      'orderedCardIds must match the current card set exactly.',
    );
    return <DeckCardEntity>[for (final id in orderedIds) byId[id]!];
  }
}
