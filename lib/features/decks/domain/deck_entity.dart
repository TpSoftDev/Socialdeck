/*---------------------------- deck_entity.dart -----------------------------*/
// Immutable domain model for a user-created deck stored at users/{uid}/decks.
// Keeps pure-Dart color keys, ordering, favorite state, and up to 52 ordered
// DeckCardEntity items so domain logic stays decoupled from Flutter UI enums.
//
// Usage:
//   final deck = DeckEntity(
//     id: 'deck_1',
//     name: 'Fire Pics',
//     colorKey: 'brightCoral',
//     orderIndex: 0,
//   );
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'deck_card_entity.dart';
import 'decks_failure.dart';

//------------------------------- DeckEntity --------------------------------//
class DeckEntity {
  DeckEntity({
    required this.id,
    required this.name,
    required this.colorKey,
    this.favorited = false,
    this.orderIndex = 0,
    this.tiltDegrees = 0.0,
    Iterable<DeckCardEntity> cards = const <DeckCardEntity>[],
    this.createdAt,
    this.updatedAt,
  }) : cards = List<DeckCardEntity>.unmodifiable(cards);

  //*************************** Constants ***********************************//
  static const int maxCards = 52;
  static const int maxNameLength = 15;
  static const int freeDeckLimit = 2;
  static const int minPartyPlayableCards = 7;

  /// Canonical color keys matching SDeckColorPickerColor enum names.
  static const Set<String> validColorKeys = <String>{
    'brightCoral',
    'tangerine',
    'vibrantYellow',
    'mintGreen',
    'skyBlue',
    'lavender',
    'coolGray',
    'inverse',
  };

  //*************************** Properties **********************************//
  final String id;
  final String name;
  final String colorKey;
  final bool favorited;
  final int orderIndex;
  final double tiltDegrees;
  final List<DeckCardEntity> cards;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  //*************************** Derived Helpers *****************************//
  int get cardCount => cards.length;
  int get remainingCapacity => maxCards - cards.length;
  bool get isFull => cards.length >= maxCards;
  bool get canUseAsSinglePartyDeck => cards.length >= minPartyPlayableCards;

  //*************************** Validation **********************************//
  static String cleanName(String raw) {
    final trimmed = raw.trim();
    requireDecks(
      trimmed.isNotEmpty && trimmed.length <= maxNameLength,
      DecksError.invalidName,
      'Deck name must be 1–$maxNameLength characters.',
    );
    return trimmed;
  }

  static String cleanColorKey(String raw) {
    final trimmed = raw.trim();
    requireDecks(
      validColorKeys.contains(trimmed),
      DecksError.invalidInput,
      'Unsupported deck color key: $trimmed',
    );
    return trimmed;
  }

  void validate() {
    requireDecks(
      id.trim().isNotEmpty && !id.contains('/'),
      DecksError.invalidInput,
      'Invalid deck ID.',
    );
    cleanName(name);
    cleanColorKey(colorKey);
    requireDecks(
      orderIndex >= 0,
      DecksError.invalidInput,
      'Deck orderIndex cannot be negative.',
    );
    requireDecks(
      tiltDegrees >= -2.0 && tiltDegrees <= 2.0,
      DecksError.invalidInput,
      'Deck tiltDegrees must stay within [-2.0, 2.0].',
    );
    requireDecks(
      cards.length <= maxCards,
      DecksError.deckCardLimitReached,
      'A deck cannot exceed $maxCards cards.',
    );
    final uniqueIds = <String>{};
    for (final card in cards) {
      card.validate();
      requireDecks(
        uniqueIds.add(card.id),
        DecksError.invalidInput,
        'Duplicate card ID ${card.id} inside deck $id.',
      );
    }
  }

  //*************************** Copy & Equality *****************************//
  DeckEntity copyWith({
    String? id,
    String? name,
    String? colorKey,
    bool? favorited,
    int? orderIndex,
    double? tiltDegrees,
    Iterable<DeckCardEntity>? cards,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeckEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      colorKey: colorKey ?? this.colorKey,
      favorited: favorited ?? this.favorited,
      orderIndex: orderIndex ?? this.orderIndex,
      tiltDegrees: tiltDegrees ?? this.tiltDegrees,
      cards: cards ?? this.cards,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckEntity &&
          id == other.id &&
          name == other.name &&
          colorKey == other.colorKey &&
          favorited == other.favorited &&
          orderIndex == other.orderIndex &&
          tiltDegrees == other.tiltDegrees &&
          sameDeckCardList(cards, other.cards) &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    colorKey,
    favorited,
    orderIndex,
    tiltDegrees,
    Object.hashAll(cards),
    createdAt,
    updatedAt,
  );
}
