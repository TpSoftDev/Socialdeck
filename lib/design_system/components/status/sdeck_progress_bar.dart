/*------------------------ sdeck_progress_bar.dart -------------------------*/
// Figma progessBar. An 8px track inside a 16px row.
//   default_   — track only
//   fraction   — track plus a current/total label
//   percentage — track plus a percent label
//
// Light: track #EBEBEB, fill and label #5E5E5E.
// Semantic Dark keeps the fill and label at #C4C4C4 and the track at #1F1F1F.
// Those steps differ from semantic.tertiary and semantic.secondary.
//
// Usage:
//   SDeckProgressBar(value: 0.5)
//   SDeckProgressBar(type: SDeckProgressBarType.fraction, current: 1, total: 4)
//   SDeckProgressBar(type: SDeckProgressBarType.percentage, value: 0.25)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../tokens/index.dart';

//======================== SDeckProgressBarType ==============================//
enum SDeckProgressBarType { default_, fraction, percentage }

//======================== SDeckProgressBar ==================================//
class SDeckProgressBar extends StatelessWidget {
  final SDeckProgressBarType type;

  /// Filled portion of the track, from 0 to 1.
  /// Ignored when [type] is [SDeckProgressBarType.fraction].
  final double value;

  /// Numerator shown by [SDeckProgressBarType.fraction].
  final int current;

  /// Denominator shown by [SDeckProgressBarType.fraction].
  final int total;

  const SDeckProgressBar({
    super.key,
    this.type = SDeckProgressBarType.default_,
    this.value = 0,
    this.current = 0,
    this.total = 0,
  });

  double get _progress {
    if (type == SDeckProgressBarType.fraction) {
      if (total <= 0) return 0;
      return (current / total).clamp(0, 1).toDouble();
    }
    return value.clamp(0, 1).toDouble();
  }

  String get _label {
    return switch (type) {
      SDeckProgressBarType.fraction => '$current/$total',
      SDeckProgressBarType.percentage => '${(_progress * 100).round()}%',
      SDeckProgressBarType.default_ => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final Widget track = _ProgressTrack(progress: _progress);
    return SizedBox(
      height: SDeckSize.size16,
      child: switch (type) {
        SDeckProgressBarType.default_ => Align(
          alignment: Alignment.centerLeft,
          child: track,
        ),
        SDeckProgressBarType.fraction || SDeckProgressBarType.percentage => Row(
          children: [
            Expanded(child: track),
            const SizedBox(width: SDeckSpace.gap8),
            Text(_label, style: _labelStyle(context)),
          ],
        ),
      },
    );
  }

  TextStyle _labelStyle(BuildContext context) {
    final TextStyle base =
        Theme.of(context).textTheme.labelSmall ?? const TextStyle();
    return base.copyWith(
      fontSize: SDeckFontSizes.labelSmall,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.labelSmall / SDeckFontSizes.labelSmall,
      color: _indicatorColor(context),
    );
  }
}

class _ProgressTrack extends StatelessWidget {
  final double progress;

  const _ProgressTrack({required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double fillWidth = constraints.maxWidth * progress;
        return Container(
          width: constraints.maxWidth,
          height: SDeckSize.size8,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: _trackColor(context),
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius4),
          ),
          child:
              fillWidth <= 0
                  ? null
                  : Container(
                    width: fillWidth,
                    decoration: BoxDecoration(
                      color: _indicatorColor(context),
                      borderRadius: BorderRadius.circular(
                        SDeckRadius.borderRadius4,
                      ),
                    ),
                  ),
        );
      },
    );
  }
}

/// progressBarTrack. Light #EBEBEB, Semantic Dark #1F1F1F.
Color _trackColor(BuildContext context) {
  final bool dark = Theme.of(context).brightness == Brightness.dark;
  return dark ? SDeckBaseColors.coolGray[900]! : SDeckBaseColors.coolGray[100]!;
}

/// progressBarFill and progressBarIndicatorText.
/// Light #5E5E5E, Semantic Dark #C4C4C4.
Color _indicatorColor(BuildContext context) {
  final bool dark = Theme.of(context).brightness == Brightness.dark;
  return dark ? SDeckBaseColors.coolGray[300]! : SDeckBaseColors.coolGray[700]!;
}
