/*------------------------- quick_pics_entity.dart --------------------------*/
// Immutable domain model for the user's Quick Pics collection stored at
// users/{uid}/quickPics/main. Holds up to 100 local-reference cards in their
// user-arranged order without counting toward the 2-deck free tier limit.
//
// Usage:
//   const quickPics = QuickPicsEntity();
//   final count = quickPics.cardCount;
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'deck_card_entity.dart';
import 'decks_failure.dart';

//----------------------------- QuickPicsEntity -----------------------------//
class QuickPicsEntity {
  QuickPicsEntity({
    Iterable<DeckCardEntity> cards = const <DeckCardEntity>[],
    this.updatedAt,
  }) : cards = List<DeckCardEntity>.unmodifiable(cards);

  //*************************** Constants ***********************************//
  static const String documentId = 'main';
  static const int maxCards = 100;

  //*************************** Properties **********************************//
  final List<DeckCardEntity> cards;
  final DateTime? updatedAt;

  //*************************** Derived Helpers *****************************//
  int get cardCount => cards.length;
  int get remainingCapacity => maxCards - cards.length;
  bool get isEmpty => cards.isEmpty;
  bool get isNotEmpty => cards.isNotEmpty;
  bool get isFull => cards.length >= maxCards;

  //*************************** Validation **********************************//
  void validate() {
    requireDecks(
      cards.length <= maxCards,
      DecksError.quickPicsLimitReached,
      'Quick Pics cannot exceed $maxCards cards.',
    );
    final uniqueIds = <String>{};
    for (final card in cards) {
      card.validate();
      requireDecks(
        uniqueIds.add(card.id),
        DecksError.invalidInput,
        'Duplicate card ID ${card.id} inside Quick Pics.',
      );
    }
  }

  //*************************** Copy & Equality *****************************//
  QuickPicsEntity copyWith({
    Iterable<DeckCardEntity>? cards,
    DateTime? updatedAt,
  }) {
    return QuickPicsEntity(
      cards: cards ?? this.cards,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuickPicsEntity &&
          sameDeckCardList(cards, other.cards) &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(Object.hashAll(cards), updatedAt);
}
