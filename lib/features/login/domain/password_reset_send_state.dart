// -----------------------------------------------------------------------------
// password_reset_send_state.dart
// -----------------------------------------------------------------------------
// State for the "Send password reset link" action (forgot-password screen).
// -----------------------------------------------------------------------------

/// Loading and error feedback while requesting a Firebase reset email.
class PasswordResetSendState {
  final bool isLoading;
  final String? errorMessage;
  final bool emailSent;

  const PasswordResetSendState({
    this.isLoading = false,
    this.errorMessage,
    this.emailSent = false,
  });
}
