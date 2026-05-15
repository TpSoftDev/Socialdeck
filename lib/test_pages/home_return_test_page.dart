import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

import 'home_in_party_test_page.dart';
import 'home_party_flow_dialogs.dart';

//--------------------------- _HomeTopToastPayload ---------------------------//
class _HomeTopToastPayload {
  const _HomeTopToastPayload({
    required this.status,
    required this.title,
    required this.description,
  });

  final SDeckToastStatus status;
  final String title;
  final String description;
}

//--------------------------- HomeReturnTestRouteArgs ------------------------//
/// Pass as `GoRouter` `extra` when opening [AppPaths.homeReturnTest]. Backend
/// (or shell wiring) sets [showReturnToGame] when the network/session edge case
/// applies so **Return to Game** is shown; otherwise the row stays hidden.
class HomeReturnTestRouteArgs {
  const HomeReturnTestRouteArgs({
    this.showReturnToGame = false,
    this.returnGameDescription = "Prompt'd - Round 1",
  });

  /// When `true`, the **Return to Game** selection row is visible.
  final bool showReturnToGame;

  /// Subtitle on that row (active game context per Figma).
  final String returnGameDescription;
}

enum _HomeReturnTutorialLifecycle {
  /// Scrim + elevated Tutorial only; tap Tutorial to open the step dialog.
  awaitingTutorialTap,
  /// Step dialog + scrim; Tutorial tile is hidden.
  learning,
  /// Centered completion placeholder; scrim still blocks the rest of the body.
  completion,
  /// Full home body and bottom nav are interactive again.
  dismissed,
}

//------------------------------- HomeReturnTestPage -------------------------//
/// Figma **Home – Returning** / **Home – Return to Game** (top bar, carousels,
/// selection targets, bottom nav) plus optional rows:
///
/// - **Return to Game** — Figma `imageTarget (Rive)` [230:7126](https://www.figma.com/design/QhMHFggCqffYfBcF7Fy7eX/Socialdeck---Home?node-id=230-7126&m=dev):
///   hidden by default; shown only when route `extra` is a [HomeReturnTestRouteArgs]
///   with `showReturnToGame: true` (backend / shell when disconnected). Subtitle
///   comes from [HomeReturnTestRouteArgs.returnGameDescription]. Rive slot uses the
///   checkered asset until a Rive asset is wired.
/// - **Tutorial** — `imageTarget` 230:3681 flow: scrim, steps, completion.
///
/// **Create / Join** use [HomePartyFlowDialogs] and push [AppPaths.homeInPartyTest].
/// Those dialogs use [SDeckPartyInGameNameInputDialog] / [SDeckPartyCodeInputDialog],
/// which set `enableSuggestions: false` and `autocorrect: false` on the field so
/// Android’s keyboard suggestion strip is minimized (IME-dependent; not fully
/// removable without a custom keyboard).
///
/// **Toasts** (Figma Home): optional top [SDeckToast] slides from above; driven
/// only here via [SDeckToast] + [SDeckToastStatus] — no global host. When route
/// `extra` has [HomeReturnTestRouteArgs.showReturnToGame] true, a **Lost
/// connection…** warning toast is shown once after the first frame.
///
/// Pushed from [HomePage] via [AppPaths.homeReturnTest]. Pass a
/// [HomeReturnTestRouteArgs] as `extra` when the disconnected edge case applies.
class HomeReturnTestPage extends StatefulWidget {
  const HomeReturnTestPage({
    super.key,
    this.showReturnToGame = false,
    this.returnGameDescription = "Prompt'd - Round 1",
  });

  /// Edge case: user lost connection / returned from active game — show row.
  final bool showReturnToGame;

  /// Subtitle on **Return to Game** (e.g. game name and round).
  final String returnGameDescription;

  @override
  State<HomeReturnTestPage> createState() => _HomeReturnTestPageState();
}

