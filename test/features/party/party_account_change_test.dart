import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_wiring_test.dart' as fixtures;
import 'party_name_lifecycle_test.dart' show NameRepository;

class AccountRepository extends NameRepository {
  final kicks = <String>[];
  @override Future<void> kickPlayer(String id, String target) async { kicks.add(target); }
}
void main() {
  for (final action in ['rename', 'kick']) {
    for (final signout in [false, true]) {
      testWidgets('$action blocks open dialog and stale callback after ${signout ? "signout" : "account switch"}', (tester) async {
        final account = StateProvider<TestUser?>((ref) => TestUser('host'));
        final repo = AccountRepository();
        final container = ProviderContainer(overrides: [
          currentUserProvider.overrideWith((ref) => ref.watch(account)),
          partyRepositoryProvider.overrideWithValue(repo),
          partyByIdProvider('123456').overrideWith((ref) => Stream.value(fixtures.lobby())),
          partyHandProvider('123456').overrideWith((ref) => Stream.value(null)),
          partyEventsProvider('123456').overrideWith((ref) => Stream.value([])),
        ]);
        await tester.pumpWidget(UncontrolledProviderScope(container: container,
          child: MaterialApp(theme: SDeckAppTheme.light, home: const PartyLobbyPage(partyId: '123456'))));
        await tester.pumpAndSettle();
        await tester.tap(find.text(action == 'rename' ? 'Alex' : 'Guest'));
        await tester.pumpAndSettle();
        await tester.tap(find.text(action == 'rename' ? 'Change Name' : 'Kick'));
        await tester.pumpAndSettle();
        if(action == 'rename') {
          await tester.enterText(find.byType(TextField), 'Changed');
          await tester.pumpAndSettle();
        }
        final button = find.widgetWithText(SDeckSolidButton, action == 'rename' ? 'Update' : 'Kick');
        final stale = tester.widget<SDeckSolidButton>(button).onPressed!;
        container.read(account.notifier).state = signout ? null : TestUser('guest');
        await tester.pumpAndSettle();
        expect(tester.widget<SDeckSolidButton>(button).onPressed, isNull);
        stale();
        await tester.pumpAndSettle();
        expect(repo.names, isEmpty);
        expect(repo.kicks, isEmpty);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        container.dispose();
      });
    }
  }
}
