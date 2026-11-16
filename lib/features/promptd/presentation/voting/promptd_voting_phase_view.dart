import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

import '../../domain/promptd_vote_models.dart';
import 'widgets/promptd_submission_band.dart';

class PromptdVotingPhaseView extends StatelessWidget {
  const PromptdVotingPhaseView({
    super.key,
    required this.scenario,
    required this.remainingSeconds,
    this.selectedSubmissionId,
    this.voteCounts = const {},
    this.revealVotes = false,
    this.votingLocked = false,
    this.currentPlayerId,
    this.onVoteSelected,
    this.onPause,
    this.onMore,
  });

  final PromptdScenario scenario;
  final int remainingSeconds;
  final String? selectedSubmissionId;
  final Map<String, int> voteCounts;
  final bool revealVotes;
  final bool votingLocked;
  final String? currentPlayerId;

  final ValueChanged<String>? onVoteSelected;
  final VoidCallback? onPause;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.semantic.surface,
      child: SafeArea(
        child: Column(
          children: [
            SDeckPromptdTopBar(
              type: SDeckPromptdTopBarType.timer,
              timerValue: remainingSeconds.toString(),
              onPausePressed: onPause,
              onRightIconPressed: onMore,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: SDeckSpeechBubble(
                text: scenario.prompt,
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final count = scenario.submissions.length;

                  if (count == 0) {
                    return const SizedBox.shrink();
                  }

                  final bandHeight =
                      (constraints.maxHeight / count)
                          .clamp(170.0, 230.0)
                          .toDouble();

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: count,
                    itemBuilder: (context, index) {
                      final submission =
                          scenario.submissions[index];

                      final selected =
                          selectedSubmissionId == submission.id;

                      return PromptdSubmissionBand(
                        key: ValueKey(submission.id),
                        submission: submission,
                        selected: selected && !revealVotes,
                        isCurrentPlayer:
                            currentPlayerId != null &&
                            submission.playerId == currentPlayerId,
                        showRank: !revealVotes,
                        showVotes: revealVotes,
                        voteCount:
                            voteCounts[submission.id] ?? 0,
                        height: bandHeight,
                        onTap: votingLocked || revealVotes
                            ? null
                            : () => onVoteSelected?.call(
                                  submission.id,
                                ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}