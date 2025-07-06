import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_form_provider.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_validation_provider.dart';

class SignUpPasswordPage extends ConsumerStatefulWidget {
  const SignUpPasswordPage({super.key});

  @override
  ConsumerState<SignUpPasswordPage> createState() => _SignUpPasswordPageState();
}

class _SignUpPasswordPageState extends ConsumerState<SignUpPasswordPage> {
  //*************************** Local State for Password ***********//
  /// Controls whether the password is obscured (hidden) or visible
  bool _obscurePassword = true;

  /// Toggles the password visibility when the eye icon is pressed
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  //*************************** Helper Methods *******************************//

  /// Called whenever the user types in the password field.
  /// Updates the form provider (for UI state) and resets async validation state.
  void _onInputChanged(String value) {
    // Update the synchronous form state (for field visuals, button enablement)
    ref.read(signUpFormProvider.notifier).updatePassword(value);
    // Reset async validation state (clears error/loading)
    ref.read(signUpValidationProvider.notifier).resetPasswordValidation();
  }

  /// Called when the user presses the Next button.
  /// Triggers async validation and only navigates if the password is valid.
  Future<void> _onNextPressed() async {
    final formState = ref.read(signUpFormProvider);
    final validationNotifier = ref.read(signUpValidationProvider.notifier);

    // Trigger async validation (shows loading spinner)
    await validationNotifier.validatePassword(formState.password);

    // After validation, check if valid
    final validationState = ref.read(signUpValidationProvider);
    if (validationState.isPasswordValid) {
      context.push('/sign-up/confirm-password');
    }
    // If not valid, error message will be shown by the template
  }

  //*************************** Build Method *********************************//
  @override
  Widget build(BuildContext context) {
    // Watch the form provider for the latest password input value
    final formState = ref.watch(signUpFormProvider);
    // The raw state object (fields like error, loading, etc.)
    final signUpValidationState = ref.watch(signUpValidationProvider);
    // The provider instance with computed logic/getters
    final signUpValidationController = ref.watch(
      signUpValidationProvider.notifier,
    );

    return OnboardingInputTemplate(
      title: "Sign Up",
      fieldLabel: "Password",
      placeholder: "Enter your password",
      inputValue: formState.password, // From provider, not local state
      onInputChanged: _onInputChanged, // Calls both providers
      onNextPressed: _onNextPressed, // Now async, triggers validation
      isNextEnabled:
          signUpValidationController
              .isPasswordNextEnabled, // From provider logic
      keyboardType: TextInputType.visiblePassword,
      isObscureText: _obscurePassword, // Local state controls visibility
      showPasswordToggle: true, // Show the eye icon for password field
      onPasswordToggle: _togglePasswordVisibility, // Toggle handler
      showSocialLogin: false,
      fieldState:
          signUpValidationController.passwordFieldState, // From provider logic
      errorMessage:
          signUpValidationState.passwordErrorMessage, // Raw error from state
      // Show the note if appropriate, otherwise null (no note)
      noteMessage:
          signUpValidationController.showPasswordNote
              ? "Password must be at least 8 characters long"
              : null,
      isLoading: signUpValidationState.isLoading, // Raw loading state
    );
  }
}
