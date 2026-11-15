/*--------------------- waiting_free_phase_view.dart ----------------------*/
// The wait after a free player places a card. Pieces fade with the
// design-system fade ([SDeckMotionDuration.normal],
// [SDeckMotionCurve.easeIn]):
//   a blank fade transition screen
//   an enlarged timer, the square image, and the remove-ads target
//   the same screen with the timer in alert
//   a blank fade transition screen
//   Time's Up
//
// Light and dark share this widget. The page fill is surface:
// #FDFBF5 in light, #101822 in dark. The round title, pause, and
// meatballs are primary. The opponent line is navigation supporting
// text. The timer, placeholder, and image target use their own fills.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//-------------------------- WaitingFreePhaseView ---------------------------//
class WaitingFreePhaseView extends StatelessWidget {
  const WaitingFreePhaseView({
    super.key,
    this.showChrome = false,
    this.showWait = false,
    this.round = 'Round 1',
    this.opposingPlayer = 'vs. tpsoftdev',
    this.timerValue = '11',
    this.timerType = SDeckTimerType.enlarged,
    this.adTitle = 'Remove Ads?',
    this.adDescription = 'Get Socialdeck+ for more!',
    this.showTimesUp = false,
    this.onPause,
    this.onMore,
    this.onRemoveAds,
  });

  /// False leaves the Prompt'd bar empty.
  final bool showChrome;

  /// False hides the timer, the square image, and the remove-ads target.
  final bool showWait;

  final String round;
  final String opposingPlayer;
  final String timerValue;
  final SDeckTimerType timerType;
  final String adTitle;
  final String adDescription;

  /// Centers the clock and "Time's Up!" over a clear screen.
  final bool showTimesUp;

  final VoidCallback? onPause;
  final VoidCallback? onMore;
  final VoidCallback? onRemoveAds;

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
              child: _fade(
                visible: showWait,
                child: Padding(
                  padding: const EdgeInsets.all(SDeckSpace.margin16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: SDeckTimer(value: timerValue, type: timerType),
                      ),
                      const SizedBox(height: SDeckSpace.gap16),
                      const AspectRatio(
                        aspectRatio: 1,
                        child: SDeckVisualPlaceholder(),
                      ),
                      const SizedBox(height: SDeckSpace.gap16),
                      SDeckImageTarget(
                        title: adTitle,
                        description: adDescription,
                        onTap: onRemoveAds,
                      ),
                    ],
                  ),
                ),
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
