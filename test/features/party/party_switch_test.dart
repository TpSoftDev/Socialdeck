import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_home_controls.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_wiring_test.dart' as fixtures;

class SwitchRepository extends fixtures.UiRepository {
  int leaves = 0;
  bool fail = false;
  @override
  Future<void> leaveParty(String id) async {
    leaves++;
    if (fail) throw const PartyFailure(PartyError.network);
  }
}

void main() {
  for (final joining in [true, false]) {
    for (final confirm in [true, false]) {
      testWidgets(
        '${joining ? "Join" : "Create"} confirmation ${confirm ? "failure" : "cancel"} preserves flow',
        (tester) async {
          final repo = SwitchRepository()..fail = true;
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                currentUserProvider.overrideWithValue(TestUser('host')),
                partyRepositoryProvider.overrideWithValue(repo),
                activePartyProvider.overrideWith(
                  (ref) => AsyncData(fixtures.lobby()),
                ),
                partyInvitationsProvider.overrideWith(
                  (ref) => Stream.value([]),
                ),
              ],
              child: MaterialApp(
                theme: SDeckAppTheme.light,
                home: const Scaffold(
                  body: SingleChildScrollView(child: PartyHomeControls()),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final button = find.text(joining ? 'Join a Party' : 'Create Party');
          await tester.ensureVisible(button);
          final card = tester.widget<SDeckSelectionTargetCard>(
            find.ancestor(
              of: button,
              matching: find.byType(SDeckSelectionTargetCard),
            ),
          );
          card.onTap!();
          card.onTap!();
          await tester.pumpAndSettle();
          expect(find.text('Already in a party'), findsOneWidget);
          await tester.tap(
            find.text(confirm ? 'Leave and continue' : 'Cancel'),
          );
          await tester.pumpAndSettle();
          expect(repo.leaves, confirm ? 1 : 0);
          expect(find.byType(TextField), findsNothing);
          expect(tester.takeException(), isNull);
          await tester.tap(button);
          await tester.pumpAndSettle();
          expect(find.text('Already in a party'), findsOneWidget);
        },
      );
    }
  }
}
