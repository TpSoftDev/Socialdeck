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
  bool full = false;
  bool closed = false;
  final joined = <String>[];
  final declined = <String>[];
  @override
  Future<String> joinParty(
    String code,
    String name, {
    String? invitationId,
  }) async {
    if (closed) throw const PartyFailure(PartyError.closed);
    if (full) throw const PartyFailure(PartyError.full);
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
        await tester.tap(accept ? find.text('Join') : find.bySemanticsLabel('Decline invitation'));
        await tester.pumpAndSettle();
        if (accept) {
          await tester.enterText(find.byType(TextField), 'Tester');
          await tester.pump();
          await tester.tap(find.text('Next'));
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
  testWidgets('last seat lost during name entry returns to inbox with full feedback', (tester) async {
    final repo = InboxRepository();
    await tester.pumpWidget(ProviderScope(overrides: [
      currentUserProvider.overrideWithValue(TestUser('me')),
      partyRepositoryProvider.overrideWithValue(repo),
      activePartyProvider.overrideWith((ref) => const AsyncData(null)),
      partyInvitationsProvider.overrideWith((ref) => Stream.value([invite])),
    ], child: MaterialApp(theme: SDeckAppTheme.light, home: const SocialInboxPage())));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Join'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Tester');
    repo.full = true; // Another player claims the final seat while the dialog is open.
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('This party is full (8 players).'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(repo.joined, isEmpty);
    expect(tester.widget<SDeckSolidButton>(find.widgetWithText(SDeckSolidButton, 'Join')).onPressed, isNotNull);
    await tester.tap(find.bySemanticsLabel('Decline invitation'));
    await tester.pumpAndSettle();
    expect(repo.declined, [invite.id]);
  });
  testWidgets('disband during name entry returns to inbox with ended-party feedback', (tester) async {
    final repo = InboxRepository();
    await tester.pumpWidget(ProviderScope(overrides: [
      currentUserProvider.overrideWithValue(TestUser('me')),
      partyRepositoryProvider.overrideWithValue(repo),
      activePartyProvider.overrideWith((ref) => const AsyncData(null)),
      partyInvitationsProvider.overrideWith((ref) => Stream.value([invite])),
    ], child: MaterialApp(theme: SDeckAppTheme.light, home: const SocialInboxPage())));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Join'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Tester');
    repo.closed = true; // Host disbands while the invitee enters their name.
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('The party has ended or the game has already started.'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(repo.joined, isEmpty);
    expect(tester.widget<SDeckSolidButton>(find.widgetWithText(SDeckSolidButton, 'Join')).onPressed, isNotNull);
    await tester.tap(find.bySemanticsLabel('Decline invitation'));
    await tester.pumpAndSettle();
    expect(repo.declined, [invite.id]);
  });
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
          .widget<SDeckSolidButton>(find.widgetWithText(SDeckSolidButton, 'Join'))
          .onPressed,
      isNull,
    );
    await tester.tap(find.text('News'));
    await tester.pumpAndSettle();
    expect(find.text('No news available.'), findsOneWidget);
    expect(find.text('Join'), findsNothing);
  });
}
