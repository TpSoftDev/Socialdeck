// -----------------------------------------------------------------------------
// party_policy_test.dart
// Behavioral tests for Party invariants, independent of live Firebase services.
// -----------------------------------------------------------------------------
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/features/party/domain/party_failure.dart';
import 'package:socialdeck/features/party/domain/party_models.dart';
import 'package:socialdeck/features/party/domain/party_policy.dart';
import 'package:socialdeck/features/party/data/party_firestore_mapper.dart';

Matcher fails(PartyError error) =>
    throwsA(isA<PartyFailure>().having((e) => e.code, 'code', error));
Party initial() => Party(
  id: '123456',
  hostId: 'host',
  members: {'host': const PartyMember(uid: 'host', name: 'Host')},
);
List<PartyCard> cards({bool mixed = false}) => List.generate(
  7,
  (i) => PartyCard(
    id: 'card$i',
    deckId: mixed ? 'deck$i' : 'deck',
    imageUrl: 'https://example.invalid/card$i.jpg',
  ),
);

void main() {
  test('name and code validation preserve six-digit join contract', () {
    expect(PartyPolicy.cleanName(' Alex '), 'Alex');
    expect(PartyPolicy.cleanCode(' 123456 '), '123456');
    expect(() => PartyPolicy.cleanName(' '), fails(PartyError.invalidInput));
    expect(
      () => PartyPolicy.cleanCode('12abc6'),
      fails(PartyError.invalidInput),
    );
  });

  test(
    'joining does not mutate the previous snapshot and capacity is bounded',
    () {
      final original = initial();
      var party = original;
      for (var i = 1; i < 8; i++) {
        party = PartyPolicy.join(party, 'user$i', 'Player $i');
      }
      expect(original.members.length, 1);
      expect(party.members.length, 8);
      expect(
        () => PartyPolicy.join(party, 'ninth', 'Ninth'),
        fails(PartyError.full),
      );
      expect(() => party.members.clear(), throwsUnsupportedError);
    },
  );

  test('duplicate membership and joins after start are rejected', () {
    expect(
      () => PartyPolicy.join(initial(), 'host', 'Host'),
      fails(PartyError.alreadyInParty),
    );
    expect(
      () => PartyPolicy.join(
        initial().copyWith(phase: PartyPhase.playing),
        'guest',
        'Guest',
      ),
      fails(PartyError.closed),
    );
  });

  test('only host may select game, kick another player, or promote', () {
    final party = PartyPolicy.join(initial(), 'guest', 'Guest');
    expect(
      () => PartyPolicy.selectGame(party, 'guest', const PartyGame()),
      fails(PartyError.forbidden),
    );
    expect(
      () => PartyPolicy.promote(party, 'guest', 'guest'),
      fails(PartyError.forbidden),
    );
    expect(
      () => PartyPolicy.remove(party, 'guest', 'host'),
      fails(PartyError.forbidden),
    );
  });

  test('host transfers ownership before leaving', () {
    var party = PartyPolicy.join(initial(), 'guest', 'Guest');
    expect(
      () => PartyPolicy.remove(party, 'host', 'host'),
      fails(PartyError.hostMustTransfer),
    );
    party = PartyPolicy.promote(party, 'host', 'guest');
    party = PartyPolicy.remove(party, 'host', 'host');
    expect(party.hostId, 'guest');
    expect(party.members.keys, ['guest']);
  });

  test('character can be explicitly cleared without losing card state', () {
    var party = PartyPolicy.identity(initial(), 'host', 'Alex', 'cat');
    party = PartyPolicy.identity(party, 'host', 'Alex', null);
    expect(party.members['host']!.characterId, isNull);
  });

  test('ready needs a selected game and a full current selection', () {
    var party = initial();
    expect(
      () => PartyPolicy.setReady(party, 'host', true),
      fails(PartyError.noGame),
    );
    party = PartyPolicy.selectGame(party, 'host', const PartyGame());
    expect(
      () => PartyPolicy.setReady(party, 'host', true),
      fails(PartyError.invalidCards),
    );
    party = PartyPolicy.selectCards(party, 'host', cards());
    party = PartyPolicy.setReady(party, 'host', true);
    expect(party.isReady('host'), isTrue);
    expect(party.canStart, isFalse); // Minimum two players.
  });

  test(
    'changing cards resets own readiness; settings invalidate all readiness',
    () {
      var party = PartyPolicy.selectGame(initial(), 'host', const PartyGame());
      party = PartyPolicy.selectCards(party, 'host', cards());
      party = PartyPolicy.setReady(party, 'host', true);
      party = PartyPolicy.selectCards(party, 'host', cards());
      expect(party.isReady('host'), isFalse);
      party = PartyPolicy.setReady(party, 'host', true);
      party = PartyPolicy.selectGame(party, 'host', const PartyGame(rounds: 4));
      expect(party.isReady('host'), isFalse);
      expect(
        () => PartyPolicy.setReady(party, 'host', true),
        fails(PartyError.invalidCards),
      );
    },
  );

  test('players may mix decks but duplicate cards are rejected', () {
    final party = PartyPolicy.selectGame(initial(), 'host', const PartyGame());
    expect(
      PartyPolicy.selectCards(
        party,
        'host',
        cards(mixed: true),
      ).members['host']!.cardCount,
      7,
    );
    expect(
      () => PartyPolicy.selectCards(party, 'host', [cards()[0], cards()[0]]),
      fails(PartyError.invalidCards),
    );
  });

  test(
    'host starts only after every player is ready, then lobby edits stop',
    () {
      var party = PartyPolicy.join(initial(), 'guest', 'Guest');
      party = PartyPolicy.selectGame(party, 'host', const PartyGame());
      expect(
        () => PartyPolicy.start(party, 'host'),
        fails(PartyError.notReady),
      );
      for (final uid in ['host', 'guest']) {
        party = PartyPolicy.selectCards(party, uid, cards());
        party = PartyPolicy.setReady(party, uid, true);
      }
      expect(party.canStart, isTrue);
      expect(
        () => PartyPolicy.start(party, 'guest'),
        fails(PartyError.forbidden),
      );
      party = PartyPolicy.start(party, 'host');
      expect(party.phase, PartyPhase.playing);
      expect(
        () => PartyPolicy.selectCards(party, 'guest', cards()),
        fails(PartyError.closed),
      );
    },
  );

  test('disband ends the party and blocks member actions', () {
    final closed = PartyPolicy.disband(initial(), 'host');
    expect(closed.phase, PartyPhase.closed);
    expect(
      () => PartyPolicy.identity(closed, 'host', 'Name', null),
      fails(PartyError.closed),
    );
  });

  test(
    'Firestore round-trip preserves state and keeps card URLs out of lobby',
    () {
      var party = PartyPolicy.join(initial(), 'guest', 'Guest');
      party = PartyPolicy.selectGame(party, 'host', const PartyGame());
      party = PartyPolicy.selectCards(party, 'host', cards());
      final data = PartyFirestoreMapper.toMap(party);
      final restored = PartyFirestoreMapper.fromMap(party.id, data);
      expect(restored.members['host']!.cardCount, 7);
      expect(restored.game!.id, 'promptd');
      expect(data.toString().contains('imageUrl'), isFalse);
      final hand = PartyFirestoreMapper.handFromMap(
        PartyFirestoreMapper.handToMap(
          PartyHand(cards: cards(), revision: party.revision),
        ),
      );
      expect(hand.cards.length, 7);
      expect(hand.revision, party.revision);
    },
  );
}
