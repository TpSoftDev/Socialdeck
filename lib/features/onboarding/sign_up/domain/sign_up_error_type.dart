// -----------------------------------------------------------------------------
// sign_up_error_type.dart
// -----------------------------------------------------------------------------
// Error classification enum for the sign-up flow.
//
// Lets the provider set the error type once and the UI branch on it — instead
// of comparing against hardcoded error message strings. If copy changes, only
// the provider message needs updating, not the branching logic in page files.
// -----------------------------------------------------------------------------

enum SignUpErrorType {
  /// No error. Default state.
  none,

  /// The email address is already registered to an existing account.
  duplicateEmail,

  /// The email address is not formatted correctly.
  invalidEmail,

  /// The email field was submitted empty.
  emptyEmail,

  /// The password does not meet the minimum strength requirements.
  weakPassword,

  /// The password field was submitted empty.
  emptyPassword,

  /// The confirm-password field does not match the password field.
  passwordMismatch,

  /// The confirm-password field was submitted empty.
  emptyConfirmPassword,

  /// A network connectivity problem occurred.
  networkError,

  /// An unexpected error with no specific classification.
  unknownError,
}
