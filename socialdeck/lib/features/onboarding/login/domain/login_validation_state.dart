// -----------------------------------------------------------------------------
// login_validation_state.dart
// -----------------------------------------------------------------------------
// Domain model for login validation state in the onboarding flow.
// This class will hold all the asynchronous validation state including loading,
// error messages, and success states. It follows the same pattern as LoginFormState.
// -----------------------------------------------------------------------------

// Import the design system's text field state enum for visual consistency
import 'package:socialdeck/design_system/components/inputs/sdeck_text_field.dart';

/// Immutable state model for login validation.
///
/// This class will hold all asynchronous validation state that the UI needs to display
/// loading states, error messages, and success feedback.
class LoginValidationState {
  /// Whether validation is currently in progress.
  ///
  /// When true, the UI should show loading indicators (spinners, disabled buttons).
  /// When false, the UI should show the final result (success or error).
  final bool isLoading;

  /// Error message to display to the user if validation failed.
  ///
  /// If null, no error message should be shown.
  /// If not null, the UI should display this message below the relevant field.
  ///
  /// Example messages:
  /// - "Username not found"
  /// - "Incorrect password"
  /// - "Network error. Please try again."
  final String? errorMessage;

  /// Whether the validation was successful (credentials are correct).
  ///
  /// This field tracks whether the user's input passed validation:
  /// - true: Username exists AND password matches (user can proceed)
  /// - false: Username doesn't exist OR password is wrong OR validation not yet run
  ///
  /// Note: This is about the credentials being valid, not about the validation
  /// method running successfully. The method can run successfully and still
  /// return false if the credentials are incorrect.
  final bool isValidationSuccessful;

  /// Visual state of the username field (hint, filled, error, success).
  ///
  /// This field controls the visual appearance of the username text field:
  /// - hint: Default placeholder state
  /// - filled: User has entered text
  /// - error: Validation failed (red border, X icon)
  /// - success: Validation passed (green border, checkmark icon)
  final SDeckTextFieldState usernameFieldState;

  /// Visual state of the password field (hint, filled, error, success).
  ///
  /// This field controls the visual appearance of the password text field:
  /// - hint: Default placeholder state
  /// - filled: User has entered text
  /// - error: Validation failed (red border, X icon)
  /// - success: Validation passed (green border, checkmark icon)
  final SDeckTextFieldState passwordFieldState;

  /// Constructor with named parameters and sensible defaults.
  ///
  /// Default state represents "not yet validated" - no loading, no error, not valid.
  const LoginValidationState({
    this.isLoading = false,
    this.errorMessage,
    this.isValidationSuccessful = false,
    this.usernameFieldState = SDeckTextFieldState.hint,
    this.passwordFieldState = SDeckTextFieldState.hint,
  });

  // Sentinel value to distinguish between 'no update' and 'set to null'.
  static const _noUpdate = Object();

  /// Returns a copy of this state with the given fields updated.
  ///
  /// This is the standard Dart pattern for immutable state updates.
  /// Only the specified fields are changed, all others remain the same.
  ///
  LoginValidationState copyWith({
    bool? isLoading,
    Object? errorMessage = _noUpdate, // Use Object? to allow explicit null
    bool? isValidationSuccessful,
    SDeckTextFieldState? usernameFieldState,
    SDeckTextFieldState? passwordFieldState,
  }) {
    return LoginValidationState(
      isLoading: isLoading ?? this.isLoading,
      // If errorMessage is _noUpdate, keep the old value. If it's anything else (even null), use it.
      errorMessage:
          errorMessage == _noUpdate
              ? this.errorMessage
              : errorMessage as String?,
      isValidationSuccessful:
          isValidationSuccessful ?? this.isValidationSuccessful,
      usernameFieldState: usernameFieldState ?? this.usernameFieldState,
      passwordFieldState: passwordFieldState ?? this.passwordFieldState,
    );
  }

  // Override equality and hashCode for value comparison (needed for Riverpod)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginValidationState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          errorMessage == other.errorMessage &&
          isValidationSuccessful == other.isValidationSuccessful &&
          usernameFieldState == other.usernameFieldState &&
          passwordFieldState == other.passwordFieldState;

  @override
  int get hashCode => Object.hash(
    isLoading,
    errorMessage,
    isValidationSuccessful,
    usernameFieldState,
    passwordFieldState,
  );
}
