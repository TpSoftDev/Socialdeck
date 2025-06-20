import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';

class ProfileUsernamePage extends ConsumerStatefulWidget {
  const ProfileUsernamePage({super.key});

  @override
  ConsumerState<ProfileUsernamePage> createState() =>
      _ProfileUsernamePageState();
}

class _ProfileUsernamePageState extends ConsumerState<ProfileUsernamePage> {
  //*************************** State Variables *******************************//
  String _username = '';

  //*************************** Helper Methods ********************************//
  void _onInputChanged(String value) {
    setState(() {
      _username = value;
    });
    print('Username: $value'); // Debug output
  }

  void _onNextPressed() {
    print('Username entered: $_username');
    // Navigate to add profile card screen
    context.push('/profile/add-card');
  }

  bool get _isNextEnabled => _username.isNotEmpty;

  //*************************** Field State Logic *****************************//
  SDeckTextFieldState _getUsernameState() {
    if (_username.isEmpty) return SDeckTextFieldState.hint;
    return SDeckTextFieldState.filled;
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return OnboardingInputTemplate(
      title: "Profile",
      fieldLabel: "Create Username",
      placeholder: "Enter a username",
      inputValue: _username,
      onInputChanged: _onInputChanged,
      onNextPressed: _onNextPressed,
      isNextEnabled: _isNextEnabled,
      isObscureText: false,
      showSocialLogin: false,
      fieldState: _getUsernameState(),
    );
  }
}
