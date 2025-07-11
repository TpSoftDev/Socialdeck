import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_form_provider.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_validation_provider.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  @override
  void initState() {
    super.initState();
    // Reset validation state when this page is shown
    Future.microtask(() {
      ref.read(signUpValidationProvider.notifier).resetAll();
    });
  }

  //------------------------------- _onInputChanged -----------------------------//
  /// Called whenever the user types in the email field.
  /// Only updates the form provider (for UI state). No validation yet.
  void _onInputChanged(String value) {
    ref.read(signUpFormProvider.notifier).updateEmail(value);
    // Reset validation state so error message disappears as soon as user types
    ref.read(signUpValidationProvider.notifier).resetEmailValidation();
  }

  //------------------------------- _onNextPressed -----------------------------//
  /// Called when the user presses the Next button.
  /// Only validates email format and then navigates to the password page.
  Future<void> _onNextPressed() async {
    final formState = ref.read(signUpFormProvider);
    final validationNotifier = ref.read(signUpValidationProvider.notifier);

    // Validate email format only
    await validationNotifier.validateEmail(formState.email);
    final validationState = ref.read(signUpValidationProvider);
    if (validationState.isEmailValid && mounted) {
      context.push('/sign-up/password');
    }
    // If not valid, the provider's state will have the error message,
    // and the UI will display it automatically (no need to do anything here)
  }

  //------------------------------- _onBackPressed -----------------------------//
  /// Called when the user presses the custom back button.
  /// Resets state and navigates to the welcome screen.
  void _onBackPressed() {
    // Reset the sign-up form and validation state
    ref.read(signUpFormProvider.notifier).reset();
    ref.read(signUpValidationProvider.notifier).resetEmailValidation();
    // Dismiss the keyboard
    FocusScope.of(context).unfocus();
    // Wait for the keyboard to collapse, then navigate
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.mounted) {
        context.go('/welcome');
      }
    });
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    // Watch the form and validation providers for the latest state
    final formState = ref.watch(signUpFormProvider);
    final validationState = ref.watch(signUpValidationProvider);

    return PopScope(
      canPop: false, // Block native back/swipe navigation
      child: OnboardingInputTemplate(
        title: "Sign Up",
        fieldLabel: "Email",
        placeholder: "Enter your email address",
        inputValue: formState.email,
        onInputChanged: _onInputChanged,
        onNextPressed: _onNextPressed,
        isNextEnabled: formState.isNextEnabled,
        keyboardType: TextInputType.emailAddress,
        isObscureText: false,
        showSocialLogin: true,
        fieldState: validationState.emailFieldState,
        errorMessage: validationState.emailErrorMessage,
        isLoading: validationState.isLoading,
        onBackPressed: _onBackPressed,
      ),
    );
  }
}
