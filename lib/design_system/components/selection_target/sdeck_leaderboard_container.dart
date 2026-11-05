/*--------------------- sdeck_leaderboard_container.dart --------------------*/
// One leaderboard row. The standing picks the fill and what sits on the right.
// Podium rows show a score. The tournament row shows the winning card.
// Plain rows have no fill. Light and dark colors come from the theme.
//
// The profile circle grows with the row, up to 108px, so fewer players make
// taller rows. The tournament photo stays 64px.
//
// Usage:
//   SDeckLeaderboardContainer(
//     standing: SDeckLeaderboardStanding.gold,
//     playerName: 'Player Name',
//     points: '220',
//   )
//   SDeckLeaderboardContainer(
//     standing: SDeckLeaderboardStanding.tournament,
//     playerName: 'Player Name',
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
import 'leaderboard_container_enums.dart';

//---------------------------- SDeckLeaderboardContainer ---------------------//
class SDeckLeaderboardContainer extends StatelessWidget {
  // Podium and plain circles stop growing at this size.
  static const double _maxAvatarSize = 108;

  // Tournament photo is fixed.
  static const double _tournamentAvatarSize = 64;

  // Figma tilts the winning card by this many degrees.
  static const double _cardTiltDegrees = -0.76;

  final SDeckLeaderboardStanding standing;
  final String playerName;

  /// Score on the right. Ignored for [SDeckLeaderboardStanding.tournament].
  final String points;

  /// Line under the name on the tournament row.
  final String description;

  /// Profile photo. Null shows the checkered placeholder.
  final String? photoUrl;
  final double scale;
  final double panX;
  final double panY;
  final double rotation;

  /// Photo inside the tournament card. Null shows the checkered placeholder.
  final String? cardImagePath;
  final double cardScale;
  final double cardPanX;
  final double cardPanY;

  const SDeckLeaderboardContainer({
    super.key,
    required this.standing,
    required this.playerName,
    this.points = '',
    this.description = 'Tournament Winner',
    this.photoUrl,
    this.scale = 1.0,
    this.panX = 0.0,
    this.panY = 0.0,
    this.rotation = 0.0,
    this.cardImagePath,
    this.cardScale = 1.0,
    this.cardPanX = 0.0,
    this.cardPanY = 0.0,
  });

  //*************************** Build *****************************************//
  @override
  Widget build(BuildContext context) {
    final colors = context.component;
    final bool tournament = standing == SDeckLeaderboardStanding.tournament;
    final bool plain = standing == SDeckLeaderboardStanding.plain;

    final Color surface = switch (standing) {
      SDeckLeaderboardStanding.gold => colors.leaderboardContainerSurfaceGold,
      SDeckLeaderboardStanding.silver =>
        colors.leaderboardContainerSurfaceSilver,
      SDeckLeaderboardStanding.bronze =>
        colors.leaderboardContainerSurfaceBronze,
      SDeckLeaderboardStanding.tournament =>
        colors.leaderboardContainerSurfaceTournament,
      SDeckLeaderboardStanding.plain => Colors.transparent,
    };
    final Color pointsColor = switch (standing) {
      SDeckLeaderboardStanding.gold => colors.leaderboardContainerPointsGold,
      SDeckLeaderboardStanding.silver =>
        colors.leaderboardContainerPointsSilver,
      SDeckLeaderboardStanding.bronze =>
        colors.leaderboardContainerPointsBronze,
      SDeckLeaderboardStanding.plain => colors.leaderboardContainerPointsPlain,
      SDeckLeaderboardStanding.tournament =>
        colors.leaderboardContainerDescriptionTournament,
    };

    final EdgeInsets padding =
        tournament
            ? const EdgeInsets.fromLTRB(
              SDeckSpace.padding16,
              SDeckSpace.padding16,
              SDeckSpace.padding16,
              SDeckSpace.padding48,
            )
            : plain
            ? const EdgeInsets.symmetric(
              horizontal: SDeckSpace.padding16,
              vertical: SDeckSpace.padding8,
            )
            : const EdgeInsets.all(SDeckSpace.padding16);

    return ColoredBox(
      color: surface,
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _player(context, tournament)),
            if (tournament) _card() else _score(context, pointsColor, plain),
          ],
        ),
      ),
    );
  }

  Widget _player(BuildContext context, bool tournament) {
    final TextStyle nameStyle = Theme.of(context).textTheme.caption.copyWith(
      color: context.component.leaderboardContainerPlayerName,
    );

    return Row(
      children: [
        tournament ? _tournamentAvatar() : _growingAvatar(),
        const SizedBox(width: SDeckSpace.gap8),
        Flexible(
          child:
              tournament
                  ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: nameStyle,
                      ),
                      const SizedBox(height: SDeckSpace.gap4),
                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.footer.copyWith(
                          color:
                              context
                                  .component
                                  .leaderboardContainerDescriptionTournament,
                        ),
                      ),
                    ],
                  )
                  : Text(
                    playerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: nameStyle,
                  ),
        ),
      ],
    );
  }

  /// Fills the row height up to 108px, and uses 108px when the row is not given a height.
  Widget _growingAvatar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double available = constraints.maxHeight;
        final double size =
            available.isFinite
                ? math.min(available, _maxAvatarSize)
                : _maxAvatarSize;
        return _avatar(size <= 0 ? _maxAvatarSize : size);
      },
    );
  }

  Widget _tournamentAvatar() => _avatar(_tournamentAvatarSize);

  Widget _avatar(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: SDeckProfileCardPlaceholder(
        variant: SDeckProfileCardVariant.responsive,
        photoUrl: photoUrl,
        scale: scale,
        panX: panX,
        panY: panY,
        rotation: rotation,
      ),
    );
  }

  Widget _score(BuildContext context, Color color, bool plain) {
    final TextStyle style =
        plain ? Theme.of(context).textTheme.h6 : Theme.of(context).textTheme.h2;
    return Text(
      points,
      textAlign: TextAlign.center,
      style: style.copyWith(color: color),
    );
  }

  Widget _card() {
    return Transform.rotate(
      angle: _cardTiltDegrees * math.pi / 180,
      child: SDeckPlayingCard(
        size: SDeckPlayingCardSize.extraSmall,
        shadow: SDeckPlayingCardShadow.medium,
        imagePath: cardImagePath,
        scale: cardScale,
        panX: cardPanX,
        panY: cardPanY,
      ),
    );
  }
}
