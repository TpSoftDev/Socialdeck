/*------------------- selecting_card_phase_view.dart -------------------*/
// Prompt'd card selection. Pieces fade with the design-system fade
// ([SDeckMotionDuration.normal], [SDeckMotionCurve.easeIn]):
//   a blank fade transition screen
//   the large prompt and the wide placeholder
//   a blank fade transition screen, with the round bar staying
//   the medium prompt, the square placeholder, and the card sheet
//   the sheet scrolls, a card is selected, then it lifts onto the
//   image and shrinks into place
// The put-back edge case returns that card to the hand, still
// selected, one place to the right of where it was lifted.
// Running out of time keeps the hand up, switches the timer to
// alert, fades the screen clear, then shows Time's Up.
//
// Light and dark share this widget. The page fill is surface:
// #FDFBF5 in light, #101822 in dark. The round title, pause, and
// meatballs are primary. The opponent line is navigation supporting
// text. The speech bubble, placeholder, timer, and cards use their
// own fills.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//-------------------------- SelectingCardPhaseView -------------------------//
class SelectingCardPhaseView extends StatelessWidget {
  const SelectingCardPhaseView({
    super.key,
    this.showChrome = false,
    this.showPrompt = false,
    this.showChoice = false,
    this.prompt = 'Oh man, I wish I could live this moment again.',
    this.round = 'Round 1',
    this.opposingPlayer = 'vs. tpsoftdev',
    this.timerValue = '20',
    this.timerType = SDeckTimerType.default_,
    this.scrollFraction = 0.5,
    this.selectedIndex,
    this.placedIndex,
    this.showLiftedCard = false,
    this.liftedScale = 1,
    this.liftedRotation = -1.37,
    this.showTimesUp = false,
    this.onPause,
    this.onMore,
  });

  /// False leaves the Prompt'd bar empty.
  final bool showChrome;

  /// False hides the large prompt and the wide image.
  final bool showPrompt;

  /// False hides the medium prompt, the square image, and the card sheet.
  final bool showChoice;

  final String prompt;
  final String round;
  final String opposingPlayer;
  final String timerValue;
  final SDeckTimerType timerType;

  /// 0 pins the first card. 0.5 centers the strip.
  final double scrollFraction;

  /// Index into the design strip. Null leaves every card unselected.
  /// While [showLiftedCard] is true, this card leaves the strip.
  final int? selectedIndex;

  /// Where the selected card sits once it is back in the hand.
  /// Null keeps its original place.
  final int? placedIndex;

  final bool showLiftedCard;

  /// 1 is the medium card. 0.2 is the card settling on the image.
  final double liftedScale;

  /// Degrees, matching the Figma rotation.
  final double liftedRotation;

  /// Centers the clock and "Time's Up!" over a clear screen.
  final bool showTimesUp;

  final VoidCallback? onPause;
  final VoidCallback? onMore;

  /// Figma visual placeholder size 2x4: width 370 over height 185.
  static const double _wideAspect = 2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                const SDeckPromptdTopBar(
                  showRoundDetails: false,
                  showPause: false,
                  showRightIcon: false,
                ),
                _fade(
                  visible: showChrome,
                  child: SDeckPromptdTopBar(
                    round: round,
                    opposingPlayer: opposingPlayer,
                    rightIcon: SDeckIcons(
                      SDeckIcon.more,
                      size: SDeckSize.size36,
                      color: context.semantic.primary,
                    ),
                    onPausePressed: onPause,
                    onRightIconPressed: onMore,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  _fade(
                    visible: showPrompt,
                    child: _PromptReveal(prompt: prompt),
                  ),
                  _fade(
                    visible: showChoice,
                    child: _ChooseCard(
                      prompt: prompt,
                      showLiftedCard: showLiftedCard,
                      liftedScale: liftedScale,
                      liftedRotation: liftedRotation,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _fade(
                      visible: showChoice,
                      child: SDeckCardListSheet(
                        timerValue: timerValue,
                        timerType: timerType,
                        scrollFraction: scrollFraction,
                        cards: _sheetCards(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned.fill(
          child: _fade(visible: showTimesUp, child: const _TimesUp()),
        ),
      ],
    );
  }

  List<SDeckCardListEntry> _sheetCards() {
    final List<SDeckCardListEntry> source = SDeckCardListSheet.designCards;
    final List<int> order = <int>[for (var i = 0; i < source.length; i++) i];
    final int? held = selectedIndex;
    final int? slot = placedIndex;
    if (!showLiftedCard &&
        held != null &&
        slot != null &&
        slot != held &&
        slot >= 0 &&
        slot < order.length) {
      order.remove(held);
      order.insert(slot, held);
    }

    final List<SDeckCardListEntry> cards = [];
    for (final int i in order) {
      if (showLiftedCard && i == held) continue;
      final SDeckCardListEntry entry = source[i];
      cards.add(
        SDeckCardListEntry(
          imagePath: entry.imagePath,
          rotationDegrees: entry.rotationDegrees,
          scale: entry.scale,
          panX: entry.panX,
          panY: entry.panY,
          state:
              !showLiftedCard && i == held
                  ? SDeckPlayingCardState.selected
                  : SDeckPlayingCardState.default_,
        ),
      );
    }
    return cards;
  }
}

//--------------------------------- _TimesUp ---------------------------------//
class _TimesUp extends StatelessWidget {
  const _TimesUp();

  @override
  Widget build(BuildContext context) {
    final Color color = context.semantic.primary;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SDeckIcons(SDeckIcon.clock, size: SDeckSize.size108, color: color),
          const SizedBox(height: SDeckSpace.gap16),
          Text(
            'Time’s Up!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.h3.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

//------------------------------- _PromptReveal ------------------------------//
class _PromptReveal extends StatelessWidget {
  const _PromptReveal({required this.prompt});

  final String prompt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.margin16),
          child: SDeckSpeechBubble(
            text: prompt,
            size: SDeckSpeechBubbleSize.large,
          ),
        ),
        const AspectRatio(
          aspectRatio: SelectingCardPhaseView._wideAspect,
          child: SDeckVisualPlaceholder(),
        ),
      ],
    );
  }
}

//------------------------------- _ChooseCard --------------------------------//
class _ChooseCard extends StatelessWidget {
  const _ChooseCard({
    required this.prompt,
    required this.showLiftedCard,
    required this.liftedScale,
    required this.liftedRotation,
  });

  final String prompt;
  final bool showLiftedCard;
  final double liftedScale;
  final double liftedRotation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.margin16),
          child: SDeckSpeechBubble(text: prompt),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              const SDeckVisualPlaceholder(),
              _fade(
                visible: showLiftedCard,
                child: AnimatedScale(
                  scale: liftedScale,
                  duration: SDeckMotionDuration.normal,
                  curve: SDeckMotionCurve.easeIn,
                  child: AnimatedRotation(
                    turns: liftedRotation / 360,
                    duration: SDeckMotionDuration.normal,
                    curve: SDeckMotionCurve.easeIn,
                    child: const SDeckPlayingCard(
                      size: SDeckPlayingCardSize.medium,
                      state: SDeckPlayingCardState.selected,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _fade({required bool visible, required Widget child}) {
  return IgnorePointer(
    ignoring: !visible,
    child: AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: SDeckMotionDuration.normal,
      curve: SDeckMotionCurve.easeIn,
      child: child,
    ),
  );
}
