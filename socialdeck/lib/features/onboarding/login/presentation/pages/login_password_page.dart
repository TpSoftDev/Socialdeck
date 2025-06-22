/*-------------------- login_password_page.dart ---------------------------*/
// Login Password Page for entering password after card confirmation
// Uses OnboardingLoginTemplate in password mode to maintain card context
// Shows the same tilted card + username while user enters their password
//
// User Journey: Login → Username → Card Confirmation → Password Entry → Success
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import '../../../shared/templates/onboarding_login_template.dart';

class LoginPasswordPage extends ConsumerStatefulWidget {
  const LoginPasswordPage({super.key});

  @override
  ConsumerState<LoginPasswordPage> createState() => _LoginPasswordPageState();
}

class _LoginPasswordPageState extends ConsumerState<LoginPasswordPage> {
  //*************************** State Variables *******************************//
  String _password = '';

  //*************************** Helper Methods ********************************//
  void _onPasswordChanged(String value) {
    setState(() {
      _password = value;
    });
    print('Password: $value'); // Debug output matching your pattern
  }

  void _onNextPressed() {
    print('Password entered: $_password');
    print('Login successful - navigating to home');
    // TODO: Add actual authentication logic here
    context.push('/home'); // Navigate to home for now
  }

  bool get _isNextEnabled => _password.isNotEmpty;

  //*************************** Field State Logic *****************************//
  SDeckTextFieldState _getPasswordState() {
    if (_password.isEmpty) return SDeckTextFieldState.hint;
    return SDeckTextFieldState.filled;
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return OnboardingLoginTemplate(
      // Core parameters - same card context from previous screen
      title: "Log In",
      subtitle: "Enter your password",

      // User context (test data - will come from user state later)
      username: "username", // Same username from card display screen
      imagePath: null, // Shows placeholder for now
      scale: 1.0,
      panX: 0.0,
      panY: 0.0,

      // Password mode - show password field and Next button
      showPasswordField: true,
      passwordValue: _password,
      onPasswordChanged: _onPasswordChanged,
      passwordFieldState: _getPasswordState(),

      // Next button configuration
      showNextButton: true,
      isNextEnabled: _isNextEnabled,
      onNextPressed: _onNextPressed,
    );
  }
}
