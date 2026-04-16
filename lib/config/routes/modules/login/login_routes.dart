// -----------------------------------------------------------------------------
// login_routes.dart
// -----------------------------------------------------------------------------
// Contains GoRoute definitions for the login section of onboarding.
// All login routes use the same fade transition (matches confirm → password flow).
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/login/presentation/pages/login_load_into_main_menu_page.dart';
import 'package:socialdeck/features/login/presentation/pages/login_forgot_password_page.dart';
import 'package:socialdeck/features/login/presentation/pages/login_reset_password_confirm_page.dart';
import 'package:socialdeck/features/login/presentation/pages/login_page.dart';
import 'package:socialdeck/features/login/presentation/pages/login_password_page.dart';
import 'package:socialdeck/features/login/presentation/pages/login_reset_password_page.dart';
import 'package:socialdeck/features/login/presentation/pages/login_confirm_profile_page.dart';

/// Shared login stack transition: fade only (no slide), [SDeckMotion.fade].
CustomTransitionPage<void> _loginFadePage({
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

final List<GoRoute> loginRoutes = [
  GoRoute(
    path: '/login',
    name: 'login',
    pageBuilder:
        (context, state) => _loginFadePage(
          key: state.pageKey,
          child: const LoginPage(),
        ),
  ),

  GoRoute(
    path: '/login/confirm-profile',
    name: 'loginConfirmProfile',
    pageBuilder:
        (context, state) => _loginFadePage(
          key: state.pageKey,
          child: const LoginConfirmProfilePage(),
        ),
  ),

  // Login password page route - password entry (direct from username)
  GoRoute(
    path: '/login/password',
    name: 'loginPassword',
    pageBuilder:
        (context, state) => _loginFadePage(
          key: state.pageKey,
          child: const LoginPasswordPage(),
        ),
  ),

  // Forgot password entry route ([GoRouterState.extra] = email string from login)
  GoRoute(
    path: '/login/forgot-password',
    name: 'loginForgotPassword',
    pageBuilder: (context, state) {
      final extra = state.extra;
      final email = extra is String ? extra : '';
      return _loginFadePage(
        key: state.pageKey,
        child: LoginForgotPasswordPage(emailForDisplay: email),
      );
    },
  ),

  GoRoute(
    path: '/login/reset-password',
    name: 'loginResetPassword',
    pageBuilder:
        (context, state) => _loginFadePage(
          key: state.pageKey,
          child: const LoginResetPasswordPage(),
        ),
  ),

  GoRoute(
    path: '/login/reset-password/confirm',
    name: 'loginResetPasswordConfirm',
    pageBuilder: (context, state) {
      final extra = state.extra;
      final pwd = extra is String ? extra : '';
      return _loginFadePage(
        key: state.pageKey,
        child: LoginResetPasswordConfirmPage(newPassword: pwd),
      );
    },
  ),

  GoRoute(
    path: '/login/load-into-main-menu',
    name: 'loginLoadIntoMainMenu',
    pageBuilder:
        (context, state) => _loginFadePage(
          key: state.pageKey,
          child: const LoginLoadIntoMainMenuPage(),
        ),
  ),
];
