import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/domain/party_selection.dart';
import 'package:socialdeck/features/party/presentation/party_cards_page.dart';
import 'package:socialdeck/features/party/presentation/party_home_controls.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_wiring_test.dart' as fixtures;

void main() {
  for (final home in [true, false]) {
    testWidgets(
      '${home ? 'Home' : 'Return to Game'} retries a retained failed lobby listener',
      (tester) async {
        var attempts = 0;
        final container = ProviderContainer(
          overrides: [
            currentUserProvider.overrideWithValue(TestUser('host')),
            partyRepositoryProvider.overrideWithValue(fixtures.UiRepository()),
            activePartyIdProvider.overrideWith((ref) => Stream.value('123456')),
            partyInvitationsProvider.overrideWith((ref) => Stream.value([])),
            partyHandProvider(
              '123456',
            ).overrideWith((ref) => Stream.value(null)),
            partyEventsProvider(
              '123456',
            ).overrideWith((ref) => Stream.value([])),
            partyByIdProvider('123456').overrideWith((ref) {
              attempts++;
              return attempts == 1
                  ? Stream.error(const PartyFailure(PartyError.network))
                  : Stream.value(fixtures.lobby());
            }),
          ],
        );
        addTearDown(container.dispose);
        // Another mounted page can keep the failed family instance alive.
        final retained = container.listen(
          partyByIdProvider('123456'),
          (_, __) {},
        );
        addTearDown(retained.close);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: SDeckAppTheme.dark,
              home:
                  home
                      ? const Scaffold(
                        body: SingleChildScrollView(child: PartyHomeControls()),
                      )
                      : const PartySessionPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text(home ? 'Retry party connection' : 'Retry'));
        await tester.pumpAndSettle();
        expect(attempts, 2);
        expect(
          find.text('Could not connect. Check your connection and retry.'),
          findsNothing,
        );
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }

  testWidgets(
    'deleted cards no longer count and catalog errors disable confirmation',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final catalog = StreamController<List<PartyCard>>();
      addTearDown(catalog.close);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWithValue(TestUser('host')),
            partyRepositoryProvider.overrideWithValue(fixtures.UiRepository()),
            partyByIdProvider(
              '123456',
            ).overrideWith((ref) => Stream.value(fixtures.lobby())),
            partyDecksProvider.overrideWith(
              (ref) =>
                  Stream.value([const PartyDeck(id: 'deck', name: 'My Deck')]),
            ),
            partyAllCardsProvider.overrideWith((ref) => catalog.stream),
          ],
          child: MaterialApp(
            theme: SDeckAppTheme.dark,
            home: const PartyCardsPage(
              partyId: '123456',
              method: PartySelectionMethod.handpicked,
            ),
          ),
        ),
      );
      catalog.add(fixtures.cards(7));
      await tester.pumpAndSettle();
      await tester.tap(find.text('My Deck'));
      await tester.pumpAndSettle();
      for (var i = 1; i <= 7; i++) {
        await tester.ensureVisible(find.bySemanticsLabel('Card $i'));
        await tester.pumpAndSettle();
        await tester.tap(find.bySemanticsLabel('Card $i'));
        await tester.pump();
      }
      expect(find.text('Use These 7 Cards'), findsOneWidget);
      catalog.add(fixtures.cards(6));
      await tester.pumpAndSettle();
      expect(find.text('1 Cards Remaining'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      catalog.add(fixtures.cards(7));
      await tester.pumpAndSettle();
      catalog.addError(const PartyFailure(PartyError.network));
      await tester.pumpAndSettle();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(
        find.text('Could not connect. Check your connection and retry.'),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
