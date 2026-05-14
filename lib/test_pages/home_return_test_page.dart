import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- HomeReturnTestPage -------------------------//
/// Stateless preview of the Figma **Home – Returning** screen (top bar
/// 314:2814, carousel 314:2816, selection targets, bottom nav 314:2819).
/// Pushed from [HomePage] via [AppPaths.homeReturnTest].
///
/// Top bar: [SDeckTopNavigationBar.titleWithAvatar] — **Home** (H4) and
/// profile placeholder, **no back chevron** (per Figma). Use the system back
/// gesture / Android back to return from this pushed route.
///
/// Bottom bar matches the main shell tabs so you can jump to other tabs
/// ([SDeckBottomNavBar]); **Home** uses [context.go] to `/home` (leaves this
/// test route).
///
/// **Join a Party** opens a two-step dialog: in-game name, then party code.
/// **Create Party** opens only **Let's Begin!** (in-game name; no code step).
class HomeReturnTestPage extends StatelessWidget {
  const HomeReturnTestPage({super.key});

  /// Carousel height from content width (Figma card is roughly square).
  static double _carouselHeightForWidth(double width) {
    return (width * 1.0).clamp(240.0, 440.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
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
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double w = constraints.maxWidth -
                      2 * SDeckSpace.padding16;
                  final double carouselH = _carouselHeightForWidth(w);
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SDeckSpace.padding16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: SDeckSpace.gap12),
                        SizedBox(
                          height: carouselH,
                          child: SDeckCarouselCard(
                            title: "What's New?",
                            description:
                                "Here's an update on what's going on...",
                            totalSegments: 3,
                            currentIndex: 0,
                            height: carouselH,
                            backgroundAssetPath:
                                SDeckIcon.checkeredBackground,
                            onPrevious: () {},
                            onNext: () {},
                          ),
                        ),
                        const SizedBox(height: SDeckSpace.gap12),
                        SDeckSelectionTargetCard(
                          title: 'Create Party',
                          description: 'Start a new game',
                          backgroundAssetPath:
                              SDeckIcon.checkeredBackground,
                          onTap: () => _showCreatePartyLetsBegin(context),
                        ),
                        const SizedBox(height: SDeckSpace.gap12),
                        SDeckSelectionTargetCard(
                          title: 'Join a Party',
                          description: 'Insert a game code',
                          backgroundAssetPath:
                              SDeckIcon.checkeredBackground,
                          onTap: () => _showJoinPartyFlow(context),
                        ),
                        const SizedBox(height: SDeckSpace.gap16),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SDeckBottomNavBar(
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
    );
  }

  /// Figma 230:3901 — **Let's Begin!** only; closes on **Next** (no code step).
  static void _showCreatePartyLetsBegin(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel:
          MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (
        BuildContext dialogContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: SDeckSpace.padding24,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              void closeFlow() {
                FocusManager.instance.primaryFocus?.unfocus();
                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }
              }

              final String raw = nameController.text;
              final bool nameOk = raw.trim().isNotEmpty;
              return SDeckPartyInGameNameInputDialog(
                controller: nameController,
                inputState: raw.isEmpty
                    ? SDeckInputState.hint
                    : SDeckInputState.filled,
                primaryButtonEnabled: nameOk,
                onChanged: (_) => setState(() {}),
                onClose: closeFlow,
                onNext: () {
                  if (nameController.text.trim().isEmpty) {
                    return;
                  }
                  closeFlow();
                },
                onSubmitted: (_) {
                  if (nameController.text.trim().isNotEmpty) {
                    closeFlow();
                  }
                },
              );
            },
          ),
        );
      },
      transitionBuilder: _fadeDialogTransition,
    ).whenComplete(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        nameController.dispose();
      });
    });
  }

  /// The modal fades in when opened ([showGeneralDialog] + [FadeTransition]).
  static void _showJoinPartyFlow(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController codeController = TextEditingController();
    // Must live outside [pageBuilder]: Flutter may call [pageBuilder] again
    // during transitions/rebuilds; resetting [step] here caused inconsistent
    // subtrees and framework assertions when dismissing (e.g. X on code step).
    int step = 0;

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel:
          MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (
        BuildContext dialogContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: SDeckSpace.padding24,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              void closeFlow() {
                FocusManager.instance.primaryFocus?.unfocus();
                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }
              }

              if (step == 0) {
                final String raw = nameController.text;
                final bool nameOk = raw.trim().isNotEmpty;
                return SDeckPartyInGameNameInputDialog(
                  controller: nameController,
                  inputState: raw.isEmpty
                      ? SDeckInputState.hint
                      : SDeckInputState.filled,
                  primaryButtonEnabled: nameOk,
                  onChanged: (_) => setState(() {}),
                  onClose: closeFlow,
                  onNext: () {
                    if (nameController.text.trim().isEmpty) {
                      return;
                    }
                    setState(() => step = 1);
                  },
                  onSubmitted: (_) {
                    if (nameController.text.trim().isNotEmpty) {
                      setState(() => step = 1);
                    }
                  },
                );
              }

              final String digits = codeController.text;
              final bool codeComplete = digits.length == 6;
              return SDeckPartyCodeInputDialog(
                controller: codeController,
                inputState: digits.isEmpty
                    ? SDeckInputState.hint
                    : SDeckInputState.filled,
                primaryButtonEnabled: codeComplete,
                onChanged: (_) => setState(() {}),
                onClose: closeFlow,
                onNext: () {
                  if (!codeComplete) {
                    return;
                  }
                  closeFlow();
                },
                onSubmitted: (_) {
                  if (codeComplete) {
                    closeFlow();
                  }
                },
              );
            },
          ),
        );
      },
      transitionBuilder: _fadeDialogTransition,
    ).whenComplete(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        nameController.dispose();
        codeController.dispose();
      });
    });
  }

  static Widget _fadeDialogTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}
