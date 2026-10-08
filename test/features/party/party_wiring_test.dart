import 'dart:async';
import 'dart:math';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/party/presentation/party_home_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/domain/party_policy.dart';
import 'package:socialdeck/features/party/domain/party_selection.dart';
import 'package:socialdeck/features/party/data/party_firestore_mapper.dart';
import 'package:socialdeck/features/party/presentation/party_cards_page.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/features/party/providers/party_social_provider.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;

class UiRepository implements PartyRepository {
  final readyCalls = <bool>[];
  final createResult = Completer<String>();
  String? createdName;
  @override
  Future<String> createParty(String name) {
    createdName = name;
    return createResult.future;
  }

  final invitations = <String>[];
  final hands = <List<String>>[];
  @override
  Future<void> setReady(String id, bool ready) async => readyCalls.add(ready);
  @override
  Future<void> selectCards(String id, List<String> ids) async => hands.add(ids);
  @override
  Future<void> invitePlayer(String id, String uid) async {
    invitations.add(uid);
    if (uid == 'already') throw const PartyFailure(PartyError.alreadyInParty);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Party lobby({bool selected = false}) => Party(
  id: '123456',
  hostId: 'host',
  game: const PartyGame(),
  members: {
    'host': PartyMember(
      uid: 'host',
      name: 'Alex',
      cardCount: selected ? 7 : 0,
      selectionRevision: selected ? 0 : -1,
    ),
    'guest': const PartyMember(uid: 'guest', name: 'Guest'),
  },
);

List<PartyCard> cards(int count, {String deck = 'deck'}) => [
  for (var i = 0; i < count; i++)
    PartyCard(
      id: '$deck-$i',
      deckId: deck,
      imageUrl: 'https://example.invalid/$i.jpg',
    ),
];

void main() {
  test(
    'a candidate pool of eight yields seven unique owned IDs without mutating it',
    () {
      final pool = cards(8);
      final result = PartySelection.draw(pool, count: 7, random: Random(1));
      expect(result.toSet(), hasLength(7));
      expect(result.every((id) => pool.any((c) => c.id == id)), isTrue);
      expect(
        pool.map((c) => c.id).toList(),
        cards(8).map((c) => c.id).toList(),
      );
      expect(
        () => PartySelection.draw([...cards(6), cards(1).first], count: 7),
        throwsA(isA<PartyFailure>()),
      );
    },
  );

  test('host leave closes a solo party and otherwise retains join order', () {
    final party = lobby().copyWith(
      members: {
        ...lobby().members,
        'third': const PartyMember(uid: 'third', name: 'Third'),
      },
    );
    final left = PartyPolicy.leave(party, 'host');
    expect(left.hostId, 'guest');
    expect(left.members.keys.toList(), ['guest', 'third']);
    final solo = lobby().copyWith(members: {'host': lobby().members['host']!});
    expect(PartyPolicy.leave(solo, 'host').phase, PartyPhase.closed);
  });

  test('mapper follows memberIds rather than Firestore sorted map keys', () {
    final data = PartyFirestoreMapper.toMap(lobby());
    data['memberIds'] = ['host', 'guest'];
    data['members'] = {
      'guest': data['members']['guest'],
      'host': data['members']['host'],
    };
    expect(
      PartyFirestoreMapper.fromMap('123456', data).members.keys.first,
      'host',
    );
  });

  testWidgets(
    'ready stays disabled until selection is valid, then calls backend',
    (tester) async {
      final repository = UiRepository();
      final stream = StreamController<Party?>();
      addTearDown(stream.close);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWithValue(TestUser('host')),
            partyRepositoryProvider.overrideWithValue(repository),
            partyByIdProvider('123456').overrideWith((ref) => stream.stream),
            partyHandProvider(
              '123456',
            ).overrideWith((ref) => Stream.value(null)),
            partyEventsProvider(
              '123456',
            ).overrideWith((ref) => Stream.value([])),
          ],
          child: MaterialApp(
            theme: SDeckAppTheme.dark,
            home: const PartyLobbyPage(partyId: '123456'),
          ),
        ),
      );
      stream.add(lobby());
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Ready'))
            .onPressed,
        isNull,
      );
      stream.add(lobby(selected: true));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Ready'));
      await tester.pumpAndSettle();
      expect(repository.readyCalls, [true]);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'multi-invite reports failure while continuing remaining recipients',
    (tester) async {
      final repository = UiRepository();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWithValue(TestUser('host')),
            partyRepositoryProvider.overrideWithValue(repository),
            partyFriendsProvider.overrideWith(
              (ref) => Stream.value([
                const PartyFriend(uid: 'already', name: 'Already'),
                const PartyFriend(uid: 'new', name: 'New friend'),
              ]),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(body: const PartyInviteSheet(partyId: '123456')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Already'));
      await tester.tap(find.text('New friend'));
      await tester.pump();
      await tester.tap(find.text('Invite 2 Friends'));
      await tester.pumpAndSettle();
      expect(repository.invitations, ['already', 'new']);
      expect(find.text('Invite sent'), findsOneWidget);
      expect(find.text('This player is already in a party.'), findsOneWidget);
    },
  );

  testWidgets(
    'single deck requires seven cards but handpicking accepts a small deck',
    (tester) async {
      final repository = UiRepository();
      Widget page(PartySelectionMethod method) => ProviderScope(
        overrides: [
          currentUserProvider.overrideWithValue(TestUser('host')),
          partyRepositoryProvider.overrideWithValue(repository),
          partyByIdProvider(
            '123456',
          ).overrideWith((ref) => Stream.value(lobby())),
          partyDecksProvider.overrideWith(
            (ref) => Stream.value([
              const PartyDeck(id: 'small', name: 'Small'),
              const PartyDeck(id: 'large', name: 'Large'),
            ]),
          ),
          partyAllCardsProvider.overrideWith(
            (ref) => Stream.value([
              ...cards(3, deck: 'small'),
              ...cards(8, deck: 'large'),
            ]),
          ),
        ],
        child: MaterialApp(
          theme: SDeckAppTheme.dark,
          home: PartyCardsPage(partyId: '123456', method: method),
        ),
      );
      await tester.pumpWidget(page(PartySelectionMethod.singleDeck));
      await tester.pumpAndSettle();
      expect(
        tester.widget<ListTile>(find.widgetWithText(ListTile, 'Small')).enabled,
        isFalse,
      );
      expect(
        tester.widget<ListTile>(find.widgetWithText(ListTile, 'Large')).enabled,
        isTrue,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(page(PartySelectionMethod.handpicked));
      await tester.pumpAndSettle();
      expect(
        tester.widget<ListTile>(find.widgetWithText(ListTile, 'Small')).enabled,
        isTrue,
      );
    },
  );

  testWidgets('Home waits for create success before navigating', (
    tester,
  ) async {
    final repository = UiRepository();
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder:
              (_, __) => const Scaffold(
                body: SingleChildScrollView(child: PartyHomeControls()),
              ),
        ),
        GoRoute(
          path: '/home/party/:id',
          builder:
              (_, state) =>
                  Scaffold(body: Text('Opened ${state.pathParameters['id']}')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWithValue(TestUser('host')),
          partyRepositoryProvider.overrideWithValue(repository),
          activePartyProvider.overrideWithValue(const AsyncData(null)),
          partyInvitationsProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp.router(
          theme: SDeckAppTheme.dark,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Party'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Alex');
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();
    expect(find.text('Opened 123456'), findsNothing);
    expect(repository.createdName, 'Alex');
    repository.createResult.complete('123456');
    await tester.pumpAndSettle();
    expect(find.text('Opened 123456'), findsOneWidget);
  });

  testWidgets(
    'handpicked shelf survives deck navigation and submits seven from eight',
    (tester) async {
      final repository = UiRepository();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWithValue(TestUser('host')),
            partyRepositoryProvider.overrideWithValue(repository),
            partyByIdProvider(
              '123456',
            ).overrideWith((ref) => Stream.value(lobby())),
            partyDecksProvider.overrideWith(
              (ref) => Stream.value([
                const PartyDeck(id: 'one', name: 'One'),
                const PartyDeck(id: 'two', name: 'Two'),
              ]),
            ),
            partyAllCardsProvider.overrideWith(
              (ref) => Stream.value([
                ...cards(4, deck: 'one'),
                ...cards(4, deck: 'two'),
              ]),
            ),
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
      await tester.pumpAndSettle();
      await tester.tap(find.text('One'));
      await tester.pumpAndSettle();
      for (var i = 1; i <= 4; i++) {
        await tester.ensureVisible(find.bySemanticsLabel('Card $i'));
        await tester.pumpAndSettle();
        await tester.tap(find.bySemanticsLabel('Card $i'));
        await tester.pump();
      }
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('3 Cards Remaining'), findsOneWidget);
      await tester.tap(find.text('Two'));
      await tester.pumpAndSettle();
      for (var i = 1; i <= 4; i++) {
        await tester.ensureVisible(find.bySemanticsLabel('Card $i'));
        await tester.pumpAndSettle();
        await tester.tap(find.bySemanticsLabel('Card $i'));
        await tester.pump();
      }
      expect(find.text('Use Any of 8 Cards'), findsOneWidget);
      await tester.tap(find.text('Use Any of 8 Cards'));
      await tester.pumpAndSettle();
      expect(repository.hands.single.toSet(), hasLength(7));
      expect(
        repository.hands.single.every(
          (id) => id.startsWith('one-') || id.startsWith('two-'),
        ),
        isTrue,
      );
    },
  );
}
