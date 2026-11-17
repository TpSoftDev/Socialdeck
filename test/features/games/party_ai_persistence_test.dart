import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/games/domain/game_setup_state.dart';
import 'package:socialdeck/features/games/domain/prompt_ai.dart';
import 'package:socialdeck/features/games/domain/party_ai_setup.dart';
import 'package:socialdeck/features/games/data/party_ai_setup_mapper.dart';
import 'package:socialdeck/features/games/data/firebase_party_ai_setup_repository.dart';
import 'package:socialdeck/features/games/providers/custom_party_preview.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/data/party_firestore_mapper.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import '../party/firebase_party_repository_test.dart'
    show RecordingFirestore, TestAuth, TestUser;
import '../party/party_late_state_test.dart' show LateStateRepository;
import '../party/party_wiring_test.dart' as fixtures;

const draft = GameSetupState(
  groupCategories: ['Friends'],
  selectedTopics: ['Other'],
  customTopics: ['Campus life'],
  groupDescription: 'College friends',
  styleLevel: 'bold',
  averageAgeText: '22',
  safeMode: true,
);
final prompts = List.generate(
  5,
  (i) => AiPrompt('prompt_1234567890_$i', 'Saved approved example number $i', [
    'Campus life',
  ]),
);
PromptAiSession session() => PromptAiSession('session_1234567890', prompts, {
  for (final p in prompts) p.id: true,
});
PartyAiSetup saved(int revision) => PartyAiSetup(
  revision: revision,
  sessionId: session().id,
  draft: draft,
  prompts: prompts,
);
void main() {
  test(
    'saved data roundtrips all five exact texts, IDs, topics and profile',
    () {
      final read = PartyAiSetupMapper.decode(
        PartyAiSetupMapper.encode(saved(2)),
      );
      expect(read.revision, 2);
      expect(read.sessionId, session().id);
      expect(read.draft.approvedExamples, prompts.map((p) => p.text).toList());
      expect(read.draft.approvedExampleTopics[prompts.first.text], [
        'Campus life',
      ]);
      expect(read.draft.groupDescription, 'College friends');
      expect(read.draft.averageAge, 22);
    },
  );
  test('malformed summaries are errors, not an empty successful setup', () {
    final data = PartyAiSetupMapper.encode(saved(2));
    data['prompts'] = [];
    expect(
      () => PartyAiSetupMapper.decode(data),
      throwsA(isA<PromptAiException>()),
    );
  });
  test(
    'repository writes game and summary together and captures resulting revision',
    () async {
      final db = RecordingFirestore();
      final party = fixtures.lobby().copyWith(clearGame: true);
      db.documents['parties/123456'] = PartyFirestoreMapper.toMap(party);
      final repo = FirebasePartyAiSetupRepository(
        'host',
        firestore: db,
        auth: TestAuth('host'),
      );
      final result = await repo.save(
        '123456',
        party.revision,
        draft,
        session(),
      );
      expect(db.writes.map((w) => w.path), [
        'parties/123456',
        'parties/123456/aiSetup/current',
      ]);
      expect(result.revision, party.revision + 1);
      expect(db.writes.last.data!['prompts'], hasLength(5));
    },
  );
  test(
    'stale revision, lost host and incomplete approvals produce no writes',
    () async {
      for (final mode in ['stale', 'host', 'incomplete']) {
        final db = RecordingFirestore();
        final party = fixtures.lobby();
        db.documents['parties/123456'] = PartyFirestoreMapper.toMap(
          mode == 'host' ? party.copyWith(hostId: 'guest') : party,
        );
        final repo = FirebasePartyAiSetupRepository(
          'host',
          firestore: db,
          auth: TestAuth('host'),
        );
        await expectLater(
          repo.save(
            '123456',
            mode == 'stale' ? 9 : party.revision,
            draft,
            mode == 'incomplete'
                ? PromptAiSession(session().id, prompts, {})
                : session(),
          ),
          throwsA(anything),
        );
        expect(db.writes, isEmpty);
      }
    },
  );
  for (final uid in ['host', 'guest']) {
    testWidgets(
      'fresh $uid app restores summary without local preview memory',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final party = fixtures.lobby();
        final restored = PartyAiSetupMapper.decode(
          PartyAiSetupMapper.encode(saved(party.revision)),
        );
        final container = ProviderContainer(
          overrides: [
            currentUserProvider.overrideWithValue(TestUser(uid)),
            partyRepositoryProvider.overrideWithValue(LateStateRepository()),
            partyByIdProvider(
              '123456',
            ).overrideWith((ref) => Stream.value(party)),
            partyHandProvider(
              '123456',
            ).overrideWith((ref) => Stream.value(null)),
            partyEventsProvider(
              '123456',
            ).overrideWith((ref) => Stream.value([])),
            savedPartyAiSetupProvider(
              '123456',
            ).overrideWith((ref) => Stream.value(restored)),
          ],
        );
        addTearDown(container.dispose);
        expect(container.read(customPartyPreviewsProvider), isEmpty);
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
        await tester.pumpAndSettle();
        final button = find.byKey(const ValueKey('party-topics-examples'));
        await tester.ensureVisible(button);
        expect(tester.widget<SDeckOutlineButton>(button).enabled, true);
        await tester.tap(button);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('summary-toggle')));
        await tester.pumpAndSettle();
        expect(find.text('1 of 5'), findsOneWidget);
        expect(find.text('“Saved approved example number 0”'), findsOneWidget);
        expect(find.text('Campus life'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
