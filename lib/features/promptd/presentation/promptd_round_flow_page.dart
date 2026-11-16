import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

import '../domain/promptd_vote_models.dart';
import 'reveal/promptd_scenario_reveal_view.dart';
import 'voting/promptd_voting_phase_view.dart';
import 'results/promptd_results_phase_view.dart';

class PromptdRoundFlowPage extends StatefulWidget {
  const PromptdRoundFlowPage({
    super.key,
    required this.scenario,
    required this.results,
    this.currentPlayerId,
    this.votingDurationSeconds = 15,
    this.onVoteSelected,
    this.onRoundFinished,
  });

  final PromptdScenario scenario;
  final PromptdRoundResults results;
  final String? currentPlayerId;
  final int votingDurationSeconds;

  final ValueChanged<String>? onVoteSelected;
  final VoidCallback? onRoundFinished;

  @override
  State<PromptdRoundFlowPage> createState() =>
      _PromptdRoundFlowPageState();
}

class _PromptdRoundFlowPageState
    extends State<PromptdRoundFlowPage> {
  PromptdScreenPhase _phase =
      PromptdScreenPhase.votingIntroduction;

  PromptdRevealStage _revealStage =
      PromptdRevealStage.blank;

  String? _selectedSubmissionId;
  Timer? _timer;

  int _remainingSeconds = 15;
  bool _paused = false;
  bool _showScores = false;
  bool _showKillReveal = false;

  final Map<String, int> _revealedVoteCounts = {};

  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.votingDurationSeconds;
    _startSequence();
  }

  @override
  void didUpdateWidget(covariant PromptdRoundFlowPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.scenario.id != widget.scenario.id) {
      _generation++;
      _timer?.cancel();

      _phase = PromptdScreenPhase.votingIntroduction;
      _revealStage = PromptdRevealStage.blank;
      _selectedSubmissionId = null;
      _remainingSeconds = widget.votingDurationSeconds;
      _paused = false;
      _showScores = false;
      _showKillReveal = false;
      _revealedVoteCounts.clear();

      _startSequence();
    }
  }

  @override
  void dispose() {
    _generation++;
    _timer?.cancel();
    super.dispose();
  }

  Future<bool> _wait(
    Duration duration,
    int generation,
  ) async {
    var elapsed = Duration.zero;

    while (elapsed < duration) {
      if (!mounted || generation != _generation) {
        return false;
      }

      if (_paused) {
        await Future<void>.delayed(
          SDeckMotionDuration.quick,
        );
        continue;
      }

      final remaining = duration - elapsed;
      final step = remaining < SDeckMotionDuration.quick
          ? remaining
          : SDeckMotionDuration.quick;

      await Future<void>.delayed(step);
      elapsed += step;
    }

    return mounted && generation == _generation;
  }

  Future<void> _startSequence() async {
    final generation = ++_generation;

    if (!await _wait(
      SDeckMotionDuration.pause,
      generation,
    )) {
      return;
    }

    setState(() {
      _phase = PromptdScreenPhase.scenarioReveal;
    });

    final stages = [
      PromptdRevealStage.prompt,
      PromptdRevealStage.minimized,
      PromptdRevealStage.firstCard,
      PromptdRevealStage.transition,
      PromptdRevealStage.secondCard,
      PromptdRevealStage.finished,
    ];

    for (final stage in stages) {
      final duration = switch (stage) {
        PromptdRevealStage.prompt =>
          SDeckMotionDuration.read,
        PromptdRevealStage.minimized =>
          SDeckMotionDuration.slow,
        PromptdRevealStage.firstCard =>
          SDeckMotionDuration.slow,
        PromptdRevealStage.transition =>
          SDeckMotionDuration.pause,
        PromptdRevealStage.secondCard =>
          SDeckMotionDuration.slow,
        PromptdRevealStage.finished =>
          SDeckMotionDuration.pause,
        PromptdRevealStage.blank =>
          SDeckMotionDuration.normal,
      };

      if (!await _wait(duration, generation)) {
        return;
      }

      setState(() {
        _revealStage = stage;
      });
    }

    if (!await _wait(
      SDeckMotionDuration.normal,
      generation,
    )) {
      return;
    }

    setState(() {
      _phase = PromptdScreenPhase.voting;
    });

    _startVotingTimer(generation);
  }

  void _startVotingTimer(int generation) {
    _timer?.cancel();

    if (_remainingSeconds <= 0) {
      _finishVoting(generation);
      return;
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted || generation != _generation) {
          timer.cancel();
          return;
        }

        if (_paused) return;

        if (_remainingSeconds <= 1) {
          timer.cancel();
          _finishVoting(generation);
        } else {
          setState(() {
            _remainingSeconds--;
          });
        }
      },
    );
  }

  void _finishVoting(int generation) {
    if (!mounted || generation != _generation) return;

    setState(() {
      _remainingSeconds = 0;
      _phase = PromptdScreenPhase.revealingVotes;
      _revealedVoteCounts.clear();
    });

    _runVoteReveal(generation);
  }

  Future<void> _runVoteReveal(int generation) async {
    // Keep the supplied result data as the source of truth.
    // Each voter ID represents one marker to reveal.
    final voteOrder = <String>[];

    for (final entry in widget.results.entries) {
      for (final voterId in entry.voterIds) {
        voteOrder.add(entry.submissionId);
      }
    }

    // Allow the voting screen to settle before the reveal.
    if (!await _wait(
      SDeckMotionDuration.slow,
      generation,
    )) {
      return;
    }

    // Reveal one vote at a time.
    for (final submissionId in voteOrder) {
      if (!await _wait(
        SDeckMotionDuration.normal,
        generation,
      )) {
        return;
      }

      setState(() {
        _revealedVoteCounts[submissionId] =
            (_revealedVoteCounts[submissionId] ?? 0) + 1;
      });
    }

    // Hold the completed vote totals briefly.
    if (!await _wait(
      SDeckMotionDuration.pause,
      generation,
    )) {
      return;
    }

    setState(() {
      _phase = PromptdScreenPhase.results;
    });

    if (!await _wait(
      SDeckMotionDuration.slow,
      generation,
    )) {
      return;
    }

    setState(() {
      _showKillReveal = true;
    });

    if (!await _wait(
      SDeckMotionDuration.slow,
      generation,
    )) {
      return;
    }

    setState(() {
      _showScores = true;
    });
  }

  void _selectVote(String id) {
    if (_paused ||
        _phase != PromptdScreenPhase.voting) {
      return;
    }

    setState(() {
      _selectedSubmissionId = id;
    });

    widget.onVoteSelected?.call(id);
  }

  void _togglePause() {
    setState(() {
      _paused = !_paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = switch (_phase) {
      PromptdScreenPhase.votingIntroduction =>
        const _VotingIntroduction(),

      PromptdScreenPhase.scenarioReveal =>
        PromptdScenarioRevealView(
          scenario: widget.scenario,
          stage: _revealStage,
          onPause: _togglePause,
        ),

      PromptdScreenPhase.voting =>
        PromptdVotingPhaseView(
          scenario: widget.scenario,
          remainingSeconds: _remainingSeconds,
          selectedSubmissionId: _selectedSubmissionId,
          currentPlayerId: widget.currentPlayerId,
          votingLocked: _paused,
          onVoteSelected: _selectVote,
          onPause: _togglePause,
        ),

      PromptdScreenPhase.revealingVotes =>
        PromptdVotingPhaseView(
          scenario: widget.scenario,
          remainingSeconds: 0,
          selectedSubmissionId: _selectedSubmissionId,
          currentPlayerId: widget.currentPlayerId,
          votingLocked: true,
          revealVotes: true,
          voteCounts: _revealedVoteCounts,
          onPause: _togglePause,
        ),

      PromptdScreenPhase.results =>
        PromptdResultsPhaseView(
          scenario: widget.scenario,
          results: widget.results,
          showVoteMarkers: true,
          showFinalScores: _showScores,
          showKillReveal: _showKillReveal,
          onContinue: widget.onRoundFinished,
        ),
    };

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: SDeckMotionDuration.normal,
              switchInCurve: SDeckMotionCurve.easeInOut,
              switchOutCurve: SDeckMotionCurve.easeInOut,
              layoutBuilder: (
                currentChild,
                previousChildren,
              ) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ...previousChildren,
                    if (currentChild != null)
                      currentChild,
                  ],
                );
              },
              child: KeyedSubtree(
                key: ValueKey(_phase),
                child: content,
              ),
            ),
          ),

          if (_paused)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withValues(alpha: .45),
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Paused'),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _togglePause,
                            child: const Text('Resume'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _VotingIntroduction extends StatefulWidget {
  const _VotingIntroduction();

  @override
  State<_VotingIntroduction> createState() =>
      _VotingIntroductionState();
}

class _VotingIntroductionState
    extends State<_VotingIntroduction>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: SDeckMotionDuration.slow,
    );

    final curved = CurvedAnimation(
      parent: _controller,
      curve: SDeckMotionCurve.easeOut,
    );

    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curved);

    _scale = Tween<double>(
      begin: .94,
      end: 1,
    ).animate(curved);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.semantic.surface,
      child: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _opacity,
            child: ScaleTransition(
              scale: _scale,
              child: Text(
                'Voting Time!',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                      color: context.semantic.surface,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
