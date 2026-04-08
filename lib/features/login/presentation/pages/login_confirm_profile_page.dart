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

  //************************* Lifecycle & State ******************************//
  @override
  void initState() {
    super.initState();

    // Delay before revealing the confirm content to mimic the "reveal" step.
    Future.delayed(SDeckMotion.fade, () {
      if (!mounted) return;
      setState(() => _showConfirmContent = true);
    });
  }

  //******************************* Build ***********************************//
  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: Column(
                children: [
                  const SizedBox(height: SDeckSpace.gap16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final size = constraints.maxWidth;
                      return Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            SDeckRadius.borderRadius16,
                          ),
                          image: const DecorationImage(
                            image: AssetImage(SDeckIcon.checkeredBackground),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: SDeckSpace.gap16),

                  // Animated "confirm" section: question + username + action button.
                  AnimatedOpacity(
                    opacity: _showConfirmContent ? 1 : 0,
                    duration: SDeckMotion.fade,
                    curve: Curves.easeInOut,
                    child: Column(
                      children: [
                        Text(
                          "eth6nhunt",
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
                          onPressed: () => context.push(AppPaths.loginPassword),
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
