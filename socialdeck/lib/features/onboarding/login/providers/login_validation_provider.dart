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
/// It extends StateNotifier, which is a Riverpod class for managing state.
/// The state it manages is a LoginValidationState (our immutable state model).
class LoginValidationProvider extends StateNotifier<LoginValidationState> {
  /// Repository for performing validation checks.
  ///
  /// This field holds a reference to the repository that will perform
  /// the actual validation (checking usernames, passwords, etc.).
  /// It can be a TestLoginRepository for development or FirebaseLoginRepository
  /// for production.
  final LoginRepository _repository;

  /// The constructor initializes the provider with the repository and default state.
  ///
  /// Parameters:
  /// - repository: The repository to use for validation (injected dependency)
  LoginValidationProvider(this._repository)
    : super(const LoginValidationState());

  /// Validates a username by checking if it exists in the database.
  ///
  /// This method should be called when the user presses Next on the username screen.
  /// It shows loading state, calls the repository to check username existence,
  /// and updates the UI state based on the result.
  ///
  /// Parameters:
  /// - username: The username to validate
  ///`
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
      // Username exists - show success state
      state = state.copyWith(
        isLoading: false,
        isValidationSuccessful: true,
        usernameFieldState: SDeckTextFieldState.success,
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

  /// Validates a password by checking if it matches the username.
  ///
  /// This method should be called when the user presses Next on the password screen.
  /// It shows loading state, calls the repository to check password correctness,
  /// and updates the UI state based on the result.
  ///
  /// Parameters:
  /// - username: The username to validate against
  /// - password: The password to validate

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
        // Password is correct - show success state
        state = state.copyWith(
          isLoading: false,
          isValidationSuccessful: true,
          passwordFieldState:
              SDeckTextFieldState.success, // Green border, checkmark
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
}

// -----------------------------------------------------------------------------
// Riverpod provider variable for the login validation
// -----------------------------------------------------------------------------
// This is what you use in your UI to watch or update the validation state.
// Example usage:
//   final validationState = ref.watch(loginValidationProvider);
//   ref.read(loginValidationProvider.notifier).validateUsername(username);
final loginValidationProvider =
    StateNotifierProvider<LoginValidationProvider, LoginValidationState>(
      (ref) => LoginValidationProvider(TestLoginRepository()),
    );
