import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/games/presentation/pages/invite_sheet_page.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_wiring_test.dart' as fixtures;

void main() {
  for (final state in ['closed', 'missing', 'removed']) {
    testWidgets('$state lobby explains exit and Home navigates out', (tester) async {
      final updates = StreamController<Party?>();
      final router = GoRouter(initialLocation: '/party', routes: [
        GoRoute(path: '/party', builder: (_, __) => const PartyLobbyPage(partyId: '123456')),
        GoRoute(path: '/home', builder: (_, __) => const Scaffold(body: Text('Home destination'))),
      ]);
      await tester.pumpWidget(ProviderScope(overrides: [
        currentUserProvider.overrideWithValue(TestUser('guest')),
        partyRepositoryProvider.overrideWithValue(fixtures.UiRepository()),
        partyByIdProvider('123456').overrideWith((ref) => updates.stream),
        partyHandProvider('123456').overrideWith((ref) => Stream.value(null)),
        partyEventsProvider('123456').overrideWith((ref) => Stream.value([])),
      ], child: MaterialApp.router(theme: SDeckAppTheme.light, routerConfig: router)));
      updates.add(fixtures.lobby());
      await tester.pumpAndSettle();
      expect(find.byType(InviteSheetPage), findsOneWidget);
      final party = fixtures.lobby();
      updates.add(state == 'missing' ? null : state == 'closed'
          ? party.copyWith(phase: PartyPhase.closed)
          : party.copyWith(members: {'host': party.members['host']!}));
      await tester.pumpAndSettle();
      expect(find.byType(InviteSheetPage), findsNothing);
      expect(find.text(state == 'closed' ? 'This party has ended.' : state == 'missing'
          ? 'This party is no longer available.' : 'You are no longer in this party.'), findsOneWidget);
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Home destination'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      unawaited(updates.close());
      await tester.pump();
      router.dispose();
    });
  }
}
