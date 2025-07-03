// -----------------------------------------------------------------------------
// auth_guards.dart
// -----------------------------------------------------------------------------
// Global authentication guards for the entire app
// Handles redirects based on user login status
//
// This file contains the core authentication logic that applies to ALL routes
// regardless of which flow the user is in (login, signup, profile, etc.)
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/onboarding/shared/providers/auth_state_provider.dart';
import '../route_constants.dart';

//------------------------------- authGuards Function -----------------------------//
/// Global authentication guard function
///
/// This function handles authentication-based redirects for the entire app.
/// It runs BEFORE any flow-specific guards to ensure authentication is always checked first.
/// LOGIC:
/// 1. If user IS logged in but tries to visit login/signup pages → redirect to home
/// 2. If user is NOT logged in but tries to visit protected pages → redirect to welcome
/// 3. Otherwise → allow navigation to proceed
String? authGuards(Ref ref, BuildContext context, GoRouterState state) {
  // Check if user is currently logged in using our auth provider
  final isLoggedIn = ref.read(authStateProvider);

  // Get the current URI the user is trying to navigate to
  final currentUri = state.uri.toString();

  //------------------------------- Logged-in User Protection -----------------------------//
  // If user IS logged in but tries to visit login/signup pages
  // → Redirect them to home (they don't need to log in again)
  if (isLoggedIn &&
      (currentUri == AppPaths.login || currentUri == AppPaths.signUp)) {
    return AppPaths.home;
  }

  //------------------------------- Unauthenticated User Protection -----------------------------//
  // If user is NOT logged in but tries to visit protected pages
  // → Redirect them to welcome (they must authenticate first)
  if (!isLoggedIn && currentUri.startsWith(AppPaths.home)) {
    return AppPaths.welcome;
  }

  //------------------------------- No Redirect Needed -----------------------------//
  // If no authentication rules apply, return null to allow navigation to proceed
  return null;
}
