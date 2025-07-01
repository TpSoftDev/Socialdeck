/*-------------------- login_password_page.dart ---------------------------*/
// Login Password Page for entering password after card confirmation
// Uses OnboardingLoginTemplate in password mode to maintain card context
// Shows the same tilted card + username while user enters their password
//
// User Journey: Login → Username → Card Confirmation → Password Entry → Success
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/onboarding/login/providers/login_form_provider.dart';
import '../../../shared/templates/onboarding_login_template.dart';

class LoginPasswordPage extends ConsumerStatefulWidget {
  const LoginPasswordPage({super.key});

  @override
  ConsumerState<LoginPasswordPage> createState() => _LoginPasswordPageState();
}

class _LoginPasswordPageState extends ConsumerState<LoginPasswordPage> {
  //*************************** Helper Methods ********************************//
  /// Called when the user types in the password field.
  /// Updates the provider's state instead of local state.
  void _onPasswordChanged(String value) {
    // Use the provider to update the password field
    ref.read(loginFormProvider.notifier).updatePassword(value);
    print('Password: $value'); // Debug output matching your pattern
  }

  /// Called when the user presses the Next button.
  void _onNextPressed() {
    // Get the current state from the provider
    final currentState = ref.read(loginFormProvider);
    print('Password entered: ${currentState.password}');
    print('Login successful - navigating to home');
    // TODO: Add actual authentication logic here
    context.push('/home'); // Navigate to home for now
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    // Watch the provider for the latest form state.
    // Use loginFormProvider (the provider variable), not LoginFormProvider (the class)
    final formState = ref.watch(loginFormProvider);

    return OnboardingLoginTemplate(
      // Core parameters - same card context from previous screen
      title: "Log In",
      subtitle: "Enter your password",

      // User context (test data - will come from user state later)
      username:
          formState.usernameOrEmail, // Same username from card display screen
      imagePath: null, // Shows placeholder for now
      scale: 1.0,
      panX: 0.0,
      panY: 0.0,

      // Password mode - show password field and Next button
      showPasswordField: true,
      passwordValue: formState.password,
      onPasswordChanged: _onPasswordChanged,
      passwordFieldState: formState.passwordFieldState, // Use provider's state
      // Next button configuration
      showNextButton: true,
      isNextEnabled: formState.isNextEnabled, // Use provider's state
      onNextPressed: _onNextPressed,
    );
  }
}
