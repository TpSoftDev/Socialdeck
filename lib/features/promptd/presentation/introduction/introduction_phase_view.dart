/*--------------------- introduction_phase_view.dart -----------------------*/
// Prompt'd introduction when the in-game tutorial is off.
// One widget covers the three Figma frames. Pieces fade in and stay,
// using the design-system fade ([SDeckMotionDuration.normal],
// [SDeckMotionCurve.easeIn]):
//   blank surface and an empty top bar
//   "Socialdeck presents..."
//   the Prompt'd sticker and the visual placeholder together
// Hidden pieces keep their slot so the line does not jump.
//
// Light and dark share this widget. The page fill is surface:
// #FDFBF5 in light, #101822 in dark. The presents line is secondary:
// #5E5E5E in light, #D9D9D9 in dark. The sticker is the existing asset.
// The placeholder uses its own surface fill.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//---------------------------- IntroductionPhaseView -------------------------//
class IntroductionPhaseView extends StatelessWidget {
  const IntroductionPhaseView({
    super.key,
    this.presentsLabel = 'Socialdeck presents...',
    this.showPresents = false,
    this.showArtwork = false,
    this.showTopBar = true,
  });

  final String presentsLabel;

  /// False hides "Socialdeck presents...".
  final bool showPresents;

  /// False hides the Prompt'd sticker and the square placeholder.
  /// They arrive together on the third frame.
  final bool showArtwork;

  /// False when a parent already draws the top bar.
  final bool showTopBar;

  /// Figma sticker frame: width 133.95 over height 48.
  static const double _stickerAspect = 133.9534912109375 / 48;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTopBar)
          const SDeckPromptdTopBar(
            showRoundDetails: false,
            showPause: false,
            showRightIcon: false,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.margin16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SDeckSpace.margin32,
                  vertical: SDeckSpace.margin16,
                ),
                child: Column(
                  children: [
                    _fade(
                      visible: showPresents,
                      child: Text(
                        presentsLabel,
                        textAlign: TextAlign.center,
                        style: text.bodySmallFigma.copyWith(
                          color: context.semantic.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: SDeckSpace.gap24),
                    _fade(
                      visible: showArtwork,
                      child: const AspectRatio(
                        aspectRatio: _stickerAspect,
                        child: Image(
                          image: AssetImage(SDeckIcon.promptdSticker),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SDeckSpace.gap16),
              _fade(
                visible: showArtwork,
                child: const AspectRatio(
                  aspectRatio: 1,
                  child: SDeckVisualPlaceholder(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fade({required bool visible, required Widget child}) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: SDeckMotionDuration.normal,
      curve: SDeckMotionCurve.easeIn,
      child: child,
    );
  }
}
