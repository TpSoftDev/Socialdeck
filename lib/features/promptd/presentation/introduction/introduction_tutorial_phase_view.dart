/*----------------- introduction_tutorial_phase_view.dart ------------------*/
// Prompt'd introduction when the in-game tutorial is on.
// One widget covers the Figma strip. Pieces fade in and stay, using the
// design-system fade ([SDeckMotionDuration.normal], [SDeckMotionCurve.easeIn]):
//   the no-tutorial intro (blank, "Socialdeck presents...", sticker)
//   a blank beat
//   tutorial chrome, placeholder, countdown, and each script
//   scripts fade out between steps while the image and bar stay
//   a blank beat, then "Let's get prompting!" on a full bar
//
// Light and dark share this widget. The page fill is surface:
// #FDFBF5 in light, #101822 in dark. Titles are primary:
// #1F1F1F in light, #F5F5F5 in dark. Script lines are secondary:
// #5E5E5E in light, #D9D9D9 in dark. The countdown uses the progress
// bar's own colors. Skip uses the solid button, including its dark colors.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

import 'introduction_phase_view.dart';

//------------------------ IntroductionTutorialPhaseView ---------------------//
class IntroductionTutorialPhaseView extends StatelessWidget {
  const IntroductionTutorialPhaseView({
    super.key,
    this.presentsLabel = 'Socialdeck presents...',
    this.showPresents = false,
    this.showArtwork = false,
    this.tutorial = false,
    this.showChrome = false,
    this.showTutorial = false,
    this.showScript = false,
    this.title = '',
    this.body,
    this.remainingLabel = '',
    this.progress = 0,
    this.skipLabel = 'Skip #/5',
    this.onMore,
    this.onSkip,
  });

  final String presentsLabel;
  final bool showPresents;
  final bool showArtwork;

  /// True once the strip has left the intro frames.
  final bool tutorial;

  /// False hides the more icon and the Skip button.
  final bool showChrome;

  /// False hides the placeholder and the countdown.
  final bool showTutorial;

  /// False hides the title and body. The image and bar can stay.
  final bool showScript;

  final String title;
  final String? body;

  /// Countdown beside the bar, such as "40s". The game supplies this later.
  final String remainingLabel;

  /// Filled portion of the countdown track, from 0 to 1.
  final double progress;

  final String skipLabel;
  final VoidCallback? onMore;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            const SDeckPromptdTopBar(
              showRoundDetails: false,
              showPause: false,
              showRightIcon: false,
            ),
            _fade(
              visible: showChrome,
              ignoreWhenHidden: true,
              child: SDeckPromptdTopBar(
                type: SDeckPromptdTopBarType.tutorial,
                skipLabel: skipLabel,
                onSkipPressed: onSkip,
                onLeftIconPressed: onMore,
                leftIcon: SDeckIcons(
                  SDeckIcon.more,
                  size: SDeckSize.size36,
                  color: context.semantic.primary,
                ),
              ),
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: SDeckMotionDuration.normal,
          switchInCurve: SDeckMotionCurve.easeIn,
          switchOutCurve: SDeckMotionCurve.easeIn,
          layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
            return Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          child:
              tutorial
                  ? _TutorialBody(
                    key: const ValueKey<String>('tutorial'),
                    showTutorial: showTutorial,
                    showScript: showScript,
                    title: title,
                    body: body,
                    remainingLabel: remainingLabel,
                    progress: progress,
                  )
                  : IntroductionPhaseView(
                    key: const ValueKey<String>('intro'),
                    presentsLabel: presentsLabel,
                    showPresents: showPresents,
                    showArtwork: showArtwork,
                    showTopBar: false,
                  ),
        ),
      ],
    );
  }
}

//------------------------------- _TutorialBody ------------------------------//
class _TutorialBody extends StatelessWidget {
  const _TutorialBody({
    super.key,
    required this.showTutorial,
    required this.showScript,
    required this.title,
    required this.body,
    required this.remainingLabel,
    required this.progress,
  });

  final bool showTutorial;
  final bool showScript;
  final String title;
  final String? body;
  final String remainingLabel;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.gap16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _fade(
            visible: showTutorial,
            child: const AspectRatio(
              aspectRatio: 1,
              child: SDeckVisualPlaceholder(),
            ),
          ),
          const SizedBox(height: SDeckSpace.gap16),
          _fade(
            visible: showTutorial,
            child: SDeckProgressBar(
              value: progress,
              indicatorLabel: remainingLabel,
            ),
          ),
          const SizedBox(height: SDeckSpace.gap16),
          _fade(
            visible: showScript,
            child: Padding(
              padding: const EdgeInsets.all(SDeckSpace.padding16),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: text.h5.copyWith(color: context.semantic.primary),
                  ),
                  if (body != null) ...[
                    const SizedBox(height: SDeckSpace.gap16),
                    Text(
                      body!,
                      textAlign: TextAlign.center,
                      style: text.body.copyWith(
                        color: context.semantic.secondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _fade({
  required bool visible,
  required Widget child,
  bool ignoreWhenHidden = false,
}) {
  final Widget faded = AnimatedOpacity(
    opacity: visible ? 1 : 0,
    duration: SDeckMotionDuration.normal,
    curve: SDeckMotionCurve.easeIn,
    child: child,
  );
  if (!ignoreWhenHidden) return faded;
  return IgnorePointer(ignoring: !visible, child: faded);
}
