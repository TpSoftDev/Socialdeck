import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/providers/party_social_provider.dart';
import 'package:socialdeck/features/party/presentation/party_invitations_list.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_inbox_test.dart' show InboxRepository, invite;

void main() {
  for (final scenario in ['friend', 'party', 'missing', 'error']) {
    testWidgets('sender label uses $scenario data without blocking invitation', (tester) async {
      await tester.pumpWidget(ProviderScope(overrides: [
        currentUserProvider.overrideWithValue(TestUser('me')),
        partyRepositoryProvider.overrideWithValue(InboxRepository()),
        activePartyProvider.overrideWith((ref) => const AsyncData(null)),
        partyInvitationsProvider.overrideWith((ref) => Stream.value([invite])),
        partyFriendsProvider.overrideWith((ref) => scenario == 'error'
          ? Stream.error(Exception('offline'))
          : Stream.value(scenario == 'friend' ? const [PartyFriend(uid: 'host', name: 'Account Alex')] : [])),
        partyByIdProvider('123456').overrideWith((ref) => scenario == 'error'
          ? Stream.error(Exception('offline'))
          : Stream.value(scenario == 'missing' ? null : Party(id: '123456', hostId: 'newhost', members: {
              'host': const PartyMember(uid: 'host', name: 'Party Alex'),
              'newhost': const PartyMember(uid: 'newhost', name: 'Different Host'),
            }))),
      ], child: MaterialApp(theme: SDeckAppTheme.light, home: const Scaffold(body: PartyInvitationsList()))));
      await tester.pumpAndSettle();
      expect(find.text(scenario == 'friend' ? 'Account Alex invited you' : scenario == 'party' ? 'Party Alex invited you' : 'Party invitation'), findsOneWidget);
      expect(find.text('Different Host invited you'), findsNothing);
      expect(find.text('Party 123456'), findsOneWidget);
      expect(tester.widget<SDeckSolidButton>(find.widgetWithText(SDeckSolidButton, 'Join')).onPressed, isNotNull);
      expect(find.bySemanticsLabel('Decline invitation'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
