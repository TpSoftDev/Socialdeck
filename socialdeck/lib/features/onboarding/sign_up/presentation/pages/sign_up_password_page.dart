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

  //------------------------------- _togglePasswordVisibility -----------------------------//
  /// Toggles the password visibility when the eye icon is pressed
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  //------------------------------- _onInputChanged -----------------------------//
  /// Called whenever the user types in the password field.
  /// Updates the form provider (for UI state) and resets async validation state.
  void _onInputChanged(String value) {
    ref.read(signUpFormProvider.notifier).updatePassword(value);
    ref.read(signUpValidationProvider.notifier).resetPasswordValidation();
  }

  //------------------------------- _onNextPressed -----------------------------//
  /// Called when the user presses the Next button.
  /// Triggers async validation and only navigates if the password is valid.
  Future<void> _onNextPressed() async {
    final formState = ref.read(signUpFormProvider);
    final validationNotifier = ref.read(signUpValidationProvider.notifier);
    await validationNotifier.validatePassword(formState.password);
    final validationState = ref.read(signUpValidationProvider);
    if (validationState.isPasswordValid) {
      context.push('/sign-up/confirm-password');
    }
  }

  //------------------------------- _onBackPressed -----------------------------//
  /// Called when the user presses the custom back button.
  /// Resets the entire form and validation state, then navigates to the email entry screen.
  void _onBackPressed() {
    ref.read(signUpFormProvider.notifier).reset();
    ref.read(signUpValidationProvider.notifier).resetAll();
    FocusScope.of(context).unfocus();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.mounted) {
        context.go('/sign-up');
      }
    });
  }

  //*************************** Build Method *********************************//
  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(signUpFormProvider);
    final signUpValidationState = ref.watch(signUpValidationProvider);
    final signUpValidationController = ref.watch(
      signUpValidationProvider.notifier,
    );
    return PopScope(
      canPop: false,
      child: OnboardingInputTemplate(
        title: "Sign Up",
        fieldLabel: "Password",
        placeholder: "Enter your password",
        inputValue: formState.password,
        onInputChanged: _onInputChanged,
        onNextPressed: _onNextPressed,
        isNextEnabled: signUpValidationController.isPasswordNextEnabled,
        keyboardType: TextInputType.visiblePassword,
        isObscureText: _obscurePassword,
        showPasswordToggle: true,
        onPasswordToggle: _togglePasswordVisibility,
        showSocialLogin: false,
        fieldState: signUpValidationController.passwordFieldState,
        errorMessage: signUpValidationState.passwordErrorMessage,
        noteMessage:
            signUpValidationController.showPasswordNote
                ? "Password must be at least 8 characters long"
                : null,
        isLoading: signUpValidationState.isLoading,
        onBackPressed: _onBackPressed,
      ),
    );
  }
}
