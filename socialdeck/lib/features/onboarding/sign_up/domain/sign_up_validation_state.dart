// -----------------------------------------------------------------------------
// sign_up_validation_state.dart
// -----------------------------------------------------------------------------
// Domain model for sign-up validation state in the onboarding flow.
// Holds all asynchronous validation state including loading, error messages,
// and success states. Designed for use with Riverpod's StateNotifier.
// -----------------------------------------------------------------------------

import 'package:socialdeck/design_system/components/inputs/sdeck_text_field.dart';

class SignUpValidationState {
  // Whether an async operation (validation, sending verification) is in progress
  final bool isLoading;

  // Error message for the email field (null if no error)
  final String? emailErrorMessage;

  // Error message for the password field (null if no error)
  final String? passwordErrorMessage;

  // Error message for the confirm password field (null if no error)
  final String? confirmPasswordErrorMessage;

  // Whether the email is valid (format and not taken)
  final bool isEmailValid;

  // Whether the password is valid (meets all rules)
  final bool isPasswordValid;

  // Whether the confirm password matches the password
  final bool isConfirmPasswordValid;

  // Whether the verification email was sent successfully (simulated)
  final bool isVerificationSent;

  // Visual state for the email field (hint, filled, error, etc.)
  final SDeckTextFieldState emailFieldState;

  // Visual state for the password field (hint, filled, error, success, etc.)
  final SDeckTextFieldState passwordFieldState;

  // Sentinel value to distinguish between 'no update' and 'set to null'.
  static const _noUpdate = Object();

  // Constructor with named parameters and sensible defaults for each field.
  const SignUpValidationState({
    this.isLoading = false,
    this.emailErrorMessage,
    this.passwordErrorMessage,
    this.confirmPasswordErrorMessage,
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.isConfirmPasswordValid = false,
    this.isVerificationSent = false,
    this.emailFieldState = SDeckTextFieldState.hint,
    this.passwordFieldState = SDeckTextFieldState.hint,
  });

  /// Returns a copy of this state with the given fields updated.
  /// Uses sentinel values for nullable fields to allow explicit null assignment.
  SignUpValidationState copyWith({
    bool? isLoading,
    Object? emailErrorMessage = _noUpdate,
    Object? passwordErrorMessage = _noUpdate,
    Object? confirmPasswordErrorMessage = _noUpdate,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    bool? isVerificationSent,
    SDeckTextFieldState? emailFieldState,
    SDeckTextFieldState? passwordFieldState,
  }) {
    return SignUpValidationState(
      isLoading: isLoading ?? this.isLoading,
      emailErrorMessage:
          emailErrorMessage == _noUpdate
              ? this.emailErrorMessage
              : emailErrorMessage as String?,
      passwordErrorMessage:
          passwordErrorMessage == _noUpdate
              ? this.passwordErrorMessage
              : passwordErrorMessage as String?,
      confirmPasswordErrorMessage:
          confirmPasswordErrorMessage == _noUpdate
              ? this.confirmPasswordErrorMessage
              : confirmPasswordErrorMessage as String?,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid:
          isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isVerificationSent: isVerificationSent ?? this.isVerificationSent,
      emailFieldState: emailFieldState ?? this.emailFieldState,
      passwordFieldState: passwordFieldState ?? this.passwordFieldState,
    );
  }

  // -----------------------------------------------------------------------------
  // Equality and hashCode overrides
  // -----------------------------------------------------------------------------
  // These ensure that two SignUpValidationState instances with the same values are
  // considered equal. This is important for Riverpod and Flutter to know when
  // to rebuild widgets or update state. It also helps with debugging and testing.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignUpValidationState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          emailErrorMessage == other.emailErrorMessage &&
          passwordErrorMessage == other.passwordErrorMessage &&
          confirmPasswordErrorMessage == other.confirmPasswordErrorMessage &&
          isEmailValid == other.isEmailValid &&
          isPasswordValid == other.isPasswordValid &&
          isConfirmPasswordValid == other.isConfirmPasswordValid &&
          isVerificationSent == other.isVerificationSent &&
          emailFieldState == other.emailFieldState &&
          passwordFieldState == other.passwordFieldState;

  @override
  int get hashCode => Object.hash(
    isLoading,
    emailErrorMessage,
    passwordErrorMessage,
    confirmPasswordErrorMessage,
    isEmailValid,
    isPasswordValid,
    isConfirmPasswordValid,
    isVerificationSent,
    emailFieldState,
    passwordFieldState,
  );
}
