import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/dev_tools/promptd_dev_tools_page.dart';
import 'package:socialdeck/features/promptd/presentation/announcement/promptd_announcement_view.dart';
import 'package:socialdeck/features/promptd/presentation/conclusion/promptd_conclusion_view.dart';
import 'package:socialdeck/features/promptd/presentation/shell/promptd_fade_through.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('voting announcement shows the title, message, and square', (
    tester,
  ) async {
    await _pump(
      tester,
      theme: SDeckAppTheme.light,
      child: const PromptdAnnouncementView(
        title: 'Voting Time!',
        message:
            'Climb the bracket to win the final tournament for double points!',
      ),
    );

    expect(find.text('Voting Time!'), findsOneWidget);
    expect(find.byType(SDeckPromptdTopBar), findsOneWidget);
    expect(
      tester.getRect(find.text('Voting Time!')).top,
      greaterThan(tester.getRect(find.byType(SDeckPromptdTopBar)).bottom),
    );
    expect(
      find.text(
        'Climb the bracket to win the final tournament for double points!',
      ),
      findsOneWidget,
    );
    final Size placeholder = tester.getSize(
      find.byType(SDeckVisualPlaceholder),
    );
    expect(placeholder.height, placeholder.width);
    expect(
      _titleColor(tester, 'Voting Time!'),
      _primary(tester, 'Voting Time!'),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('final two uses the dark text color', (tester) async {
    await _pump(
      tester,
      theme: SDeckAppTheme.dark,
      child: const PromptdAnnouncementView(
        title: 'Final Two!',
        message: 'Vote for the best card of the tournament.',
      ),
    );

    expect(find.text('Final Two!'), findsOneWidget);
    expect(find.byType(SDeckPromptdTopBar), findsOneWidget);
    expect(_titleColor(tester, 'Final Two!'), _primary(tester, 'Final Two!'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('host conclusion has the extra actions and player does not', (
    tester,
  ) async {
    await _pump(
      tester,
      theme: SDeckAppTheme.dark,
      child: const PromptdConclusionView(role: PromptdConclusionRole.host),
    );
    expect(find.text('Thanks for playing!'), findsOneWidget);
    expect(find.byType(SDeckPromptdTopBar), findsOneWidget);
    expect(
      tester.getRect(find.text('Thanks for playing!')).top,
      greaterThanOrEqualTo(
        tester.getRect(find.byType(SDeckPromptdTopBar)).bottom,
      ),
    );
    expect(find.text('Play Again'), findsOneWidget);
    expect(find.text('Change Settings'), findsOneWidget);
    expect(find.text('Back to Party'), findsOneWidget);
    expect(find.byType(SDeckVisualPlaceholder), findsOneWidget);
    expect(
      _titleColor(tester, 'Thanks for playing!'),
      _primary(tester, 'Thanks for playing!'),
    );

    await _pump(
      tester,
      theme: SDeckAppTheme.light,
      child: const PromptdConclusionView(role: PromptdConclusionRole.player),
    );
    expect(find.text('Play Again'), findsNothing);
    expect(find.text('Change Settings'), findsNothing);
    expect(find.text('Back to Party'), findsOneWidget);
    expect(find.byType(SDeckPromptdTopBar), findsOneWidget);
    expect(
      tester.getRect(find.text('Thanks for playing!')).top,
      greaterThanOrEqualTo(
        tester.getRect(find.byType(SDeckPromptdTopBar)).bottom,
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('announcements fade out before the next one fades in', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        theme: SDeckAppTheme.light,
        child: const PromptdFadeThrough(
          step: 0,
          child: PromptdAnnouncementView(
            title: 'Voting Time!',
            message:
                'Climb the bracket to win the final tournament for double points!',
          ),
        ),
      ),
    );

    await tester.pumpWidget(
      _app(
        theme: SDeckAppTheme.light,
        child: const PromptdFadeThrough(
          step: 1,
          child: PromptdAnnouncementView(
            title: 'Final Two!',
            message: 'Vote for the best card of the tournament.',
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));
    expect(_opacity(tester, 'Voting Time!'), 0);
    expect(_opacity(tester, 'Final Two!'), 0);

    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.text('Voting Time!'), findsNothing);
    expect(_opacity(tester, 'Final Two!'), 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'leaderboard dev fades into voting time, then the final two',
    (tester) async {
      await tester.pumpWidget(
        _app(
          theme: SDeckAppTheme.light,
          child: const LeaderboardsTournamentDevPage(),
        ),
      );

      await _until(
        tester,
        () =>
            find.text('Voting Time!').evaluate().isNotEmpty &&
            _opacity(tester, 'Voting Time!') == 1,
      );
      expect(
        find.text(
          'Climb the bracket to win the final tournament for double points!',
        ),
        findsOneWidget,
      );

      await _until(
        tester,
        () =>
            find.text('Final Two!').evaluate().isNotEmpty &&
            _opacity(tester, 'Final Two!') == 1,
      );
      expect(find.text('Voting Time!'), findsNothing);
      expect(
        find.text('Vote for the best card of the tournament.'),
        findsOneWidget,
      );

      await _until(
        tester,
        () =>
            find.text('Game Over!').evaluate().isNotEmpty &&
            _opacity(tester, 'Game Over!') == 1,
      );
      expect(find.text('Final Two!'), findsNothing);
      expect(find.text('The final standings are in!'), findsOneWidget);

      await _until(
        tester,
        () =>
            find.text('Tournament Winner').evaluate().isNotEmpty &&
            _opacity(tester, 'Tournament Winner') == 1,
      );
      expect(find.text('Game Over!'), findsNothing);
      expect(find.text('Final'), findsOneWidget);
      expect(find.text('220'), findsOneWidget);
      expect(find.byType(SDeckPlayingCard), findsOneWidget);

      await _until(
        tester,
        () =>
            find.text('Play Again').evaluate().isNotEmpty &&
            _opacity(tester, 'Play Again') == 1,
      );
      expect(find.text('Thanks for playing!'), findsOneWidget);
      expect(find.text('Change Settings'), findsOneWidget);
      expect(find.text('Tournament Winner'), findsNothing);

      await _until(
        tester,
        () =>
            find.text('Play Again').evaluate().isEmpty &&
            find.text('Back to Party').evaluate().isNotEmpty &&
            _opacity(tester, 'Back to Party') == 1,
      );
      expect(find.text('Change Settings'), findsNothing);
      expect(find.text('Thanks for playing!'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
    timeout: const Timeout(Duration(seconds: 60)),
  );
}

Future<void> _until(WidgetTester tester, bool Function() ready) async {
  for (var i = 0; i < 200; i++) {
    if (ready()) return;
    await tester.pump(const Duration(milliseconds: 200));
  }
  fail('timed out waiting for the announcement');
}

Future<void> _pump(
  WidgetTester tester, {
  required ThemeData theme,
  required Widget child,
}) async {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(_app(theme: theme, child: child));
}

Widget _app({required ThemeData theme, required Widget child}) {
  return MaterialApp(theme: theme, home: Scaffold(body: child));
}

Color _titleColor(WidgetTester tester, String title) {
  return tester.widget<Text>(find.text(title)).style!.color!;
}

Color _primary(WidgetTester tester, String title) {
  return tester.element(find.text(title)).semantic.primary;
}

double _opacity(WidgetTester tester, String text) {
  double product = 1;
  tester.element(find.text(text)).visitAncestorElements((Element element) {
    final Widget widget = element.widget;
    if (widget is Opacity) product *= widget.opacity;
    if (widget is FadeTransition) product *= widget.opacity.value;
    return true;
  });
  return product;
}
