import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/widgets/onboarding_template.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  //*************************** State Variables *******************************//
  String _email = '';

  //*************************** Helper Methods *********************************//
  void _onInputChanged(String value) {
    setState(() {
      _email = value;
    });
    print('Email: $value');
  }

  void _onNextPressed() {
    print('Email Next: $_email');
    context.push('/sign-up/password');
  }

  bool get _isNextEnabled => _email.isNotEmpty;

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      title: "Sign Up",
      fieldLabel: "Email",
      placeholder: "Enter your email address",
      inputValue: _email,
      onInputChanged: _onInputChanged,
      onNextPressed: _onNextPressed,
      isNextEnabled: _isNextEnabled,
      keyboardType: TextInputType.emailAddress,
      isObscureText: false,
      showSocialLogin: true,
      fieldState: _email.isEmpty ? SDeckTextFieldState.hint : SDeckTextFieldState.filled,
    );
  }
}
