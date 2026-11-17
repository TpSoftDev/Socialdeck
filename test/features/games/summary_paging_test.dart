import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/games/domain/game_setup_state.dart';
import 'package:socialdeck/features/games/providers/game_setup_provider.dart';
import 'package:socialdeck/features/games/data/mock_game_setup_repository.dart';
import 'package:socialdeck/features/games/presentation/pages/party_topics_examples_dialog.dart';

void main() {
  test(
    'approvals keep exact reviewed text and new generation clears them',
    () async {
      final setup = GameSetupNotifier(MockGameSetupRepository());
      addTearDown(setup.dispose);
      await setup.generatePrompts();
      setup.approveExample(0);
      setup.approveExample(2);
      setup.approveExample(0);
      expect(setup.state.approvedExamples, [
        setup.state.examplePrompts![0],
        setup.state.examplePrompts![2],
      ]);
      await setup.generatePrompts();
      expect(setup.state.approvedExamples, isEmpty);
    },
  );
  testWidgets(
    'fixed card pages approved examples and optional scrollable description',
    (tester) async {
      tester.view.physicalSize = const Size(320, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final draft = GameSetupState(
        groupCategories: const ['Friends'],
        selectedTopics: const ['Memes'],
        groupDescription: List.filled(60, 'Group description.').join(' '),
        examplePrompts: const ['Rejected', 'Approved first', 'Approved second'],
        approvedExamples: const ['Approved first', 'Approved second'],
        approvedExampleTopics: const {
          'Approved first': ['Memes'],
          'Approved second': ['Fitness'],
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: SDeckAppTheme.light,
          home: Scaffold(body: PartyTopicsExamplesDialog(draft: draft)),
        ),
      );
      final card = find.byKey(const ValueKey('topics-examples-card'));
      final initialSize = tester.getSize(card);
      final previous = find.byKey(const ValueKey('summary-previous'));
      final next = find.byKey(const ValueKey('summary-next'));
      final toggle = find.byKey(const ValueKey('summary-toggle'));
      expect(tester.widget<IconButton>(previous).onPressed, isNull);
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(find.text('About your group'), findsOneWidget);
      expect(tester.widget<IconButton>(next).onPressed, isNull);
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(card), initialSize);
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      expect(
        tester
            .getSize(find.byKey(const ValueKey('approved-example-card')))
            .height,
        280,
      );
      expect(find.text('“Approved first”'), findsOneWidget);
      expect(find.text('Memes'), findsOneWidget);
      expect(find.text('Approved'), findsNothing);
      expect(find.text('Fitness'), findsNothing);
      expect(find.textContaining('Rejected'), findsNothing);
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(
        tester
            .getSize(find.byKey(const ValueKey('approved-example-card')))
            .height,
        280,
      );
      expect(find.text('“Approved second”'), findsOneWidget);
      expect(find.text('Fitness'), findsOneWidget);
      expect(find.text('Memes'), findsNothing);
      expect(tester.widget<IconButton>(next).onPressed, isNull);
      await tester.tap(previous);
      await tester.pumpAndSettle();
      expect(
        tester
            .getSize(find.byKey(const ValueKey('approved-example-card')))
            .height,
        280,
      );
      expect(find.text('“Approved first”'), findsOneWidget);
      expect(find.text('Memes'), findsOneWidget);
      expect(find.text('Approved'), findsNothing);
      expect(find.text('Fitness'), findsNothing);
      expect(tester.getSize(card), initialSize);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('no approvals and no description do not offer extra pages', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SDeckAppTheme.light,
        home: const Scaffold(
          body: PartyTopicsExamplesDialog(draft: GameSetupState()),
        ),
      ),
    );
    final next = find.byKey(const ValueKey('summary-next'));
    expect(tester.widget<IconButton>(next).onPressed, isNull);
    await tester.tap(find.byKey(const ValueKey('summary-toggle')));
    await tester.pumpAndSettle();
    expect(find.text('No examples approved yet.'), findsOneWidget);
    expect(tester.widget<IconButton>(next).onPressed, isNull);
  });
}
