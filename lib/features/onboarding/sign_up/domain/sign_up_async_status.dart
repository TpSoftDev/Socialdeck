// -----------------------------------------------------------------------------
// sign_up_async_status.dart
// -----------------------------------------------------------------------------
// Lifecycle enum for async operations in the sign-up flow.
//
// Replaces the plain isLoading bool so the provider can communicate not just
// "something is running" but also the outcome once it finishes. The UI can
// then react to .success or .failure without needing extra boolean flags.
//
// NOTE:
// Use the isLoading getter on SignUpValidationState rather than comparing
// against this enum directly in UI code.
// -----------------------------------------------------------------------------

enum SignUpAsyncStatus {
  /// No operation in progress. Default state.
  idle,

  /// An async operation is currently running (email check, account creation…).
  loading,

  /// The most recent operation completed successfully.
  success,

  /// The most recent operation failed. Inspect SignUpErrorType for details.
  failure,
}
