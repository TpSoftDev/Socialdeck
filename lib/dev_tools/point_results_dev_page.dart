/*---------------------- point_results_dev_page.dart --------------------*/
// Dev playback for the Prompt'd results screen. Each step is the same
// stateless view with different entries: a set, a tie, a kill, a loss,
// and the tournament winner.
/*--------------------------------------------------------------------------*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/promptd/presentation/results/promptd_point_results_view.dart';
import 'package:socialdeck/features/promptd/presentation/shell/promptd_fade_through.dart';

class PointResultsDevPage extends StatefulWidget {
  const PointResultsDevPage({super.key});

  @override
  State<PointResultsDevPage> createState() => _PointResultsDevPageState();
}

class _PointResultsDevPageState extends State<PointResultsDevPage> {
  int _step = 0;
  Timer? _timer;

  static const List<PromptdPointEntry> _set = <PromptdPointEntry>[
    PromptdPointEntry(
      playerName: 'Player Name',
      points: 120,
      tone: PromptdPointTone.vibrantYellow,
    ),
    PromptdPointEntry(
      playerName: 'Player Name',
      points: 40,
      tone: PromptdPointTone.lavender,
      cardOnLeft: false,
    ),
    PromptdPointEntry(
      playerName: 'You',
      points: 20,
      layout: PromptdPointLayout.compact,
    ),
  ];

  static const List<PromptdPointEntry> _tie = <PromptdPointEntry>[
    PromptdPointEntry(
      playerName: 'Player Name',
      points: 50,
      tone: PromptdPointTone.mintGreen,
      announcement: 'Tie!',
    ),
    PromptdPointEntry(
      playerName: 'Player Name',
      points: 50,
      tone: PromptdPointTone.skyBlue,
      cardOnLeft: false,
      announcement: 'Tie!',
    ),
    PromptdPointEntry(
      playerName: 'You',
      points: 10,
      layout: PromptdPointLayout.compact,
    ),
  ];

  static const List<PromptdPointEntry> _killedIt = <PromptdPointEntry>[
    PromptdPointEntry(
      playerName: 'Player Name',
      points: 150,
      tone: PromptdPointTone.brightCoral,
      announcement: 'Killed It!',
    ),
    PromptdPointEntry(
      playerName: 'Player Name',
      points: 20,
      tone: PromptdPointTone.tangerine,
      cardOnLeft: false,
    ),
    PromptdPointEntry(
      playerName: 'You',
      points: 20,
      layout: PromptdPointLayout.compact,
    ),
  ];

  static const List<PromptdPointEntry> _setLoss = <PromptdPointEntry>[
    PromptdPointEntry(
      playerName: 'Player Name',
      points: 115,
      tone: PromptdPointTone.skyBlue,
    ),
    PromptdPointEntry(
      playerName: 'Player Name',
      points: 40,
      tone: PromptdPointTone.vibrantYellow,
      cardOnLeft: false,
    ),
    PromptdPointEntry(
      playerName: 'You',
      points: -50,
      layout: PromptdPointLayout.compact,
    ),
  ];

  static const List<PromptdPointEntry> _tournament = <PromptdPointEntry>[
    PromptdPointEntry(
      playerName: 'Player Name',
      points: 230,
      tone: PromptdPointTone.tangerine,
      announcement: 'Winner!',
    ),
    PromptdPointEntry(
      playerName: 'Player Name',
      points: 80,
      tone: PromptdPointTone.coolGray,
      cardOnLeft: false,
      announcement: 'Eliminated!',
    ),
    PromptdPointEntry(
      playerName: 'You',
      points: 40,
      layout: PromptdPointLayout.compact,
    ),
  ];

  static const List<PromptdPointEntry> _tournamentLoss = <PromptdPointEntry>[
    PromptdPointEntry(
      playerName: 'Player Name',
      points: 230,
      tone: PromptdPointTone.tangerine,
      announcement: 'Winner!',
    ),
    PromptdPointEntry(
      playerName: 'Player Name',
      points: 80,
      tone: PromptdPointTone.coolGray,
      cardOnLeft: false,
      announcement: 'Eliminated!',
    ),
    PromptdPointEntry(
      playerName: 'You',
      points: -100,
      layout: PromptdPointLayout.compact,
    ),
  ];

  static const List<PromptdPointEntry> _youWon = <PromptdPointEntry>[
    PromptdPointEntry(
      playerName: 'You',
      points: 230,
      tone: PromptdPointTone.tangerine,
      announcement: 'Winner!',
    ),
    PromptdPointEntry(
      playerName: 'Player Name',
      points: 80,
      tone: PromptdPointTone.coolGray,
      cardOnLeft: false,
      announcement: 'Eliminated!',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _holdThenAdvance();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _holdThenAdvance() {
    _timer?.cancel();
    if (_step >= 6) return;
    _timer = Timer(SDeckMotionDuration.linger + SDeckMotionDuration.slower, () {
      if (!mounted || _step >= 6) return;
      setState(() => _step += 1);
      _holdThenAdvance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final (String subtitle, List<PromptdPointEntry> entries) = switch (_step) {
      0 => ('Set 2', _set),
      1 => ('Set 3', _tie),
      2 => ('Set 4', _killedIt),
      3 => ('Set 4', _setLoss),
      4 => ('Round 3 Tournament', _tournament),
      5 => ('Round 3 Tournament', _tournamentLoss),
      _ => ('Round 3 Tournament', _youWon),
    };
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: PromptdFadeThrough(
          step: _step,
          child: PromptdPointResultsView(subtitle: subtitle, entries: entries),
        ),
      ),
    );
  }
}
