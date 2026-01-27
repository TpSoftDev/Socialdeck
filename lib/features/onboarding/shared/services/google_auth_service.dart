// -----------------------------------------------------------------------------
// google_auth_service.dart
// -----------------------------------------------------------------------------
// Service for handling Google authentication from UI components.
// This service coordinates between the UI, repository, and navigation.
// Keeps UI code clean by centralizing the Google sign-in + navigation logic.
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../login/data/firebase_login_repository.dart';

/// Service that handles Google sign-in flow from UI components.
/// Coordinates authentication, error handling, and navigation.
class GoogleAuthService {
  final FirebaseLoginRepository _repository = FirebaseLoginRepository();

  /// Handles complete Google sign-in flow from UI button press.
  ///
  /// What this method does:
  /// 1. Calls your repository to handle Google OAuth
  /// 2. Shows loading/error states appropriately
  /// 3. Navigates to profile username page on success
  /// 4. Handles all error cases gracefully
  ///
  /// Parameters:
  /// - [context]: For navigation and showing error messages
  /// - [ref]: For accessing providers if needed in future
  Future<void> handleGoogleSignIn(BuildContext context, WidgetRef ref) async {
    try {
      print('🎯 GoogleAuthService: Starting sign-in flow...');

      // Step 1: Call your repository's Google sign-in method
      final userCredential = await _repository.signInWithGoogle();

      // Step 2: Handle the result
      if (userCredential != null && userCredential.user != null) {
        // Google sign-in successful!
        final user = userCredential.user!;
        print('🎉 Google sign-in successful for: ${user.email}');

        // Check if this is a new user or returning user
        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
        print('📋 Is new user: $isNewUser');

        // Step 3: Check onboarding status in Firestore
        await _handlePostSignInNavigation(context, user, isNewUser);
      } else {
        // Google sign-in was cancelled or failed
        print('❌ Google sign-in cancelled or failed');

        // Show user-friendly message (optional - could be silent for cancellation)
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Google sign-in was cancelled'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // Handle any unexpected errors not caught by repository
      print('❌ GoogleAuthService error: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google sign-in failed. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Handles navigation after successful Google sign-in based on user's onboarding status.
  ///
  /// Logic:
  /// 1. Check if user has completed onboarding in Firestore
  /// 2. Returning users with complete onboarding → Home
  /// 3. New users or incomplete onboarding → Profile username page
  Future<void> _handlePostSignInNavigation(
    BuildContext context,
    User user,
    bool isNewUser,
  ) async {
    try {
      print('🔍 Checking onboarding status for user: ${user.email}');

      // Check user's onboarding status in Firestore
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      bool onboardingComplete = false;

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        onboardingComplete = userData['onboardingComplete'] ?? false;
        print('📊 Onboarding complete: $onboardingComplete');
      } else {
        print('📝 No user document found - new user needs onboarding');
      }

      // Navigate based on onboarding status
      if (context.mounted) {
        if (onboardingComplete) {
          // Returning user with complete profile → Home
          print('🏠 Navigating returning user to home...');
          context.go('/home');
        } else {
          // New user or incomplete onboarding → Profile setup
          print('👤 Navigating to profile username page...');
          context.go('/profile/username');
        }
      }
    } catch (e) {
      print('❌ Error checking onboarding status: $e');

      // On error, default to profile setup (safer for new users)
      if (context.mounted) {
        print('⚠️ Defaulting to profile setup due to error');
        context.go('/profile/username');
      }
    }
  }

  /// Signs out from Google completely, clearing cached account.
  /// This allows users to choose different Google accounts on next sign-in.
  ///
  /// Perfect for testing with multiple Google accounts during development.
  Future<void> signOutFromGoogle() async {
    try {
      print('🚪 Signing out from Google and clearing cache...');

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Sign out from Google and clear cached account
      await _repository.signOutFromGoogle();

      print('✅ Successfully signed out from Google');
    } catch (e) {
      print('❌ Error signing out from Google: $e');
    }
  }
}

/// Riverpod provider for GoogleAuthService
/// This allows easy access to the service from any widget that uses Riverpod
final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});
