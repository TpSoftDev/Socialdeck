import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_form_provider.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_validation_provider.dart';
import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_validation_state.dart';

class SignUpConfirmPasswordPage extends ConsumerStatefulWidget {
  const SignUpConfirmPasswordPage({super.key});

  @override
  ConsumerState<SignUpConfirmPasswordPage> createState() =>
      _SignUpConfirmPasswordPageState();
}

class _SignUpConfirmPasswordPageState
    extends ConsumerState<SignUpConfirmPasswordPage> {
  //*************************** Local State for Show/Hide Toggles ************//
  /// Controls whether the original password is obscured (hidden) or visible
  bool _obscurePassword = true;

  /// Controls whether the confirm password is obscured (hidden) or visible
  bool _obscureConfirmPassword = true;

  //***************** Controller for the read-only password field ************//
  // Controller for the read-only password field
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final password = ref.read(signUpFormProvider).password;
    _passwordController = TextEditingController(text: password);
  }

  @override
  void didUpdateWidget(covariant SignUpConfirmPasswordPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final password = ref.read(signUpFormProvider).password;
    if (_passwordController.text != password) {
      _passwordController.text = password;
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  //------------------------------- Toggle Password --------------------------//
  /// Toggles the original password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  //------------------------------- Toggle Confirm Password ------------------//
  /// Toggles the confirm password visibility
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  //------------------------------- _onConfirmPasswordChanged ----------------//
  /// Called when the user types in the confirm password field.
  /// Updates the form provider (for UI state)
  void _onConfirmPasswordChanged(String value) {
    ref.read(signUpFormProvider.notifier).updateConfirmPassword(value);
  }

  //------------------------------- _onNextPressed -----------------------------//
  /// Called when the user presses the Next button.
  /// Creates the user account and proceeds to verification if successful.
  void _onNextPressed() async {
    final formState = ref.read(signUpFormProvider);
    final validationNotifier = ref.read(signUpValidationProvider.notifier);

    // Attempt to create the user account
    final success = await validationNotifier.createUser(
      formState.email,
      formState.password,
    );

    if (success && context.mounted) {
      // User created successfully, proceed to verification
      context.push('/sign-up/verify-account');
    }
    // If creation failed, error message will be shown by the validation provider
  }

  //------------------------------- _onBackPressed -----------------------------//
  /// Called when the user presses the custom back button.
  /// Resets password field visual state and navigates to the password entry screen.
  void _onBackPressed() {
    // Clear BOTH password values completely - fresh slate
    ref.read(signUpFormProvider.notifier).updatePassword('');
    ref.read(signUpFormProvider.notifier).updateConfirmPassword('');

    // Reset validation states
    ref.read(signUpValidationProvider.notifier).resetPasswordValidation();
    ref
        .read(signUpValidationProvider.notifier)
        .resetConfirmPasswordValidation();

    // Dismiss the keyboard
    FocusScope.of(context).unfocus();
    // Wait for the keyboard to collapse, then navigate
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.mounted) {
        context.go('/sign-up/password');
      }
    });
  }

  //==================== BUTTON LOGIC HELPERS =============================//
  /// Returns true if the 'email already registered' error is present.
  bool isEmailTakenError(SignUpValidationState validationState) =>
      validationState.emailErrorMessage == "This email is already registered.";

  /// Returns the correct label for the main button based on error state.
  String mainButtonLabel(SignUpValidationState validationState) =>
      isEmailTakenError(validationState) ? 'Change Email' : 'Next';

  /// Returns the correct action for the main button based on error state.
  VoidCallback mainButtonAction(
    BuildContext context,
    SignUpValidationState validationState,
  ) {
    if (isEmailTakenError(validationState)) {
      // Go Back to Email Entry logic
      return () {
        ref.read(signUpFormProvider.notifier).reset();
        ref.read(signUpValidationProvider.notifier).resetAll();
        FocusScope.of(context).unfocus();
        Future.delayed(const Duration(milliseconds: 100), () {
          if (context.mounted) {
            context.push('/sign-up');
          }
        });
      };
    } else {
      // Normal Next logic
      return _onNextPressed;
    }
  }

  /// Returns whether the main button should be enabled.
  /// - Always enabled for 'Use a Different Email'
  /// - Only enabled for 'Next' if validation passes
  bool isMainButtonEnabled(
    SignUpValidationState validationState,
    SignUpValidationProvider validationNotifier,
  ) {
    if (isEmailTakenError(validationState)) return true;
    return validationNotifier.canSubmitConfirmPassword &&
        !validationState.isLoading;
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    // Get the form and validation provider state
    final formState = ref.watch(signUpFormProvider);
    final validationNotifier = ref.watch(signUpValidationProvider.notifier);
    final validationState = ref.watch(signUpValidationProvider);

    // Determine field states based on error
    final passwordFieldState =
        isEmailTakenError(validationState)
            ? SDeckTextFieldState.hint
            : (formState.password.isNotEmpty
                ? SDeckTextFieldState.filled
                : SDeckTextFieldState.hint);
    final confirmPasswordFieldState =
        isEmailTakenError(validationState)
            ? SDeckTextFieldState.hint
            : validationNotifier.confirmPasswordFieldState;

    return PopScope(
      canPop: false, // Block native back/swipe navigation
      child: OnboardingInputTemplate(
        title: "Sign Up",
        fieldLabel: "Create Password",
        placeholder: "Enter your password",
        inputValue: formState.password,
        controller: _passwordController,
        onInputChanged: (_) {},
        isObscureText: _obscurePassword,
        showPasswordToggle: true,
        onPasswordToggle: _togglePasswordVisibility,
        fieldState: passwordFieldState,
        showSocialLogin: false,
        readOnly: true,

        //*************************** Confirm Password Field *******************//
        showSecondField: true,
        secondFieldLabel: "Confirm Password",
        secondPlaceholder: "Confirm your password",
        secondInputValue: formState.confirmPassword,
        onSecondInputChanged: _onConfirmPasswordChanged,
        secondFieldState: confirmPasswordFieldState,
        secondFieldObscureText: _obscureConfirmPassword,
        secondShowPasswordToggle: true,
        secondOnPasswordToggle: _toggleConfirmPasswordVisibility,
        // Show the error under the confirm password field if email is taken
        secondErrorMessage:
            isEmailTakenError(validationState)
                ? validationState.emailErrorMessage
                : null,
        // Only one button, label/action changes with error
        isNextEnabled: isMainButtonEnabled(validationState, validationNotifier),
        onNextPressed: mainButtonAction(context, validationState),
        nextButtonLabel: mainButtonLabel(validationState),
        onBackPressed: _onBackPressed,
      ),
    );
  }
}
