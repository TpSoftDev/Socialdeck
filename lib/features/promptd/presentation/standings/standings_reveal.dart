import 'dart:async';
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
import 'promptd_leaderboard_row.dart';
import 'standings_phase_view.dart';

// IA: Reuse Laura's reveal in normal game screens as well as Dev Tools.
// The caller supplies ranked results; this widget never calculates or saves scores.
// Use a ValueKey containing game ID and round ID to start a new round's reveal.
class StandingsReveal extends StatefulWidget {
  const StandingsReveal({
    super.key,
    required this.entries,
    this.round = 'Round 1',
    this.onPause,
    this.onMore,
  });

  final List<PromptdLeaderboardEntry> entries;
  final String round;
  // IA: These callbacks belong to the game controller, not the local animation.
  final VoidCallback? onPause;
  final VoidCallback? onMore;

  @override
  State<StandingsReveal> createState() => _StandingsRevealState();
}

class _LeaderboardFrame {
  const _LeaderboardFrame({
    required this.chrome,
    required this.placeholder,
    required this.bars,
    required this.content,
  });

  final bool chrome;
  final bool placeholder;
  final int bars;
  final int content;
}

class _StandingsRevealState extends State<StandingsReveal> {
  // Blank, top bar, placeholder, each podium color, each score, then the
  // plain rows. Matches the Leaderboard Prototype Extended strip.
  List<_LeaderboardFrame> get _frames => <_LeaderboardFrame>[
    _LeaderboardFrame(chrome: false, placeholder: false, bars: 0, content: 0),
    _LeaderboardFrame(chrome: true, placeholder: false, bars: 0, content: 0),
    _LeaderboardFrame(chrome: true, placeholder: true, bars: 0, content: 0),
    _LeaderboardFrame(chrome: true, placeholder: true, bars: 1, content: 0),
    _LeaderboardFrame(chrome: true, placeholder: true, bars: 2, content: 0),
    _LeaderboardFrame(
      chrome: true,
      placeholder: true,
      bars: widget.entries.length.clamp(0, 3),
      content: 0,
    ),
    _LeaderboardFrame(
      chrome: true,
      placeholder: true,
      bars: widget.entries.length.clamp(0, 3),
      content: 1,
    ),
    _LeaderboardFrame(
      chrome: true,
      placeholder: true,
      bars: widget.entries.length.clamp(0, 3),
      content: 2,
    ),
    _LeaderboardFrame(
      chrome: true,
      placeholder: true,
      bars: widget.entries.length.clamp(0, 3),
      content: 3,
    ),
    for (var i = 4; i <= widget.entries.length; i++)
      _LeaderboardFrame(chrome: true, placeholder: true, bars: i, content: i),
  ];

  int _step = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _schedule() {
    _timer?.cancel();
    _timer = Timer(SDeckMotionDuration.pause + SDeckMotionDuration.normal, () {
      if (!mounted) return;
      if (_step >= _frames.length - 1) return;
      setState(() => _step++);
      _schedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    final frame = _frames[_step.clamp(0, _frames.length - 1)];
    return StandingsPhaseView(
      entries: widget.entries,
      round: widget.round,
      showChrome: frame.chrome,
      showPlaceholder: frame.placeholder,
      revealedBars: frame.bars,
      revealedContent: frame.content,
      onPause: widget.onPause,
      onMore: widget.onMore,
    );
  }
}
