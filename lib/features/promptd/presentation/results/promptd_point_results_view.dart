/*----------------- promptd_point_results_view.dart -------------------*/
// Prompt'd round results. One stateless screen: the top bar, then one
// band per player. A featured band shows the card, the callout
// (Winner, Tie, Killed It, Eliminated), and the points won that round.
// A compact band is the current player when they are not already in a
// featured band. Points may be positive or negative. The game supplies
// the entries. Light and dark colors come from the theme swatches.
/*--------------------------------------------------------------------------*/

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

/// Band color. Plain uses the screen surface. The others are the point
/// distribution fills from the Prompt'd file.
enum PromptdPointTone {
  tangerine,
  vibrantYellow,
  mintGreen,
  skyBlue,
  lavender,
  brightCoral,
  coolGray,
  plain,
}

/// Featured bands fill the leftover height. Compact bands keep their
/// own height and sit wherever they are in [PromptdPointResultsView.entries].
enum PromptdPointLayout { featured, compact }

//------------------------------ PromptdPointEntry ---------------------------//
class PromptdPointEntry {
  const PromptdPointEntry({
    required this.playerName,
    required this.points,
    this.tone = PromptdPointTone.plain,
    this.layout = PromptdPointLayout.featured,
    this.cardOnLeft = true,
    this.announcement,
    this.photoUrl,
    this.cardImagePath,
  });

  final String playerName;

  /// Points won this round. Negative values render with a minus.
  final int points;
  final PromptdPointTone tone;
  final PromptdPointLayout layout;

  /// Featured bands only. True puts the card on the left.
  final bool cardOnLeft;

  /// Winner!, Tie!, Killed It!, Eliminated!, or none.
  final String? announcement;
  final String? photoUrl;
  final String? cardImagePath;
}

//-------------------------- PromptdPointResultsView -------------------------//
class PromptdPointResultsView extends StatelessWidget {
  const PromptdPointResultsView({
    super.key,
    required this.entries,
    this.round = 'Results',
    this.subtitle = 'Round 1',
    this.onPause,
    this.onMore,
  });

  final List<PromptdPointEntry> entries;
  final String round;
  final String subtitle;
  final VoidCallback? onPause;
  final VoidCallback? onMore;

  /// Figma column gap. No space token is 10.
  static const double _columnGap = 10;

  /// Card tilt on the point distribution container.
  static const double _cardTiltDegrees = -1.25;

  static const double _featuredAvatar = 108;
  static const double _compactAvatar = 64;

