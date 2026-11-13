import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/dev_tools/promptd_dev_tools_page.dart';
import 'package:socialdeck/features/promptd/presentation/standings/promptd_leaderboard_row.dart';
import 'package:socialdeck/features/promptd/presentation/standings/standings_phase_view.dart';

const List<PromptdLeaderboardEntry> _eight = <PromptdLeaderboardEntry>[
  PromptdLeaderboardEntry(
    playerName: 'Player Name',
    points: '220',
    standing: SDeckLeaderboardStanding.gold,
  ),
  PromptdLeaderboardEntry(
    playerName: 'Player Name',
    points: '185',
    standing: SDeckLeaderboardStanding.silver,
  ),
  PromptdLeaderboardEntry(
    playerName: 'Player Name',
    points: '170',
    standing: SDeckLeaderboardStanding.bronze,
  ),
  PromptdLeaderboardEntry(
    playerName: 'Player Name',
    points: '140',
    standing: SDeckLeaderboardStanding.plain,
  ),
  PromptdLeaderboardEntry(
    playerName: 'Player Name',
    points: '100',
    standing: SDeckLeaderboardStanding.plain,
  ),
  PromptdLeaderboardEntry(
    playerName: 'Player Name',
    points: '90',
    standing: SDeckLeaderboardStanding.plain,
  ),
  PromptdLeaderboardEntry(
    playerName: 'Player Name',
    points: '80',
    standing: SDeckLeaderboardStanding.plain,
  ),
  PromptdLeaderboardEntry(
    playerName: 'Player Name',
    points: '70',
    standing: SDeckLeaderboardStanding.plain,
  ),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full board shows round, placeholder, and scores', (
    tester,
  ) async {
    await _pumpBoard(tester, theme: SDeckAppTheme.light);

    expect(find.text('Round 1'), findsOneWidget);
    expect(find.text('Leaderboard'), findsOneWidget);
    expect(find.text('220'), findsOneWidget);
    expect(find.text('140'), findsOneWidget);
    expect(find.byType(SDeckVisualPlaceholder), findsWidgets);
    expect(find.byType(SDeckLeaderboardContainer), findsNWidgets(8));
    expect(_goldSurface(tester), SDeckBaseColors.vibrantYellow[100]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dark board uses the dark gold surface', (tester) async {
    await _pumpBoard(tester, theme: SDeckAppTheme.dark);

    expect(find.text('220'), findsOneWidget);
    expect(_goldSurface(tester), SDeckBaseColors.vibrantYellow[900]);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'blank frame hides the board and a partial reveal hides later rows',
    (tester) async {
      await _pumpBoard(
        tester,
        theme: SDeckAppTheme.light,
        showChrome: false,
        showPlaceholder: false,
        revealedBars: 0,
        revealedContent: 0,
      );
      expect(_textOpacity(tester, 'Round 1'), 0);
      expect(_rowOpacity(tester, '220'), 0);

      await _pumpBoard(
        tester,
        theme: SDeckAppTheme.light,
        revealedBars: 1,
        revealedContent: 1,
      );
      expect(_rowOpacity(tester, '220'), 1);
      expect(_rowOpacity(tester, '185'), 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('podium color shows before the score', (tester) async {
    await _pumpBoard(
      tester,
      theme: SDeckAppTheme.light,
      revealedBars: 3,
      revealedContent: 0,
    );

    expect(_outerFade(tester, '220'), 1);
    expect(_contentFade(tester, '220'), 0);
    expect(_outerFade(tester, '140'), 0);
    expect(_outerFade(tester, '140'), 0);
    expect(_goldSurface(tester), SDeckBaseColors.vibrantYellow[100]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('two players fill the board without overflowing', (tester) async {
    await _pumpBoard(
      tester,
      theme: SDeckAppTheme.light,
      entries: _eight.take(2).toList(),
    );
    expect(find.byType(SDeckLeaderboardContainer), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('new pieces fade in on the design-system curve', (tester) async {
    await tester.pumpWidget(
      _app(theme: SDeckAppTheme.light, child: const _RevealHost()),
    );
    expect(_textOpacity(tester, 'Round 1'), 0);

    tester.state<_RevealHostState>(find.byType(_RevealHost)).reveal();
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 150));
    final double mid = _textOpacity(tester, 'Round 1');
    expect(mid, greaterThan(0));
    expect(mid, lessThan(1));

    await tester.pump(const Duration(milliseconds: 200));
    expect(_textOpacity(tester, 'Round 1'), 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('podium scores stay inside the row on a phone', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: SDeckAppTheme.light,
        home: const MediaQuery(
          data: MediaQueryData(
            size: Size(393, 852),
            padding: EdgeInsets.only(top: 59, bottom: 34),
          ),
          child: Scaffold(
            body: SafeArea(child: StandingsPhaseView(entries: _eight)),
          ),
        ),
      ),
    );

    final Rect score = tester.getRect(find.text('220'));
    final Rect row = tester.getRect(
      find
          .ancestor(
            of: find.text('220'),
            matching: find.byType(PromptdLeaderboardRow),
          )
          .first,
    );
    expect(
      score.height,
      greaterThan(40),
      reason:
          'score ${score.height} row ${row.height} top ${score.top - row.top}',
    );
    expect(score.top, greaterThanOrEqualTo(row.top - 0.5));
    expect(score.bottom, lessThanOrEqualTo(row.bottom + 0.5));
    final Rect last = tester.getRect(find.text('70'));
    final Rect view = tester.getRect(find.byType(StandingsPhaseView));
    expect(
      view.bottom - last.bottom,
      lessThan(90),
      reason: 'gap ${view.bottom - last.bottom} score ${score.height}',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('dev tools opens on the blank frame and then reveals the board', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        theme: SDeckAppTheme.light,
        child: const LeaderboardsTournamentDevPage(),
      ),
    );
    expect(_textOpacity(tester, 'Round 1'), 0);

    await _until(tester, () => _textOpacity(tester, 'Round 1') == 1);
    await _until(tester, () => _outerFade(tester, '220') == 1);
    expect(_contentFade(tester, '220'), 0);

    await _until(tester, () => _contentFade(tester, '220') == 1);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _until(WidgetTester tester, bool Function() ready) async {
  for (var i = 0; i < 40; i++) {
    if (ready()) return;
    await tester.pump(const Duration(milliseconds: 200));
  }
  fail('timed out waiting for the leaderboard frame');
}

Future<void> _pumpBoard(
  WidgetTester tester, {
  required ThemeData theme,
  List<PromptdLeaderboardEntry> entries = _eight,
  bool showChrome = true,
  bool showPlaceholder = true,
  int? revealedBars,
  int? revealedContent,
}) async {
  tester.view.physicalSize = const Size(402, 824);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    _app(
      theme: theme,
      child: StandingsPhaseView(
        entries: entries,
        showChrome: showChrome,
        showPlaceholder: showPlaceholder,
        revealedBars: revealedBars,
        revealedContent: revealedContent,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Widget _app({required ThemeData theme, required Widget child}) {
  return MaterialApp(theme: theme, home: Scaffold(body: child));
}

class _RevealHost extends StatefulWidget {
  const _RevealHost();

  @override
  State<_RevealHost> createState() => _RevealHostState();
}

class _RevealHostState extends State<_RevealHost> {
  bool _chrome = false;

  void reveal() => setState(() => _chrome = true);

  @override
  Widget build(BuildContext context) {
    return StandingsPhaseView(
      entries: _eight,
      showChrome: _chrome,
      showPlaceholder: false,
      revealedBars: 0,
      revealedContent: 0,
    );
  }
}

Color? _goldSurface(WidgetTester tester) {
  final ColoredBox box = tester.widget<ColoredBox>(
    find
        .ancestor(of: find.text('220'), matching: find.byType(ColoredBox))
        .first,
  );
  return box.color;
}

double _textOpacity(WidgetTester tester, String text) {
  double? value;
  tester.element(find.text(text)).visitAncestorElements((Element element) {
    final Widget widget = element.widget;
    if (widget is FadeTransition) {
      value = widget.opacity.value;
      return false;
    }
    return true;
  });
  return value ?? 1;
}

double _contentFade(WidgetTester tester, String points) =>
    _scoreFades(tester, points).first;

double _outerFade(WidgetTester tester, String points) =>
    _scoreFades(tester, points)[1];

double _rowOpacity(WidgetTester tester, String points) {
  return _scoreFades(tester, points).reduce((double a, double b) => a * b);
}

/// Fade values around one score, nearest first: the player fade, then the row.
List<double> _scoreFades(WidgetTester tester, String points) {
  final List<double> values = <double>[];
  tester.element(find.text(points)).visitAncestorElements((Element element) {
    final Widget widget = element.widget;
    if (widget is FadeTransition) values.add(widget.opacity.value);
    return widget is! PromptdLeaderboardRow;
  });
  return values;
}
