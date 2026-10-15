import 'dart:async';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/config/routes/modules/party/party_routes.dart';
import 'package:socialdeck/features/games/presentation/pages/invite_sheet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/games/presentation/pages/prompt_settings_page.dart';
import 'package:socialdeck/features/games/providers/game_setup_provider.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'package:socialdeck/features/party/presentation/party_settings_page.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_late_state_test.dart' as harness;
import 'party_wiring_test.dart' as fixtures;

class SettingsRepository extends harness.LateStateRepository {
  Completer<void>? pending;
  bool fail = false;
  @override
  Future<void> selectGame(
    String id,
    PartyGame? game, {
    int? expectedRevision,
  }) async {
    expect(
      expectedRevision,
      isNotNull,
      reason: "Live settings must pass their draft revision",
    );
    games.add(game);
    if (pending != null) await pending!.future;
    if (fail) throw const PartyFailure(PartyError.network);
  }
}

final saveButton = find.widgetWithText(SDeckSolidButton, 'Back to Party');

Future<ProviderContainer> openSettings(
  WidgetTester tester,
  SettingsRepository repo,
  StreamController<Party?> updates, {
  Party? initial,
}) async {
  final container = await harness.mount(
    tester,
    repo,
    updates,
    initial: initial,
  );
  await tester.tap(
    find.text(
      initial?.game == null && initial != null
          ? 'Game Library'
          : 'Game Settings / Change Game',
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  return container;
}

void main() {
  for (final mode in PartyPlayMode.values) {
    testWidgets('real preview settings route returns to $mode lobby', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/dev/tools/party',
        routes: [
          GoRoute(
            path: '/dev/tools',
            builder: (_, __) => const SizedBox(),
            routes: partyRoutes,
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            theme: SDeckAppTheme.light,
            routerConfig: router,
          ),
        ),
      );
      router.go(AppPaths.promptSettingsDev, extra: mode);
      await tester.pumpAndSettle();
      expect(
        find.text('Environment'),
        mode == PartyPlayMode.normal ? findsNothing : findsOneWidget,
      );
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        mode == PartyPlayMode.normal
            ? AppPaths.defaultPartyDev
            : AppPaths.inviteSheetDev,
      );
      expect(
        tester.widget<InviteSheetPage>(find.byType(InviteSheetPage)).playMode,
        mode,
      );
      expect(tester.takeException(), isNull);
    });
  }

  for (final pending in [false, true]) {
    testWidgets('sign-out blocks settings, pending save: $pending', (
      tester,
    ) async {
      final repo = SettingsRepository();
      if (pending) repo.pending = Completer<void>();
      final user = StateProvider<TestUser?>((ref) => TestUser('host'));
      final root = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWith((ref) => ref.watch(user)),
          partyRepositoryProvider.overrideWith((ref) {
            if (ref.watch(currentUserProvider) == null) {
              throw const PartyFailure(PartyError.unauthenticated);
            }
            return repo;
          }),
          partyByIdProvider(
            '123456',
          ).overrideWith((ref) => Stream.value(fixtures.lobby())),
        ],
      );
      addTearDown(root.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: root,
          child: MaterialApp(
            theme: SDeckAppTheme.light,
            home: PartySettingsPage(party: fixtures.lobby(), actorId: 'host'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final save = tester.widget<SDeckSolidButton>(saveButton).onPressed!;
      if (pending) {
        save();
        await tester.pump();
      }
      root.read(user.notifier).state = null;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.widget<SDeckSolidButton>(saveButton).enabled, isFalse);
      if (pending) repo.pending!.complete();
      save();
      await tester.pumpAndSettle();
      expect(repo.games.length, pending ? 1 : 0);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('settings fit a small phone and rounds stay within bounds', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final updates = StreamController<Party?>();
    addTearDown(updates.close);
    await openSettings(tester, SettingsRepository(), updates);
    final local = ProviderScope.containerOf(
      tester.element(find.byType(PromptSettingsPage)),
    );
    for (var i = 0; i < 8; i++) {
      await tester.tap(find.byKey(const ValueKey('party-rounds-increase')));
      await tester.pumpAndSettle();
    }
    expect(local.read(gameSetupProvider).rounds, 5);
    for (var i = 0; i < 8; i++) {
      await tester.tap(find.byKey(const ValueKey('party-rounds-decrease')));
      await tester.pumpAndSettle();
    }
    expect(local.read(gameSetupProvider).rounds, 1);
    await tester.ensureVisible(saveButton);
    expect(tester.takeException(), isNull);
  });

  testWidgets('team controls save all supported settings before returning', (
    tester,
  ) async {
    final repo = SettingsRepository()..pending = Completer<void>();
    final updates = StreamController<Party?>();
    addTearDown(updates.close);
    await openSettings(tester, repo, updates);
    await tester.tap(find.byKey(const ValueKey('party-mix-cards')));
    await tester.tap(find.byKey(const ValueKey('party-safe-mode')));
    await tester.tap(find.byKey(const ValueKey('party-rounds-increase')));
    await tester.pumpAndSettle();
    final capturedSave = tester.widget<SDeckSolidButton>(saveButton).onPressed!;
    await tester.tap(saveButton);
    await tester.pump();
    capturedSave();
    await tester.pump();
    expect(repo.games, [
      const PartyGame(rounds: 4, mixCards: true, safeMode: true),
    ]);
    expect(find.byType(PromptSettingsPage), findsOneWidget);
    expect(tester.widget<SDeckSolidButton>(saveButton).enabled, isFalse);
    repo.pending!.complete();
    await tester.pumpAndSettle();
    expect(find.byType(PromptSettingsPage), findsNothing);
  });

  testWidgets(
    'saved values initialize the draft and Cancel cannot leak edits',
    (tester) async {
      final repo = SettingsRepository();
      final updates = StreamController<Party?>();
      addTearDown(updates.close);
      final root = await openSettings(
        tester,
        repo,
        updates,
        initial: fixtures.lobby().copyWith(
          game: const PartyGame(rounds: 5, mixCards: true, safeMode: true),
        ),
      );
      final local = ProviderScope.containerOf(
        tester.element(find.byType(PromptSettingsPage)),
      );
      expect(local.read(gameSetupProvider).rounds, 5);
      expect(local.read(gameSetupProvider).mixCards, isTrue);
      expect(local.read(gameSetupProvider).safeMode, isTrue);
      await tester.tap(find.byKey(const ValueKey('party-rounds-decrease')));
      await tester.pumpAndSettle();
      expect(local.read(gameSetupProvider).rounds, 4);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(repo.games, isEmpty);
      expect(root.read(gameSetupProvider).rounds, 3);
      expect(root.read(gameSetupProvider).mixCards, isFalse);
    },
  );

  testWidgets('unchanged settings send the original values, not defaults', (
    tester,
  ) async {
    final repo = SettingsRepository();
    final updates = StreamController<Party?>();
    addTearDown(updates.close);
    const original = PartyGame(rounds: 2, mixCards: true);
    await openSettings(
      tester,
      repo,
      updates,
      initial: fixtures.lobby().copyWith(game: original),
    );
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(repo.games, [original]);
  });

  testWidgets('failed save retains the draft and can retry', (tester) async {
    final repo = SettingsRepository()..fail = true;
    final updates = StreamController<Party?>();
    addTearDown(updates.close);
    await openSettings(tester, repo, updates);
    await tester.tap(find.byKey(const ValueKey('party-rounds-decrease')));
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.byType(PromptSettingsPage), findsOneWidget);
    expect(
      find.text('Could not connect. Check your connection and retry.'),
      findsOneWidget,
    );
    repo.fail = false;
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(repo.games, [
      const PartyGame(rounds: 2),
      const PartyGame(rounds: 2),
    ]);
    expect(find.byType(PromptSettingsPage), findsNothing);
  });

  for (final change in ['revision', 'removed', 'error']) {
    testWidgets('settings block stale callbacks after $change', (tester) async {
      final repo = SettingsRepository();
      final updates = StreamController<Party?>();
      addTearDown(updates.close);
      await openSettings(tester, repo, updates);
      final callback = tester.widget<SDeckSolidButton>(saveButton).onPressed!;
      if (change == 'error') {
        updates.addError(const PartyFailure(PartyError.network));
      } else {
        updates.add(
          change == 'revision'
              ? fixtures.lobby().copyWith(revision: 1)
              : fixtures.lobby().copyWith(members: {}),
        );
      }
      await tester.pumpAndSettle();
      expect(tester.widget<SDeckSolidButton>(saveButton).enabled, isFalse);
      callback();
      await tester.pumpAndSettle();
      expect(repo.games, isEmpty);
    });
  }

  testWidgets(
    'settings can select the first game without exposing mock AI actions',
    (tester) async {
      final repo = SettingsRepository();
      final updates = StreamController<Party?>();
      addTearDown(updates.close);
      await openSettings(
        tester,
        repo,
        updates,
        initial: fixtures.lobby().copyWith(clearGame: true),
      );
      expect(find.text('Update Prompts'), findsNothing);
      expect(find.text('Environment'), findsNothing);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(repo.games, [const PartyGame()]);
    },
  );

  testWidgets('preview Back to Party returns to its caller', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: TextButton(
              onPressed: () => context.push('/settings'),
              child: const Text('Open settings'),
            ),
          ),
        ),
        GoRoute(
          path: '/settings',
          builder: (_, __) => const PromptSettingsPage(),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: SDeckAppTheme.light,
          routerConfig: router,
        ),
      ),
    );
    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('Open settings'), findsOneWidget);
  });
}
