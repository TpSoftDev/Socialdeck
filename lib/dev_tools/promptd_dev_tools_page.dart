/*-------------------- promptd_dev_tools_page.dart -----------------------*/
// Nested Dev Tools page for Prompt'd game screens.
// Opened from Dev Tools via the "Prompt'd Dev" button.
/*--------------------------------------------------------------------------*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/promptd/presentation/standings/promptd_leaderboard_row.dart';
import 'package:socialdeck/features/promptd/presentation/standings/standings_phase_view.dart';

//------------------------------- PromptDevToolsPage ---------------------------//
class PromptDevToolsPage extends StatelessWidget {
  const PromptDevToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.page,
              right: SDeckTopBarRight.none,
              title: "Prompt'd Dev",
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SDeckSolidButton(
                      text: 'Leaderboards',
                      size: SDeckButtonSize.medium,
                      fullWidth: true,
                      onPressed:
                          () =>
                              context.push(AppPaths.leaderboardsTournamentDev),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//------------------------- LeaderboardsTournamentDevPage --------------------//
/// Plays the Figma leaderboard prototype. Each piece fades in and stays.
/// The fade is the design-system one: [SDeckMotionDuration.normal] on
/// [SDeckMotionCurve.easeIn], the same fade-in the Prompt'd routes use.
class LeaderboardsTournamentDevPage extends StatefulWidget {
  const LeaderboardsTournamentDevPage({super.key});

  @override
  State<LeaderboardsTournamentDevPage> createState() =>
      _LeaderboardsTournamentDevPageState();
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

class _LeaderboardsTournamentDevPageState
    extends State<LeaderboardsTournamentDevPage> {
  // Figma Round 1 board: 220, 185, 170, then the plain places.
  static const List<PromptdLeaderboardEntry> _entries =
      <PromptdLeaderboardEntry>[
        PromptdLeaderboardEntry(
          playerName: 'Player Name',
          points: '220',
          standing: SDeckLeaderboardStanding.gold,
        ),
        PromptdLeaderboardEntry(
          playerName: 'Player Name',
          points: '185',
          standing: SDeckLeaderboardStanding.silver,
        ),
        PromptdLeaderboardEntry(
          playerName: 'Player Name',
          points: '170',
          standing: SDeckLeaderboardStanding.bronze,
        ),
        PromptdLeaderboardEntry(
          playerName: 'Player Name',
          points: '140',
          standing: SDeckLeaderboardStanding.plain,
        ),
        PromptdLeaderboardEntry(
          playerName: 'Player Name',
          points: '100',
          standing: SDeckLeaderboardStanding.plain,
        ),
        PromptdLeaderboardEntry(
          playerName: 'Player Name',
          points: '90',
          standing: SDeckLeaderboardStanding.plain,
        ),
        PromptdLeaderboardEntry(
          playerName: 'Player Name',
          points: '80',
          standing: SDeckLeaderboardStanding.plain,
        ),
        PromptdLeaderboardEntry(
          playerName: 'Player Name',
          points: '70',
          standing: SDeckLeaderboardStanding.plain,
        ),
      ];

  // Blank, top bar, placeholder, each podium color, each score, then the
  // plain rows. Matches the Leaderboard Prototype Extended strip.
  static final List<_LeaderboardFrame> _frames = <_LeaderboardFrame>[
    const _LeaderboardFrame(
      chrome: false,
      placeholder: false,
      bars: 0,
      content: 0,
    ),
    const _LeaderboardFrame(
      chrome: true,
      placeholder: false,
      bars: 0,
      content: 0,
    ),
    const _LeaderboardFrame(
      chrome: true,
      placeholder: true,
      bars: 0,
      content: 0,
    ),
    const _LeaderboardFrame(
      chrome: true,
      placeholder: true,
      bars: 1,
      content: 0,
    ),
    const _LeaderboardFrame(
      chrome: true,
      placeholder: true,
      bars: 2,
      content: 0,
    ),
    const _LeaderboardFrame(
      chrome: true,
      placeholder: true,
      bars: 3,
      content: 0,
    ),
    const _LeaderboardFrame(
      chrome: true,
      placeholder: true,
      bars: 3,
      content: 1,
    ),
    const _LeaderboardFrame(
      chrome: true,
      placeholder: true,
      bars: 3,
      content: 2,
    ),
    const _LeaderboardFrame(
      chrome: true,
      placeholder: true,
      bars: 3,
      content: 3,
    ),
    for (var i = 4; i <= _entries.length; i++)
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
    final _LeaderboardFrame frame = _frames[_step];

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: StandingsPhaseView(
          entries: _entries,
          showChrome: frame.chrome,
          showPlaceholder: frame.placeholder,
          revealedBars: frame.bars,
          revealedContent: frame.content,
        ),
      ),
    );
  }
}
