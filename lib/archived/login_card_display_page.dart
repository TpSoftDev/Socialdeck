/*-------------------- login_card_display_page.dart -----------------------*/
// ARCHIVED: Login Card Display Page
//
// This file has been archived because the login flow was simplified to remove
// the "Is this your card?" confirmation step. The flow now goes directly from
// username entry to password entry for a faster, smoother experience.
//
// ARCHIVED DATE: [Current Date]
// REASON: Simplified login flow - removed unnecessary confirmation step
// FUTURE USE: May be restored if card confirmation is needed again
//             or could be adapted for profile creation flow
//
// Original User Journey: Login → Enter username → See their profile card → Confirm identity
// New User Journey: Login → Enter username → Enter password → Success
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/features/login/providers/login_form_provider.dart';
import '../features/onboarding/shared/templates/onboarding_login_template.dart';
import 'package:socialdeck/features/login/providers/login_validation_provider.dart';
import 'package:go_router/go_router.dart'; // Add GoRouter for imperative navigation

class LoginCardDisplayPage extends ConsumerWidget {
  const LoginCardDisplayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider for the latest form state.
    final formState = ref.watch(loginFormProvider);

    return OnboardingLoginTemplate(
      title: "Log In",
      subtitle: "Is this your card?",
      username: formState.usernameOrEmail,
      imagePath: null,
      scale: 1.0,
      panX: 0.0,
      panY: 0.0,

      // Confirmation mode - show the two action buttons
      showConfirmationButtons: true,
      primaryButtonText: "Yes, that's me!",
      secondaryButtonText: "No, go back",
      onPrimaryPressed: () => _handleYesPressed(context),
      onSecondaryPressed: () => _handleNoPressed(context, ref),
    );
  }

  // Go to password entry step.
  void _handleYesPressed(BuildContext context) {
    context.push('/login/password');
  }

  // Go back to username entry step.
  void _handleNoPressed(BuildContext context, WidgetRef ref) {
    // Reset the validation state so the username/email field is neutral
    ref.read(loginValidationProvider.notifier).resetUsernameValidation();
    // Pop the current page off the stack (back to username entry)
    context.pop();
  }
}
