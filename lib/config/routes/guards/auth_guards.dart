// -----------------------------------------------------------------------------
// auth_guards.dart
// -----------------------------------------------------------------------------
// Global authentication guard for the entire app.
// Ensures users can only access protected routes if they are logged in,
// have completed onboarding, and (if required) verified their email.
// Redirects users to the correct onboarding step as needed.
// -----------------------------------------------------------------------------

// ------------------------------- Imports ------------------------------- //
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/route_constants.dart';
import 'profile_setup_redirect.dart';

// ------------------------------- AuthGuards ------------------------------- //
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
    if (currentUri.startsWith(AppPaths.home) &&
        currentUri != AppPaths.unableToContinue) {
      print('AuthGuards: Redirecting to welcome (not logged in)');
      return AppPaths.welcome;
    }
    print(
      'AuthGuards: No redirect needed (not logged in, not accessing protected route)',
    );
    return null;
  }

  // Setup screens do not need another profile read on every navigation.
  if (!needsProfileStatus(state.uri.path)) return null;

  // 2. Check onboarding status directly from Firestore (bypass provider cache)
  bool onboardingComplete = false;
  try {
    print('AuthGuards: Checking onboarding status for user: ${user.email}');

    // Read directly from Firestore to avoid provider cache issues
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    final docSnap = await docRef.get();

    if (docSnap.exists) {
      final data = docSnap.data();
      onboardingComplete = data?['onboardingComplete'] ?? false;
      print('AuthGuards: Onboarding complete: $onboardingComplete');
    } else {
      print('AuthGuards: No user document found, onboarding not complete');
      onboardingComplete = false;
    }
  } catch (e) {
    // A failed lookup does not prove the profile is missing.
    return null;
  }

  // Discard a response that belongs to an account that has since signed out.
  if (FirebaseAuth.instance.currentUser?.uid != user.uid) {
    return AppPaths.welcome;
  }
  return profileSetupRedirect(state.uri.path, onboardingComplete);
}
