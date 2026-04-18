// -----------------------------------------------------------------------------
// sign_up_validation_state.dart
// -----------------------------------------------------------------------------
// Immutable state class for all async and validation data in the sign-up flow.
//
// This is the ASYNC half of the domain split. It holds validation results,
// error messages, async status, and flow flags — nothing the user typed
// (that lives in sign_up_form_state.dart), and no design system imports.
//
// NOTE:
// Field visual states (SDeckInputState) are NOT stored here. They are derived
// in sign_up_validation_provider.dart as compatibility getters so that page
// files never need to be touched.
//
// The _unset sentinel in copyWith allows callers to explicitly reset a nullable
// field back to null. Without it, passing null would be ambiguous — "leave it
// alone" vs "clear it". Any nullable field that can be cleared must use this.
// -----------------------------------------------------------------------------

import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_async_status.dart';
import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_error_type.dart';

/// Sentinel that lets copyWith distinguish "leave this field alone"
/// from "set this field to null". Never referenced outside this file.
const _unset = Object();

class SignUpValidationState {
  // ---------------------------------------------------------------------------
  // Async status
  // ---------------------------------------------------------------------------

  /// Current lifecycle status of the active (or most recent) async operation.
  final SignUpAsyncStatus status;

  /// Classification of the active error. Drive UI branching off this,
  /// not off error message string comparisons.
  final SignUpErrorType errorType;

  // ---------------------------------------------------------------------------
  // Email
  // ---------------------------------------------------------------------------

  /// Human-readable error for the email field. Null when no error.
  final String? emailErrorMessage;

  /// True once the email has passed both local format and backend availability.
  final bool isEmailValid;

  // ---------------------------------------------------------------------------
  // Password
  // ---------------------------------------------------------------------------

  /// Human-readable error for the password field. Null when no error.
  final String? passwordErrorMessage;

  /// True once the password has passed all validation rules.
  final bool isPasswordValid;

  // ---------------------------------------------------------------------------
  // Confirm password
  // ---------------------------------------------------------------------------

  /// Human-readable error for the confirm-password field. Null when no error.
  final String? confirmPasswordErrorMessage;

  /// True once the confirm-password matches the password field.
  final bool isConfirmPasswordValid;

  // ---------------------------------------------------------------------------
  // Flow flags
  // ---------------------------------------------------------------------------

  /// True after sendVerificationEmail() completes successfully.
  final bool isVerificationSent;

  /// True after reloadCurrentUser() confirms emailVerified == true.
  final bool isEmailVerified;

  // ---------------------------------------------------------------------------
  // Constructor
  // ---------------------------------------------------------------------------

  const SignUpValidationState({
    this.status = SignUpAsyncStatus.idle,
    this.errorType = SignUpErrorType.none,
    this.emailErrorMessage,
    this.isEmailValid = false,
    this.passwordErrorMessage,
    this.isPasswordValid = false,
    this.confirmPasswordErrorMessage,
    this.isConfirmPasswordValid = false,
    this.isVerificationSent = false,
    this.isEmailVerified = false,
  });

  // ---------------------------------------------------------------------------
  // Derived getters
  // ---------------------------------------------------------------------------

  /// True while any async operation is running.
  /// Prefer this over checking status directly in UI code.
  bool get isLoading => status == SignUpAsyncStatus.loading;

  /// True if any field currently carries a validation error.
  bool get hasAnyFieldError =>
      emailErrorMessage != null ||
      passwordErrorMessage != null ||
      confirmPasswordErrorMessage != null;

  // ---------------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------------

  SignUpValidationState copyWith({
    SignUpAsyncStatus? status,
    SignUpErrorType? errorType,
    Object? emailErrorMessage = _unset,
    bool? isEmailValid,
    Object? passwordErrorMessage = _unset,
    bool? isPasswordValid,
    Object? confirmPasswordErrorMessage = _unset,
    bool? isConfirmPasswordValid,
    bool? isVerificationSent,
    bool? isEmailVerified,
  }) {
    return SignUpValidationState(
      status: status ?? this.status,
      errorType: errorType ?? this.errorType,
      emailErrorMessage: emailErrorMessage == _unset
          ? this.emailErrorMessage
          : emailErrorMessage as String?,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      passwordErrorMessage: passwordErrorMessage == _unset
          ? this.passwordErrorMessage
          : passwordErrorMessage as String?,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      confirmPasswordErrorMessage: confirmPasswordErrorMessage == _unset
          ? this.confirmPasswordErrorMessage
          : confirmPasswordErrorMessage as String?,
      isConfirmPasswordValid:
          isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isVerificationSent: isVerificationSent ?? this.isVerificationSent,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  // ---------------------------------------------------------------------------
  // Equality
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignUpValidationState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          errorType == other.errorType &&
          emailErrorMessage == other.emailErrorMessage &&
          isEmailValid == other.isEmailValid &&
          passwordErrorMessage == other.passwordErrorMessage &&
          isPasswordValid == other.isPasswordValid &&
          confirmPasswordErrorMessage == other.confirmPasswordErrorMessage &&
          isConfirmPasswordValid == other.isConfirmPasswordValid &&
          isVerificationSent == other.isVerificationSent &&
          isEmailVerified == other.isEmailVerified;

  @override
  int get hashCode => Object.hash(
        status,
        errorType,
        emailErrorMessage,
        isEmailValid,
        passwordErrorMessage,
        isPasswordValid,
        confirmPasswordErrorMessage,
        isConfirmPasswordValid,
        isVerificationSent,
        isEmailVerified,
      );
}