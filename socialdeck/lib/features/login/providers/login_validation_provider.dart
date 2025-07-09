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
import '../data/test_login_repository.dart';
import 'package:socialdeck/design_system/components/inputs/sdeck_text_field.dart';

/// The LoginValidationProvider is responsible for managing validation state.
class LoginValidationProvider extends StateNotifier<LoginValidationState> {
  /// Repository for performing validation checks.
  final LoginRepository _repository;

  //------------------------------- Constructor -----------------------------//
  LoginValidationProvider(this._repository)
    : super(const LoginValidationState());

  //------------------------------- validateUsername -----------------------------//
  /// This method should be called when the user presses Next on the username screen.
  /// It shows loading state, calls the repository to check username existence,
  /// and updates the UI state based on the result.
  Future<void> validateUsername(String username) async {
    // Show loading state
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      usernameFieldState: SDeckTextFieldState.filled,
    );

    // Call repository to check if username exists
    final usernameFound = await _repository.checkUsernameExists(username);

    // Update state based on result
    if (usernameFound) {
      // Username exists - validation successful but no green state for login
      state = state.copyWith(
        isLoading: false,
        isValidationSuccessful: true,
        usernameFieldState: SDeckTextFieldState.filled,
      );
    } else {
      // Username not found - show error state
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Error: Couldn't find an account, try again.",
        usernameFieldState: SDeckTextFieldState.error,
      );
    }
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
      passwordFieldState: SDeckTextFieldState.filled,
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
        // Password is correct - validation successful but no green state for login
        state = state.copyWith(
          isLoading: false,
          isValidationSuccessful: true,
          passwordFieldState:
              SDeckTextFieldState.filled, // Stay in normal filled state
          errorMessage: null, // No error message
        );
      } else {
        // Password is wrong - show error state
        state = state.copyWith(
          isLoading: false,
          isValidationSuccessful: false,
          passwordFieldState: SDeckTextFieldState.error, // Red border, X icon
          errorMessage: "Incorrect password", // Error message for UI
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
          SDeckTextFieldState.hint, // Reset field to neutral state
      isValidationSuccessful: false, // Not validated yet
      isLoading: false, // Not loading
    );
  }

  //------------------------------- resetPasswordValidation -----------------------------//
  /// Resets the password validation state.
  ///
  /// This should be called when the user starts typing in the password field again,
  /// so that the error state and error message disappear and the field returns to normal.
  void resetPasswordValidation() {
    state = state.copyWith(
      errorMessage: null, // Remove any error message
      passwordFieldState:
          SDeckTextFieldState.hint, // Reset field to neutral state
      isValidationSuccessful: false, // Not validated yet
      isLoading: false, // Not loading
    );
  }
}

// -----------------------------------------------------------------------------
// Riverpod provider variable for the login validation
// -----------------------------------------------------------------------------
final loginValidationProvider =
    StateNotifierProvider<LoginValidationProvider, LoginValidationState>(
      (ref) => LoginValidationProvider(TestLoginRepository()),
    );
