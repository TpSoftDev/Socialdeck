import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';

class SignUpConfirmPasswordPage extends ConsumerStatefulWidget {
  const SignUpConfirmPasswordPage({super.key});

  @override
  ConsumerState<SignUpConfirmPasswordPage> createState() =>
      _SignUpConfirmPasswordPageState();
}

class _SignUpConfirmPasswordPageState
    extends ConsumerState<SignUpConfirmPasswordPage> {
  //*************************** State Variables *******************************//
  String _password = ''; // First field: Create Password
  String _confirmPassword = ''; // Second field: Confirm Password

  //*************************** Helper Methods ********************************//
  void _onPasswordChanged(String value) {
    setState(() {
      _password = value;
    });
    print('Password: $value'); // Same as your other pages
  }

  void _onConfirmPasswordChanged(String value) {
    setState(() {
      _confirmPassword = value;
    });
    print('Confirm Password: $value'); // Same pattern
  }

  void _onNextPressed() {
    print('Password: $_password');
    print('Confirm Password: $_confirmPassword');
    print('Ready for final signup!');
    context.push('/sign-up/verify-account');
  }

  bool get _isNextEnabled =>
      _password.isNotEmpty && _confirmPassword.isNotEmpty;

  //*************************** Field State Logic *****************************//
  SDeckTextFieldState _getPasswordState() {
    if (_password.isEmpty) return SDeckTextFieldState.hint;
    return SDeckTextFieldState.filled;
  }

  SDeckTextFieldState _getConfirmPasswordState() {
    if (_confirmPassword.isEmpty) return SDeckTextFieldState.hint;
    return SDeckTextFieldState.filled;
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return OnboardingInputTemplate(
      title: "Sign Up",
      fieldLabel: "Create Password",
      placeholder: "Enter your password",
      inputValue: _password,
      onInputChanged: _onPasswordChanged,
      onNextPressed: _onNextPressed,
      isNextEnabled: _isNextEnabled,
      isObscureText: true,
      showSocialLogin: false,
      fieldState: _getPasswordState(),

      // Second field parameters
      showSecondField: true,
      secondFieldLabel: "Confirm Password",
      secondPlaceholder: "Confirm your password",
      secondInputValue: _confirmPassword,
      onSecondInputChanged: _onConfirmPasswordChanged,
      secondFieldState: _getConfirmPasswordState(),
      secondFieldObscureText: true,
    );
  }
}
