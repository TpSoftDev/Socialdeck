// -----------------------------------------------------------------------------
// sign_up_repository_result.dart
// -----------------------------------------------------------------------------
// Sealed result enum for all sign-up repository operations.
//
// Translates raw FirebaseAuthExceptions into app-friendly outcomes so that
// no Firebase error codes ever reach the domain or UI layers.
//
// NOTE:
// When a new Firebase error case is discovered, add a new value here and
// handle it inside _mapFirebaseAuthException() in firebase_sign_up_repository.dart.
// Never catch FirebaseAuthException anywhere above the data layer.
// -----------------------------------------------------------------------------

enum SignUpRepositoryResult {
  // ---------------------------------------------------------------------------
  // Success
  // ---------------------------------------------------------------------------

  /// Operation completed successfully.
  success,

  // ---------------------------------------------------------------------------
  // Email errors
  // ---------------------------------------------------------------------------

  /// The email address is already registered to an existing account.
  duplicateEmail,

  /// The email address is not formatted correctly.
  invalidEmail,

  // ---------------------------------------------------------------------------
  // Password errors
  // ---------------------------------------------------------------------------

  /// The password does not meet Firebase's minimum strength requirements.
  weakPassword,

  // ---------------------------------------------------------------------------
  // User state errors
  // ---------------------------------------------------------------------------

  /// No signed-in user was found when one was required.
  noCurrentUser,

  /// The user record was not found on the backend.
  userNotFound,

  // ---------------------------------------------------------------------------
  // Infrastructure errors
  // ---------------------------------------------------------------------------

  /// The device has no network connectivity or the request timed out.
  networkError,

  /// An unexpected error occurred that does not map to a known case.
  unknownError,
}