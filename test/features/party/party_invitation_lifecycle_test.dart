import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_invitations_list.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_inbox_test.dart' as fixtures;

void main() {
  for (final change in ['removed', 'accepted', 'declined', 'error', 'account', 'signout']) {
    testWidgets('pending invitation blocks $change before joining', (tester) async {
      final invites = StreamController<List<PartyInvitation>>();
      addTearDown(invites.close);
      final account = StateProvider<TestUser?>((ref) => TestUser('me'));
      final repo = fixtures.InboxRepository();
      final container = ProviderContainer(overrides: [
        currentUserProvider.overrideWith((ref) => ref.watch(account)),
        partyRepositoryProvider.overrideWithValue(repo),
        activePartyProvider.overrideWith((ref) => const AsyncData(null)),
        partyInvitationsProvider.overrideWith((ref) => invites.stream),
      ]);
      addTearDown(container.dispose);
      await tester.pumpWidget(UncontrolledProviderScope(container: container,
        child: MaterialApp(theme: SDeckAppTheme.light,
          home: const Scaffold(body: PartyInvitationsList())),
      ));
      invites.add([fixtures.invite]);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Join'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Tester');
      await tester.pump();
      final oldSubmit = tester.widget<SDeckSolidButton>(find.widgetWithText(SDeckSolidButton, 'Next')).onPressed!;
      if (change == 'removed') invites.add([]);
      // IA: Production's pending-only query removes resolved invites. Also
      // exercise explicit status updates so the guard doesn't trust presence alone.
      if (change == 'accepted' || change == 'declined') {
        invites.add([PartyInvitation(
          id: fixtures.invite.id, partyId: fixtures.invite.partyId,
          senderId: fixtures.invite.senderId, recipientId: fixtures.invite.recipientId,
          status: change == 'accepted' ? PartyInvitationStatus.accepted : PartyInvitationStatus.declined,
        )]);
      }
      if (change == 'error') invites.addError(const PartyFailure(PartyError.network));
      if (change == 'account') container.read(account.notifier).state = TestUser('other');
      if (change == 'signout') container.read(account.notifier).state = null;
      await tester.pumpAndSettle();
      expect(tester.widget<SDeckSolidButton>(find.widgetWithText(SDeckSolidButton, 'Next')).onPressed, isNull);
      oldSubmit();
      await tester.pumpAndSettle();
      expect(repo.joined, isEmpty);
      // The stale dialog must still be dismissible, rather than trapping the user.
      tester.widget<SDeckPartyInGameNameInputDialog>(find.byType(SDeckPartyInGameNameInputDialog)).onClose!();
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
