// -----------------------------------------------------------------------------
// sign_up_form_state.dart
// -----------------------------------------------------------------------------
// Immutable state class for raw user input during the sign-up flow.
//
// This is the SYNC half of the domain split. It holds only what the user has
// typed — nothing more. No validation results, no async status, no logic,
// no design system imports.
//
// NOTE:
// Field visual states (SDeckInputState) are NOT stored here. They are UI
// concerns and belong as compatibility getters in sign_up_validation_provider.
// The only exception is isNextEnabled — it is a trivial, sync gate on the
// email field that the form provider sets alongside updateEmail().
// -----------------------------------------------------------------------------

class SignUpFormState {
  // ---------------------------------------------------------------------------
  // Fields
  // ---------------------------------------------------------------------------

  /// Raw email string as typed by the user. Not yet validated.
  final String email;

  /// Raw password string as typed by the user. Not yet validated.
  final String password;

  /// Raw confirm-password string as typed by the user.
  final String confirmPassword;

  /// Whether the "Next" button on the email screen should be enabled.
  /// True only when the email field is non-empty.
  final bool isNextEnabled;

  // ---------------------------------------------------------------------------
  // Constructor
  // ---------------------------------------------------------------------------

  const SignUpFormState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isNextEnabled = false,
  });

  // ---------------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------------

  SignUpFormState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    bool? isNextEnabled,
  }) {
    return SignUpFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isNextEnabled: isNextEnabled ?? this.isNextEnabled,
    );
  }

  // ---------------------------------------------------------------------------
  // Equality
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignUpFormState &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          confirmPassword == other.confirmPassword &&
          isNextEnabled == other.isNextEnabled;

  @override
  int get hashCode => Object.hash(
        email,
        password,
        confirmPassword,
        isNextEnabled,
      );
}