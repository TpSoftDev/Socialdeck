// -----------------------------------------------------------------------------
// auth_state_provider.dart
// -----------------------------------------------------------------------------
// Firebase authentication state provider for managing login status.
// This provider automatically listens to Firebase Auth state changes
// and provides the current User object (or null if not logged in).
// -----------------------------------------------------------------------------

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StreamProvider that automatically listens to Firebase Auth state changes.
///
/// This provider:
/// - Listens to Firebase Auth state changes in real-time
/// - Returns User? object (User if logged in, null if not logged in)
/// - Automatically updates when user signs in/out with Firebase
/// - No manual login/logout calls needed - Firebase handles everything
final authStateProvider = StreamProvider<User?>((ref) {
  // This stream automatically emits:
  // - User object when someone signs in
  // - null when someone signs out
  // - null when app starts and no one is signed in
  return FirebaseAuth.instance.authStateChanges();
});

/// Helper provider that converts User? to bool for backward compatibility
/// This allows existing code to still check "is logged in" without changes
final isLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(authStateProvider);
  // Return true if we have a user, false if loading or no user
  return user.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Helper provider to get the current user object
/// Use this when you need user details (email, uid, etc.)
final currentUserProvider = Provider<User?>((ref) {
  final user = ref.watch(authStateProvider);
  return user.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});
