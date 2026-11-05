/*-------------------------- sdeck_vote_target.dart ---------------------------*/
// Vote target for a tournament matchup band.
// One full-width row: a playing card in one column and a rank in the other.
// Light and dark colors come from the theme.
//
// Usage:
//   SDeckVoteTarget(
//     label: '#1',
//     color: SDeckVoteTargetColor.tangerine,
//     cardPosition: SDeckVoteTargetCardPosition.left,
//   )
/*--------------------------------------------------------------------------*/

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../themes/text_theme.dart';
import '../../tokens/index.dart';
import '../avatar/profile_card_enums.dart';
import '../avatar/sdeck_profile_card_placeholder.dart';
import '../cards/playing_card_enums.dart';
import '../cards/sdeck_playing_card.dart';
import 'vote_target_enums.dart';

//------------------------------- SDeckVoteTarget ----------------------------//
class SDeckVoteTarget extends StatelessWidget {
  // Figma tilts the playing card by this many degrees.
  static const double _cardTiltDegrees = -1.25;

  // Voter cluster: 64px circles, two per row, inside a 180px column.
  static const double _voterSize = 64;
  static const double _voterClusterWidth = 180;

  // One photo under a caption, as in the Selected and You frames.
  static const double _captionPhotoSize = 96;

  /// Rank shown in the open column, for example `#1`.
  /// Hidden when [voters] is not empty and [caption] is null.
  final String label;

  final SDeckVoteTargetColor color;
  final SDeckVoteTargetCardPosition cardPosition;

  /// Deeper band fill. The rank switches to the light swatch.
  final bool selected;

  /// Line under the rank, such as `Selected` or `You`.
  /// Keeps the rank visible and shows one 96px photo when [voters] is set.
  final String? caption;

  /// Voter photos. With no [caption], these replace the rank as 64px circles.
  final List<SDeckVoteTargetVoter> voters;

  /// Photo inside the playing card. Null shows the checkered placeholder.
  final String? imagePath;
  final double scale;
  final double panX;
  final double panY;

  const SDeckVoteTarget({
    super.key,
    required this.label,
    this.color = SDeckVoteTargetColor.tangerine,
    this.cardPosition = SDeckVoteTargetCardPosition.left,
    this.selected = false,
    this.caption,
    this.voters = const [],
    this.imagePath,
    this.scale = 1.0,
    this.panX = 0.0,
    this.panY = 0.0,
  });

  //*************************** Build *****************************************//
  @override
  Widget build(BuildContext context) {
    final Color surface = switch ((color, selected)) {
      (SDeckVoteTargetColor.tangerine, false) =>
        context.component.voteTargetSurfaceTangerine,
      (SDeckVoteTargetColor.tangerine, true) =>
        context.component.voteTargetSurfaceTangerineSelected,
      (SDeckVoteTargetColor.mintGreen, false) =>
        context.component.voteTargetSurfaceMintGreen,
      (SDeckVoteTargetColor.mintGreen, true) =>
        context.component.voteTargetSurfaceMintGreenSelected,
    };
    final Color titleColor = switch ((color, selected)) {
      (SDeckVoteTargetColor.tangerine, false) =>
        context.component.voteTargetTitleTangerine,
      (SDeckVoteTargetColor.tangerine, true) =>
        context.component.voteTargetTitleTangerineSelected,
      (SDeckVoteTargetColor.mintGreen, false) =>
        context.component.voteTargetTitleMintGreen,
      (SDeckVoteTargetColor.mintGreen, true) =>
        context.component.voteTargetTitleMintGreenSelected,
    };
    final Color descriptionColor = switch (color) {
      SDeckVoteTargetColor.tangerine =>
        context.component.voteTargetDescriptionTangerine,
      SDeckVoteTargetColor.mintGreen =>
        context.component.voteTargetDescriptionMintGreen,
    };
    final Color band = surface;

    final Widget card = Transform.rotate(
      angle: _cardTiltDegrees * math.pi / 180,
      child: SDeckPlayingCard(
        size: SDeckPlayingCardSize.medium,
        shadow: SDeckPlayingCardShadow.medium,
        imagePath: imagePath,
        scale: scale,
        panX: panX,
        panY: panY,
      ),
    );
    final Widget rank = Text(
      label,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.h1.copyWith(color: titleColor),
    );
    final Widget info = _info(context, rank, descriptionColor);

    final bool cardOnLeft = cardPosition == SDeckVoteTargetCardPosition.left;

    return ColoredBox(
      color: band,
      child: Padding(
        padding: const EdgeInsets.all(SDeckSpace.padding16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Center(child: cardOnLeft ? card : info)),
            const SizedBox(width: SDeckSpace.gap12),
            Expanded(child: Center(child: cardOnLeft ? info : card)),
          ],
        ),
      ),
    );
  }

  Widget _info(BuildContext context, Widget rank, Color descriptionColor) {
    if (caption == null) {
      return voters.isEmpty ? rank : _voterCluster();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        rank,
        Text(
          caption!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: descriptionColor,
          ),
        ),
        if (voters.isNotEmpty) ...[
          const SizedBox(height: SDeckSpace.gap16),
          SizedBox(
            width: _captionPhotoSize,
            height: _captionPhotoSize,
            child: _photo(voters.first),
          ),
        ],
      ],
    );
  }

  Widget _voterCluster() {
    return SizedBox(
      width: _voterClusterWidth,
      child: Wrap(
        spacing: SDeckSpace.gap8,
        runSpacing: SDeckSpace.gap8,
        alignment: WrapAlignment.center,
        children: [
          for (final voter in voters)
            SizedBox(
              width: _voterSize,
              height: _voterSize,
              child: _photo(voter),
            ),
        ],
      ),
    );
  }

  Widget _photo(SDeckVoteTargetVoter voter) {
    return SDeckProfileCardPlaceholder(
      variant: SDeckProfileCardVariant.responsive,
      photoUrl: voter.photoUrl,
      scale: voter.scale,
      panX: voter.panX,
      panY: voter.panY,
      rotation: voter.rotation,
    );
  }
}
