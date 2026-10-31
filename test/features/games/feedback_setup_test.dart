import 'package:flutter/material.dart';
import 'package:socialdeck/features/games/presentation/pages/prompt_settings_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/games/data/mock_game_setup_repository.dart';
import 'package:socialdeck/features/games/data/game_setup_repository.dart';
import 'package:socialdeck/features/games/providers/game_setup_provider.dart';
import 'package:socialdeck/features/games/presentation/pages/prompt_custom_setup_page.dart';

class FeedbackRepository extends MockGameSetupRepository {
  final feedback = <PromptFeedbackData>[];
  @override
  Future<void> reportFeedback(PromptFeedbackData data) async {
    feedback.add(data);
  }
}

void main() {
  testWidgets(
    'settings shows actual choices and topic editing returns to settings',
    (tester) async {
      tester.view.physicalSize = const Size(320, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final setup = GameSetupNotifier(FeedbackRepository());
      setup.toggleGroupCategory('Friends');
      setup.toggleGroupCategory('Other');
      setup.updateOtherGroup('Roommates');
      setup.confirmGroup();
      setup.toggleTopic('Fitness');
      setup.confirmTopics();
      setup.updateStyleLevel('bold');
      setup.updateAverageAge('24');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [gameSetupProvider.overrideWith((ref) => setup)],
          child: MaterialApp(
            theme: SDeckAppTheme.light,
            home: const PromptSettingsPage(),
          ),
        ),
      );
      expect(find.text("Who's playing"), findsOneWidget);
      expect(find.text('Friends, Roommates'), findsOneWidget);
      expect(find.text('Topics'), findsOneWidget);
      expect(find.text('Prompt style'), findsOneWidget);
      expect(find.text('24'), findsOneWidget);
      expect(find.text('Keywords'), findsNothing);
      expect(find.text('Mood'), findsNothing);
      final change = find.byKey(const ValueKey('settings-change-Topics'));
      await tester.ensureVisible(change);
      await tester.tap(change);
      await tester.pumpAndSettle();
      final pets = find.byKey(const ValueKey('topic-Pets'));
      await tester.ensureVisible(pets);
      await tester.tap(pets);
      await tester.pumpAndSettle();
      final next = find.byKey(const ValueKey('topic-next'));
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(find.byType(PromptSettingsPage), findsOneWidget);
      expect(find.byType(PromptCustomSetupIntensityPage), findsNothing);
      expect(find.text('Fitness, Pets'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('finalizing shows Complete before settings', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gameSetupProvider.overrideWith(
            (ref) => GameSetupNotifier(FeedbackRepository()),
          ),
        ],
        child: MaterialApp(
          theme: SDeckAppTheme.light,
          home: const PromptCustomSetupFinishingPage(),
        ),
      ),
    );
    expect(find.text('Finalizing prompts...'), findsOneWidget);
    expect(find.text('Complete!'), findsNothing);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1999));
    expect(find.text('Finalizing prompts...'), findsOneWidget);
    expect(find.text('Complete!'), findsNothing);
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.text('Complete!'), findsOneWidget);
    expect(find.byType(PromptSettingsPage), findsNothing);
    await tester.pump(const Duration(milliseconds: 1999));
    expect(find.text('Complete!'), findsOneWidget);
    expect(find.byType(PromptSettingsPage), findsNothing);
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(PromptSettingsPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'feedback supports multiple reasons and custom entries at narrow width',
    (tester) async {
      tester.view.physicalSize = const Size(320, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repo = FeedbackRepository();
      final setup = GameSetupNotifier(repo);
      await setup.generatePrompts();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [gameSetupProvider.overrideWith((ref) => setup)],
          child: MaterialApp(
            theme: SDeckAppTheme.light,
            home: const PromptCustomSetupReviewPage(),
          ),
        ),
      );
      Future<void> tap(Finder target) async {
        await tester.ensureVisible(target);
        await tester.tap(target);
        await tester.pumpAndSettle();
      }

      await tap(find.bySemanticsLabel('Dislike this prompt'));
      expect(find.text('How could this prompt be better?'), findsOneWidget);
      final rowY =
          tester
              .getTopLeft(find.byKey(const ValueKey('feedback-Too boring')))
              .dy;
      expect(
        tester
            .getTopLeft(find.byKey(const ValueKey('feedback-Too intense')))
            .dy,
        rowY,
      );
      expect(
        tester
            .getTopLeft(find.byKey(const ValueKey('feedback-Too generic')))
            .dy,
        rowY,
      );
      final next = find.byKey(const ValueKey('feedback-next'));
      bool enabled() => tester.widget<SDeckSolidButton>(next).enabled;
      expect(enabled(), isFalse);
      for (final choice in ['Too boring', 'Too generic', 'Other']) {
        await tap(find.byKey(ValueKey('feedback-$choice')));
      }
      expect(enabled(), isFalse);
      final input = find.descendant(
        of: find.byKey(const ValueKey('feedback-other-input')),
        matching: find.byType(TextField),
      );
      for (final text in ['More jokes', 'more jokes', 'Shorter']) {
        await tester.enterText(input, text);
        await tester.pumpAndSettle();
        await tap(find.byKey(const ValueKey('feedback-other-add')));
      }
      expect(
        find.byKey(const ValueKey('feedback-remove-more jokes')),
        findsNothing,
      );
      await tap(find.byKey(const ValueKey('feedback-remove-Shorter')));
      await tester.enterText(input, 'Less jargon');
      await tester.pumpAndSettle();
      await tap(next);
      expect(find.text('Example 2 of 5'), findsOneWidget);
      expect(repo.feedback.single.promptNumber, 1);
      expect(
        repo.feedback.single.promptFeedback,
        'Too boring; Too generic; More jokes; Less jargon',
      );
      await tap(find.bySemanticsLabel('Dislike this prompt'));
      expect(tester.widget<SDeckSolidButton>(next).enabled, isFalse);
      Navigator.of(tester.element(next)).pop();
      await tester.pumpAndSettle();
      expect(find.text('Example 2 of 5'), findsOneWidget);
      expect(repo.feedback.length, 1);
      expect(tester.takeException(), isNull);
    },
  );
}
