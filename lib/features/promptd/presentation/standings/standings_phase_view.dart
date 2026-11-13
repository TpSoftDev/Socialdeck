/*---------------------- standings_phase_view.dart ------------------------*/
// Prompt'd leaderboard. Stateless snapshot of one Figma frame.
// Pieces fade in with the design-system fade
// ([SDeckMotionDuration.normal], [SDeckMotionCurve.easeIn]):
// top bar, visual placeholder, podium colors, then each score.
// Hidden rows keep their slot so the board does not reflow.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

import 'promptd_leaderboard_row.dart';

//------------------------------- StandingsPhaseView --------------------------//
class StandingsPhaseView extends StatelessWidget {
  const StandingsPhaseView({
    super.key,
    required this.entries,
    this.round = 'Round 1',
    this.subtitle = 'Leaderboard',
    this.showChrome = true,
    this.showPlaceholder = true,
    this.revealedBars,
    this.revealedContent,
    this.onPause,
    this.onMore,
  });

  final List<PromptdLeaderboardEntry> entries;
  final String round;
  final String subtitle;

  /// False hides the round title, pause, and more icon.
  final bool showChrome;

  /// False hides the image above the rows.
  final bool showPlaceholder;

  /// How many standing colors from the top are on screen. Null shows every row.
  final int? revealedBars;

  /// How many rows show a player and score. Null shows every row.
  final int? revealedContent;

  final VoidCallback? onPause;
  final VoidCallback? onMore;

  bool _shown(int? count, int index) {
    if (count == null) return true;
    return index < count;
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.semantic.surface,
      child: Column(
        children: [
          AnimatedOpacity(
            opacity: showChrome ? 1 : 0,
            duration: SDeckMotionDuration.normal,
            curve: SDeckMotionCurve.easeIn,
            child: SDeckPromptdTopBar(
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
          ),
          Expanded(child: _board(context)),
        ],
      ),
    );
  }

  Widget _board(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SDeckSpace.margin48),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SDeckSpace.margin16,
            ),
            child: AnimatedOpacity(
              opacity: showPlaceholder ? 1 : 0,
              duration: SDeckMotionDuration.normal,
              curve: SDeckMotionCurve.easeIn,
              child: SDeckVisualPlaceholder(
                height: SDeckVisualPlaceholder.heightForGridRow(context),
              ),
            ),
          ),
          const SizedBox(height: SDeckSpace.gap16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < entries.length; i++)
                  Expanded(
                    child: PromptdLeaderboardRow(
                      entry: entries[i],
                      visible: _shown(revealedBars, i),
                      showContent: _shown(revealedContent, i),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
