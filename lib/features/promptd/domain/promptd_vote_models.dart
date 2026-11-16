import 'package:flutter/material.dart';

enum PromptdOutcome {
  winner,
  loser,
  tie,
  kill,
  doubleKill,
}

enum PromptdScreenPhase {
  votingIntroduction,
  scenarioReveal,
  voting,
  revealingVotes,
  results,
}

enum PromptdRevealStage {
  blank,
  prompt,
  minimized,
  firstCard,
  transition,
  secondCard,
  finished,
}

@immutable
class PromptdSubmission {
  const PromptdSubmission({
    required this.id,
    required this.rank,
    required this.color,
    this.imagePath,
    this.playerId,
    this.playerName,
  });

  final String id;
  final int rank;
  final Color color;
  final String? imagePath;
  final String? playerId;
  final String? playerName;
}

@immutable
class PromptdScenario {
  const PromptdScenario({
    required this.id,
    required this.prompt,
    required this.submissions,
    required this.roundNumber,
  });

  final String id;
  final String prompt;
  final List<PromptdSubmission> submissions;
  final int roundNumber;
}

@immutable
class PromptdVoteResult {
  const PromptdVoteResult({
    required this.submissionId,
    required this.voterIds,
    this.points = 0,
    this.outcome,
  });

  final String submissionId;
  final List<String> voterIds;
  final int points;
  final PromptdOutcome? outcome;

  int get voteCount => voterIds.length;
}

@immutable
class PromptdRoundResults {
  const PromptdRoundResults({
    required this.entries,
    required this.playerScoreChange,
    this.winningSubmissionIds = const [],
  });

  final List<PromptdVoteResult> entries;
  final List<String> winningSubmissionIds;
  final int playerScoreChange;

  PromptdVoteResult? forSubmission(String id) {
    for (final entry in entries) {
      if (entry.submissionId == id) {
        return entry;
      }
    }
    return null;
  }
}