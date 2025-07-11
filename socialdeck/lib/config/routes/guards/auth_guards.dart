// -----------------------------------------------------------------------------
// auth_guards.dart
// -----------------------------------------------------------------------------
// Global authentication guard for the entire app.
// Ensures users can only access protected routes if they are logged in,
// have completed onboarding, and (if required) verified their email.
// Redirects users to the correct onboarding step as needed.
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../route_constants.dart';


/// Async global authentication guard for all routes.
Future<String?> authGuards(
  Ref ref,
  BuildContext context,
  GoRouterState state,
) async {
  // Get fresh user data to avoid stale verification status
  final user = FirebaseAuth.instance.currentUser;
  final isLoggedIn = user != null;
  final currentUri = state.uri.toString();

  print(
    'AuthGuards: URI=$currentUri, isLoggedIn=$isLoggedIn, user=${user?.email}',
  );

  // 1. Not logged in → /welcome (only if trying to access protected routes)
  if (!isLoggedIn) {
    if (currentUri.startsWith(AppPaths.home)) {
      print('AuthGuards: Redirecting to welcome (not logged in)');
      return AppPaths.welcome;
    }
    print(
      'AuthGuards: No redirect needed (not logged in, not accessing protected route)',
    );
    return null;
  }

  // 2. Check onboarding status directly from Firestore (bypass provider cache)
  bool onboardingComplete = false;
  try {
    print('AuthGuards: Checking onboarding status for user: ${user?.email}');

    // Read directly from Firestore to avoid provider cache issues
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid);
    final docSnap = await docRef.get();

    if (docSnap.exists) {
      final data = docSnap.data();
      onboardingComplete = (data?['onboardingComplete'] ?? false) as bool;
      print('AuthGuards: Onboarding complete: $onboardingComplete');
    } else {
      print('AuthGuards: No user document found, onboarding not complete');
      onboardingComplete = false;
    }
  } catch (e) {
    // If there's an error reading from Firestore, assume onboarding is not complete
    print('AuthGuards: Error reading onboarding status: $e');
    onboardingComplete = false;
  }

  // 3. Onboarding complete → allow all, except block login/signup
  if (onboardingComplete) {
    if (currentUri == AppPaths.login || currentUri == AppPaths.signUp) {
      print(
        'AuthGuards: Redirecting to home (onboarding complete, trying to access auth routes)',
      );
      return AppPaths.home;
    }
    print('AuthGuards: No redirect needed (onboarding complete)');
    return null;
  }

  // 4. Onboarding NOT complete - only redirect if trying to access protected routes
  if (currentUri.startsWith(AppPaths.home)) {
    // Reload user to get fresh verification status
    await user?.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;

    //    a. Email not verified → /sign-up/verify-account
    if (refreshedUser == null || !refreshedUser.emailVerified) {
      print('AuthGuards: Redirecting to verify account (email not verified)');
      return AppPaths.signUpVerifyAccount;
    }
    //    b. Email verified → /profile/username (or first onboarding step)
    print(
      'AuthGuards: Redirecting to profile username (email verified, onboarding not complete)',
    );
    return AppPaths.profileUsername;
  }

  // Allow navigation if no rules matched
  print('AuthGuards: No redirect needed (no rules matched)');
  return null;
}