class _HomeReturnTestPageState extends State<HomeReturnTestPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _tutorialTileKey = GlobalKey();

  _HomeReturnTutorialLifecycle _tutorialLifecycle =
      _HomeReturnTutorialLifecycle.awaitingTutorialTap;

  /// After the user starts the step flow, the in-list Tutorial tile is removed
  /// permanently for this page instance (no return after dismiss).
  bool _tutorialTileConsumed = false;

  /// Tutorial card bounds in [Stack] coordinates (for the elevated duplicate).
  Rect? _tutorialRectInStack;

  Timer? _completionDismissTimer;

  static const Duration _completionVisibleDuration = Duration(seconds: 3);

  /// Top toast (Figma): slide from above; exit is a smooth ease upward.
  static const Duration _toastEnterDuration = Duration(milliseconds: 320);
  static const Duration _toastExitDuration = Duration(milliseconds: 420);

  late final AnimationController _toastAnim = AnimationController(
    vsync: this,
    duration: _toastEnterDuration,
  );
  late final Animation<Offset> _toastSlide = Tween<Offset>(
    begin: const Offset(0, -1),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _toastAnim,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    ),
  );

  _HomeTopToastPayload? _toastPayload;
  Timer? _toastAutoDismissTimer;

  /// Only clear [_toastPayload] after [AnimationStatus.dismissed] when a dismiss
  /// was requested — avoids spurious `dismissed` from `forward(from: 0)` wiping
  /// the toast or leaving the layer stuck.
  bool _toastAwaitingRemoval = false;

  /// Tracks when this route is covered so we can drop the OS keyboard when we
  /// become visible again (otherwise the IME suggestion strip can linger).
  bool? _routeWasCovered;

  static const Duration _toastVisibleDuration = Duration(seconds: 6);

  bool get _tutorialOverlayActive =>
      _tutorialLifecycle != _HomeReturnTutorialLifecycle.dismissed;

  /// Hug height for a selection row (Return / Tutorial / Create / Join).
  static const double _kApproxSelectionRowHeight = 84.0;

  /// Height for **What's New?** [SDeckCarouselCard] — same vertical budget as
  /// before the Return row existed: the Return tile only adds scroll extent and
  /// does not shrink this carousel. Optional Tutorial row still participates so
  /// the column does not overflow when both are visible.
  double _whatsNewCarouselHeight(double scrollViewportHeight) {
    if (!scrollViewportHeight.isFinite || scrollViewportHeight <= 0) {
      return 400;
    }
    final double tutBlock = !_tutorialTileConsumed
        ? _kApproxSelectionRowHeight + SDeckSpace.gap8
        : 0;

    final double reservedExcludingCarousel = SDeckSpace.gap8 +
        SDeckSpace.gap8 +
        _kApproxSelectionRowHeight * 2 +
        SDeckSpace.gap8 +
        SDeckSpace.padding16;

    final double fill =
        scrollViewportHeight - reservedExcludingCarousel - tutBlock;
    return fill.clamp(220.0, 520.0);
  }

  void _onReturnToGameTap(BuildContext context) {
    context.push(
      AppPaths.homeInPartyTest,
      extra: const HomeInPartyRouteArgs(
        partyTitle: "Prompt'd",
        partySubtitle: 'Round 1',
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _toastAnim.addStatusListener(_onToastAnimationStatus);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      FocusManager.instance.primaryFocus?.unfocus();
      _measureTutorialInStack();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _measureTutorialInStack();
        }
      });
      if (mounted && widget.showReturnToGame) {
        _showTopToast(
          status: SDeckToastStatus.warning,
          title: 'Lost connection...',
          description: 'You disconnected from our servers.',
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool covered = !(ModalRoute.of(context)?.isCurrent ?? true);
    if (_routeWasCovered == true && !covered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      });
    }
    _routeWasCovered = covered;
  }

  @override
  void dispose() {
    _toastAnim.removeStatusListener(_onToastAnimationStatus);
    _toastAnim.dispose();
    _toastAutoDismissTimer?.cancel();
    _completionDismissTimer?.cancel();
    super.dispose();
  }

  void _onToastAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed &&
        mounted &&
        _toastAwaitingRemoval) {
      _toastAwaitingRemoval = false;
      setState(() => _toastPayload = null);
    }
  }

  void _scheduleToastAutoDismiss() {
    _toastAutoDismissTimer?.cancel();
    _toastAutoDismissTimer = Timer(_toastVisibleDuration, () {
      if (mounted) {
        _dismissTopToast();
      }
    });
  }

  /// Shows a top [SDeckToast] (Figma: drops from top of screen).
  void _showTopToast({
    required SDeckToastStatus status,
    required String title,
    required String description,
  }) {
    _toastAutoDismissTimer?.cancel();
    _toastAwaitingRemoval = false;
    setState(() {
      _toastPayload = _HomeTopToastPayload(
        status: status,
        title: title,
        description: description,
      );
    });
    // Run after layout so [SlideTransition] is attached; otherwise [forward] can
    // mis-sync and the toast never reaches a clean `reverse` → `dismissed`.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _toastPayload == null) {
        return;
      }
      _toastAnim.duration = _toastEnterDuration;
      _toastAnim.forward(from: 0);
    });
    _scheduleToastAutoDismiss();
  }

  void _dismissTopToast() {
    _toastAutoDismissTimer?.cancel();
    _toastAutoDismissTimer = null;
    if (_toastPayload == null) {
      return;
    }
    if (!_toastAnim.isAnimating &&
        _toastAnim.value == 0 &&
        _toastAnim.status == AnimationStatus.dismissed) {
      _toastAwaitingRemoval = false;
      setState(() => _toastPayload = null);
      return;
    }
    _toastAwaitingRemoval = true;
    _toastAnim.duration = _toastExitDuration;
    _toastAnim.reverse().whenCompleteOrCancel(() {
      if (mounted) {
        _toastAnim.duration = _toastEnterDuration;
      }
    });
  }

  void _measureTutorialInStack() {
    if (_tutorialLifecycle !=
            _HomeReturnTutorialLifecycle.awaitingTutorialTap ||
        _tutorialTileConsumed ||
        !mounted) {
      return;
    }
    final BuildContext? stackCtx = _stackKey.currentContext;
    final BuildContext? tileCtx = _tutorialTileKey.currentContext;
    if (stackCtx == null || tileCtx == null) {
      return;
    }
    final RenderObject? stackRo = stackCtx.findRenderObject();
    final RenderObject? tileRo = tileCtx.findRenderObject();
    if (stackRo is! RenderBox || tileRo is! RenderBox || !stackRo.hasSize) {
      return;
    }
    final Offset topLeft = stackRo.globalToLocal(
      tileRo.localToGlobal(Offset.zero),
    );
    final Rect next = topLeft & tileRo.size;
    if (_tutorialRectInStack != next) {
      setState(() => _tutorialRectInStack = next);
    }
  }

  void _onTutorialTileTappedToStartSteps() {
    if (_tutorialLifecycle !=
        _HomeReturnTutorialLifecycle.awaitingTutorialTap) {
      return;
    }
    setState(() {
      _tutorialTileConsumed = true;
      _tutorialLifecycle = _HomeReturnTutorialLifecycle.learning;
      _tutorialRectInStack = null;
    });
  }

  void _onTutorialStepsFinished() {
    if (!mounted) {
      return;
    }
    _completionDismissTimer?.cancel();
    setState(() {
      _tutorialLifecycle = _HomeReturnTutorialLifecycle.completion;
      _tutorialRectInStack = null;
    });
    _completionDismissTimer = Timer(_completionVisibleDuration, () {
      if (!mounted) {
        return;
      }
      setState(() {
        _tutorialLifecycle = _HomeReturnTutorialLifecycle.dismissed;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              key: _stackKey,
              clipBehavior: Clip.none,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SDeckTopNavigationBar.titleWithAvatar(
                      title: 'Home',
                      showBottomFade: true,
                      avatar: Image.asset(
                        SDeckIcon.checkeredBackground,
                        fit: BoxFit.cover,
                      ),
                      onActionPressed: null,
                    ),
                    Expanded(
                      child: IgnorePointer(
                        ignoring: _tutorialOverlayActive,
                        child: LayoutBuilder(
                          builder:
                              (BuildContext context, BoxConstraints inner) {
                            final double whatsNewH =
                                _whatsNewCarouselHeight(inner.maxHeight);
                            return SingleChildScrollView(
                              physics: _tutorialOverlayActive
                                  ? const NeverScrollableScrollPhysics()
                                  : const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: SDeckSpace.padding16,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  const SizedBox(height: SDeckSpace.gap8),
                                  if (widget.showReturnToGame) ...<Widget>[
                                    SDeckSelectionTargetCard(
                                      title: 'Return to Game',
                                      description: widget.returnGameDescription,
                                      backgroundAssetPath:
                                          SDeckIcon.checkeredBackground,
                                      onTap: () => _onReturnToGameTap(context),
                                    ),
                                    const SizedBox(height: SDeckSpace.gap8),
                                  ],
                                  if (!_tutorialTileConsumed) ...<Widget>[
                                    SDeckSelectionTargetCard(
                                      key: _tutorialTileKey,
                                      title: 'Tutorial',
                                      description:
                                          'Learn how to play Socialdeck.',
                                      backgroundAssetPath:
                                          SDeckIcon.checkeredBackground,
                                      boxShadow: SDeckBoxShadows.boxShadow(
                                        context.semantic.shadow,
                                      ),
                                      onTap: null,
                                    ),
                                    const SizedBox(height: SDeckSpace.gap8),
                                  ],
                                  SizedBox(
                                    height: whatsNewH,
                                    child: SDeckCarouselCard(
                                      title: "What's New?",
                                      description:
                                          "Here's an update on what's going on...",
                                      totalSegments: 3,
                                      currentIndex: 0,
                                      height: whatsNewH,
                                      backgroundAssetPath:
                                          SDeckIcon.checkeredBackground,
                                      onPrevious: () {},
                                      onNext: () {},
                                    ),
                                  ),
                                  const SizedBox(height: SDeckSpace.gap8),
                                  SDeckSelectionTargetCard(
                                    title: 'Create Party',
                                    description: 'Start a new game',
                                    backgroundAssetPath:
                                        SDeckIcon.checkeredBackground,
                                    onTap: () =>
                                        HomePartyFlowDialogs.showCreatePartyLetsBegin(
                                      context,
                                      onNamedComplete:
                                          (BuildContext ctx, String inGameName) {
                                        ctx.push(
                                          AppPaths.homeInPartyTest,
                                          extra: HomeInPartyRouteArgs
                                              .fromCreatedPartyInGameName(
                                            inGameName,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: SDeckSpace.gap8),
                                  SDeckSelectionTargetCard(
                                    title: 'Join a Party',
                                    description: 'Insert a game code',
                                    backgroundAssetPath:
                                        SDeckIcon.checkeredBackground,
                                    onTap: () =>
                                        HomePartyFlowDialogs.showJoinPartyFlow(
                                      context,
                                      onJoinCompleted:
                                          (BuildContext ctx, String _,
                                              String __) {
                                        ctx.push(
                                          AppPaths.homeInPartyTest,
                                          extra: const HomeInPartyRouteArgs(),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: SDeckSpace.padding16),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (_tutorialOverlayActive) ...<Widget>[
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                  if (_tutorialLifecycle ==
                      _HomeReturnTutorialLifecycle.learning)
                    Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SDeckSpace.padding24,
                        ),
                        child: _HomeReturnTutorialFlow(
                          onFinished: _onTutorialStepsFinished,
                        ),
                      ),
                    ),
                  if (_tutorialLifecycle ==
                      _HomeReturnTutorialLifecycle.completion)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SDeckSpace.padding24,
                        ),
                        child: LayoutBuilder(
                          builder:
                              (BuildContext context, BoxConstraints c) {
                            return SDeckHomeTutorialCompletionPopup(
                              maxWidth: c.maxWidth,
                            );
                          },
                        ),
                      ),
                    ),
                  if (_tutorialLifecycle ==
                          _HomeReturnTutorialLifecycle
                              .awaitingTutorialTap &&
                      _tutorialRectInStack != null)
                    Positioned(
                      left: _tutorialRectInStack!.left,
                      top: _tutorialRectInStack!.top,
                      width: _tutorialRectInStack!.width,
                      height: _tutorialRectInStack!.height,
                      child: Material(
                        type: MaterialType.transparency,
                        child: SDeckSelectionTargetCard(
                          title: 'Tutorial',
                          description:
                              'Learn how to play Socialdeck.',
                          backgroundAssetPath:
                              SDeckIcon.checkeredBackground,
                          boxShadow: SDeckBoxShadows.boxShadow(
                            context.semantic.shadow,
                          ),
                          onTap: _onTutorialTileTappedToStartSteps,
                        ),
                      ),
                    ),
                ],
                if (_toastPayload != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          SDeckSpace.padding16,
                          SDeckSpace.padding12,
                          SDeckSpace.padding16,
                          0,
                        ),
                        child: SlideTransition(
                          position: _toastSlide,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: SDeckToast(
                              status: _toastPayload!.status,
                              title: _toastPayload!.title,
                              description: _toastPayload!.description,
                              onDismiss: _dismissTopToast,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: ClipRect(
        child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            IgnorePointer(
              ignoring: _tutorialOverlayActive,
              child: SDeckBottomNavBar(
                currentIndex: 0,
                items: SDeckBottomNavBar.defaultItems,
                onTap: (int index) {
                  switch (index) {
                    case 0:
                      context.go('/home');
                      break;
                    case 1:
                      context.go('/social');
                      break;
                    case 2:
                      context.go('/decks');
                      break;
                    case 3:
                      context.go('/store');
                      break;
                    case 4:
                      context.go('/profile');
                      break;
                  }
                },
              ),
            ),
            if (_tutorialOverlayActive)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.45),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

//--------------------------- _HomeReturnTutorialFlow -------------------------//
class _HomeReturnTutorialFlow extends StatefulWidget {
  const _HomeReturnTutorialFlow({required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<_HomeReturnTutorialFlow> createState() =>
      _HomeReturnTutorialFlowState();
}

class _HomeReturnTutorialFlowState extends State<_HomeReturnTutorialFlow> {
  static const List<String> _titles = <String>[
    'Tutorial',
    'Friends',
    'Decks',
    'Play',
    'Shop',
    'Profile',
    'Learn More',
  ];

  static const int _totalSteps = 7;

  int _step = 1;

  String get _title =>
      _titles[(_step - 1).clamp(0, _titles.length - 1)];

  bool get _pastFirstStep => _step > 1;

  bool get _onLastStep => _step >= _totalSteps;

  void _goNext() {
    if (_onLastStep) {
      widget.onFinished();
      return;
    }
    setState(() => _step++);
  }

  void _goBack() {
    if (_step <= 1) {
      return;
    }
    setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    return SDeckHomeTutorialStepDialog(
      title: _title,
      currentStep: _step,
      totalSteps: _totalSteps,
      primaryButtonText: _onLastStep ? 'Finish' : 'Next',
      secondaryButtonText: _pastFirstStep ? 'Back' : null,
      onSecondaryPressed: _pastFirstStep ? _goBack : null,
      onPrimaryPressed: _goNext,
    );
  }
}
