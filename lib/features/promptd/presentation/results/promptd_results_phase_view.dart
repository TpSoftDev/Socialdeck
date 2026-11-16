import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

import '../../domain/promptd_vote_models.dart';
import '../voting/widgets/promptd_submission_band.dart';

class PromptdResultsPhaseView extends StatelessWidget {
  const PromptdResultsPhaseView({
    super.key,
    required this.scenario,
    required this.results,
    this.showVoteMarkers = true,
    this.showFinalScores = true,
    this.showKillReveal = false,
    this.onContinue,
  });

  final PromptdScenario scenario;
  final PromptdRoundResults results;
  final bool showVoteMarkers;
  final bool showFinalScores;
  final bool showKillReveal;
  final VoidCallback? onContinue;

  PromptdOutcome? get _specialOutcome {
    for (final result in results.entries) {
      if (result.outcome == PromptdOutcome.doubleKill) {
        return PromptdOutcome.doubleKill;
      }
      if (result.outcome == PromptdOutcome.kill) {
        return PromptdOutcome.kill;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final special = _specialOutcome;

    final winnerIndex = scenario.submissions.indexWhere(
      (submission) =>
          results.winningSubmissionIds.contains(submission.id),
    );

    final slots = [
      for (final submission in scenario.submissions)
        _buildResultSlot(context, submission),
    ];

    final canAnimateKill =
        special != null &&
        winnerIndex >= 0 &&
        slots.length >= 2;

    return ColoredBox(
      color: context.semantic.surface,
      child: SafeArea(
        child: Column(
          children: [
            SDeckPromptdTopBar(
              round: 'Results',
              opposingPlayer: 'Round ${scenario.roundNumber}',
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SDeckSpeechBubble(
                text: scenario.prompt,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: canAnimateKill
                    ? SDeckVotingKillReveal(
                        options: slots,
                        winnerIndex: winnerIndex,
                        revealed: showKillReveal,
                        doubleKill:
                            special == PromptdOutcome.doubleKill,
                        duration: SDeckMotionDuration.slow,
                      )
                    : Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: slots,
                      ),
              ),
            ),

            _AnimatedResultsFooter(
              visible: showFinalScores,
              points: results.playerScoreChange,
              onContinue: onContinue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSlot(
    BuildContext context,
    PromptdSubmission submission,
  ) {
    final result = results.forSubmission(submission.id);

    final isWinner = results.winningSubmissionIds.contains(
      submission.id,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PromptdSubmissionBand(
          submission: submission,
          selected: isWinner,
          showRank: false,
          showVotes: showVoteMarkers,
          voteCount: result?.voteCount ?? 0,
        ),

        if (result != null)
          _AnimatedResultCaption(
            visible: showFinalScores,
            outcome: result.outcome,
            points: result.points,
          ),
      ],
    );
  }
}

class _AnimatedResultCaption extends StatelessWidget {
  const _AnimatedResultCaption({
    required this.visible,
    required this.outcome,
    required this.points,
  });

  final bool visible;
  final PromptdOutcome? outcome;
  final int points;

  String get title {
    return switch (outcome) {
      PromptdOutcome.winner => 'Winner!',
      PromptdOutcome.loser => 'Loser',
      PromptdOutcome.tie => 'Tie!',
      PromptdOutcome.kill => 'Killed It!',
      PromptdOutcome.doubleKill => 'Double Kill!',
      null => 'Result',
    };
  }

  IconData get outcomeIcon {
    return switch (outcome) {
      PromptdOutcome.winner => Icons.emoji_events_rounded,
      PromptdOutcome.loser => Icons.close_rounded,
      PromptdOutcome.tie => Icons.handshake_rounded,
      PromptdOutcome.kill => Icons.local_fire_department_rounded,
      PromptdOutcome.doubleKill =>
        Icons.local_fire_department_rounded,
      null => Icons.stars_rounded,
    };
  }

  Color _outcomeColor(ColorScheme scheme) {
    return switch (outcome) {
      PromptdOutcome.winner => scheme.primary,
      PromptdOutcome.loser => scheme.onSurfaceVariant,
      PromptdOutcome.tie => scheme.tertiary,
      PromptdOutcome.kill => scheme.error,
      PromptdOutcome.doubleKill => scheme.error,
      null => scheme.onSurface,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _outcomeColor(theme.colorScheme);

    return ClipRect(
      child: AnimatedSize(
        duration: SDeckMotionDuration.slow,
        curve: SDeckMotionCurve.easeInOut,
        alignment: Alignment.topCenter,
        child: visible
            ? TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: SDeckMotionDuration.slow,
                curve: SDeckMotionCurve.easeOut,
                builder: (context, progress, child) {
                  return Opacity(
                    opacity: progress,
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        12 * (1 - progress),
                      ),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  color:
                      theme.colorScheme.surfaceContainerLow,
                  child: Row(
                    children: [
                      Icon(
                        outcomeIcon,
                        color: color,
                        size: 24,
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          title,
                          style:
                              theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),

                      TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: 0,
                          end: points.toDouble(),
                        ),
                        duration: SDeckMotionDuration.slow,
                        curve: SDeckMotionCurve.easeOut,
                        builder: (context, value, child) {
                          final displayed = value.round();

                          return Text(
                            displayed > 0
                                ? '+$displayed'
                                : '$displayed',
                            style:
                                theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: points < 0
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurface,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _AnimatedResultsFooter extends StatelessWidget {
  const _AnimatedResultsFooter({
    required this.visible,
    required this.points,
    required this.onContinue,
  });

  final bool visible;
  final int points;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedSize(
        duration: SDeckMotionDuration.slow,
        curve: SDeckMotionCurve.easeInOut,
        alignment: Alignment.bottomCenter,
        child: visible
            ? TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: SDeckMotionDuration.slow,
                curve: SDeckMotionCurve.easeOut,
                builder: (context, progress, child) {
                  return Opacity(
                    opacity: progress,
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        20 * (1 - progress),
                      ),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SDeckVotingPointBar(
                      points: points,
                    ),

                    if (onContinue != null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: onContinue,
                            child: const Text('Continue'),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}