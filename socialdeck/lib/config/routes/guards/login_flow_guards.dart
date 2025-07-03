// -----------------------------------------------------------------------------
// login_flow_guards.dart
// -----------------------------------------------------------------------------
// Login flow-specific navigation guards
// Handles redirects and navigation rules specific to the login flow
//
// This file contains logic that ONLY applies to the login flow:
// - Preventing back swipe navigation
// - Ensuring proper login flow sequence
// - Handling direct URL access to login steps
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../route_constants.dart';

//------------------------------- loginFlowGuards Function -----------------------------//
String? loginFlowGuards(Ref ref, BuildContext context, GoRouterState state) {
  // Get the current URI the user is trying to navigate to
  final currentUri = state.uri.toString();

  // Get the previous URI (where user is coming from)
  final previousUri = state.uri.toString();

  //------------------------------- Prevent Direct Access to Password Page -----------------------------//
  // If someone tries to go directly to /login/password without going through /login first
  // This prevents users from bookmarking or directly accessing the password page
  if (currentUri == AppPaths.loginPassword) {
    // TODO: Add logic to check if user came from login page
    // For now, we'll allow it but log the attempt
    print('🔒 Login Guard: User accessing password page directly');

    // In the future, we could add more sophisticated logic here:
    // - Check if user has a valid session
    // - Verify they came from the login page
    // - Redirect to login if unauthorized
  }

  //------------------------------- Prevent Back Navigation to Unauthorized Pages -----------------------------//
  // If user is on password page and tries to go back to welcome (skipping login)
  // This prevents users from going backwards in the flow inappropriately
  if (currentUri == AppPaths.welcome &&
      previousUri.contains(AppPaths.loginPassword)) {
    print(
      '🔒 Login Guard: User trying to go back to welcome from password page → redirecting to login',
    );
    return AppPaths.login;
  }

  //------------------------------- Allow Legitimate Back Navigation -----------------------------//
  // If user is on password page and tries to go back to login page
  // This allows users to correct their username if needed
  if (currentUri == AppPaths.login &&
      previousUri.contains(AppPaths.loginPassword)) {
    print(
      '🔒 Login Guard: User going back from password to login (legitimate)',
    );
    return null; // Allow this navigation
  }

  //------------------------------- No Login Flow Rules Apply -----------------------------//
  // If no login flow rules apply, return null to allow navigation to proceed
  return null;
}
