/*---------------- universal_edge_cases_phase_view.dart ----------------*/
// Prompt'd overlays that can land on the prompt screen. Pieces fade with
// the design-system fade ([SDeckMotionDuration.normal],
// [SDeckMotionCurve.easeIn]):
//   a note that the game is paused, with play in the bar
//   an error that a player left
//   the options sheet over a scrim
//   a confirm dialog for leaving the game
//   a confirm dialog for leaving the party
//   an error that the host left, on a clear screen
//
// Light and dark share this widget. The page fill is surface:
// #FDFBF5 in light, #101822 in dark. The round title and meatballs are
// primary. The opponent line is navigation supporting text. The speech
// bubble, placeholder, toast, sheet, and dialog use their own fills.
// The scrim is #1F1F1F at 25% in both modes.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//----------------------- UniversalEdgeCasesPhaseView -----------------------//
class UniversalEdgeCasesPhaseView extends StatelessWidget {
  const UniversalEdgeCasesPhaseView({
    super.key,
    this.showChrome = false,
    this.showPrompt = false,
    this.showPlay = false,
    this.prompt = 'Oh man, I wish I could live this moment again.',
    this.round = 'Round 1',
    this.opposingPlayer = 'vs. tpsoftdev',
    this.showToast = false,
    this.toastStatus = SDeckToastStatus.note,
    this.toastTitle = '',
    this.toastDescription = '',
    this.showOptions = false,
    this.showLeaveGame = false,
    this.showLeaveParty = false,
    this.onPause,
    this.onMore,
  });

  /// False leaves the Prompt'd bar empty.
  final bool showChrome;

  /// False hides the large prompt and the wide image.
  final bool showPrompt;

  /// True draws play in the pause slot. The game is paused.
  final bool showPlay;

  final String prompt;
  final String round;
  final String opposingPlayer;

  final bool showToast;
  final SDeckToastStatus toastStatus;
  final String toastTitle;
  final String toastDescription;

  final bool showOptions;
  final bool showLeaveGame;
  final bool showLeaveParty;

  final VoidCallback? onPause;
  final VoidCallback? onMore;

  /// Figma visual placeholder size 2x4: width 370 over height 185.
  static const double _wideAspect = 2;

  bool get _showScrim => showOptions || showLeaveGame || showLeaveParty;

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
                    pauseIcon:
                        showPlay
                            ? SDeckIcons(
                              SDeckIcon.playHollow,
                              size: SDeckSize.size36,
                              color: context.semantic.primary,
                            )
                            : null,
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
                visible: showPrompt,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SDeckSpace.margin16,
                      ),
                      child: SDeckSpeechBubble(
                        text: prompt,
                        size: SDeckSpeechBubbleSize.large,
                      ),
                    ),
                    const AspectRatio(
                      aspectRatio: _wideAspect,
                      child: SDeckVisualPlaceholder(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned.fill(
          child: _fade(
            visible: _showScrim,
            child: ColoredBox(color: context.semantic.scrim),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _fade(
            visible: showOptions,
            child: SDeckBottomSheet(
              title: 'Options',
              onClosePressed: () {},
              buttons: [
                SDeckSolidButton(
                  text: 'Leave Game',
                  size: SDeckButtonSize.large,
                  fullWidth: true,
                  color: SDeckSolidButtonColor.brightCoral,
                  onPressed: () {},
                ),
                SDeckOutlineButton(
                  text: 'Leave Party',
                  size: SDeckButtonSize.large,
                  fullWidth: true,
                  color: SDeckOutlineButtonColor.brightCoral,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return _swap(
                child:
                    showLeaveGame || showLeaveParty
                        ? Padding(
                          key: ValueKey(showLeaveParty),
                          padding: const EdgeInsets.symmetric(
                            horizontal: SDeckSpace.margin32,
                          ),
                          child: Center(
                            child: SDeckDialog(
                              title: 'Wait!',
                              description:
                                  showLeaveParty
                                      ? 'Are you sure you want to leave the party? You would also leave the game.'
                                      : 'Are you sure you want to leave the game?',
                              showClose: false,
                              dialogWidth:
                                  constraints.maxWidth -
                                  SDeckSpace.margin32 * 2,
                              secondaryAction: SDeckOutlineButton(
                                text: 'Back',
                                size: SDeckButtonSize.medium,
                                onPressed: () {},
                              ),
                              primaryAction: SDeckSolidButton(
                                text: 'Leave',
                                size: SDeckButtonSize.medium,
                                color: SDeckSolidButtonColor.brightCoral,
                                onPressed: () {},
                              ),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(key: ValueKey('dialog-hidden')),
              );
            },
          ),
        ),
        Positioned(
          left: SDeckSpace.margin16,
          right: SDeckSpace.margin16,
          bottom: SDeckSpace.margin16,
          child: _swap(
            child:
                showToast
                    ? SDeckToast(
                      key: ValueKey(toastTitle),
                      status: toastStatus,
                      title: toastTitle,
                      description: toastDescription,
                    )
                    : const SizedBox.shrink(key: ValueKey('toast-hidden')),
          ),
        ),
      ],
    );
  }
}

Widget _swap({required Widget child}) {
  return AnimatedSwitcher(
    duration: SDeckMotionDuration.normal,
    switchInCurve: SDeckMotionCurve.easeIn,
    switchOutCurve: SDeckMotionCurve.easeIn,
    child: child,
  );
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
