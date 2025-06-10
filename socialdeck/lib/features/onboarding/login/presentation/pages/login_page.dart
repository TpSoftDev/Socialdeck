import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:socialdeck/features/onboarding/shared/widgets/onboarding_template.dart';

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
    print('Email: $value'); // Keep original functionality
  }

  void _onNextPressed() {
    print('Next'); // Keep original functionality
  }

  bool get _isNextEnabled => _usernameOrEmail.isNotEmpty;

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      title: "Log In",
      fieldLabel: "Username or Email",
      placeholder: "Enter username/email",
      inputValue: _usernameOrEmail,
      onInputChanged: _onInputChanged,
      onNextPressed: _onNextPressed,
      isNextEnabled: _isNextEnabled,
      keyboardType: TextInputType.emailAddress,
    );
  }
}
