import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/games/data/mock_game_setup_repository.dart';
import 'package:socialdeck/features/games/providers/game_setup_provider.dart';
import 'package:socialdeck/features/games/presentation/pages/prompt_custom_setup_page.dart';

void main() {
  test('group validation and legacy summary preserve all selected context', () {
    final setup = GameSetupNotifier(MockGameSetupRepository());
    addTearDown(setup.dispose);
    expect(setup.confirmGroup(), isFalse);
    setup.updateGroupDescription('   ');
    expect(setup.confirmGroup(), isFalse);
    setup.updateGroupDescription('We enjoy gaming');
    expect(setup.confirmGroup(), isTrue);
    setup.toggleGroupCategory('Friends');
    setup.toggleGroupCategory('Family');
    setup.toggleGroupCategory('Other');
    expect(setup.confirmGroup(), isFalse);
    setup.updateOtherGroup('  Cofounders  ');
    expect(setup.confirmGroup(), isTrue);
    expect(
      setup.state.playingWith,
      'Friends, Family, Cofounders. We enjoy gaming',
    );
    setup.toggleGroupCategory('Other');
    setup.confirmGroup();
    expect(setup.state.playingWith, 'Friends, Family. We enjoy gaming');
    setup.resetDomain();
    expect(setup.state.groupCategories, isEmpty);
    expect(setup.state.groupDescription, isEmpty);
  });

  test('topics require a selection and nonblank Other; reset clears draft', () {
    final setup = GameSetupNotifier(MockGameSetupRepository());
    addTearDown(setup.dispose);
    expect(setup.confirmTopics(), isFalse);
    setup.toggleTopic('Group Chat');
    setup.toggleTopic('Family Moments');
    setup.toggleTopic('Other');
    setup.updateOtherTopic('  ');
    expect(setup.confirmTopics(), isFalse);
    setup.updateOtherTopic('  Travel  ');
    expect(setup.confirmTopics(), isTrue);
    expect(setup.state.gameMood, 'Group Chat, Family Moments, Travel');
    setup.toggleTopic('Other');
    setup.confirmTopics();
    expect(setup.state.gameMood, 'Group Chat, Family Moments');
    setup.resetDomain();
    expect(setup.state.selectedTopics, isEmpty);
    expect(setup.state.otherTopic, isEmpty);
  });

  testWidgets('topics multi-select, Other and Back work on a narrow screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final setup = GameSetupNotifier(MockGameSetupRepository());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [gameSetupProvider.overrideWith((ref) => setup)],
        child: MaterialApp(
          theme: SDeckAppTheme.light,
          home: const PromptCustomSetupMoodPage(),
        ),
      ),
    );
    bool enabled() =>
        tester
            .widget<SDeckSolidButton>(find.byKey(const ValueKey('topic-next')))
            .enabled;
    expect(enabled(), isFalse);
    final firstY =
        tester.getCenter(find.byKey(const ValueKey('topic-Group Chat'))).dy;
    expect(
      tester.getCenter(find.byKey(const ValueKey('topic-Work Life'))).dy,
      firstY,
    );
    for (final topic in ['Group Chat', 'Family Moments', 'Other']) {
      final choice = find.byKey(ValueKey('topic-$topic'));
      await tester.ensureVisible(choice);
      await tester.tap(choice);
      await tester.pumpAndSettle();
    }
    expect(find.text('What topics do you want to see?'), findsOneWidget);
    expect(enabled(), isFalse);
    await tester.enterText(
      find.descendant(
        of: find.byKey(const ValueKey('topic-other-input')),
        matching: find.byType(TextField),
      ),
      'Travel',
    );
    await tester.pumpAndSettle();
    expect(enabled(), isTrue);
    await tester.ensureVisible(find.byKey(const ValueKey('topic-next')));
    await tester.tap(find.byKey(const ValueKey('topic-next')));
    await tester.pumpAndSettle();
    expect(find.byType(PromptCustomSetupIntensityPage), findsOneWidget);
    Navigator.of(
      tester.element(find.byType(PromptCustomSetupIntensityPage)),
    ).pop();
    await tester.pumpAndSettle();
    expect(setup.state.selectedTopics, [
      'Group Chat',
      'Family Moments',
      'Other',
    ]);
    expect(find.text('Travel ×'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final isGroup in [true, false]) {
    final prefix = isGroup ? 'group' : 'topic';
    testWidgets(
      '$prefix supports adding duplicates, removing and saving pending Other',
      (tester) async {
        tester.view.physicalSize = const Size(320, 740);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final setup = GameSetupNotifier(MockGameSetupRepository());
        await tester.pumpWidget(
          ProviderScope(
            overrides: [gameSetupProvider.overrideWith((ref) => setup)],
            child: MaterialApp(
              theme: SDeckAppTheme.light,
              home:
                  isGroup
                      ? const PromptCustomSetupPage()
                      : const PromptCustomSetupMoodPage(),
            ),
          ),
        );
        Future<void> tapKey(String key) async {
          final target = find.byKey(ValueKey(key));
          await tester.ensureVisible(target);
          await tester.tap(target);
          await tester.pumpAndSettle();
        }

        await tapKey('$prefix-Other');
        final input = find.descendant(
          of: find.byKey(ValueKey('$prefix-other-input')),
          matching: find.byType(TextField),
        );
        for (final value in ['  Travel  ', 'travel', 'Gaming']) {
          await tester.enterText(input, value);
          await tester.pumpAndSettle();
          await tapKey('$prefix-other-add');
        }
        expect(isGroup ? setup.state.customGroups : setup.state.customTopics, [
          'Travel',
          'Gaming',
        ]);
        await tapKey('$prefix-remove-Travel');
        await tapKey('$prefix-remove-Gaming');
        expect(
          tester
              .widget<SDeckSolidButton>(find.byKey(ValueKey('$prefix-next')))
              .enabled,
          isFalse,
        );
        await tester.enterText(input, 'New entry');
        await tester.pumpAndSettle();
        await tapKey('$prefix-next');
        expect(isGroup ? setup.state.customGroups : setup.state.customTopics, [
          'New entry',
        ]);
        expect(
          isGroup ? setup.state.otherGroup : setup.state.otherTopic,
          isEmpty,
        );
        await setup.resetDomain();
        expect(setup.state.customGroups, isEmpty);
        expect(setup.state.customTopics, isEmpty);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('style selection, safe mode and optional age survive Back', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final setup = GameSetupNotifier(MockGameSetupRepository());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [gameSetupProvider.overrideWith((ref) => setup)],
        child: MaterialApp(
          theme: SDeckAppTheme.light,
          home: const PromptCustomSetupIntensityPage(),
        ),
      ),
    );
    bool enabled() =>
        tester
            .widget<SDeckSolidButton>(find.byKey(const ValueKey('style-next')))
            .enabled;
    expect(enabled(), isFalse);
    for (final style in ['light', 'bold', 'wild']) {
      final target = find.byKey(ValueKey('style-$style'));
      await tester.ensureVisible(target);
      await tester.tap(target);
      await tester.pumpAndSettle();
      expect(setup.state.styleLevel, style);
    }
    expect(enabled(), isTrue);
    expect(setup.state.safeMode, isTrue);
    final toggle = find.byKey(const ValueKey('style-safe-mode'));
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(setup.state.safeMode, isFalse);
    final age = find.descendant(
      of: find.byKey(const ValueKey('style-age')),
      matching: find.byType(TextField),
    );
    for (final invalid in ['-1', '121', '2.5', 'abc']) {
      await tester.enterText(age, invalid);
      await tester.pumpAndSettle();
      expect(enabled(), isFalse);
    }
    await tester.enterText(age, '');
    await tester.pumpAndSettle();
    expect(enabled(), isTrue);
    await tester.enterText(age, '24');
    await tester.pumpAndSettle();
    final next = find.byKey(const ValueKey('style-next'));
    await tester.ensureVisible(next);
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(find.text('Generating example prompts...'), findsOneWidget);
    expect(find.byType(PromptCustomSetupReviewPage), findsNothing);
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();
    expect(find.byType(PromptCustomSetupReviewPage), findsOneWidget);
    expect(find.text('Example 1 of 5'), findsOneWidget);
    for (var number = 2; number <= 5; number++) {
      final like = find.bySemanticsLabel('Like this prompt');
      await tester.ensureVisible(like);
      await tester.tap(like);
      await tester.pumpAndSettle();
      expect(find.text('Example $number of 5'), findsOneWidget);
    }
    Navigator.of(
      tester.element(find.byType(PromptCustomSetupReviewPage)),
    ).pop();
    await tester.pumpAndSettle();
    expect(setup.state.averageAge, 24);
    expect(setup.state.styleLevel, 'wild');
    expect(setup.state.safeMode, isFalse);
    expect(find.text('24'), findsOneWidget);
    await setup.resetDomain();
    expect(setup.state.averageAge, isNull);
    expect(setup.state.styleLevel, isEmpty);
    expect(setup.state.safeMode, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('multi-select waits for Next and Back preserves the group', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final setup = GameSetupNotifier(MockGameSetupRepository());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [gameSetupProvider.overrideWith((ref) => setup)],
        child: MaterialApp(
          theme: SDeckAppTheme.light,
          home: const PromptCustomSetupPage(),
        ),
      ),
    );
    bool enabled() =>
        tester
            .widget<SDeckSolidButton>(find.byKey(const ValueKey('group-next')))
            .enabled;
    expect(enabled(), isFalse);
    await tester.tap(find.byKey(const ValueKey('group-Friends')));
    await tester.tap(find.byKey(const ValueKey('group-Family')));
    await tester.pumpAndSettle();
    expect(find.text('Who are you playing with?'), findsOneWidget);
    expect(setup.state.groupCategories, ['Friends', 'Family']);
    expect(enabled(), isTrue);
    await tester.tap(find.byKey(const ValueKey('group-Other')));
    await tester.pumpAndSettle();
    expect(enabled(), isFalse);
    await tester.enterText(
      find.descendant(
        of: find.byKey(const ValueKey('group-other-input')),
        matching: find.byType(TextField),
      ),
      'Cofounders',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('group-next')));
    await tester.tap(find.byKey(const ValueKey('group-next')));
    await tester.pumpAndSettle();
    expect(find.text('What topics do you want to see?'), findsOneWidget);
    Navigator.of(tester.element(find.byType(PromptCustomSetupMoodPage))).pop();
    await tester.pumpAndSettle();
    expect(find.text('Who are you playing with?'), findsOneWidget);
    expect(setup.state.groupCategories.length, 3);
    expect(find.text('Cofounders ×'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'description alone works on a narrow screen and survives collapse',
    (tester) async {
      tester.view.physicalSize = const Size(320, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gameSetupProvider.overrideWith(
              (ref) => GameSetupNotifier(MockGameSetupRepository()),
            ),
          ],
          child: MaterialApp(
            theme: SDeckAppTheme.light,
            home: const PromptCustomSetupPage(),
          ),
        ),
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey('group-description-toggle')),
      );
      await tester.tap(find.byKey(const ValueKey('group-description-toggle')));
      await tester.pumpAndSettle();
      final descriptionField = tester.widget<TextField>(
        find.descendant(
          of: find.byKey(const ValueKey('group-description-input')),
          matching: find.byType(TextField),
        ),
      );
      expect(
        descriptionField.decoration!.hintStyle!.fontSize,
        lessThan(descriptionField.style!.fontSize!),
      );
      await tester.enterText(
        find.descendant(
          of: find.byKey(const ValueKey('group-description-input')),
          matching: find.byType(TextField),
        ),
        'College gamers',
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<SDeckSolidButton>(find.byKey(const ValueKey('group-next')))
            .enabled,
        isTrue,
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey('group-description-toggle')),
      );
      await tester.tap(find.byKey(const ValueKey('group-description-toggle')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('group-description-input')),
        findsNothing,
      );
      expect(
        tester
            .widget<SDeckSolidButton>(find.byKey(const ValueKey('group-next')))
            .enabled,
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
