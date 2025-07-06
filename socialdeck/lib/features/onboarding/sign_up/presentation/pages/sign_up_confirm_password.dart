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

  /// Controller for the read-only password field
  late final TextEditingController _passwordController;

  //------------------------------- Init State -----------------------------//
  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

//------------------------------- Did Change Dependencies ---------------------//
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Always sync the controller with the provider's password value
    final password = ref.watch(signUpFormProvider).password;
    if (_passwordController.text != password) {
      _passwordController.text = password;
    }
  }

  //------------------------------- Dispose -----------------------------//
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
  /// Proceeds to the next step if passwords match (button only enabled if match)
  void _onNextPressed() {
    context.push('/sign-up/verify-account');
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    // Get the form and validation provider state
    final formState = ref.watch(signUpFormProvider);
    final validation = ref.watch(signUpValidationProvider.notifier);

    return OnboardingInputTemplate(
      title: "Sign Up",
      fieldLabel: "Create Password",
      placeholder: "Enter your password",
      inputValue: formState.password, // Pre-filled from provider
      onInputChanged: (_) {}, // Read-only, not editable here
      isObscureText: _obscurePassword,
      showPasswordToggle: true,
      onPasswordToggle: _togglePasswordVisibility,
      fieldState:
          formState.password.isNotEmpty
              ? SDeckTextFieldState.filled
              : SDeckTextFieldState.hint,
      showSocialLogin: false,
      // Pass the controller and readOnly for the first field
      controller: _passwordController,
      readOnly: true,
      // Second field: Confirm Password
      showSecondField: true,
      secondFieldLabel: "Confirm Password",
      secondPlaceholder: "Confirm your password",
      secondInputValue: formState.confirmPassword,
      onSecondInputChanged: _onConfirmPasswordChanged,
      secondFieldState: validation.confirmPasswordFieldState,
      secondFieldObscureText: _obscureConfirmPassword,
      secondShowPasswordToggle: true, // Show the eye icon for confirm password
      secondOnPasswordToggle:
          _toggleConfirmPasswordVisibility, // Toggle handler
      // Button
      isNextEnabled: validation.canSubmitConfirmPassword,
      onNextPressed: _onNextPressed,
    );
  }
}
