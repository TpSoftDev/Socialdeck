import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/domain/party_selection.dart';
import 'package:socialdeck/features/party/presentation/party_cards_page.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/features/party/presentation/party_home_controls.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_wiring_test.dart' as fixtures;

class LateStateRepository extends fixtures.UiRepository {
  final leaves = <String>[];
  final disbands = <String>[];
  final games = <PartyGame?>[];
  @override
  Future<void> leaveParty(String id) async => leaves.add(id);
  @override
  Future<void> disbandParty(String id) async => disbands.add(id);
  @override
  Future<void> selectGame(String id, PartyGame? game) async => games.add(game);
}

Future<ProviderContainer> mount(
  WidgetTester tester,
  LateStateRepository repo,
  StreamController<Party?> updates, {
  Party? initial,
  PartySelectionMethod? method,
  Stream<List<PartyDeck>>? decks,
}) async {
  final router = GoRouter(
    initialLocation: '/party',
    routes: [
      GoRoute(path: '/home', builder: (_, __) => const Text('Home')),
      GoRoute(
        path: '/party',
        builder:
            (_, __) =>
                method == null
                    ? const PartyLobbyPage(partyId: '123456')
                    : PartyCardsPage(partyId: '123456', method: method),
      ),
    ],
  );
  addTearDown(router.dispose);
  final container = ProviderContainer(
    overrides: [
      currentUserProvider.overrideWithValue(TestUser('host')),
      partyRepositoryProvider.overrideWithValue(repo),
      partyByIdProvider('123456').overrideWith((ref) => updates.stream),
      partyHandProvider('123456').overrideWith((ref) => Stream.value(null)),
      partyEventsProvider('123456').overrideWith((ref) => Stream.value([])),
      partyDecksProvider.overrideWith(
        (ref) =>
            decks ??
            Stream.value([const PartyDeck(id: 'deck', name: 'My Deck')]),
      ),
      partyAllCardsProvider.overrideWith(
        (ref) => Stream.value(fixtures.cards(7)),
      ),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: SDeckAppTheme.light,
        routerConfig: router,
      ),
    ),
  );
  updates.add(initial ?? fixtures.lobby());
  await tester.pumpAndSettle();
  return container;
}

