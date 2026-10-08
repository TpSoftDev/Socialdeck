// -----------------------------------------------------------------------------
// firebase_party_card_repository.dart
// Read adapter for owned decks/cards. The Decks feature supplies this catalog;
// Party does not upload, duplicate, or publish a player's image data.
// -----------------------------------------------------------------------------
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/party_failure.dart';
import '../domain/party_models.dart';
import '../domain/party_repository.dart';
import 'party_firestore_mapper.dart';
import 'party_firebase_errors.dart';

class FirebasePartyCardRepository implements PartyCardRepository {
  FirebasePartyCardRepository({required this.uid, FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;
  final String uid;
  final FirebaseFirestore _db;

  @override
  Stream<List<PartyCard>> watchAllCards() => PartyFirebaseErrors.stream(
    _db
        .collection('users')
        .doc(uid)
        .collection('partyCards')
        .snapshots()
        .map(
          (s) => List.unmodifiable(
            s.docs.map((d) => PartyFirestoreMapper.card(d.id, d.data())),
          ),
        ),
  );

  // Keep catalog failures consistent with lobby and command failures.
  @override
  Stream<List<PartyDeck>> watchDecks() => PartyFirebaseErrors.stream(
    _db
        .collection('users')
        .doc(uid)
        .collection('partyDecks')
        .snapshots()
        .map(
          (s) => List.unmodifiable(
            s.docs.map(
              (d) => PartyDeck(
                id: d.id,
                name: d.data()['name'] as String,
                favorite: d.data()['favorite'] as bool? ?? false,
              ),
            ),
          ),
        ),
  );

  @override
  Stream<List<PartyCard>> watchCards(String deckId) {
    requireParty(
      deckId.isNotEmpty &&
          !deckId.contains('/') &&
          deckId != '.' &&
          deckId != '..',
      PartyError.invalidInput,
    );
    return PartyFirebaseErrors.stream(
      _db
          .collection('users')
          .doc(uid)
          .collection('partyCards')
          .where('deckId', isEqualTo: deckId)
          .snapshots()
          .map(
            (s) => List.unmodifiable(
              s.docs.map((d) => PartyFirestoreMapper.card(d.id, d.data())),
            ),
          ),
    );
  }
}
