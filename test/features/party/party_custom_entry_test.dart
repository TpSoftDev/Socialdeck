import 'dart:async';
import 'package:socialdeck/features/games/providers/custom_party_preview.dart';
import 'package:socialdeck/features/games/presentation/pages/prompt_settings_page.dart';
import 'package:socialdeck/features/games/presentation/pages/party_topics_examples_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/games/data/mock_game_setup_repository.dart';
import 'package:socialdeck/features/games/providers/game_setup_provider.dart';
import 'package:socialdeck/features/games/presentation/pages/prompt_custom_setup_page.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_late_state_test.dart' show LateStateRepository;
import 'party_wiring_test.dart' as fixtures;

void main() {
  for (final (capturedTarget, stacked) in [
    (true, false),
    (false, false),
    (true, true),
  ]) {
    testWidgets(
      'save opens the real lobby (captured target: $capturedTarget, stacked: $stacked)',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final initial = fixtures.lobby().copyWith(clearGame: true);
        final updates = StreamController<Party?>();
        addTearDown(updates.close);
        final repo = LateStateRepository();
        final setup = GameSetupNotifier(MockGameSetupRepository());
        setup.toggleGroupCategory('Friends');
        setup.confirmGroup();
        setup.toggleTopic('Memes');
        setup.confirmTopics();
        setup.updateStyleLevel('light');
        await setup.generatePrompts();
        setup.approveExample(0);
        final container = ProviderContainer(
          overrides: [
            savedPartyAiSetupProvider(
              '123456',
            ).overrideWith((ref) => Stream.value(null)),
            currentUserProvider.overrideWithValue(TestUser('host')),
            activePartyIdProvider.overrideWith((ref) => Stream.value('123456')),
            partyRepositoryProvider.overrideWithValue(repo),
            partyByIdProvider('123456').overrideWith((ref) => updates.stream),
            partyHandProvider(
              '123456',
            ).overrideWith((ref) => Stream.value(null)),
            partyEventsProvider(
              '123456',
            ).overrideWith((ref) => Stream.value([])),
            gameSetupProvider.overrideWith((ref) => setup),
          ],
        );
        addTearDown(container.dispose);
        // Keep the snapshot subscribed while the settings route saves.
        final subscription = container.listen(
          partyByIdProvider('123456'),
          (_, __) {},
        );
        addTearDown(subscription.close);
        if (capturedTarget)
          container.read(customSetupTargetProvider.notifier).state = (
            uid: 'host',
            partyId: '123456',
            revision: initial.revision,
          );
        final router = GoRouter(
          initialLocation: stacked ? '/home/party/123456' : '/',
          routes: [
            GoRoute(path: '/', builder: (_, __) => const PromptSettingsPage()),
            GoRoute(
              path: '/home/party/123456',
              builder: (_, __) => const PartyLobbyPage(partyId: '123456'),
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(
              theme: SDeckAppTheme.light,
              routerConfig: router,
            ),
          ),
        );
        updates.add(initial);
        await tester.pumpAndSettle();
        if (stacked) {
          // IA: Match the real flow: imperative setup pages above the same party URL.
          final navigator = Navigator.of(
            tester.element(find.byType(PartyLobbyPage)),
          );
          navigator.push(
            MaterialPageRoute<void>(
              builder: (_) => const Scaffold(body: Text('Setup library')),
            ),
          );
          await tester.pumpAndSettle();
          navigator.push(
            MaterialPageRoute<void>(builder: (_) => const PromptSettingsPage()),
          );
          await tester.pumpAndSettle();
        }
        final save = find.text('Save & Continue');
        await tester.ensureVisible(save);
        await tester.tap(save);
        await tester.pumpAndSettle();
        expect(repo.games.length, 1);
        expect(find.byType(PromptSettingsPage), findsNothing);
        final preview =
            container.read(customPartyPreviewsProvider)['host:123456']!;
        updates.add(
          initial.copyWith(game: repo.games.single, revision: preview.revision),
        );
        await tester.pumpAndSettle();
        final button = find.byKey(const ValueKey('party-topics-examples'));
        await tester.ensureVisible(button);
        expect(tester.widget<SDeckOutlineButton>(button).enabled, isTrue);
        await tester.tap(button);
        await tester.pumpAndSettle();
        final card = find.byKey(const ValueKey('topics-examples-card'));
        final size = tester.getSize(card);
        final close = find.byKey(const ValueKey('summary-close'));
        final toggle = find.byKey(const ValueKey('summary-toggle'));
        expect(
          tester.getCenter(close).dx,
          lessThan(tester.getCenter(toggle).dx),
        );
        await tester.tap(toggle);
        await tester.pumpAndSettle();
        expect(tester.getSize(card), size);
        expect(find.text('1 of 1'), findsOneWidget);
        await tester.tap(toggle);
        await tester.pumpAndSettle();
        expect(find.text("Who's playing?"), findsOneWidget);
        expect(tester.getSize(card), size);
        await tester.tap(close);
        await tester.pumpAndSettle();
        expect(find.byType(PartyTopicsExamplesDialog), findsNothing);
        updates.add(
          initial.copyWith(
            game: repo.games.single,
            revision: preview.revision + 1,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.widget<SDeckOutlineButton>(button).enabled, isFalse);
        expect(tester.takeException(), isNull);
      },
    );
  }
  for (final existingGame in [false, true]) {
    for (final loseHost in [false, true]) {
      testWidgets(
        loseHost
            ? 'Custom AI refuses entry after host rights change (existing game: $existingGame)'
            : 'Custom AI opens from normal lobby and Back returns to library (existing game: $existingGame)',
        (tester) async {
          final updates = StreamController<Party?>();
          addTearDown(updates.close);
          final initial =
              existingGame
                  ? fixtures.lobby()
                  : fixtures.lobby().copyWith(clearGame: true);
          final repo = LateStateRepository();
          final container = ProviderContainer(
            overrides: [
              savedPartyAiSetupProvider(
                '123456',
              ).overrideWith((ref) => Stream.value(null)),
              currentUserProvider.overrideWithValue(TestUser('host')),
              partyRepositoryProvider.overrideWithValue(repo),
              partyByIdProvider('123456').overrideWith((ref) => updates.stream),
              partyHandProvider(
                '123456',
              ).overrideWith((ref) => Stream.value(null)),
              partyEventsProvider(
                '123456',
              ).overrideWith((ref) => Stream.value([])),
              gameSetupProvider.overrideWith(
                (ref) => GameSetupNotifier(MockGameSetupRepository()),
              ),
            ],
          );
          addTearDown(container.dispose);
          final router = GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (_, __) => const PartyLobbyPage(partyId: '123456'),
              ),
            ],
          );
          addTearDown(router.dispose);
          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: MaterialApp.router(
                theme: SDeckAppTheme.light,
                routerConfig: router,
              ),
            ),
          );
          updates.add(initial);
          await tester.pumpAndSettle();
          expect(
            find.text('Select Game'),
            existingGame ? findsNothing : findsOneWidget,
          );
          expect(
            tester
                .widget<SDeckIcons>(find.byKey(const ValueKey('party-options')))
                .iconPath,
            existingGame ? SDeckIcon.more : SDeckIcon.leave,
          );
          await tester.tap(find.byKey(const ValueKey('party-settings')));
          await tester.pumpAndSettle();
          await tester.tap(find.text('2-8'));
          await tester.pumpAndSettle();
          if (loseHost) {
            updates.add(initial.copyWith(hostId: 'other'));
            await tester.pumpAndSettle();
          }
          await tester.tap(find.text('Custom AI'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(repo.games, isEmpty);
          if (loseHost) {
            expect(find.byType(PromptCustomSetupPage), findsNothing);
          } else {
            expect(find.text('Who are you playing with?'), findsOneWidget);
            expect(container.read(gameSetupProvider).isCustom, isTrue);
            expect(container.read(gameSetupProvider).gameSelection, "Prompt'd");
            // IA: Back must reveal the existing library, without reopening its sheet.
            Navigator.of(
              tester.element(find.byType(PromptCustomSetupPage)),
            ).pop();
            await tester.pumpAndSettle();
            expect(find.text('Game Library'), findsOneWidget);
            expect(find.text("Play Prompt'd"), findsNothing);
          }
        },
      );
    }
  }
}
