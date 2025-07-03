// -----------------------------------------------------------------------------
// auth_state_provider.dart
// -----------------------------------------------------------------------------
// Simple authentication state provider for managing login status.
// This provider tracks whether a user is currently logged in or not.
// It works with our existing test data and validation providers.
//
// Later, when we add Firebase Auth, we can easily swap this provider
// for one that watches Firebase Auth state instead.
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StateNotifier that manages the authentication state of the app.
///
/// This provider tracks whether a user is currently logged in or not.
/// It starts with false (not logged in) and can be updated when
/// the user successfully completes authentication.
class AuthStateNotifier extends StateNotifier<bool> {
  /// Initialize with false (user is not logged in)
  AuthStateNotifier() : super(false);

  /// Called when user successfully logs in
  ///
  /// This should be called after password validation succeeds
  /// in the login flow.
  void login() {
    print('🔐 User logged in - setting auth state to true');
    state = true;
  }

  /// Called when user logs out
  ///
  /// This will be used when user wants to log out of the app.
  /// For now, it's mainly for testing and future logout functionality.
  void logout() {
    print('🚪 User logged out - setting auth state to false');
    state = false;
  }

  /// Check if user is currently logged in
  ///
  /// This is a getter method that returns the current auth state.
  /// Returns true if logged in, false if not.
  bool get isLoggedIn => state;
}

//------------------------------- authStateProvider variable -----------------------------//
final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>(
  (ref) => AuthStateNotifier(),
);
