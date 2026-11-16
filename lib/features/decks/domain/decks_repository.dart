/*-------------------------- decks_repository.dart --------------------------*/
// Abstract repository contract for the Decks feature. Owns all persistence
// operations for users/{uid}/decks/{deckId}, users/{uid}/quickPics/main, and
// the user's Socialdeck+ entitlement flag, keeping callers independent of
// whether data comes from MockDecksRepository or FirebaseDecksRepository.
//
// Usage:
//   final decksStream = repository.watchDecks();
//   final created = await repository.createDeck(name: 'Fire Pics', colorKey: 'brightCoral');
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'deck_entity.dart';
import 'quick_pics_entity.dart';

//-------------------------- NewDeckCardDraft -------------------------------//
/// Input payload when adding newly picked local photos from Camera Roll,
/// Shuffle Search, or the device camera into a Deck or Quick Pics.
class NewDeckCardDraft {
  const NewDeckCardDraft({
    required this.localPath,
    this.assetId,
    this.tiltDegrees,
  });

  final String localPath;
  final String? assetId;
  final double? tiltDegrees;
}

//----------------------------- DecksRepository -----------------------------//
abstract class DecksRepository {
  //*************************** Streams *************************************//

  /// Streams the signed-in user's decks sorted by ascending [DeckEntity.orderIndex].
  Stream<List<DeckEntity>> watchDecks();

  /// Streams the signed-in user's Quick Pics collection (`users/{uid}/quickPics/main`).
  Stream<QuickPicsEntity> watchQuickPics();

  /// Streams whether the signed-in user currently has Socialdeck+ unlocked.
  Stream<bool> watchIsSocialdeckPlus();

  //*************************** Deck Mutations ******************************//

  /// Creates a new deck at the end of the user's deck order.
  /// Throws [DecksFailure] with `freeDeckLimitReached` if the user is on the
  /// free tier and already owns [DeckEntity.freeDeckLimit] decks.
  Future<DeckEntity> createDeck({
    required String name,
    required String colorKey,
  });

  /// Updates mutable deck metadata (name, colorKey, or favorited status).
  Future<DeckEntity> updateDeck({
    required String deckId,
    String? name,
    String? colorKey,
    bool? favorited,
  });

  /// Deletes a deck and its inline card list permanently.
  Future<void> deleteDeck(String deckId);

  /// Persists a new ordering of deck IDs after a press-and-hold drag in SDeckMoveGrid.
  Future<void> reorderDecks(List<String> orderedDeckIds);

  //*************************** Deck Card Mutations *************************//

  /// Appends local-reference cards to [deckId]. Throws `deckCardLimitReached`
  /// if the resulting count would exceed [DeckEntity.maxCards] (52).
  Future<DeckEntity> addCardsToDeck({
    required String deckId,
    required List<NewDeckCardDraft> drafts,
  });

  /// Saves the reordered card IDs inside [deckId] after a press-and-hold drag.
  Future<DeckEntity> reorderDeckCards({
    required String deckId,
    required List<String> orderedCardIds,
  });

  /// Removes the specified card IDs from [deckId].
  Future<DeckEntity> removeCardsFromDeck({
    required String deckId,
    required Set<String> cardIds,
  });

  /// Updates pan/zoom/rotation adjustments for one card inside [deckId].
  Future<DeckEntity> updateDeckCardTransform({
    required String deckId,
    required String cardId,
    required double scale,
    required double panX,
    required double panY,
    required double rotation,
  });

  //*************************** Quick Pics Mutations ************************//

  /// Appends local-reference cards to `users/{uid}/quickPics/main`.
  /// Throws `quickPicsLimitReached` if total cards exceed [QuickPicsEntity.maxCards] (100).
  Future<QuickPicsEntity> addCardsToQuickPics(List<NewDeckCardDraft> drafts);

  /// Saves the reordered card IDs in Quick Pics after a press-and-hold drag.
  Future<QuickPicsEntity> reorderQuickPics(List<String> orderedCardIds);

  /// Removes the specified card IDs from Quick Pics.
  Future<QuickPicsEntity> removeCardsFromQuickPics(Set<String> cardIds);

  //*************************** Entitlements ********************************//

  /// Toggles Socialdeck+ status on the user's profile (used by the upgrade dialog
  /// until Store billing integration lands).
  Future<void> setSocialdeckPlus(bool enabled);
}
