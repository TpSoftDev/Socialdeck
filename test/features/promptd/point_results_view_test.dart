import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/dev_tools/point_results_dev_page.dart';
import 'package:socialdeck/features/promptd/presentation/results/promptd_point_results_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('tournament results show the winner, the elimination, and you', (
    tester,
  ) async {
    await _pump(
      tester,
      theme: SDeckAppTheme.dark,
      child: const PromptdPointResultsView(
        subtitle: 'Round 3 Tournament',
        entries: <PromptdPointEntry>[
          PromptdPointEntry(
            playerName: 'Player Name',
            points: 230,
            tone: PromptdPointTone.tangerine,
            announcement: 'Winner!',
          ),
          PromptdPointEntry(
            playerName: 'Player Name',
            points: 80,
            tone: PromptdPointTone.coolGray,
            cardOnLeft: false,
            announcement: 'Eliminated!',
          ),
          PromptdPointEntry(
            playerName: 'You',
            points: 40,
            layout: PromptdPointLayout.compact,
          ),
        ],
      ),
    );

    expect(find.text('Results'), findsOneWidget);
    expect(find.text('Round 3 Tournament'), findsOneWidget);
    expect(find.text('Winner!'), findsOneWidget);
    expect(find.text('+230'), findsOneWidget);
    expect(find.text('Eliminated!'), findsOneWidget);
    expect(find.text('+80'), findsOneWidget);
    expect(find.text('You'), findsOneWidget);
    expect(find.text('+40'), findsOneWidget);
    expect(find.byType(SDeckPlayingCard), findsNWidgets(2));
    expect(find.byType(SDeckPromptdTopBar), findsOneWidget);
    expect(_textColor(tester, 'Winner!'), SDeckBaseColors.tangerine[500]);
    expect(_textColor(tester, '+230'), SDeckBaseColors.tangerine[500]);
    expect(_bandColor(tester, 'Winner!'), SDeckBaseColors.tangerine[900]);
    expect(_bandColor(tester, 'Eliminated!'), SDeckBaseColors.coolGray[700]);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'a loss uses the error color and light fills use the 100 swatch',
    (tester) async {
      await _pump(
        tester,
        theme: SDeckAppTheme.light,
        child: const PromptdPointResultsView(
          entries: <PromptdPointEntry>[
            PromptdPointEntry(
              playerName: 'Player Name',
              points: 115,
              tone: PromptdPointTone.skyBlue,
              announcement: 'Winner!',
            ),
            PromptdPointEntry(
              playerName: 'You',
              points: -100,
              layout: PromptdPointLayout.compact,
            ),
          ],
        ),
      );

      expect(find.text('+115'), findsOneWidget);
      expect(find.text('-100'), findsOneWidget);
      expect(_textColor(tester, '-100'), _error(tester, '-100'));
      expect(_bandColor(tester, 'Winner!'), SDeckBaseColors.skyBlue[100]);
      expect(find.text('Play Again'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'results dev fades from a set into the tournament loss',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: SDeckAppTheme.dark,
          home: const PointResultsDevPage(),
        ),
      );
      await tester.pump();

      expect(find.text('+120'), findsOneWidget);
      expect(find.text('Set 2'), findsOneWidget);

    await _until(
      tester,
      () =>
          find.text('Tie!').evaluate().length == 2 &&
          find.text('+120').evaluate().isEmpty,
    );
    expect(find.text('+50'), findsWidgets);

      await _until(
        tester,
        () =>
            find.text('-100').evaluate().isNotEmpty &&
            _opacity(tester, '-100') == 1,
      );
      expect(find.text('Winner!'), findsOneWidget);
      expect(find.text('Eliminated!'), findsOneWidget);
      expect(_textColor(tester, '-100'), _error(tester, '-100'));
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
  fail('timed out waiting for the results screen');
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
  await tester.pumpWidget(
    MaterialApp(theme: theme, home: Scaffold(body: child)),
  );
  await tester.pump();
}

Color _textColor(WidgetTester tester, String text) {
  return tester.widget<Text>(find.text(text)).style!.color!;
}

Color _error(WidgetTester tester, String text) {
  return tester.element(find.text(text)).semantic.error;
}

Color _bandColor(WidgetTester tester, String text) {
  Color? found;
  tester.element(find.text(text)).visitAncestorElements((Element element) {
    final Widget widget = element.widget;
    if (widget is ColoredBox) {
      found = widget.color;
      return false;
    }
    return true;
  });
  return found!;
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
