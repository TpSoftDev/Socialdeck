/*--------------------- promptd_bracket_round_view.dart -------------------*/
// One Prompt'd bracket beat. Stateless snapshot:
// top bar, speech bubble, image band, then the card sheet.
// The beat decides which of those are on screen. Light and dark
// colors come from the theme.
/*--------------------------------------------------------------------------*/

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- PromptdBracketBeat --------------------------//
/// Where the round is in the Figma prototype.
enum PromptdBracketBeat {
  /// Large prompt and the image band.
  reveal,

  /// Medium prompt and the image band.
  minimize,

  /// Medium prompt, image band, and the revealed card.
  card,

  /// Medium prompt only. The card has left the screen.
  promptOnly,
}

//---------------------------- PromptdBracketCardTone -------------------------//
/// Fill behind the revealed card. The swatch follows the theme.
enum PromptdBracketCardTone { tangerine, mint }

//---------------------------- PromptdBracketRoundView ------------------------//
class PromptdBracketRoundView extends StatelessWidget {
  /// The card reveal sheet tilts the playing card by this many degrees.
  static const double _cardTiltDegrees = -1.87;
  const PromptdBracketRoundView({
    super.key,
    required this.prompt,
    this.round = 'Round 3',
    this.subtitle = 'Vote for your favorite!',
    this.beat = PromptdBracketBeat.reveal,
    this.cardTone = PromptdBracketCardTone.tangerine,
    this.onPause,
    this.onMore,
  });

  final String prompt;
  final String round;
  final String subtitle;
  final PromptdBracketBeat beat;
  final PromptdBracketCardTone cardTone;
  final VoidCallback? onPause;
  final VoidCallback? onMore;

  bool get _largePrompt => beat == PromptdBracketBeat.reveal;

  bool get _showBand =>
      beat == PromptdBracketBeat.reveal ||
      beat == PromptdBracketBeat.minimize ||
      beat == PromptdBracketBeat.card;

  bool get _showCard => beat == PromptdBracketBeat.card;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _showCard ? _sheetColor(context) : context.semantic.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SDeckPromptdTopBar(
            round: round,
            opposingPlayer: subtitle,
            rightIcon: SDeckIcons(
              SDeckIcon.more,
              size: SDeckSize.size36,
              color: context.semantic.primary,
            ),
            onPausePressed: onPause,
            onRightIconPressed: onMore,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SDeckSpace.margin16,
            ),
            child: SDeckSpeechBubble(
              text: prompt,
              size:
                  _largePrompt
                      ? SDeckSpeechBubbleSize.large
                      : SDeckSpeechBubbleSize.medium,
            ),
          ),
          if (_showCard)
            Expanded(child: _cardStage(context))
          else if (_showBand)
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SDeckVisualPlaceholder(height: constraints.maxWidth / 2);
              },
            ),
        ],
      ),
    );
  }

  /// The image band, with the card starting over its lower edge.
  /// In the Figma frame the band is 201 tall and the sheet starts 145
  /// pixels down that band.
  Widget _cardStage(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double bandHeight = constraints.maxWidth / 2;
        final double sheetTop = bandHeight * 145 / 201;
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: bandHeight,
              child: const SDeckVisualPlaceholder(),
            ),
            Positioned(
              top: sheetTop,
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  SDeckSpace.margin16,
                  SDeckSpace.margin24,
                  SDeckSpace.margin16,
                  SDeckSize.size64,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Transform.rotate(
                      angle: _cardTiltDegrees * math.pi / 180,
                      child: const SDeckPlayingCard(
                        size: SDeckPlayingCardSize.extraLarge,
                        shadow: SDeckPlayingCardShadow.high,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _sheetColor(BuildContext context) {
    return switch (cardTone) {
      PromptdBracketCardTone.tangerine =>
        context.component.voteTargetSurfaceTangerine,
      PromptdBracketCardTone.mint =>
        context.component.voteTargetSurfaceMintGreen,
    };
  }
}
