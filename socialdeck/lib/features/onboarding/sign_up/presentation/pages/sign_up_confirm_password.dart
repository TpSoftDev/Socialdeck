import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_form_provider.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_validation_provider.dart';

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

  //*************************** Helper Methods ********************************//
  /// Called when the user types in the confirm password field.
  /// Updates the form provider (for UI state)
  void _onConfirmPasswordChanged(String value) {
    ref.read(signUpFormProvider.notifier).updateConfirmPassword(value);
  }

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

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    // Get the form and validation provider state
    final formState = ref.watch(signUpFormProvider);
    final validation = ref.watch(signUpValidationProvider.notifier);
    final validationState = ref.watch(signUpValidationProvider);

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
        fieldState:
            formState.password.isNotEmpty
                ? SDeckTextFieldState.filled
                : SDeckTextFieldState.hint,
        showSocialLogin: false,
        readOnly: true,
        showSecondField: true,
        secondFieldLabel: "Confirm Password",
        secondPlaceholder: "Confirm your password",
        secondInputValue: formState.confirmPassword,
        onSecondInputChanged: _onConfirmPasswordChanged,
        secondFieldState: validation.confirmPasswordFieldState,
        secondFieldObscureText: _obscureConfirmPassword,
        secondShowPasswordToggle: true,
        secondOnPasswordToggle: _toggleConfirmPasswordVisibility,
        isNextEnabled:
            validation.canSubmitConfirmPassword && !validationState.isLoading,
        onNextPressed: _onNextPressed,
        onBackPressed: _onBackPressed, // Pass custom back button handler
        isLoading: validationState.isLoading,
        errorMessage:
            validationState.emailErrorMessage, // Show user creation errors
      ),
    );
  }
}
