// -----------------------------------------------------------------------------
// login_validation_provider.dart
// -----------------------------------------------------------------------------
// Riverpod StateNotifier provider for managing login validation state.
// This provider handles asynchronous validation logic including loading states,
// error messages, and success feedback. It follows the same pattern as LoginFormProvider.
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/login_validation_state.dart';
import '../data/login_repository.dart';
import '../data/firebase_login_repository.dart';
import 'login_repository_provider.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// The LoginValidationProvider is responsible for managing validation state.
class LoginValidationProvider extends StateNotifier<LoginValidationState> {
  /// Repository for performing validation checks.
  final LoginRepository _repository;

  //------------------------------- Constructor -----------------------------//
  LoginValidationProvider(this._repository)
    : super(const LoginValidationState());


  //------------------------------- loadRevealProfileForEmail -----------------------------//
  /// Loads user profile data for the reveal step after the user enters email and taps Next.
  /// Delegates to [LoginRepository.getRevealProfileByEmail]; does not sign the user in.
  Future<void> loadRevealProfileForEmail(String email) async {
    // 1) Enter loading state and clear stale data from a previous attempt.
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      usernameFieldState: SDeckInputState.filled,
      userProfileData: null,
    );
    // 2) Fetch user document fields for this email (repository = data layer only).
    final profileData = await _repository.getRevealProfileByEmail(email);

    // 3) Success: we have a matching user row 
    if (profileData != null) {
      state = state.copyWith(
        isLoading: false,
        isValidationSuccessful: true,
        usernameFieldState: SDeckInputState.filled,
        userProfileData: profileData,
      );
      return;
    }
    // 4) No row (or unrecoverable error surfaced as null by the repository).
    state = state.copyWith(
      isLoading: false,
      isValidationSuccessful: false,
      errorMessage: "We can’t find an account with this email address.",
      usernameFieldState: SDeckInputState.error,
      userProfileData: null,
    );
  }

  //------------------------------- validatePassword -----------------------------//
  /// This method should be called when the user presses Next on the password screen.
  /// It shows loading state, calls the repository to check password correctness,
  /// and updates the UI state based on the result.
  Future<void> validatePassword(String username, String password) async {
    // Show loading state
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      passwordFieldState: SDeckInputState.filled,
    );

    try {
      // Call repository to check if password is correct
      // This simulates a network call to validate credentials
      final passwordFound = await _repository.validatePassword(
        username,
        password,
      );

      // Update state based on validation result
      if (passwordFound) {
        // Password is correct - now retrieve full profile data
        Map<String, dynamic>? fullProfileData;

        if (_repository is FirebaseLoginRepository) {
          try {
            // Get the current user UID from Firebase Auth
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null) {
              // Retrieve full profile data from Firestore
              fullProfileData = await _repository.getUserProfileData(currentUser.uid);
            }
          } catch (e) {
            print('Error retrieving full profile data: $e');
            // Continue with existing profile data
            fullProfileData = state.userProfileData;
          }
        }

        // Password is correct - validation successful
        state = state.copyWith(
          isLoading: false,
          isValidationSuccessful: true,
          passwordFieldState:
              SDeckInputState.filled, // Stay in normal filled state
          errorMessage: null, // No error message
          userProfileData: fullProfileData ?? state.userProfileData,
        );
      } else {
        // Password is wrong - show error state
        state = state.copyWith(
          isLoading: false,
          isValidationSuccessful: false,
          passwordFieldState: SDeckInputState.error, // Red border, X icon
          errorMessage:
              "The password you entered is incorrect. Please try again.",
        );
      }
    } catch (e) {
      // TODO: Handle errors (final step)
    }
  }

  //------------------------------- resetUsernameValidation -----------------------------//
  /// Resets the username validation state.
  ///
  /// This should be called when the user starts typing in the username field again,
  /// so that the error state and error message disappear and the field returns to normal.
  void resetUsernameValidation() {
    state = state.copyWith(
      errorMessage: null, // Remove any error message
      usernameFieldState:
          SDeckInputState.hint, // Reset field to neutral state
      isValidationSuccessful: false, // Not validated yet
      isLoading: false, // Not loading
      userProfileData: null, // Clear profile data
    );
  }

  //------------------------------- resetPasswordValidation -----------------------------//
  /// Resets the password validation state.
  ///
  /// This should be called when the user starts typing in the password field again,
  /// so that the error state and error message disappear and the field returns to normal.
  /// Note: Does not clear userProfileData since we want to keep showing the user's profile.
  void resetPasswordValidation() {
    state = state.copyWith(
      errorMessage: null, // Remove any error message
      passwordFieldState:
          SDeckInputState.hint, // Reset field to neutral state
      isValidationSuccessful: false, // Not validated yet
      isLoading: false, // Not loading
      // userProfileData is intentionally NOT reset here - keep showing user's profile
    );
  }
}

// -----------------------------------------------------------------------------
// Riverpod provider variable for the login validation
// -----------------------------------------------------------------------------
final loginValidationProvider =
    StateNotifierProvider<LoginValidationProvider, LoginValidationState>(
      (ref) => LoginValidationProvider(ref.watch(loginRepositoryProvider)),
    );
