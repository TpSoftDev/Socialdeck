import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';

void main() {
  testWidgets('light tangerine band shows the rank on the light surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SDeckAppTheme.light,
        home: const SDeckVoteTarget(label: '#1'),
      ),
    );

    expect(find.text('#1'), findsOneWidget);
    expect(
      _surface(tester),
      SDeckBaseColors.tangerine[100],
    );
  });

  testWidgets('dark mint band with the card on the right uses the dark surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: SDeckAppTheme.dark,
        home: const SDeckVoteTarget(
          label: '#2',
          color: SDeckVoteTargetColor.mintGreen,
          cardPosition: SDeckVoteTargetCardPosition.right,
        ),
      ),
    );

    expect(find.text('#2'), findsOneWidget);
    expect(
      _surface(tester),
      SDeckBaseColors.mintGreen[900],
    );
    expect(find.byType(SDeckPlayingCard), findsOneWidget);
  });
}

Color _surface(WidgetTester tester) {
  final ColoredBox box = tester.widget<ColoredBox>(
    find.descendant(
      of: find.byType(SDeckVoteTarget),
      matching: find.byType(ColoredBox),
    ),
  );
  return box.color;
}
