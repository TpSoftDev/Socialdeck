/*---------------------- party_hand_selection.dart --------------------------*/
// Shared Free-to-Choose / Random helpers for Party Pick 7: CTA labels matching
// Figma ("N Cards Remaining" / "Use These 7 Cards" / "Use Any of N Cards") and
// a Fisher-Yates draw of exactly seven DeckCardEntity items from a larger pool.
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'dart:math';

import 'package:socialdeck/features/decks/domain/deck_card_entity.dart';

//--------------------------- PartyHandSelection ----------------------------//
class PartyHandSelection {
  const PartyHandSelection._();

  static const int handSize = 7;

  /// Figma CTA copy for the sticky confirm button under the shelf.
  static String ctaLabel(int selectedCount) {
    if (selectedCount < handSize) {
      return '${handSize - selectedCount} Cards Remaining';
    }
    if (selectedCount == handSize) {
      return 'Use These 7 Cards';
    }
    return 'Use Any of $selectedCount Cards';
  }

  static bool canConfirm(int selectedCount) => selectedCount >= handSize;

  /// Draws [count] unique cards from [candidates] (by id). Throws if the pool
  /// is too small — callers should guard with a toast first.
  static List<DeckCardEntity> draw(
    Iterable<DeckCardEntity> candidates, {
    int count = handSize,
    Random? random,
  }) {
    final byId = <String, DeckCardEntity>{};
    for (final card in candidates) {
      byId.putIfAbsent(card.id, () => card);
    }
    final pool = byId.values.toList();
    if (count <= 0 || pool.length < count) {
      throw StateError(
        'Need at least $count cards to draw, found ${pool.length}.',
      );
    }

    final rng = random ?? Random.secure();
    for (var i = 0; i < count; i++) {
      final next = i + rng.nextInt(pool.length - i);
      final swap = pool[next];
      pool[next] = pool[i];
      pool[i] = swap;
    }
    return List<DeckCardEntity>.unmodifiable(pool.take(count));
  }
}
