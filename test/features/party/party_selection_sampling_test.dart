import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/features/party/domain/party_selection.dart';
import 'party_wiring_test.dart' as fixtures;

class CountingRandom implements Random {
  final delegate = Random(47);
  int draws = 0;
  @override
  int nextInt(int max) {
    draws++;
    return delegate.nextInt(max);
  }

  @override
  bool nextBool() => delegate.nextBool();
  @override
  double nextDouble() => delegate.nextDouble();
}

void main() {
  test(
    'drawing seven from 10000 uses seven random draws and preserves the pool',
    () {
      final random = CountingRandom();
      final cards = fixtures.cards(10000);
      final original = cards.map((card) => card.id).toList();
      final hand = PartySelection.draw(
        [...cards, ...cards],
        count: 7,
        random: random,
      );
      expect(hand.toSet(), hasLength(7));
      expect(hand.every(original.contains), isTrue);
      expect(random.draws, 7);
      expect(cards.map((card) => card.id), original);
      expect(() => hand.add('extra'), throwsUnsupportedError);
    },
  );

  test(
    'every ordered two-card draw is reachable exactly once for a three-card pool',
    () {
      // Enumerate the random choices instead of relying on a flaky frequency test.
      final outcomes = <String>{};
      for (var first = 0; first < 3; first++) {
        for (var second = 0; second < 2; second++) {
          final hand = PartySelection.draw(
            fixtures.cards(3),
            count: 2,
            random: ScriptedRandom([first, second]),
          );
          expect(hand.toSet(), hasLength(2));
          expect(outcomes.add(hand.join(',')), isTrue);
        }
      }
      expect(outcomes, hasLength(6));
    },
  );
}

class ScriptedRandom extends CountingRandom {
  ScriptedRandom(this.choices);
  final List<int> choices;
  @override
  int nextInt(int max) => choices.removeAt(0);
}