  /// Player column before it has to scale down: avatar, name, points.
  static const double _featuredContentHeight = 108 + 4 + 18 + 8 + 60;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.semantic.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SDeckPromptdTopBar(
            round: round,
            opposingPlayer: subtitle,
            rightIcon: SDeckIcons(
              SDeckIcon.more,
              size: SDeckSize.size36,
              color: context.semantic.primary,
            ),
            onPausePressed: onPause,
            onRightIconPressed: onMore,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final PromptdPointEntry entry in entries)
                  entry.layout == PromptdPointLayout.featured
                      ? Expanded(child: _featured(context, entry))
                      : _compact(context, entry),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featured(BuildContext context, PromptdPointEntry entry) {
    final _BandColors colors = _colors(context, entry.tone);
    return ColoredBox(
      color: colors.surface,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double innerWidth = math.max(
            0,
            constraints.maxWidth - SDeckSpace.padding16 * 2,
          );
          final double innerHeight = math.max(
            0,
            constraints.maxHeight - SDeckSpace.padding16 * 2,
          );
          final double columnWidth = math.max(0, (innerWidth - _columnGap) / 2);
          final double contentHeight = math.max(
            innerHeight,
            _featuredContentHeight,
          );
          final Widget card = _cardSide(context, entry, colors);
          final Widget player = _playerSide(
            context,
            entry,
            colors,
            avatarSize: _featuredAvatar,
          );
          return Padding(
            padding: const EdgeInsets.all(SDeckSpace.padding16),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: innerWidth,
                height: contentHeight,
                child: Row(
                  children: [
                    SizedBox(
                      width: columnWidth,
                      height: contentHeight,
                      child: entry.cardOnLeft ? card : player,
                    ),
                    const SizedBox(width: _columnGap),
                    SizedBox(
                      width: columnWidth,
                      height: contentHeight,
                      child: entry.cardOnLeft ? player : card,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _compact(BuildContext context, PromptdPointEntry entry) {
    final _BandColors colors = _colors(context, entry.tone);
    return ColoredBox(
      color: colors.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          SDeckSpace.padding16,
          SDeckSpace.padding16,
          SDeckSpace.padding16,
          SDeckSpace.padding48,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: _compactAvatar,
                    height: _compactAvatar,
                    child: _avatar(entry, _compactAvatar),
                  ),
                  const SizedBox(height: SDeckSpace.gap4),
                  Text(
                    entry.playerName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.caption.copyWith(color: colors.name),
                  ),
                ],
              ),
            ),
            Expanded(child: _points(context, entry, colors)),
          ],
        ),
      ),
    );
  }

  Widget _cardSide(
    BuildContext context,
    PromptdPointEntry entry,
    _BandColors colors,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (entry.announcement != null) ...[
          Text(
            entry.announcement!,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.h6.copyWith(color: colors.announcement),
          ),
          const SizedBox(height: SDeckSpace.gap4),
        ],
        Transform.rotate(
          angle: _cardTiltDegrees * math.pi / 180,
          child: SDeckPlayingCard(
            size: SDeckPlayingCardSize.small,
            shadow: SDeckPlayingCardShadow.medium,
            imagePath: entry.cardImagePath,
          ),
        ),
      ],
    );
  }

  Widget _playerSide(
    BuildContext context,
    PromptdPointEntry entry,
    _BandColors colors, {
    required double avatarSize,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: avatarSize,
          height: avatarSize,
          child: _avatar(entry, avatarSize),
        ),
        const SizedBox(height: SDeckSpace.gap4),
        Text(
          entry.playerName,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.caption.copyWith(color: colors.name),
        ),
        const SizedBox(height: SDeckSpace.gap8),
        _points(context, entry, colors),
      ],
    );
  }

  Widget _avatar(PromptdPointEntry entry, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: SDeckProfileCardPlaceholder(
        variant: SDeckProfileCardVariant.responsive,
        photoUrl: entry.photoUrl,
      ),
    );
  }

  Widget _points(
    BuildContext context,
    PromptdPointEntry entry,
    _BandColors colors,
  ) {
    final Color color =
        entry.points < 0 ? context.semantic.error : colors.points;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        entry.points > 0 ? '+${entry.points}' : '${entry.points}',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.h2.copyWith(color: color),
      ),
    );
  }
}

class _BandColors {
  const _BandColors({
    required this.surface,
    required this.announcement,
    required this.name,
    required this.points,
  });

  final Color surface;
  final Color announcement;
  final Color name;
  final Color points;
}

/// Dark fills are the 900 swatch, except eliminated, which is cool gray
/// 700. Light fills are the 100 swatch. Points and the callout stay on
/// the 500 swatch. Names are 300 in dark and 700 in light. The plain
/// band uses the screen surface, and a loss uses the error color.
_BandColors _colors(BuildContext context, PromptdPointTone tone) {
  // SDeckAppTheme keeps colors on the theme extensions and leaves
  // ThemeData.brightness at its default, so the surface token is the
  // light/dark switch.
  final bool dark =
      context.semantic.surface == SDeckSemanticColors.dark.surface;
  if (tone == PromptdPointTone.plain) {
    return _BandColors(
      surface: context.semantic.surface,
      announcement: context.semantic.primary,
      name:
          dark
              ? SDeckBaseColors.coolGray[300]!
              : SDeckBaseColors.coolGray[700]!,
      points:
          dark
              ? SDeckBaseColors.coolGray[100]!
              : SDeckBaseColors.coolGray[900]!,
    );
  }

  final MaterialColor swatch = switch (tone) {
    PromptdPointTone.tangerine => SDeckBaseColors.tangerine,
    PromptdPointTone.vibrantYellow => SDeckBaseColors.vibrantYellow,
    PromptdPointTone.mintGreen => SDeckBaseColors.mintGreen,
    PromptdPointTone.skyBlue => SDeckBaseColors.skyBlue,
    PromptdPointTone.lavender => SDeckBaseColors.lavender,
    PromptdPointTone.brightCoral => SDeckBaseColors.brightCoral,
    PromptdPointTone.coolGray => SDeckBaseColors.coolGray,
    PromptdPointTone.plain => SDeckBaseColors.coolGray,
  };
  final int surface =
      tone == PromptdPointTone.coolGray
          ? (dark ? 700 : 100)
          : (dark ? 900 : 100);
  return _BandColors(
    surface: swatch[surface]!,
    announcement: swatch[500]!,
    name: dark ? swatch[300]! : swatch[700]!,
    points: swatch[500]!,
  );
}
