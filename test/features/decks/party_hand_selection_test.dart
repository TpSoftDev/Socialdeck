import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/features/decks/domain/deck_card_entity.dart';
import 'package:socialdeck/features/decks/party_selection/party_hand_selection.dart';

void main() {
  List<DeckCardEntity> cards(int count) => List.generate(count,
      (i) => DeckCardEntity(id: 'card-$i', localPath: '/test/$i.jpg'));

  test('larger selections confirm but produce exactly seven distinct cards', () {
    final pool = cards(12);
    final before = pool.map((c) => c.id).toList();
    expect(PartyHandSelection.canConfirm(12), isTrue);
    expect(PartyHandSelection.ctaLabel(12), 'Use Any of 12 Cards');
    final hand = PartyHandSelection.draw(pool, random: Random(42));
    expect(hand.length, 7);
    expect(hand.map((c) => c.id).toSet().length, 7);
    expect(hand.every(pool.contains), isTrue);
    expect(pool.map((c) => c.id), before);
  });

  test('overlapping sources cannot duplicate cards in a random hand', () {
    final pool = cards(7);
    final hand = PartyHandSelection.draw([...pool, ...pool], random: Random(7));
    expect(hand.map((c) => c.id).toSet(), pool.map((c) => c.id).toSet());
  });

  test('fewer than seven unique cards cannot form a hand', () {
    final pool = cards(6);
    expect(PartyHandSelection.canConfirm(6), isFalse);
    expect(() => PartyHandSelection.draw([...pool, ...pool]), throwsStateError);
  });
}
