/*-------------------- promptd_dev_tools_page.dart -----------------------*/
// Nested Dev Tools page for Prompt'd game screens.
// Opened from Dev Tools via the "Prompt'd Dev" button.
/*--------------------------------------------------------------------------*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/promptd/presentation/introduction/introduction_phase_view.dart';
import 'package:socialdeck/features/promptd/presentation/introduction/introduction_tutorial_phase_view.dart';
import 'package:socialdeck/features/promptd/presentation/ready/ready_phase_view.dart';
import 'package:socialdeck/features/promptd/presentation/round/round_introduction_phase_view.dart';
import 'package:socialdeck/features/promptd/presentation/round/selecting_card_phase_view.dart';
import 'package:socialdeck/features/promptd/presentation/round/universal_edge_cases_phase_view.dart';
import 'package:socialdeck/features/promptd/presentation/round/waiting_free_phase_view.dart';
import 'package:socialdeck/features/promptd/presentation/round/waiting_plus_phase_view.dart';
import 'package:socialdeck/features/promptd/presentation/standings/promptd_leaderboard_row.dart';
import 'package:socialdeck/features/promptd/domain/promptd_standing.dart';
import 'package:socialdeck/features/promptd/presentation/standings/standings_mapper.dart';
import 'package:socialdeck/features/promptd/presentation/standings/standings_reveal.dart';
import 'package:socialdeck/features/promptd/presentation/announcement/promptd_announcement_view.dart';
import 'package:socialdeck/features/promptd/presentation/conclusion/promptd_conclusion_view.dart';
import 'package:socialdeck/features/promptd/presentation/shell/promptd_fade_through.dart';

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
                      onPressed:
                          () =>
                              context.push(AppPaths.leaderboardsTournamentDev),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: 'Results',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push(AppPaths.pointResultsDev),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: "I'm Ready",
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push(AppPaths.readyPhaseDev),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: 'Introduction',
                      size: SDeckButtonSize.medium,
                      onPressed:
                          () => context.push(AppPaths.introductionPhaseDev),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: 'Introduction & Tutorial',
                      size: SDeckButtonSize.medium,
                      onPressed:
                          () => context.push(
                            AppPaths.introductionTutorialPhaseDev,
                          ),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: 'Round 1',
                      size: SDeckButtonSize.medium,
                      onPressed:
                          () => context.push(AppPaths.roundIntroductionDev),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: 'Round 2',
                      size: SDeckButtonSize.medium,
                      onPressed:
                          () => context.push(AppPaths.round2IntroductionDev),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: 'Round 3',
                      size: SDeckButtonSize.medium,
                      onPressed:
                          () => context.push(AppPaths.round3IntroductionDev),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: 'Selecting Card',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push(AppPaths.selectingCardDev),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: 'Put Card Back',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push(AppPaths.putCardBackDev),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: 'Run Out of Time',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push(AppPaths.runOutOfTimeDev),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: 'Universal Edge Cases',
                      size: SDeckButtonSize.medium,
                      onPressed:
                          () => context.push(AppPaths.universalEdgeCasesDev),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: 'Waiting Free',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push(AppPaths.waitingFreeDev),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: 'Waiting Plus',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push(AppPaths.waitingPlusDev),
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

//------------------------------- ReadyPhaseDevPage ---------------------------//
class ReadyPhaseDevPage extends StatelessWidget {
  const ReadyPhaseDevPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: ReadyPhaseView(
          // Stand-in until the game reports who has readied up.
          readyCount: 4,
          playerCount: 5,
          onButtonPressed: () {},
        ),
      ),
    );
  }
}

//-------------------------- RoundIntroductionDevPage ------------------------//
/// Plays a round introduction. The round fades in, fades out, then the
/// opponent fades in. The fade is [SDeckMotionDuration.normal] on
/// [SDeckMotionCurve.easeIn].
class RoundIntroductionDevPage extends StatefulWidget {
  const RoundIntroductionDevPage({
    super.key,
    this.roundTitle = 'Round 1',
    this.roundBody = 'You have 20 seconds to choose and place your card.',
    this.opponentName = 'tpsoftdev',
    this.showOpponentProfile = true,
  });

  final String roundTitle;
  final String roundBody;
  final String opponentName;
  final bool showOpponentProfile;

  @override
  State<RoundIntroductionDevPage> createState() =>
      _RoundIntroductionDevPageState();
}

class _RoundIntroFrame {
  const _RoundIntroFrame({this.round = false, this.opponent = false});

  final bool round;
  final bool opponent;
}

class _RoundIntroductionDevPageState extends State<RoundIntroductionDevPage> {
  // Blank, the round, a blank beat, then the opponent.
  static const List<_RoundIntroFrame> _frames = <_RoundIntroFrame>[
    _RoundIntroFrame(),
    _RoundIntroFrame(round: true),
    _RoundIntroFrame(),
    _RoundIntroFrame(opponent: true),
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
    final _RoundIntroFrame frame = _frames[_step];

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: RoundIntroductionPhaseView(
          showRound: frame.round,
          showOpponent: frame.opponent,
          // Stand-in until the game reports the round and the opponent.
          roundTitle: widget.roundTitle,
          roundBody: widget.roundBody,
          opponentName: widget.opponentName,
          showOpponentProfile: widget.showOpponentProfile,
        ),
      ),
    );
  }
}

//-------------------------- SelectingCardDevPage ----------------------------//
/// Plays the Selecting Card strip. Each beat fades with
/// [SDeckMotionDuration.normal] on [SDeckMotionCurve.easeIn].
class SelectingCardDevPage extends StatefulWidget {
  const SelectingCardDevPage({super.key});

  @override
  State<SelectingCardDevPage> createState() => _SelectingCardDevPageState();
}

class _SelectingCardFrame {
  const _SelectingCardFrame({
    this.chrome = false,
    this.prompt = false,
    this.choice = false,
    this.timerValue = '20',
    this.timerType = SDeckTimerType.default_,
    this.scrollFraction = 0.5,
    this.selectedIndex,
    this.placedIndex,
    this.lifted = false,
    this.liftedScale = 1,
    this.liftedRotation = -1.37,
    this.timesUp = false,
  });

  final bool chrome;
  final bool prompt;
  final bool choice;
  final String timerValue;
  final SDeckTimerType timerType;
  final double scrollFraction;
  final int? selectedIndex;
  final int? placedIndex;
  final bool lifted;
  final double liftedScale;
  final double liftedRotation;
  final bool timesUp;
}

class _SelectingCardDevPageState extends State<SelectingCardDevPage> {
  // Blank, the prompt, a blank beat, then the hand is browsed, selected,
  // lifted, and set down on the image.
  static const List<_SelectingCardFrame> _frames = <_SelectingCardFrame>[
    _SelectingCardFrame(),
    _SelectingCardFrame(chrome: true, prompt: true),
    _SelectingCardFrame(chrome: true),
    _SelectingCardFrame(chrome: true, choice: true, timerValue: '20'),
    _SelectingCardFrame(
      chrome: true,
      choice: true,
      timerValue: '17',
      scrollFraction: 0.1,
    ),
    _SelectingCardFrame(
      chrome: true,
      choice: true,
      timerValue: '17',
      scrollFraction: 0,
      selectedIndex: 0,
    ),
    _SelectingCardFrame(
      chrome: true,
      choice: true,
      timerValue: '16',
      scrollFraction: 0,
      selectedIndex: 0,
      lifted: true,
    ),
    _SelectingCardFrame(
      chrome: true,
      choice: true,
      timerValue: '15',
      scrollFraction: 0,
      selectedIndex: 0,
      lifted: true,
      liftedScale: 0.2,
      liftedRotation: -28.17,
    ),
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
    final _SelectingCardFrame frame = _frames[_step];

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: SelectingCardPhaseView(
          showChrome: frame.chrome,
          showPrompt: frame.prompt,
          showChoice: frame.choice,
          // Stand-in until the game reports the prompt, the round, and the hand.
          timerValue: frame.timerValue,
          timerType: frame.timerType,
          scrollFraction: frame.scrollFraction,
          selectedIndex: frame.selectedIndex,
          placedIndex: frame.placedIndex,
          showLiftedCard: frame.lifted,
          liftedScale: frame.liftedScale,
          liftedRotation: frame.liftedRotation,
          showTimesUp: frame.timesUp,
          onPause: () {},
          onMore: () {},
        ),
      ),
    );
  }
}

//---------------------------- PutCardBackDevPage ---------------------------//
/// Plays the put-back edge case. The selected card is on the image, then
/// it returns to the hand one place to the right, still selected.
class PutCardBackDevPage extends StatefulWidget {
  const PutCardBackDevPage({super.key});

  @override
  State<PutCardBackDevPage> createState() => _PutCardBackDevPageState();
}

class _PutCardBackDevPageState extends State<PutCardBackDevPage> {
  static const List<_SelectingCardFrame> _frames = <_SelectingCardFrame>[
    _SelectingCardFrame(
      chrome: true,
      choice: true,
      timerValue: '16',
      scrollFraction: 0,
      selectedIndex: 0,
      lifted: true,
    ),
    _SelectingCardFrame(
      chrome: true,
      choice: true,
      timerValue: '15',
      scrollFraction: 0.08,
      selectedIndex: 0,
      placedIndex: 1,
    ),
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
    final _SelectingCardFrame frame = _frames[_step];

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: SelectingCardPhaseView(
          showChrome: frame.chrome,
          showChoice: frame.choice,
          timerValue: frame.timerValue,
          timerType: frame.timerType,
          scrollFraction: frame.scrollFraction,
          selectedIndex: frame.selectedIndex,
          placedIndex: frame.placedIndex,
          showLiftedCard: frame.lifted,
          showTimesUp: frame.timesUp,
          onPause: () {},
          onMore: () {},
        ),
      ),
    );
  }
}

//--------------------------- RunOutOfTimeDevPage ---------------------------//
/// Plays the run-out edge case. The hand stays up while the timer drops
/// into the alert, the screen fades clear, then Time's Up appears.
class RunOutOfTimeDevPage extends StatefulWidget {
  const RunOutOfTimeDevPage({super.key});

  @override
  State<RunOutOfTimeDevPage> createState() => _RunOutOfTimeDevPageState();
}

class _RunOutOfTimeDevPageState extends State<RunOutOfTimeDevPage> {
  static const List<_SelectingCardFrame> _frames = <_SelectingCardFrame>[
    _SelectingCardFrame(chrome: true, choice: true, timerValue: '20'),
    _SelectingCardFrame(
      chrome: true,
      choice: true,
      timerValue: '17',
      scrollFraction: 0.1,
    ),
    _SelectingCardFrame(
      chrome: true,
      choice: true,
      timerValue: '5',
      timerType: SDeckTimerType.alert,
      scrollFraction: 0.1,
    ),
    _SelectingCardFrame(
      chrome: true,
      choice: true,
      timerValue: '1',
      timerType: SDeckTimerType.alert,
      scrollFraction: 0.1,
    ),
    _SelectingCardFrame(),
    _SelectingCardFrame(timesUp: true),
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
    final _SelectingCardFrame frame = _frames[_step];

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: SelectingCardPhaseView(
          showChrome: frame.chrome,
          showChoice: frame.choice,
          timerValue: frame.timerValue,
          timerType: frame.timerType,
          scrollFraction: frame.scrollFraction,
          showTimesUp: frame.timesUp,
          onPause: () {},
          onMore: () {},
        ),
      ),
    );
  }
}

//------------------------ UniversalEdgeCasesDevPage -----------------------//
/// Plays the universal overlays. Each beat fades with
/// [SDeckMotionDuration.normal] on [SDeckMotionCurve.easeIn].
class UniversalEdgeCasesDevPage extends StatefulWidget {
  const UniversalEdgeCasesDevPage({super.key});

  @override
  State<UniversalEdgeCasesDevPage> createState() =>
      _UniversalEdgeCasesDevPageState();
}

class _UniversalEdgeFrame {
  const _UniversalEdgeFrame({
    this.chrome = false,
    this.prompt = false,
    this.play = false,
    this.toast = false,
    this.toastStatus = SDeckToastStatus.note,
    this.toastTitle = '',
    this.toastDescription = '',
    this.options = false,
    this.leaveGame = false,
    this.leaveParty = false,
  });

  final bool chrome;
  final bool prompt;
  final bool play;
  final bool toast;
  final SDeckToastStatus toastStatus;
  final String toastTitle;
  final String toastDescription;
  final bool options;
  final bool leaveGame;
  final bool leaveParty;
}

class _UniversalEdgeCasesDevPageState extends State<UniversalEdgeCasesDevPage> {
  static const List<_UniversalEdgeFrame> _frames = <_UniversalEdgeFrame>[
    _UniversalEdgeFrame(
      chrome: true,
      prompt: true,
      play: true,
      toast: true,
      toastTitle: 'ethan paused the game.',
      toastDescription: 'Tell them to resume when ready.',
    ),
    _UniversalEdgeFrame(
      chrome: true,
      prompt: true,
      toast: true,
      toastStatus: SDeckToastStatus.error,
      toastTitle: 'tpsoftdev left the game.',
      toastDescription: 'They can join back though.',
    ),
    _UniversalEdgeFrame(chrome: true, prompt: true, options: true),
    _UniversalEdgeFrame(chrome: true, prompt: true, leaveGame: true),
    _UniversalEdgeFrame(chrome: true, prompt: true, leaveParty: true),
    _UniversalEdgeFrame(
      toast: true,
      toastStatus: SDeckToastStatus.error,
      toastTitle: 'The Host left the game.',
      toastDescription: 'Sending you back to the party.',
    ),
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
    final _UniversalEdgeFrame frame = _frames[_step];

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: UniversalEdgeCasesPhaseView(
          showChrome: frame.chrome,
          showPrompt: frame.prompt,
          showPlay: frame.play,
          showToast: frame.toast,
          toastStatus: frame.toastStatus,
          toastTitle: frame.toastTitle,
          toastDescription: frame.toastDescription,
          showOptions: frame.options,
          showLeaveGame: frame.leaveGame,
          showLeaveParty: frame.leaveParty,
          onPause: () {},
          onMore: () {},
        ),
      ),
    );
  }
}

//--------------------------- WaitingFreeDevPage ----------------------------//
/// Plays the free wait after a card is placed. Each beat fades with
/// [SDeckMotionDuration.normal] on [SDeckMotionCurve.easeIn].
class WaitingFreeDevPage extends StatefulWidget {
  const WaitingFreeDevPage({super.key});

  @override
  State<WaitingFreeDevPage> createState() => _WaitingFreeDevPageState();
}

class _WaitingFreeFrame {
  const _WaitingFreeFrame({
    this.chrome = false,
    this.wait = false,
    this.timerValue = '11',
    this.timerType = SDeckTimerType.enlarged,
    this.timesUp = false,
  });

  final bool chrome;
  final bool wait;
  final String timerValue;
  final SDeckTimerType timerType;
  final bool timesUp;
}

class _WaitingFreeDevPageState extends State<WaitingFreeDevPage> {
  static const List<_WaitingFreeFrame> _frames = <_WaitingFreeFrame>[
    _WaitingFreeFrame(),
    _WaitingFreeFrame(chrome: true, wait: true, timerValue: '11'),
    _WaitingFreeFrame(
      chrome: true,
      wait: true,
      timerValue: '5',
      timerType: SDeckTimerType.alert,
    ),
    _WaitingFreeFrame(),
    _WaitingFreeFrame(timesUp: true),
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
    final _WaitingFreeFrame frame = _frames[_step];

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: WaitingFreePhaseView(
          showChrome: frame.chrome,
          showWait: frame.wait,
          timerValue: frame.timerValue,
          timerType: frame.timerType,
          showTimesUp: frame.timesUp,
          onPause: () {},
          onMore: () {},
          onRemoveAds: () {},
        ),
      ),
    );
  }
}

//--------------------------- WaitingPlusDevPage ----------------------------//
/// Plays the Socialdeck+ wait after a card is placed. Each beat fades with
/// [SDeckMotionDuration.normal] on [SDeckMotionCurve.easeIn].
class WaitingPlusDevPage extends StatefulWidget {
  const WaitingPlusDevPage({super.key});

  @override
  State<WaitingPlusDevPage> createState() => _WaitingPlusDevPageState();
}

class _WaitingPlusFrame {
  const _WaitingPlusFrame({
    this.chrome = false,
    this.wait = false,
    this.timerValue = '11',
    this.timerType = SDeckTimerType.enlarged,
    this.timesUp = false,
  });

  final bool chrome;
  final bool wait;
  final String timerValue;
  final SDeckTimerType timerType;
  final bool timesUp;
}

class _WaitingPlusDevPageState extends State<WaitingPlusDevPage> {
  static const List<_WaitingPlusFrame> _frames = <_WaitingPlusFrame>[
    _WaitingPlusFrame(chrome: true, wait: true, timerValue: '11'),
    _WaitingPlusFrame(
      chrome: true,
      wait: true,
      timerValue: '5',
      timerType: SDeckTimerType.alert,
    ),
    _WaitingPlusFrame(),
    _WaitingPlusFrame(timesUp: true),
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
    final _WaitingPlusFrame frame = _frames[_step];

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: WaitingPlusPhaseView(
          showChrome: frame.chrome,
          showWait: frame.wait,
          timerValue: frame.timerValue,
          timerType: frame.timerType,
          showTimesUp: frame.timesUp,
          onPause: () {},
          onMore: () {},
          onFunButton: () {},
        ),
      ),
    );
  }
}

//-------------------------- IntroductionPhaseDevPage ------------------------//
/// Plays the Introduction - No Tutorial strip. Each piece fades in and stays.
/// The fade is the design-system one: [SDeckMotionDuration.normal] on
/// [SDeckMotionCurve.easeIn].
class IntroductionPhaseDevPage extends StatefulWidget {
  const IntroductionPhaseDevPage({super.key});

  @override
  State<IntroductionPhaseDevPage> createState() =>
      _IntroductionPhaseDevPageState();
}

class _IntroductionFrame {
  const _IntroductionFrame({required this.presents, required this.artwork});

  final bool presents;
  final bool artwork;
}

class _IntroductionPhaseDevPageState extends State<IntroductionPhaseDevPage> {
  // Blank, the presents line, then the sticker and placeholder together.
  static const List<_IntroductionFrame> _frames = <_IntroductionFrame>[
    _IntroductionFrame(presents: false, artwork: false),
    _IntroductionFrame(presents: true, artwork: false),
    _IntroductionFrame(presents: true, artwork: true),
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
    final _IntroductionFrame frame = _frames[_step];

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: IntroductionPhaseView(
          showPresents: frame.presents,
          showArtwork: frame.artwork,
        ),
      ),
    );
  }
}

//---------------------- IntroductionTutorialPhaseDevPage -------------------//
/// Plays the Introduction and Tutorial strip. Each piece fades in and stays.
/// The fade is the design-system one: [SDeckMotionDuration.normal] on
/// [SDeckMotionCurve.easeIn].
class IntroductionTutorialPhaseDevPage extends StatefulWidget {
  const IntroductionTutorialPhaseDevPage({super.key});

  @override
  State<IntroductionTutorialPhaseDevPage> createState() =>
      _IntroductionTutorialPhaseDevPageState();
}

class _TutorialStripFrame {
  const _TutorialStripFrame({
    this.presents = false,
    this.artwork = false,
    this.tutorialLayout = false,
    this.chrome = false,
    this.tutorial = false,
    this.script = false,
    this.title = '',
    this.body,
    this.remaining = '',
    this.progress = 0,
  });

  final bool presents;
  final bool artwork;
  final bool tutorialLayout;
  final bool chrome;
  final bool tutorial;
  final bool script;
  final String title;
  final String? body;
  final String remaining;
  final double progress;
}

class _IntroductionTutorialPhaseDevPageState
    extends State<IntroductionTutorialPhaseDevPage> {
  // Fill widths from the Figma frames, over the track beside that label.
  static const double _rules = 10 / 340;
  static const double _prompt = 26 / 340;
  static const double _match = 70 / 340;
  static const double _vote = 161 / 341;
  static const double _board = 210 / 343;
  static const double _tournament = 287 / 347;

  static const List<_TutorialStripFrame> _frames = <_TutorialStripFrame>[
    _TutorialStripFrame(),
    _TutorialStripFrame(presents: true),
    _TutorialStripFrame(presents: true, artwork: true),
    _TutorialStripFrame(),
    _TutorialStripFrame(
      tutorialLayout: true,
      chrome: true,
      tutorial: true,
      script: true,
      title: 'Here are the rules...',
      body: 'Quickly summarized.',
      remaining: '40s',
      progress: _rules,
    ),
    _TutorialStripFrame(
      tutorialLayout: true,
      chrome: true,
      tutorial: true,
      title: 'Here are the rules...',
      body: 'Quickly summarized.',
      remaining: '35s',
      progress: _prompt,
    ),
    _TutorialStripFrame(
      tutorialLayout: true,
      chrome: true,
      tutorial: true,
      script: true,
      title: 'You get a prompt.',
      body: 'You get a bit of time to read it.',
      remaining: '35s',
      progress: _prompt,
    ),
    _TutorialStripFrame(
      tutorialLayout: true,
      chrome: true,
      tutorial: true,
      title: 'You get a prompt.',
      body: 'You get a bit of time to read it.',
      remaining: '30s',
      progress: _match,
    ),
    _TutorialStripFrame(
      tutorialLayout: true,
      chrome: true,
      tutorial: true,
      script: true,
      title: 'Match it with a card.',
      body: 'Place a card in the middle before time runs out.',
      remaining: '30s',
      progress: _match,
    ),
    _TutorialStripFrame(
      tutorialLayout: true,
      chrome: true,
      tutorial: true,
      title: 'Match it with a card.',
      body: 'Place a card in the middle before time runs out.',
      remaining: '22s',
      progress: _vote,
    ),
    _TutorialStripFrame(
      tutorialLayout: true,
      chrome: true,
      tutorial: true,
      script: true,
      title: 'Vote for your favorites.',
      body: 'Support other players in their battles or be penalized.',
      remaining: '22s',
      progress: _vote,
    ),
    _TutorialStripFrame(
      tutorialLayout: true,
      chrome: true,
      tutorial: true,
      title: 'Vote for your favorites.',
      body: 'Support other players in their battles or be penalized.',
      remaining: '15s',
      progress: _board,
    ),
    _TutorialStripFrame(
      tutorialLayout: true,
      chrome: true,
      tutorial: true,
      script: true,
      title: 'Climb the leaderboard.',
      body: 'Grow in points and see how you stand amongst your peers.',
      remaining: '15s',
      progress: _board,
    ),
    _TutorialStripFrame(
      tutorialLayout: true,
      chrome: true,
      tutorial: true,
      title: 'Climb the leaderboard.',
      body: 'Grow in points and see how you stand amongst your peers.',
      remaining: '8s',
      progress: _tournament,
    ),
    _TutorialStripFrame(
      tutorialLayout: true,
      chrome: true,
      tutorial: true,
      script: true,
      title: 'Final Tournament',
      body:
          'Play in a bracket tournament against everyone and earn double points.',
      remaining: '8s',
      progress: _tournament,
    ),
    _TutorialStripFrame(
      tutorialLayout: true,
      title: 'Final Tournament',
      body:
          'Play in a bracket tournament against everyone and earn double points.',
    ),
    _TutorialStripFrame(
      tutorialLayout: true,
      chrome: true,
      tutorial: true,
      script: true,
      title: "Let's get prompting!",
      remaining: '0s',
      progress: 1,
    ),
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
    final _TutorialStripFrame frame = _frames[_step];

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: IntroductionTutorialPhaseView(
          showPresents: frame.presents,
          showArtwork: frame.artwork,
          tutorial: frame.tutorialLayout,
          showChrome: frame.chrome,
          showTutorial: frame.tutorial,
          showScript: frame.script,
          title: frame.title,
          body: frame.body,
          remainingLabel: frame.remaining,
          progress: frame.progress,
          onMore: () {},
          onSkip: () {},
        ),
      ),
    );
  }
}

class LeaderboardsTournamentDevPage extends StatefulWidget {
  const LeaderboardsTournamentDevPage({super.key});

  @override
  State<LeaderboardsTournamentDevPage> createState() =>
      _LeaderboardsTournamentDevPageState();
}

class _LeaderboardsTournamentDevPageState
    extends State<LeaderboardsTournamentDevPage> {
  // Preserve the existing sample data and standings mapping.
  static final List<PromptdLeaderboardEntry> _entries = mapPromptdStandings([
    for (final (index, points) in [220, 185, 170, 140, 100, 90, 80, 70].indexed)
      PromptdStanding(
        playerId: 'preview-player-$index',
        playerName: 'Player Name',
        points: points,
        rank: index + 1,
      ),
  ]);

  /// Top three, then the tournament winner. Same reveal as Round 1.
  static final List<PromptdLeaderboardEntry> _finalEntries = [
    ...mapPromptdStandings([
      for (final (index, points) in [220, 185, 170].indexed)
        PromptdStanding(
          playerId: 'final-player-$index',
          playerName: 'Player Name',
          points: points,
          rank: index + 1,
        ),
    ]),
    const PromptdLeaderboardEntry(
      playerName: 'Player Name',
      points: '',
      standing: SDeckLeaderboardStanding.tournament,
    ),
  ];

  int _step = 0;
  Timer? _timer;

  void _onLeaderboardComplete() {
    if (!mounted || _step != 0) return;
    setState(() => _step = 1);
    _holdThenAdvance(from: 1);
  }

  void _onFinalLeaderboardComplete() {
    if (!mounted || _step != 4) return;
    setState(() => _step = 5);
    _timer?.cancel();
    _timer = Timer(SDeckMotionDuration.linger + SDeckMotionDuration.slower, () {
      if (!mounted || _step != 5) return;
      setState(() => _step = 6);
    });
  }

  /// Voting Time, Final Two, and Game Over. The final board advances itself.
  void _holdThenAdvance({required int from}) {
    _timer?.cancel();
    if (from >= 4) return;
    _timer = Timer(SDeckMotionDuration.linger + SDeckMotionDuration.slower, () {
      if (!mounted || _step != from) return;
      setState(() => _step = from + 1);
      _holdThenAdvance(from: _step);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget screen = switch (_step) {
      0 => StandingsReveal(
        entries: _entries,
        onComplete: _onLeaderboardComplete,
      ),
      1 => const PromptdAnnouncementView(
        title: 'Voting Time!',
        message:
            'Climb the bracket to win the final tournament for double points!',
      ),
      2 => const PromptdAnnouncementView(
        title: 'Final Two!',
        message: 'Vote for the best card of the tournament.',
      ),
      3 => const PromptdAnnouncementView(
        title: 'Game Over!',
        message: 'The final standings are in!',
      ),
      4 => StandingsReveal(
        entries: _finalEntries,
        round: 'Final',
        onComplete: _onFinalLeaderboardComplete,
      ),
      5 => const PromptdConclusionView(role: PromptdConclusionRole.host),
      _ => const PromptdConclusionView(role: PromptdConclusionRole.player),
    };

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(child: PromptdFadeThrough(step: _step, child: screen)),
    );
  }
}
