/*----------------------- login_confirm_profile_page.dart --------------------*/
// Combined "Reveal Profile" and "Confirm Profile" login step.
// This screen first reveals the user's profile card, then fades in the confirm
// question and actions to match the onboarding flow from Figma.
//
// Usage:
//   LoginConfirmProfilePage is pushed after email validation succeeds.
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import '../../providers/login_validation_provider.dart';

//-------------------------- LoginConfirmProfilePage ------------------------//
class LoginConfirmProfilePage extends ConsumerStatefulWidget {
  const LoginConfirmProfilePage({super.key});

  @override
  ConsumerState<LoginConfirmProfilePage> createState() =>
      _LoginConfirmProfilePageState();
}

//------------------------ _LoginConfirmProfilePageState --------------------//
class _LoginConfirmProfilePageState
    extends ConsumerState<LoginConfirmProfilePage> {
  static const String _profileCardHeroTag = 'login_profile_card_hero';

  // Controls when the confirm content (question + CTA) should fade in.
  bool _showConfirmContent = false;

  // Prevents repeated taps while fade-out navigation transition is running.
  bool _isNavigatingToPassword = false;

  // Fires after the card visual is ready (no photo URL, first decoded network frame,
  // or image error). Waits before revealing confirm content. Only scheduled once.
  bool _revealDelayScheduled = false;
  Timer? _revealTimer;

  //************************* Lifecycle & State ******************************//
  @override
  void initState() {
    super.initState();

    // No remote photo: checkered card is immediate — start confirm copy delay now.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _showConfirmContent) return;
      final photoUrl =
          ref.read(loginValidationProvider).userProfileData?['photoUrl']
              as String?;
      final hasUrl = photoUrl != null && photoUrl.trim().isNotEmpty;
      if (!hasUrl) _scheduleRevealDelayAfterVisualReady();
    });
  }

  @override
  void dispose() {
    _revealTimer?.cancel();
    super.dispose();
  }

  void _scheduleRevealDelayAfterVisualReady() {
    if (!mounted || _showConfirmContent || _revealDelayScheduled) return;
    _revealDelayScheduled = true;
    _revealTimer?.cancel();
    _revealTimer = Timer(SDeckMotionDuration.wait, () {
      _revealTimer = null;
      _revealConfirmContent();
    });
  }

  void _revealConfirmContent() {
    if (!mounted || _showConfirmContent) return;
    setState(() => _showConfirmContent = true);
  }

  //*************************** Helper Methods *******************************//
  // Fades out confirm content before navigating to password.
  Future<void> _onConfirmPressed(BuildContext context) async {
    if (_isNavigatingToPassword) return;

    setState(() {
      _isNavigatingToPassword = true;
      _showConfirmContent = false;
    });

    await Future.delayed(SDeckMotionDuration.slow);
    if (!mounted || !context.mounted) return;
    context.push(AppPaths.loginPassword);
  }

  // Card slot is always filled (checkered base) so something shows immediately;
  // the network photo stacks on top and paints as soon as frames decode.
  Widget _buildProfileCardVisual(double size, String? photoUrl) {
    final trimmed = photoUrl?.trim();
    final hasUrl = trimmed != null && trimmed.isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        SDeckVisualPlaceholder(
          width: size,
          height: size,
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        ),
        if (hasUrl)
          Image.network(
            trimmed,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (frame != null || wasSynchronouslyLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  _scheduleRevealDelayAfterVisualReady();
                });
              }
              return child;
            },
            errorBuilder: (context, error, stackTrace) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                _scheduleRevealDelayAfterVisualReady();
              });
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  //******************************* Build ***********************************//
  @override
  Widget build(BuildContext context) {
    //************************ Provider State ********************************//
    // Pull the reveal-step profile data loaded by `loadRevealProfileForEmail`.
    final validationState = ref.watch(loginValidationProvider);

    // Username comes from the reveal-step Firestore profile map.
    // If the field is missing, fall back to a safe placeholder.
    final username =
        validationState.userProfileData?['username'] as String? ??
        'Unknown User';

    // Optional profile photo URL from Firestore.
    // If missing, fall back to the checkered placeholder card background.
    final photoUrl = validationState.userProfileData?['photoUrl'] as String?;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SDeckTopNavigationBar.backWithTitleOnly(
              title: "Log In",
              onBackPressed: () => context.pop(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SDeckSpace.padding16,
              ),
              child: Column(
                children: [
                  //*********************** Profile Card Visual ***********************//
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final size = constraints.maxWidth;

                      // Tap-to-skip: if the user taps during the reveal delay,
                      // immediately show the confirm content instead of waiting.
                      return Hero(
                        tag: _profileCardHeroTag,
                        child: GestureDetector(
                          onTap: () {
                            if (_showConfirmContent) return;
                            _revealTimer?.cancel();
                            _revealConfirmContent();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              SDeckRadius.borderRadius16,
                            ),
                            child: SizedBox(
                              width: size,
                              height: size,
                              child: _buildProfileCardVisual(size, photoUrl),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: SDeckSpace.gap16),

                  //*********************** Confirm Content (Fades In) ***********************//
                  // Animated confirm section: question + username + action button.
                  AnimatedOpacity(
                    opacity: _showConfirmContent ? 1 : 0,
                    duration: SDeckMotionDuration.normal,
                    curve: SDeckMotionCurve.easeIn,
                    child: Column(
                      children: [
                        Text(
                          username,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.h6.copyWith(
                            color: context.component.textPrimary,
                          ),
                        ),
                        const SizedBox(height: SDeckSpace.gap16),
                        Text(
                          "Is this your profile card?",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: context.component.textSecondary),
                        ),
                        const SizedBox(height: SDeckSpace.gap16),
                        SDeckSolidButton(
                          text: "That's me!",
                          size: SDeckButtonSize.large,
                          shape: SDeckButtonShape.default_,
                          fullWidth: true,
                          onPressed:
                              _isNavigatingToPassword
                                  ? null
                                  : () => _onConfirmPressed(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
