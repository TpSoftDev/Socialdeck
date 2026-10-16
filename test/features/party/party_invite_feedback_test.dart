import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/features/party/providers/party_social_provider.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_wiring_test.dart' as fixtures;

void main() {
  for (final existing in [false, true]) {
    testWidgets(
      'normal lobby closes invite sheet and shows team ${existing ? 'error' : 'success'} toast',
      (tester) async {
        final repo = fixtures.UiRepository();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              currentUserProvider.overrideWithValue(TestUser('host')),
              partyRepositoryProvider.overrideWithValue(repo),
              partyByIdProvider(
                '123456',
              ).overrideWith((ref) => Stream.value(fixtures.lobby())),
              partyHandProvider(
                '123456',
              ).overrideWith((ref) => Stream.value(null)),
              partyEventsProvider(
                '123456',
              ).overrideWith((ref) => Stream.value([])),
              partyFriendsProvider.overrideWith(
                (ref) => Stream.value([
                  PartyFriend(uid: existing ? 'already' : 'new', name: 'Alex'),
                ]),
              ),
            ],
            child: MaterialApp(
              theme: SDeckAppTheme.light,
              home: const PartyLobbyPage(partyId: '123456'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('party-invite')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Alex').last);
        await tester.pump();
        await tester.tap(find.text('Invite Alex'));
        await tester.pumpAndSettle();
        expect(find.byType(PartyInviteSheet), findsNothing);
        expect(
          find.text(existing ? 'Invite Error' : 'Invite Sent'),
          findsOneWidget,
        );
        expect(
          find.text(
            existing
                ? 'Alex is already in the party.'
                : 'It will be in their inbox in the Social tab.',
          ),
          findsOneWidget,
        );
        expect(repo.invitations, [existing ? 'already' : 'new']);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}
