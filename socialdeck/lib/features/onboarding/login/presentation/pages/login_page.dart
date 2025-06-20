import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  //*************************** State Variables *******************************//
  String _usernameOrEmail = '';

  //*************************** Helper Methods ********************************//
  void _onInputChanged(String value) {
    setState(() {
      _usernameOrEmail = value;
    });
    print('Email: $value');
  }

  void _onNextPressed() {
    print('Next'); // Keep original functionality
    context.push('/home');
  }

  bool get _isNextEnabled => _usernameOrEmail.isNotEmpty;

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return OnboardingInputTemplate(
      title: "Log In",
      fieldLabel: "Username or email",
      placeholder: "Enter username/email",
      inputValue: _usernameOrEmail,
      onInputChanged: _onInputChanged,
      onNextPressed: _onNextPressed,
      isNextEnabled: _isNextEnabled,
      keyboardType: TextInputType.emailAddress,
      isObscureText: false,
      showSocialLogin: true,
      fieldState: _usernameOrEmail.isEmpty
              ? SDeckTextFieldState.hint
              : SDeckTextFieldState.filled,
    );
  }
}
