/*----------------------- login_confirm_profile_page.dart --------------------*/
// Combined "Reveal Profile" and "Confirm Profile" login step.
// This screen first reveals the user's profile card, then fades in the confirm
// question and actions to match the onboarding flow from Figma.
//
// Usage:
//   LoginConfirmProfilePage is pushed after email validation succeeds.
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
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
  /// Controls when the confirm content (question + CTA) should fade in.
  bool _showConfirmContent = false;

  /// Prevents repeated taps while fade-out navigation transition is running.
  bool _isNavigatingToPassword = false;

  //************************* Lifecycle & State ******************************//
  @override
  void initState() {
    super.initState();

    // Single-screen mapping of a multi-frame Figma sequence:
    // hold reveal state first, then fade in confirm content.
    Future.delayed(SDeckMotion.readingPerLine, () {
      if (!mounted) return;
      setState(() => _showConfirmContent = true);
    });
  }

  //*************************** Helper Methods *******************************//
  /// Fades out confirm content before navigating to password.
  ///
  /// This mirrors the prototype intent where content below the visual transitions
  /// out first, then the next step appears.
  Future<void> _onConfirmPressed(BuildContext context) async {
    if (_isNavigatingToPassword) return;

    setState(() {
      _isNavigatingToPassword = true;
      _showConfirmContent = false;
    });

    await Future.delayed(SDeckMotion.smartAnimate);
    if (!mounted || !context.mounted) return;
    context.push(AppPaths.loginPassword);
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
                  const SizedBox(height: SDeckSpace.gap16),

                  //*********************** Profile Card Visual ***********************//
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final size = constraints.maxWidth;

                      final ImageProvider profileCardImageProvider =
                          (photoUrl != null && photoUrl.trim().isNotEmpty)
                              ? NetworkImage(photoUrl)
                              : const AssetImage(SDeckIcon.checkeredBackground);

                      // Tap-to-skip: if the user taps during the reveal delay,
                      // immediately show the confirm content instead of waiting.
                      return GestureDetector(
                        onTap: () {
                          if (_showConfirmContent) return;
                          setState(() => _showConfirmContent = true);
                        },
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              SDeckRadius.borderRadius16,
                            ),
                            image: DecorationImage(
                              image: profileCardImageProvider,
                              fit: BoxFit.cover,
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
                    duration: SDeckMotion.smartAnimate,
                    curve: Curves.easeIn,
                    child: Column(
                      children: [
                        Text(
                          username,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.h6.copyWith(
                                color: context.component.textPrimary,
                              ),
                        ),
                        const SizedBox(height: SDeckSpace.gap8),
                        Text(
                          "Is this your profile card?",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: context.component.textPrimary,
                              ),
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
