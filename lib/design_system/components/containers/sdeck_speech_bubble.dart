/*----------------------- sdeck_speech_bubble.dart -------------------------*/
// Figma Speech Bubble. A full-width rounded container with centered text.
//   medium — H6, 24px / 30px line height
//   large  — H5, 28px / 36px line height
//
// Surface is white in both modes. Text is brand cool gray darkest
// (#1F1F1F in light, #404040 in dark). The 4px border is scrim,
// #1F1F1F at 25% in both modes.
//
// Usage:
//   SDeckSpeechBubble(text: 'Bubble Text')
//   SDeckSpeechBubble(text: 'Bubble Text', size: SDeckSpeechBubbleSize.large)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../tokens/index.dart';

//======================== SDeckSpeechBubbleSize =============================//
enum SDeckSpeechBubbleSize { medium, large }

//======================== SDeckSpeechBubble ================================//
class SDeckSpeechBubble extends StatelessWidget {
  final String text;
  final SDeckSpeechBubbleSize size;

  const SDeckSpeechBubble({
    super.key,
    required this.text,
    this.size = SDeckSpeechBubbleSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SDeckSpace.padding24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: SDeckBaseColors.white,
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius32),
        border: Border.all(
          color: context.semantic.scrim,
          width: SDeckSize.size4,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: _textStyle(context),
      ),
    );
  }

  TextStyle _textStyle(BuildContext context) {
    final bool large = size == SDeckSpeechBubbleSize.large;
    final double fontSize = large ? SDeckFontSizes.h5 : SDeckFontSizes.h6;
    final double lineHeight = large ? SDeckLineHeights.h5 : SDeckLineHeights.h6;
    final TextStyle base =
        Theme.of(context).textTheme.titleLarge ?? const TextStyle();
    return base.copyWith(
      fontSize: fontSize,
      fontWeight: SDeckFontWeights.semiBold,
      height: lineHeight / fontSize,
      color: SDeckBrandColors.coolGrayDarkest(Theme.of(context).brightness),
    );
  }
}
