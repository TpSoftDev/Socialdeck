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
  //*************************** Helper Methods *********************************//

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
  /// Triggers async validation and only navigates if the email is valid.
  Future<void> _onNextPressed() async {
    final formState = ref.read(signUpFormProvider);
    final validationNotifier = ref.read(signUpValidationProvider.notifier);

    // Trigger async validation (shows loading spinner)
    await validationNotifier.validateEmail(formState.email);

    // After validation, check if valid
    final validationState = ref.read(signUpValidationProvider);
    if (validationState.isEmailValid) {
      context.push('/sign-up/password');
    }
    // If not valid, error message will be shown by the template
  }

  /// Optionally, handle back navigation to reset state (not required yet)

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    // Watch the form and validation providers for the latest state
    final formState = ref.watch(signUpFormProvider);
    final validationState = ref.watch(signUpValidationProvider);

    return OnboardingInputTemplate(
      title: "Sign Up",
      fieldLabel: "Email",
      placeholder: "Enter your email address",
      inputValue: formState.email, // From provider, not local state
      onInputChanged: _onInputChanged, // Calls both providers
      onNextPressed: _onNextPressed, // Now async, triggers validation
      isNextEnabled:
          formState
              .isNextEnabled, // Enable Next button as soon as the field is non-empty (matches login flow)
      keyboardType: TextInputType.emailAddress,
      isObscureText: false,
      showSocialLogin: true,
      fieldState:
          validationState
              .emailFieldState, // Now read from validation provider (matches login)
      errorMessage: validationState.emailErrorMessage, // Show error if any
      isLoading: validationState.isLoading, // Show spinner if loading
    );
  }
}
