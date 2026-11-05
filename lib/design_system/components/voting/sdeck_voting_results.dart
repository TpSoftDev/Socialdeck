import 'package:flutter/material.dart';

import '../selection_target/sdeck_vote_target.dart';
import '../selection_target/vote_target_enums.dart';
import 'sdeck_voting_kill_reveal.dart';
import 'sdeck_voting_point_bar.dart';

/// Data for one visible matchup result.
/// Vote photos are supplied by the caller.
class SDeckVotingResultEntry {
  const SDeckVotingResultEntry({
    required this.rank,
    required this.color,
    this.cardPosition = SDeckVoteTargetCardPosition.left,
    this.cardImagePath,
    this.voters = const [],
    this.pointsAwarded,
    this.outcome,
    this.isCurrentPlayer = false,
    this.eliminated = false,
  });

  final String rank;
  final SDeckVoteTargetColor color;
  final SDeckVoteTargetCardPosition cardPosition;
  final String? cardImagePath;
  final List<SDeckVoteTargetVoter> voters;
  final int? pointsAwarded;
  final String? outcome;
  final bool isCurrentPlayer;

  /// Only use in tournament mode.
  /// Regular round losers are not eliminated.
  final bool eliminated;
}

/// Voting result composition for 2/3-way matches,
/// ties, kills and tournaments.
///
/// Results and score values are passed in
/// from the session/provider.
class SDeckVotingResults extends StatelessWidget {
  const SDeckVotingResults({
    super.key,
    required this.entries,
    required this.winnerIndex,
    required this.revealed,
    this.isTournament = false,
    this.doubleKill = false,
    this.currentPlayerScoreChange,
    this.currentPlayerPhoto,
    this.onFinished,
  }) : assert(entries.length >= 2),
       assert(winnerIndex >= 0 && winnerIndex < entries.length);

  final List<SDeckVotingResultEntry> entries;
  final int winnerIndex;
  final bool revealed;
  final bool isTournament;
  final bool doubleKill;
  final int? currentPlayerScoreChange;
  final Widget? currentPlayerPhoto;
  final VoidCallback? onFinished;

  @override
  Widget build(BuildContext context) {
    final slots = <Widget>[
      for (var i = 0; i < entries.length; i++) _slot(context, entries[i], i),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SDeckVotingKillReveal(
          options: slots,
          winnerIndex: winnerIndex,
          revealed: revealed,
          doubleKill: doubleKill,
        ),

        if (revealed && currentPlayerScoreChange != null)
          SDeckVotingPointBar(
            points: currentPlayerScoreChange!,
            photo: currentPlayerPhoto,
          ),

        if (revealed && onFinished != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: onFinished,
              child: const Text('Continue'),
            ),
          ),
      ],
    );
  }

  Widget _slot(BuildContext context, SDeckVotingResultEntry entry, int index) {
    final winner = index == winnerIndex;
    final eliminated = isTournament && entry.eliminated;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Stack(
      children: [
        SDeckVoteTarget(
          label: entry.rank,
          color: entry.color,
          cardPosition: entry.cardPosition,
          selected: revealed && winner,
          caption: !revealed ? (entry.isCurrentPlayer ? 'You' : null) : null,
          voters: revealed ? entry.voters : const [],
          imagePath: entry.cardImagePath,
        ),

        if (revealed &&
            (entry.pointsAwarded != null ||
                entry.outcome != null ||
                eliminated))
          Positioned(
            right: 12,
            bottom: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(.94),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (entry.outcome != null || eliminated)
                      Text(
                        eliminated ? 'Eliminated!' : entry.outcome!,
                        style: TextStyle(color: textColor, fontSize: 11),
                      ),

                    if (entry.pointsAwarded != null)
                      Text(
                        entry.pointsAwarded! > 0
                            ? '+${entry.pointsAwarded}'
                            : '${entry.pointsAwarded}',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
