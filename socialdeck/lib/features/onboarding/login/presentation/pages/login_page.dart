/*-------------------- login_page.dart -----------------------*/
// Login Page for the onboarding flow
// Simple test page that displays the input template with sample data
// Foundation for building the full login page
//
// User Journey: Login → Enter username → Enter password → Success
/*--------------------------------------------------------------------------*/

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';
import '../../providers/login_form_provider.dart';
import '../../providers/login_validation_provider.dart';
import 'package:go_router/go_router.dart';

//------------------------------- LoginPage -----------------------------//
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  //------------------------------- _onInputChanged -----------------------------//
  void _onInputChanged(String value) {
    // 1. Update the form provider with the new input value
    ref.read(loginFormProvider.notifier).updateUsernameOrEmail(value);

    // 2. Reset the validation provider so error state and message disappear
    ref.read(loginValidationProvider.notifier).resetUsernameValidation();
  }

  //------------------------------- _onNextPressed -----------------------------//
  /// Called when the user presses the Next button.
  /// Validates the username and navigates directly to password entry if successful.
  Future<void> _onNextPressed(BuildContext context) async {
    final currentUsername = ref.read(loginFormProvider).usernameOrEmail;
    // Call the validation provider to check if username exists (async)
    await ref
        .read(loginValidationProvider.notifier)
        .validateUsername(currentUsername);
    // After validation, check the provider state for success
    final validationState = ref.read(loginValidationProvider);
    if (validationState.isValidationSuccessful) {
      // Imperative navigation: push directly to password page (card display step removed)
      if (context.mounted) {
        context.push('/login/password');
      }
    }
  }

  //==================== Build Method ====================//
  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(loginFormProvider);
    final validationState = ref.watch(loginValidationProvider);

    // Custom back button callback: always go to welcome page
    void _onBackPressed() {
      // Reset the login form and validation state so errors and input are cleared on return
      ref.read(loginFormProvider.notifier).reset();
      ref.read(loginValidationProvider.notifier).resetUsernameValidation();
      // Dismiss the keyboard
      FocusScope.of(context).unfocus();
      // Wait for the keyboard to collapse, then navigate
      Future.delayed(const Duration(milliseconds: 100), () {
        if (context.mounted) {
          context.go('/welcome');
        }
      });
    }

    return PopScope(
      canPop:
          false, // Block all native back navigation (swipe-back, device back button)
      child: OnboardingInputTemplate(
        title: "Log In",
        fieldLabel: "Username or email",
        placeholder: "Enter username/email",
        inputValue: formState.usernameOrEmail,
        onInputChanged: _onInputChanged,
        onNextPressed: () => _onNextPressed(context),
        isNextEnabled: formState.isNextEnabled,
        keyboardType: TextInputType.emailAddress,
        isObscureText: false,
        showSocialLogin: true,
        fieldState: validationState.usernameFieldState,
        errorMessage: validationState.errorMessage,
        isLoading: validationState.isLoading,
        // Pass custom back button callback
        onBackPressed: _onBackPressed,
      ),
    );
  }
}
