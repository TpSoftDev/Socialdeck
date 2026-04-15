// -----------------------------------------------------------------------------
// sign_up_routes.dart
// -----------------------------------------------------------------------------
// Contains GoRoute definitions for the sign-up section of onboarding.
// Follows the same modularization pattern as login_routes.dart.
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign_up_email.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign_up_password_page.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign_up_confirm_password.dart';

CustomTransitionPage<void> _signUpFadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: SDeckMotion.fade,
    reverseTransitionDuration: SDeckMotion.fade,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeIn,
      );
      return FadeTransition(opacity: curvedAnimation, child: child);
    },
  );
}

final List<GoRoute> signUpRoutes = [
  GoRoute(
    path: '/sign-up',
    name: 'signUp',
    pageBuilder: (context, state) => _signUpFadePage(
      key: state.pageKey,
      child: const SignUpPage(),
    ),
  ),
  GoRoute(
    path: '/sign-up/password',
    name: 'signUpPassword',
    pageBuilder: (context, state) => _signUpFadePage(
      key: state.pageKey,
      child: const SignUpPasswordPage(),
    ),
  ),
  GoRoute(
    path: '/sign-up/confirm-password',
    name: 'signUpConfirmPassword',
    pageBuilder: (context, state) => _signUpFadePage(
      key: state.pageKey,
      child: const SignUpConfirmPasswordPage(),
    ),
  ),
];