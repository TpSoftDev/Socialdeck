/*--------------------- waiting_plus_phase_view.dart ----------------------*/
// The wait after a Socialdeck+ player places a card. Pieces fade with the
// design-system fade ([SDeckMotionDuration.normal],
// [SDeckMotionCurve.easeIn]):
//   an enlarged timer, the wide image, and the fun-button target
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

//-------------------------- WaitingPlusPhaseView ---------------------------//
class WaitingPlusPhaseView extends StatelessWidget {
  const WaitingPlusPhaseView({
    super.key,
    this.showChrome = false,
    this.showWait = false,
    this.round = 'Round 1',
    this.opposingPlayer = 'vs. tpsoftdev',
    this.timerValue = '11',
    this.timerType = SDeckTimerType.enlarged,
    this.funTitle = 'Fun Button',
    this.funDescription =
        'Surprise attack players with random noises.\n\n'
            'Thank you for supporting Socialdeck!',
    this.showTimesUp = false,
    this.onPause,
    this.onMore,
    this.onFunButton,
  });

  /// False leaves the Prompt'd bar empty.
  final bool showChrome;

  /// False hides the timer, the wide image, and the fun-button target.
  final bool showWait;

  final String round;
  final String opposingPlayer;
  final String timerValue;
  final SDeckTimerType timerType;
  final String funTitle;
  final String funDescription;

  /// Centers the clock and "Time's Up!" over a clear screen.
  final bool showTimesUp;

  final VoidCallback? onPause;
  final VoidCallback? onMore;
  final VoidCallback? onFunButton;

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
              child: _fade(
                visible: showWait,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    SDeckSpace.margin16,
                    SDeckSpace.margin16,
                    SDeckSpace.margin16,
                    SDeckSpace.margin48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: SDeckTimer(value: timerValue, type: timerType),
                      ),
                      const SizedBox(height: SDeckSpace.gap16),
                      const AspectRatio(
                        aspectRatio: _wideAspect,
                        child: SDeckVisualPlaceholder(),
                      ),
                      const SizedBox(height: SDeckSpace.gap16),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (
                            BuildContext context,
                            BoxConstraints constraints,
                          ) {
                            return SDeckImageTarget(
                              title: funTitle,
                              description: funDescription,
                              centerContent: true,
                              height: constraints.maxHeight,
                              onTap: onFunButton,
                            );
                          },
                        ),
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
