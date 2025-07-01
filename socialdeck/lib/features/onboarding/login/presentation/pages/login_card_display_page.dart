/*-------------------- login_card_display_page.dart -----------------------*/
// Login Card Display Page for showing user's profile card during login
// Simple test page that displays the playing card component with sample data
// Foundation for building the full "Is this your card?" login confirmation screen
//
// User Journey: Login → Enter username → See their profile card → Confirm identity
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/features/onboarding/login/providers/login_form_provider.dart';
import '../../../shared/templates/onboarding_login_template.dart';
import 'package:socialdeck/features/onboarding/login/providers/login_validation_provider.dart';
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
