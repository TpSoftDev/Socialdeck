/*--------------------- promptd_leaderboard_row.dart ----------------------*/
// One Prompt'd standings row. Composes SDeckLeaderboardContainer.
// Hidden rows stay in the layout so later rows do not reflow the board.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//---------------------------- PromptdLeaderboardEntry -----------------------//
/// One ranked player. Backend fills this; the row does not own game state.
class PromptdLeaderboardEntry {
  const PromptdLeaderboardEntry({
    required this.playerName,
    required this.points,
    required this.standing,
    this.photoUrl,
  });

  final String playerName;
  final String points;
  final SDeckLeaderboardStanding standing;
  final String? photoUrl;
}

//---------------------------- PromptdLeaderboardRow -------------------------//
class PromptdLeaderboardRow extends StatelessWidget {
  const PromptdLeaderboardRow({
    super.key,
    required this.entry,
    this.visible = true,
    this.showContent = true,
  });

  final PromptdLeaderboardEntry entry;

  /// False keeps the row's slot, with the standing color faded out.
  final bool visible;

  /// False shows the standing color only. The player and score fade in later.
  final bool showContent;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: SDeckMotionDuration.normal,
        curve: SDeckMotionCurve.easeIn,
        child: SDeckLeaderboardContainer(
          standing: entry.standing,
          playerName: entry.playerName,
          points: entry.points,
          photoUrl: entry.photoUrl,
          showContent: showContent,
        ),
      ),
    );
  }
}
