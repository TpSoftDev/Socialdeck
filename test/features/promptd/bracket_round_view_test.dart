import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/promptd/presentation/bracket/promptd_bracket_round_view.dart';

const String _prompt = 'What I think I look like vs. what everyone else sees';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('prompt reveal shows the large prompt and the image band', (
    tester,
  ) async {
    await _pump(
      tester,
      theme: SDeckAppTheme.light,
      beat: PromptdBracketBeat.reveal,
    );

    expect(find.text('Round 3'), findsOneWidget);
    expect(find.text('Vote for your favorite!'), findsOneWidget);
    expect(find.text(_prompt), findsOneWidget);
    expect(_promptSize(tester), SDeckFontSizes.h5);
    expect(find.byType(SDeckVisualPlaceholder), findsOneWidget);
    expect(find.byType(SDeckPlayingCard), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('prompt minimize uses the medium bubble', (tester) async {
    final FontLoader loader = FontLoader('Poppins')
      ..addFont(rootBundle.load('assets/fonts/Poppins-SemiBold.ttf'));
    await loader.load();
    await _pump(
      tester,
      theme: SDeckAppTheme.dark,
      beat: PromptdBracketBeat.minimize,
    );

    expect(find.text(_prompt), findsOneWidget);
    expect(_promptSize(tester), SDeckFontSizes.h6);
    expect(find.byType(SDeckPlayingCard), findsNothing);
    expect(tester.getSize(find.byType(SDeckSpeechBubble)), const Size(370, 116));
    final Text text = tester.widget<Text>(find.text(_prompt));
    expect(text.style?.color, SDeckBaseColors.coolGray[900]);
    final Container bubble = tester.widget<Container>(
      find.descendant(
        of: find.byType(SDeckSpeechBubble),
        matching: find.byType(Container),
      ),
    );
    final BoxDecoration decoration = bubble.decoration! as BoxDecoration;
    expect(decoration.color, SDeckBaseColors.white);
    expect(decoration.border?.top.width, SDeckSize.size4);
    expect(
      decoration.border?.top.color,
      SDeckAppTheme.dark.extension<SDeckSemanticColors>()!.scrim,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('a revealed card sits on the tangerine sheet', (tester) async {
    await _pump(
      tester,
      theme: SDeckAppTheme.light,
      beat: PromptdBracketBeat.card,
      tone: PromptdBracketCardTone.tangerine,
    );

    expect(find.byType(SDeckPlayingCard), findsOneWidget);
    expect(find.byType(SDeckVisualPlaceholder), findsOneWidget);
    expect(_promptSize(tester), SDeckFontSizes.h6);
    expect(_cardTilt(tester), closeTo(-1.87 * math.pi / 180, 0.001));
    expect(_sheetColor(tester), SDeckBaseColors.tangerine[100]);
    final Rect card = tester.getRect(find.byType(SDeckPlayingCard));
    final Rect band = tester.getRect(find.byType(SDeckVisualPlaceholder));
    expect(card.top, lessThan(band.bottom));
    expect(card.bottom, greaterThan(band.bottom));
    expect(tester.takeException(), isNull);
  });

  testWidgets('dark mode uses the dark mint sheet', (tester) async {
    await _pump(
      tester,
      theme: SDeckAppTheme.dark,
      beat: PromptdBracketBeat.card,
      tone: PromptdBracketCardTone.mint,
    );

    expect(_sheetColor(tester), SDeckBaseColors.mintGreen[900]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the fade beat keeps the prompt and drops the card', (
    tester,
  ) async {
    await _pump(
      tester,
      theme: SDeckAppTheme.light,
      beat: PromptdBracketBeat.promptOnly,
    );

    expect(find.text(_prompt), findsOneWidget);
    expect(find.byType(SDeckVisualPlaceholder), findsNothing);
    expect(find.byType(SDeckPlayingCard), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required ThemeData theme,
  required PromptdBracketBeat beat,
  PromptdBracketCardTone tone = PromptdBracketCardTone.tangerine,
}) async {
  tester.view.physicalSize = const Size(402, 874);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: Scaffold(
        body: PromptdBracketRoundView(
          prompt: _prompt,
          beat: beat,
          cardTone: tone,
        ),
      ),
    ),
  );
}

Color? _sheetColor(WidgetTester tester) {
  final ColoredBox box = tester.widget<ColoredBox>(
    find
        .ancestor(
          of: find.byType(SDeckPlayingCard),
          matching: find.byType(ColoredBox),
        )
        .first,
  );
  return box.color;
}

double? _promptSize(WidgetTester tester) {
  return tester.widget<Text>(find.text(_prompt)).style?.fontSize;
}

double _cardTilt(WidgetTester tester) {
  final Transform transform = tester.widget<Transform>(
    find
        .ancestor(
          of: find.byType(SDeckPlayingCard),
          matching: find.byType(Transform),
        )
        .first,
  );
  return math.atan2(
    transform.transform.storage[1],
    transform.transform.storage[0],
  );
}
