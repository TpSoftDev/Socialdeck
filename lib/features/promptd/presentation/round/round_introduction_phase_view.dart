/*------------------- round_introduction_phase_view.dart -------------------*/
// Prompt'd round introduction. Rounds 1, 2, and 3 share this widget.
// The round title and instruction change. Rounds 1 and 2 end on the
// opponent's profile card. Round 3 ends on a second wide placeholder.
// Pieces fade with the design-system fade
// ([SDeckMotionDuration.normal], [SDeckMotionCurve.easeIn]):
//   a blank fade transition screen
//   the round title and the square placeholder
//   a blank fade transition screen
//   the wide placeholder, the opponent, and the profile card or a
//   second wide placeholder
//
// Light and dark share this widget. The page fill is surface:
// #FDFBF5 in light, #101822 in dark. The round title and the opponent
// name are primary: #1F1F1F in light, #F5F5F5 in dark. The instructions
// are secondary: #5E5E5E in light, #D9D9D9 in dark. The placeholders
// and the profile card use their own fills.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------- RoundIntroductionPhaseView -----------------------//
class RoundIntroductionPhaseView extends StatelessWidget {
  const RoundIntroductionPhaseView({
    super.key,
    this.showRound = false,
    this.showOpponent = false,
    this.roundTitle = 'Round 1',
    this.roundBody = 'You have 20 seconds to choose and place your card.',
    this.opponentLead = 'You are up against...',
    this.opponentName = 'tpsoftdev',
    this.showOpponentProfile = true,
    this.opponentPhotoUrl,
    this.opponentScale = 1,
    this.opponentPanX = 0,
    this.opponentPanY = 0,
    this.opponentRotation = 0,
  });

  /// False hides the round title, the instruction, and the square image.
  final bool showRound;

  /// False hides the wide image, the opponent line, and the profile card.
  final bool showOpponent;

  final String roundTitle;
  final String roundBody;
  final String opponentLead;

  /// Display name of the opponent. The game supplies this later.
  final String opponentName;

  /// False swaps the profile card for a second wide placeholder.
  final bool showOpponentProfile;

  /// Opponent profile photo. Null shows the checkered profile card.
  final String? opponentPhotoUrl;
  final double opponentScale;
  final double opponentPanX;
  final double opponentPanY;
  final double opponentRotation;

  /// Figma profileCardPlaceholder on this screen.
  static const double _avatarSize = 160;

  /// Figma visual placeholder size 2x4: width 370 over height 185.
  static const double _wideAspect = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SDeckPromptdTopBar(
          showRoundDetails: false,
          showPause: false,
          showRightIcon: false,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.gap16),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              _fade(
                visible: showRound,
                child: _RoundAnnouncement(title: roundTitle, body: roundBody),
              ),
              _fade(
                visible: showOpponent,
                child: _OpponentAnnouncement(
                  lead: opponentLead,
                  name: opponentName,
                  showProfile: showOpponentProfile,
                  photoUrl: opponentPhotoUrl,
                  scale: opponentScale,
                  panX: opponentPanX,
                  panY: opponentPanY,
                  rotation: opponentRotation,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//----------------------------- _RoundAnnouncement ---------------------------//
class _RoundAnnouncement extends StatelessWidget {
  const _RoundAnnouncement({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(SDeckSpace.padding16),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: text.h3.copyWith(color: context.semantic.primary),
              ),
              const SizedBox(height: SDeckSpace.gap16),
              Text(
                body,
                textAlign: TextAlign.center,
                style: text.body.copyWith(color: context.semantic.secondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: SDeckSpace.gap16),
        const AspectRatio(aspectRatio: 1, child: SDeckVisualPlaceholder()),
      ],
    );
  }
}

//---------------------------- _OpponentAnnouncement -------------------------//
class _OpponentAnnouncement extends StatelessWidget {
  const _OpponentAnnouncement({
    required this.lead,
    required this.name,
    required this.showProfile,
    required this.photoUrl,
    required this.scale,
    required this.panX,
    required this.panY,
    required this.rotation,
  });

  final String lead;
  final String name;
  final bool showProfile;
  final String? photoUrl;
  final double scale;
  final double panX;
  final double panY;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Column(
      children: [
        const AspectRatio(
          aspectRatio: RoundIntroductionPhaseView._wideAspect,
          child: SDeckVisualPlaceholder(),
        ),
        const SizedBox(height: SDeckSpace.gap16),
        Padding(
          padding: const EdgeInsets.all(SDeckSpace.padding16),
          child: Column(
            children: [
              Text(
                lead,
                textAlign: TextAlign.center,
                style: text.body.copyWith(color: context.semantic.secondary),
              ),
              const SizedBox(height: SDeckSpace.gap12),
              Text(
                name,
                textAlign: TextAlign.center,
                style: text.h4.copyWith(color: context.semantic.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: SDeckSpace.gap16),
        if (showProfile)
          SizedBox(
            width: RoundIntroductionPhaseView._avatarSize,
            child: SDeckProfileCardPlaceholder(
              variant: SDeckProfileCardVariant.responsive,
              photoUrl: photoUrl,
              scale: scale,
              panX: panX,
              panY: panY,
              rotation: rotation,
            ),
          )
        else
          const AspectRatio(
            aspectRatio: RoundIntroductionPhaseView._wideAspect,
            child: SDeckVisualPlaceholder(),
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
