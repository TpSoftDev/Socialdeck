import 'package:socialdeck/design_system/index.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/domain/party_policy.dart';
import 'party_late_state_test.dart' as harness;
import 'party_wiring_test.dart' as fixtures;

class NameRepository extends harness.LateStateRepository {
  final names = <String>[];
  @override
  Future<void> updateIdentity(String id, String name, String? character) async {
    names.add(name);
  }
}
void main() {
  for (final entry in ['player', 'options']) {
    for (final change in ['removed', 'closed', 'error', 'valid', 'unchanged']) {
      testWidgets('$entry rename handles $change membership', (tester) async {
        final updates = StreamController<Party?>();
        addTearDown(updates.close);
        final repo = NameRepository();
        await harness.mount(tester, repo, updates);
        await tester.tap(entry == 'player' ? find.text('Alex')
            : find.byKey(const ValueKey('party-options')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Change Name'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), change == 'unchanged' ? 'Alex' : 'Party nickname');
        await tester.pumpAndSettle();
        final button = find.widgetWithText(SDeckSolidButton, 'Update');
        final captured = tester.widget<SDeckSolidButton>(button).onPressed!;
        if (change == 'removed') {
          updates.add(fixtures.lobby().copyWith(hostId: 'guest', members: {
            'guest': fixtures.lobby().members['guest']!,
          }));
        } else if (change == 'closed') {
          updates.add(fixtures.lobby().copyWith(phase: PartyPhase.closed));
        } else if (change == 'error') {
          updates.addError(const PartyFailure(PartyError.network));
        }
        await tester.pumpAndSettle();
        if (change != 'valid' && change != 'unchanged') {
          expect(tester.widget<SDeckSolidButton>(button).onPressed, isNull);
        }
        captured(); // A callback saved before the update must also be safe.
        await tester.pumpAndSettle();
        expect(repo.names, change == 'valid' ? ['Party nickname'] : isEmpty);
        expect(tester.takeException(), isNull);
      });
    }
  }
  test('leaving or being kicked discards the nickname on rejoin', () {
    for (final kicked in [false, true]) {
      var party = PartyPolicy.identity(fixtures.lobby(), 'guest', 'Nickname', null);
      party = kicked ? PartyPolicy.remove(party, 'host', 'guest')
          : PartyPolicy.leave(party, 'guest');
      expect(party.members.containsKey('guest'), isFalse);
      party = PartyPolicy.join(party, 'guest', 'Default name');
      expect(party.members['guest']!.name, 'Default name');
    }
  });
}
