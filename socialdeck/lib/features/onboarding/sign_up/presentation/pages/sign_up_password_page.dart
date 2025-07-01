import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';

class SignUpPasswordPage extends ConsumerStatefulWidget {
  const SignUpPasswordPage({super.key});

  @override
  ConsumerState<SignUpPasswordPage> createState() => _SignUpPasswordPageState();
}

class _SignUpPasswordPageState extends ConsumerState<SignUpPasswordPage> {
  //*************************** State Variables *******************************//
  String _password = '';

  //*************************** Helper Methods *******************************//
  void _onInputChanged(String value) {
    setState(() {
      _password = value;
    });
    print('Password: $value'); // Keep original functionality
  }

  void _onNextPressed() {
    print('Password: $_password');
    print('Ready for signup!');
    context.push('/sign-up/confirm-password');
  }

  bool get _isNextEnabled => _password.isNotEmpty;

  //*************************** Build Method *********************************//
  @override
  Widget build(BuildContext context) {
    return OnboardingInputTemplate(
      title: "Sign Up",
      fieldLabel: "Password",
      placeholder: "Enter your password",
      inputValue: _password,
      onInputChanged: _onInputChanged,
      onNextPressed: _onNextPressed,
      isNextEnabled: _isNextEnabled,
      keyboardType: TextInputType.visiblePassword,
      isObscureText: true,
      showSocialLogin: false,
      fieldState: _password.isEmpty ? SDeckTextFieldState.hint : SDeckTextFieldState.filled,
    );
  }
}
