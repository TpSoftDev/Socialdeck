import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/features/decks/party_selection/party_hand_selection.dart';
import 'package:socialdeck/features/decks/party_selection/party_pick_cards_sheet.dart';

void main() {
  test('incomplete hands cannot be confirmed', () {
    for (var count = 0; count < 7; count++) {
      expect(PartyHandSelection.canConfirm(count), isFalse);
      expect(PartyHandSelection.ctaLabel(count), '${7 - count} Cards Remaining');
    }
  });

  test('only exactly seven cards can be confirmed', () {
    expect(PartyHandSelection.canConfirm(7), isTrue);
    expect(PartyHandSelection.ctaLabel(7), 'Use These 7 Cards');
    for (final count in [8, 12, 50]) {
      expect(PartyHandSelection.canConfirm(count), isFalse);
    }
  });

  test('picker exposes the team approved Camera Roll option', () {
    expect(PartyPickCardsMethod.values.map((method) => method.name),
        ['singleDeck', 'freeToChoose', 'cameraRoll']);
  });
}
