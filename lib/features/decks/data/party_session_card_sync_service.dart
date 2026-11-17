/*----------------- party_session_card_sync_service.dart --------------------*/
// Uploads the seven locally chosen Party photos to temporary Firebase Storage
// and mirrors them into users/{uid}/partyDecks + partyCards as https:// URLs.
// Clears prior session media on Change Cards Save, and exposes
// cleanupSessionMedia for leave / disband / kicked / party-ended exits.
//
// Usage:
//   final ids = await PartySessionCardSyncService().syncCameraRollHand(...);
//   await PartySessionCardSyncService().cleanupSessionMedia(
//     partyId: party.id,
//     uid: uid,
//   );
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../domain/decks_failure.dart';
import '../domain/decks_repository.dart';

//---------------------- PartySessionCardSyncService ------------------------//
class PartySessionCardSyncService {
  PartySessionCardSyncService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _db = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance;

  //*************************** Dependencies ********************************//
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;

  static const int _handSize = 7;
  static const int _jpegQuality = 72;
  static const int _maxEdge = 1280;

  //*************************** Public API **********************************//
  /// Compresses and uploads [drafts] for one party, then returns the new
  /// partyCards document IDs in shelf order for [selectCards].
  /// [catalogDeckName] labels the ephemeral partyDecks doc (Camera Roll or a
  /// Single Deck name); must satisfy Party validName (1–24 chars).
  Future<List<String>> syncCameraRollHand({
    required String partyId,
    required String uid,
    required List<NewDeckCardDraft> drafts,
    String catalogDeckName = 'Camera Roll',
  }) async {
    requireDecks(
      partyId.trim().isNotEmpty && !partyId.contains('/'),
      DecksError.invalidInput,
      'Invalid party id for session media.',
    );
    requireDecks(
      uid.trim().isNotEmpty && !uid.contains('/'),
      DecksError.unauthenticated,
      'Signed-in uid is required to upload session media.',
    );
    requireDecks(
      drafts.length == _handSize,
      DecksError.invalidInput,
      'Party hand must contain exactly $_handSize photos.',
    );
    final trimmedName = catalogDeckName.trim();
    requireDecks(
      trimmedName.isNotEmpty && trimmedName.length <= 24,
      DecksError.invalidName,
      'Session catalog deck name must be 1–24 characters.',
    );

    final deckId = _sessionDeckId(partyId);
    final deckRef = _db
        .collection('users')
        .doc(uid)
        .collection('partyDecks')
        .doc(deckId);
    final cardsCollection = _db
        .collection('users')
        .doc(uid)
        .collection('partyCards');

    try {
      // Change Cards / re-Save: drop the previous 7 before writing the next set.
      await _clearPreviousSessionMedia(
        partyId: partyId,
        uid: uid,
        deckId: deckId,
        cardsCollection: cardsCollection,
      );

      await deckRef.set(<String, dynamic>{'name': trimmedName});

      final cardIds = <String>[];
      for (final draft in drafts) {
        final cardRef = cardsCollection.doc();
        final cardId = cardRef.id;
        final bytes = await _compressLocalPhoto(draft.localPath);
        final objectPath =
            'partySessionsMedia/$partyId/$uid/$cardId.jpg';
        final storageRef = _storage.ref(objectPath);
        await storageRef.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        final imageUrl = await storageRef.getDownloadURL();

        await cardRef.set(<String, dynamic>{
          'deckId': deckId,
          'imageUrl': imageUrl,
        });
        cardIds.add(cardId);
      }
      return List<String>.unmodifiable(cardIds);
    } on DecksFailure {
      rethrow;
    } on FirebaseException catch (error) {
      if (error.code == 'unauthorized' || error.code == 'permission-denied') {
        throw DecksFailure(DecksError.permissionDenied, error.message);
      }
      throw DecksFailure(DecksError.storageError, error.message);
    } catch (error) {
      throw DecksFailure(DecksError.storageError, error.toString());
    }
  }

  /// Removes this user's temporary Storage folder, partyCards, and session
  /// partyDeck for [partyId]. Safe if nothing was uploaded yet.
  Future<void> cleanupSessionMedia({
    required String partyId,
    required String uid,
  }) async {
    requireDecks(
      partyId.trim().isNotEmpty && !partyId.contains('/'),
      DecksError.invalidInput,
      'Invalid party id for session media cleanup.',
    );
    requireDecks(
      uid.trim().isNotEmpty && !uid.contains('/'),
      DecksError.unauthenticated,
      'Signed-in uid is required to clean session media.',
    );

    final deckId = _sessionDeckId(partyId);
    final deckRef = _db
        .collection('users')
        .doc(uid)
        .collection('partyDecks')
        .doc(deckId);
    final cardsCollection = _db
        .collection('users')
        .doc(uid)
        .collection('partyCards');

    try {
      await _clearPreviousSessionMedia(
        partyId: partyId,
        uid: uid,
        deckId: deckId,
        cardsCollection: cardsCollection,
      );
      await deckRef.delete();
    } on FirebaseException catch (error) {
      if (error.code == 'object-not-found' || error.code == 'not-found') {
        return;
      }
      if (error.code == 'unauthorized' || error.code == 'permission-denied') {
        throw DecksFailure(DecksError.permissionDenied, error.message);
      }
      throw DecksFailure(DecksError.storageError, error.message);
    } on DecksFailure {
      rethrow;
    } catch (error) {
      throw DecksFailure(DecksError.storageError, error.toString());
    }
  }

  //*************************** Private Helpers *****************************//
  static String _sessionDeckId(String partyId) => 'session_$partyId';

  /// Deletes Storage objects under partySessionsMedia/{partyId}/{uid}/ and any
  /// partyCards still pointing at this session deck. Safe no-op on first pick.
  Future<void> _clearPreviousSessionMedia({
    required String partyId,
    required String uid,
    required String deckId,
    required CollectionReference<Map<String, dynamic>> cardsCollection,
  }) async {
    final folder = _storage.ref('partySessionsMedia/$partyId/$uid');
    try {
      final listed = await folder.listAll();
      for (final item in listed.items) {
        await item.delete();
      }
    } on FirebaseException catch (error) {
      // First-time hands have no folder yet; treat missing prefix as success.
      if (error.code != 'object-not-found') {
        rethrow;
      }
    }

    final staleCards = await cardsCollection
        .where('deckId', isEqualTo: deckId)
        .get();
    for (final doc in staleCards.docs) {
      await doc.reference.delete();
    }
  }

  Future<Uint8List> _compressLocalPhoto(String localPath) async {
    final file = File(localPath);
    requireDecks(
      await file.exists(),
      DecksError.storageError,
      'Local photo is missing: $localPath',
    );

    final compressed = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: _jpegQuality,
      minWidth: _maxEdge,
      minHeight: _maxEdge,
      format: CompressFormat.jpeg,
    );
    if (compressed != null && compressed.isNotEmpty) {
      return Uint8List.fromList(compressed);
    }

    final raw = await file.readAsBytes();
    requireDecks(
      raw.isNotEmpty,
      DecksError.storageError,
      'Could not read local photo bytes.',
    );
    return raw;
  }
}
