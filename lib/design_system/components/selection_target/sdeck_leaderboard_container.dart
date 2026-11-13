/*--------------------- sdeck_leaderboard_container.dart --------------------*/
// One leaderboard row. The standing picks the fill and what sits on the right.
// Podium rows show a score. The tournament row shows the winning card.
// Plain rows have no fill. Light and dark colors come from the theme.
//
// The profile circle grows with the row, up to 108px, so fewer players make
// taller rows. The score stays at its type size, then scales down when the
// row is shorter than that type, so the board fits any phone. The tournament
// photo stays 64px.
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

  /// False paints only the standing color. The player and score fade in
  /// with [SDeckMotionDuration.normal] and [SDeckMotionCurve.easeIn],
  /// the same fade the Prompt'd screens use.
  final bool showContent;

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
    this.showContent = true,
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _row(context, constraints.maxHeight);
      },
    );
  }

  Widget _row(BuildContext context, double height) {
    final colors = context.component;
    final bool tournament = standing == SDeckLeaderboardStanding.tournament;
    final bool plain = standing == SDeckLeaderboardStanding.plain;
    final bool bounded = height.isFinite;

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

    return ColoredBox(
      color: surface,
      child: Padding(
        padding: _padding(height, plain, tournament),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _reveal(_player(context, tournament, bounded))),
            _reveal(
              tournament
                  ? _fit(_card(), bounded, Alignment.centerRight)
                  : _score(context, pointsColor, plain, bounded),
            ),
          ],
        ),
      ),
    );
  }

  /// Fades the player and score. The standing color stays put.
  Widget _reveal(Widget child) {
    return AnimatedOpacity(
      opacity: showContent ? 1 : 0,
      duration: SDeckMotionDuration.normal,
      curve: SDeckMotionCurve.easeIn,
      child: child,
    );
  }

  /// Design padding when the row is tall enough for the score. On a shorter
  /// phone the padding gives way first so the score can stay readable.
  EdgeInsets _padding(double height, bool plain, bool tournament) {
    const double horizontal = SDeckSpace.padding16;
    final double designV = plain ? SDeckSpace.padding8 : SDeckSpace.padding16;
    final double scoreBlock = plain ? 24 : 48;

    if (!height.isFinite || height >= scoreBlock + (designV * 2)) {
      if (tournament) {
        return const EdgeInsets.fromLTRB(
          horizontal,
          SDeckSpace.padding16,
          horizontal,
          SDeckSpace.padding48,
        );
      }
      return EdgeInsets.symmetric(horizontal: horizontal, vertical: designV);
    }

    final double vertical = math.max(0, (height - scoreBlock) / 2);
    if (!tournament) {
      return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
    }

    final double bottom = math.min(SDeckSpace.padding48, vertical);
    return EdgeInsets.fromLTRB(horizontal, vertical, horizontal, bottom);
  }

  Widget _player(BuildContext context, bool tournament, bool bounded) {
    final TextStyle nameStyle = Theme.of(context).textTheme.caption.copyWith(
      color: context.component.leaderboardContainerPlayerName,
    );

    final Widget name =
        tournament
            ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playerName,
                  maxLines: 1,
                  style: nameStyle.copyWith(height: 1),
                ),
                const SizedBox(height: SDeckSpace.gap4),
                Text(
                  description,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.footer.copyWith(
                    height: 1,
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
              style: nameStyle.copyWith(height: 1),
            );

    return Row(
      children: [
        tournament ? _tournamentAvatar() : _growingAvatar(),
        const SizedBox(width: SDeckSpace.gap8),
        Flexible(child: _fit(name, bounded, Alignment.centerLeft)),
      ],
    );
  }

  /// Fills the row height up to 108px, and uses 108px when the row is not given a height.
  Widget _growingAvatar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double available = constraints.maxHeight;
        final double size =
            !available.isFinite
                ? _maxAvatarSize
                : math.min(math.max(available, 0), _maxAvatarSize);
        if (size <= 0) return const SizedBox.shrink();
        return _avatar(size);
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

  Widget _score(BuildContext context, Color color, bool plain, bool bounded) {
    final TextStyle style =
        plain ? Theme.of(context).textTheme.h6 : Theme.of(context).textTheme.h2;
    return _fit(
      Text(
        points,
        textAlign: TextAlign.center,
        style: style.copyWith(color: color, height: 1),
      ),
      bounded,
      Alignment.centerRight,
    );
  }

  /// Keeps the design size, and scales down only when the row is too short.
  Widget _fit(Widget child, bool bounded, Alignment alignment) {
    if (!bounded) return child;
    return FittedBox(fit: BoxFit.scaleDown, alignment: alignment, child: child);
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