void main() {
  for (final source in ['cards', 'decks', 'party']) {
    testWidgets('card picker can retry a failed $source subscription', (
      tester,
    ) async {
      var attempts = 0;
      bool fails(String name) => name == source && attempts++ == 0;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWithValue(TestUser('host')),
            partyRepositoryProvider.overrideWithValue(LateStateRepository()),
            partyByIdProvider('123456').overrideWith(
              (ref) =>
                  fails('party')
                      ? Stream.error(const PartyFailure(PartyError.network))
                      : Stream.value(fixtures.lobby()),
            ),
            partyDecksProvider.overrideWith(
              (ref) =>
                  fails('decks')
                      ? Stream.error(const PartyFailure(PartyError.network))
                      : Stream.value([
                        const PartyDeck(id: 'deck', name: 'My Deck'),
                      ]),
            ),
            partyAllCardsProvider.overrideWith(
              (ref) =>
                  fails('cards')
                      ? Stream.error(const PartyFailure(PartyError.network))
                      : Stream.value(fixtures.cards(7)),
            ),
          ],
          child: MaterialApp(
            theme: SDeckAppTheme.light,
            home: const PartyCardsPage(
              partyId: '123456',
              method: PartySelectionMethod.random,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await tester.tap(
        find.text(
          source == 'party' ? 'Retry party connection' : 'Retry $source',
        ),
      );
      await tester.pumpAndSettle();
      expect(attempts, 2);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
    });
  }
  for (final joining in [true, false]) {
    testWidgets(
      '${joining ? "Join" : "Create"} refuses a retained failed session',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              currentUserProvider.overrideWithValue(TestUser('host')),
              partyRepositoryProvider.overrideWithValue(LateStateRepository()),
              partyInvitationsProvider.overrideWith((ref) => Stream.value([])),
              activePartyProvider.overrideWith(
                (ref) => AsyncError<Party?>(
                  const PartyFailure(PartyError.network),
                  StackTrace.current,
                ).copyWithPrevious(AsyncData(fixtures.lobby())),
              ),
            ],
            child: MaterialApp(
              theme: SDeckAppTheme.light,
              home: const Scaffold(
                body: SingleChildScrollView(child: PartyHomeControls()),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text(joining ? 'Join a Party' : 'Create Party'));
        await tester.pumpAndSettle();
        expect(find.byType(TextField), findsNothing);
        expect(find.byType(AlertDialog), findsNothing);
        expect(find.text('Retry party connection'), findsOneWidget);
      },
    );
  }
  testWidgets(
    'Leave stays a leave when another player joins during confirmation',
    (tester) async {
      final updates = StreamController<Party?>();
      addTearDown(updates.close);
      final repo = LateStateRepository();
      final solo = fixtures.lobby().copyWith(
        members: {'host': fixtures.lobby().members['host']!},
      );
      await mount(tester, repo, updates, initial: solo);
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Leave Party'));
      await tester.pumpAndSettle();
      updates.add(fixtures.lobby());
      await tester.pumpAndSettle();
      // The intent is leave; the repository decides succession from the live roster.
      expect(find.widgetWithText(FilledButton, 'Leave'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Leave'));
      await tester.pumpAndSettle();
      expect(repo.leaves, ['123456']);
      expect(repo.disbands, isEmpty);
      expect(find.text('Home'), findsOneWidget);
    },
  );

  testWidgets(
    'pending disband loses permission when host changes, including stale callback',
    (tester) async {
      final updates = StreamController<Party?>();
      addTearDown(updates.close);
      final repo = LateStateRepository();
      await mount(tester, repo, updates);
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Disband Party'));
      await tester.pumpAndSettle();
      final button = find.widgetWithText(FilledButton, 'Disband');
      final oldConfirm = tester.widget<FilledButton>(button).onPressed!;
      updates.add(fixtures.lobby().copyWith(hostId: 'guest'));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(button).onPressed, isNull);
      oldConfirm();
      await tester.pumpAndSettle();
      expect(repo.disbands, isEmpty);
    },
  );

  for (final changed in ['host', 'started']) {
    testWidgets('open game settings disable saving after $changed changes', (
      tester,
    ) async {
      final updates = StreamController<Party?>();
      addTearDown(updates.close);
      final repo = LateStateRepository();
      await mount(tester, repo, updates);
      await tester.tap(find.text('Game Settings / Change Game'));
      await tester.pumpAndSettle();
      final button = find.widgetWithText(FilledButton, "Use Prompt'd");
      final oldSave = tester.widget<FilledButton>(button).onPressed!;
      updates.add(
        changed == 'host'
            ? fixtures.lobby().copyWith(hostId: 'guest')
            : fixtures.lobby().copyWith(phase: PartyPhase.playing),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(button).onPressed, isNull);
      oldSave();
      await tester.pumpAndSettle();
      expect(repo.games, isEmpty);
    });
  }

  for (final changed in ['removed', 'closed', 'started', 'error']) {
    testWidgets(
      'card picker blocks $changed state and a captured Save callback',
      (tester) async {
        final updates = StreamController<Party?>();
        addTearDown(updates.close);
        final repo = LateStateRepository();
        await mount(tester, repo, updates, method: PartySelectionMethod.random);
        final button = find.widgetWithText(FilledButton, 'Use 7 Random Cards');
        final oldSave = tester.widget<FilledButton>(button).onPressed!;
        if (changed == 'error') {
          updates.addError(const PartyFailure(PartyError.network));
        } else {
          updates.add(
            changed == 'removed'
                ? fixtures.lobby().copyWith(
                  hostId: 'guest',
                  members: {'guest': fixtures.lobby().members['guest']!},
                )
                : fixtures.lobby().copyWith(
                  phase:
                      changed == 'closed'
                          ? PartyPhase.closed
                          : PartyPhase.playing,
                ),
          );
        }
        await tester.pumpAndSettle();
        expect(tester.widget<FilledButton>(button).onPressed, isNull);
        oldSave();
        await tester.pumpAndSettle();
        expect(repo.hands, isEmpty);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('deleting a selected deck blocks its orphaned cards', (
    tester,
  ) async {
    final updates = StreamController<Party?>();
    final decks = StreamController<List<PartyDeck>>();
    addTearDown(updates.close);
    addTearDown(decks.close);
    final repo = LateStateRepository();
    // Deliver the deck after mounting, once the subscription exists.
    await mount(
      tester,
      repo,
      updates,
      method: PartySelectionMethod.singleDeck,
      decks: decks.stream.startWithDeck(),
    );
    await tester.tap(find.text('My Deck'));
    await tester.pumpAndSettle();
    final oldSave =
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed!;
    decks.add([]);
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    oldSave();
    await tester.pumpAndSettle();
    expect(repo.hands, isEmpty);
  });

  testWidgets(
    'Android Back from deck cards returns to decks and preserves selection',
    (tester) async {
      final updates = StreamController<Party?>();
      addTearDown(updates.close);
      await mount(
        tester,
        LateStateRepository(),
        updates,
        method: PartySelectionMethod.handpicked,
      );
      await tester.tap(find.text('My Deck'));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('Card 1'));
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.widgetWithText(ListTile, 'My Deck'), findsOneWidget);
      expect(find.byType(InputChip), findsOneWidget);
    },
  );
}

extension on Stream<List<PartyDeck>> {
  Stream<List<PartyDeck>> startWithDeck() async* {
    yield [const PartyDeck(id: 'deck', name: 'My Deck')];
    yield* this;
  }
}
