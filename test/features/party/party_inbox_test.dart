import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/social/presentation/pages/social_inbox_page.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_wiring_test.dart' as fixtures;

const invite = PartyInvitation(
  id: '123456_me',
  partyId: '123456',
  senderId: 'host',
  recipientId: 'me',
  status: PartyInvitationStatus.pending,
);

class InboxRepository extends fixtures.UiRepository {
  final joined = <String>[];
  final declined = <String>[];
  @override
  Future<String> joinParty(
    String code,
    String name, {
    String? invitationId,
  }) async {
    joined.add('$code:$name:$invitationId');
    return code;
  }

  @override
  Future<void> declineInvitation(String id) async {
    declined.add(id);
  }
}

void main() {
  for (final accept in [true, false]) {
    testWidgets(
      'Social inbox ${accept ? "joins" : "declines"} a real invitation',
      (tester) async {
        final repo = InboxRepository();
        final router = GoRouter(
          initialLocation: '/social/inbox',
          routes: [
            GoRoute(
              path: '/social/inbox',
              builder: (_, __) => const SocialInboxPage(),
            ),
            GoRoute(
              path: '/home/party/:id',
              builder:
                  (_, state) => Scaffold(
                    body: Text('Joined ${state.pathParameters['id']}'),
                  ),
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              currentUserProvider.overrideWithValue(TestUser('me')),
              partyRepositoryProvider.overrideWithValue(repo),
              activePartyProvider.overrideWith((ref) => const AsyncData(null)),
              partyInvitationsProvider.overrideWith(
                (ref) => Stream.value([invite]),
              ),
            ],
            child: MaterialApp.router(
              theme: SDeckAppTheme.light,
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('tpsoftdev'), findsNothing);
        await tester.tap(find.text(accept ? 'Join' : 'Decline'));
        await tester.pumpAndSettle();
        if (accept) {
          await tester.enterText(find.byType(TextField), 'Tester');
          await tester.pump();
          await tester.tap(find.text('Update'));
          await tester.pumpAndSettle();
          expect(repo.joined, ['123456:Tester:123456_me']);
          expect(find.text('Joined 123456'), findsOneWidget);
        } else {
          expect(repo.declined, ['123456_me']);
          expect(repo.joined, isEmpty);
        }
      },
    );
  }
  testWidgets('existing membership disables Join and News changes tabs', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWithValue(TestUser('host')),
          partyRepositoryProvider.overrideWithValue(InboxRepository()),
          activePartyProvider.overrideWith(
            (ref) => AsyncData(fixtures.lobby()),
          ),
          partyInvitationsProvider.overrideWith(
            (ref) => Stream.value([invite]),
          ),
        ],
        child: MaterialApp(
          theme: SDeckAppTheme.light,
          home: const SocialInboxPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, 'Join'))
          .onPressed,
      isNull,
    );
    await tester.tap(find.text('News'));
    await tester.pumpAndSettle();
    expect(find.text('No news available.'), findsOneWidget);
    expect(find.text('Join'), findsNothing);
  });
}
