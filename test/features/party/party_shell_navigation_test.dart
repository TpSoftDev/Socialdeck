import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/dev_tools/party_dev_tools_page.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_wiring_test.dart' as fixtures;

void main() {
  testWidgets(
    'Dev Tools returns to existing main shell without duplicate page keys',
    (tester) async {
      final router = GoRouter(
        initialLocation: '/profile',
        routes: [
          ShellRoute(
            builder: (_, __, child) => Scaffold(body: child),
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, __) => const Text('Profile'),
              ),
              GoRoute(
                path: '/home',
                builder: (_, __) => const Text('Home'),
                routes: [
                  GoRoute(
                    path: 'party/:id',
                    builder: (_, __) => const Text('Live lobby'),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/dev/tools',
            builder: (_, __) => const Text('Tools'),
            routes: [
              GoRoute(
                path: 'party',
                builder: (_, __) => const Text('Party tools'),
                routes: [
                  GoRoute(
                    path: 'live',
                    builder: (_, __) => const LivePartyDevPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWithValue(TestUser('host')),
            partyRepositoryProvider.overrideWithValue(fixtures.UiRepository()),
            activePartyProvider.overrideWith(
              (ref) => AsyncData(fixtures.lobby()),
            ),
            partyInvitationsProvider.overrideWith((ref) => Stream.value([])),
          ],
          child: MaterialApp.router(
            theme: SDeckAppTheme.light,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();
      router.push('/dev/tools');
      await tester.pumpAndSettle();
      router.push('/dev/tools/party');
      await tester.pumpAndSettle();
      router.push('/dev/tools/party/live');
      await tester.pumpAndSettle();
      await tester.tap(find.text("Alex's Party"));
      await tester.pumpAndSettle();
      expect(find.text('Live lobby'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
