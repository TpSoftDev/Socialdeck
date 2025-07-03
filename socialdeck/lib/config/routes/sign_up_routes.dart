// -----------------------------------------------------------------------------
// sign_up_routes.dart
// -----------------------------------------------------------------------------
// Contains GoRoute definitions for the sign-up section of onboarding.
// Follows the same modularization pattern as login_routes.dart.
// -----------------------------------------------------------------------------

import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign_up_email.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign_up_password_page.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign_up_confirm_password.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign_up_verify.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign_up_redirecting.dart';

final List<GoRoute> signUpRoutes = [
  // Sign up page route - for new user registration (email entry)
  GoRoute(
    path: '/sign-up',
    name: 'signUp',
    builder: (context, state) => const SignUpPage(),
  ),

  // Sign up password page route - for password creation
  GoRoute(
    path: '/sign-up/password',
    name: 'signUpPassword',
    builder: (context, state) => const SignUpPasswordPage(),
  ),

  // Sign up confirm password page route - for password confirmation
  GoRoute(
    path: '/sign-up/confirm-password',
    name: 'signUpConfirmPassword',
    builder: (context, state) => const SignUpConfirmPasswordPage(),
  ),

  // Sign up verify page route - for email verification
  GoRoute(
    path: '/sign-up/verify-account',
    name: 'signUpVerifyAccount',
    builder: (context, state) => const SignUpVerifyPage(),
  ),

  // Sign up redirecting page route - for redirecting to home
  GoRoute(
    path: '/sign-up/redirecting',
    name: 'signUpRedirecting',
    builder: (context, state) => const SignUpRedirectingPage(),
  ),
];
