// -----------------------------------------------------------------------------
// sign_up_form_state.dart
// -----------------------------------------------------------------------------
// Domain model for the sign-up form's synchronous state in the onboarding flow.
// Holds all the data needed for the sign-up form UI, including field values
// and their visual state. Designed for use with Riverpod's StateNotifier.
// -----------------------------------------------------------------------------

import 'package:socialdeck/design_system/index.dart';

class SignUpFormState {
  // The user's email input
  final String email;

  // The user's password input
  final String password;

  // The user's confirm password input
  final String confirmPassword;

  // Visual state for the email field (hint, filled, error, etc.)
  final SDeckTextFieldState emailFieldState;

  // Visual state for the password field
  final SDeckTextFieldState passwordFieldState;

  // Visual state for the confirm password field
  final SDeckTextFieldState confirmPasswordFieldState;

  // Whether the "Next" button should be enabled for the current step
  final bool isNextEnabled;

  // Constructor with named parameters and sensible defaults for each field.
  const SignUpFormState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.emailFieldState = SDeckTextFieldState.hint,
    this.passwordFieldState = SDeckTextFieldState.hint,
    this.confirmPasswordFieldState = SDeckTextFieldState.hint,
    this.isNextEnabled = false,
  });

  /// Returns a copy of this state with the given fields updated.
  /// This is the standard Dart pattern for immutable state.
  SignUpFormState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    SDeckTextFieldState? emailFieldState,
    SDeckTextFieldState? passwordFieldState,
    SDeckTextFieldState? confirmPasswordFieldState,
    bool? isNextEnabled,
  }) {
    return SignUpFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      emailFieldState: emailFieldState ?? this.emailFieldState,
      passwordFieldState: passwordFieldState ?? this.passwordFieldState,
      confirmPasswordFieldState:
          confirmPasswordFieldState ?? this.confirmPasswordFieldState,
      isNextEnabled: isNextEnabled ?? this.isNextEnabled,
    );
  }

  // -----------------------------------------------------------------------------
  // Equality and hashCode overrides
  // -----------------------------------------------------------------------------
  // These ensure that two SignUpFormState instances with the same values are
  // considered equal. This is important for Riverpod and Flutter to know when
  // to rebuild widgets or update state. It also helps with debugging and testing.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignUpFormState &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          confirmPassword == other.confirmPassword &&
          emailFieldState == other.emailFieldState &&
          passwordFieldState == other.passwordFieldState &&
          confirmPasswordFieldState == other.confirmPasswordFieldState &&
          isNextEnabled == other.isNextEnabled;

  @override
  int get hashCode => Object.hash(
    email,
    password,
    confirmPassword,
    emailFieldState,
    passwordFieldState,
    confirmPasswordFieldState,
    isNextEnabled,
  );
}
