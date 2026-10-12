import 'dart:math';
import 'party_failure.dart';
import 'party_models.dart';

enum PartySelectionMethod { singleDeck, handpicked, random }

/// A local candidate pool is separate from the seven cards saved as a hand.
class PartySelection {
  const PartySelection._();

  static List<String> draw(
    Iterable<PartyCard> candidates, {
    required int count,
    Random? random,
  }) {
    final unique = {for (final card in candidates) card.id}.toList();
    requireParty(count > 0 && unique.length >= count, PartyError.invalidCards);
    final rng = random ?? Random.secure();
    // Partial Fisher-Yates: draw only the cards needed, with no replacement.
    // A large catalog still needs deduplication, but only `count` random draws.
    for (var i = 0; i < count; i++) {
      final next = i + rng.nextInt(unique.length - i);
      final picked = unique[next];
      unique[next] = unique[i];
      unique[i] = picked;
    }
    return List.unmodifiable(unique.take(count));
  }
}
