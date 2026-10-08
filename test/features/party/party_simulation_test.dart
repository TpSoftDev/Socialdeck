import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/domain/party_policy.dart';
import 'party_wiring_test.dart' as fixtures;

void main() {
  test(
    '100 seeded simulations preserve lobby invariants over 30000 transitions',
    () {
      for (var seed = 0; seed < 100; seed++) {
        final random = Random(seed);
        var party = fixtures.lobby();
        for (var step = 0; step < 300; step++) {
          if (party.phase == PartyPhase.closed) party = fixtures.lobby();
          final before = party;
          final actor = 'u${random.nextInt(10)}';
          final member = party.members.keys.elementAt(
            random.nextInt(party.members.length),
          );
          try {
            switch (random.nextInt(9)) {
              case 0:
                party = PartyPolicy.join(party, actor, actor);
              case 1:
                party = PartyPolicy.leave(party, member);
              case 2:
                party = PartyPolicy.promote(
                  party,
                  random.nextBool() ? party.hostId : actor,
                  member,
                );
              case 3:
                party = PartyPolicy.selectGame(
                  party,
                  party.hostId,
                  PartyGame(rounds: 1 + random.nextInt(5)),
                );
              case 4:
                party = PartyPolicy.selectCards(
                  party,
                  member,
                  fixtures.cards(random.nextInt(9)),
                );
              case 5:
                party = PartyPolicy.setReady(party, member, random.nextBool());
              case 6:
                party = PartyPolicy.start(party, party.hostId);
              case 7:
                party = PartyPolicy.identity(party, member, ' Name ', null);
              case 8:
                party = PartyPolicy.remove(party, party.hostId, member);
            }
          } on PartyFailure {
            expect(identical(party, before), isTrue);
          }
          expect(party.members.length, inInclusiveRange(1, 8));
          expect(party.members.containsKey(party.hostId), isTrue);
          expect(party.revision, greaterThanOrEqualTo(before.revision));
          if (party.canStart) {
            expect(party.phase, PartyPhase.lobby);
            expect(party.members.length, greaterThanOrEqualTo(2));
            expect(party.members.keys.every(party.isReady), isTrue);
          }
          if (party.revision != before.revision) {
            expect(party.members.keys.any(party.isReady), isFalse);
          }
        }
      }
    },
  );
}
