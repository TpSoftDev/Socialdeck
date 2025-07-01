// -----------------------------------------------------------------------------
// login_form_state.dart
// -----------------------------------------------------------------------------
// Domain model for the login form's synchronous state in the onboarding flow.
// This class holds all the data needed for the login form UI, including field
// values and their visual state. It is immutable and designed for use with
// Riverpod's StateNotifier, but is not tied to any specific state management.
// -----------------------------------------------------------------------------

// Import the design system's text field state enum for visual consistency
import 'package:socialdeck/design_system/components/inputs/sdeck_text_field.dart';

/// Enum representing the visual state of a text field.
/// - hint: Field is empty, show placeholder/hint style
/// - filled: Field has text, show filled style
/// (Error/success states are handled asynchronously by validation provider)
enum LoginFieldVisualState { hint, filled }

/// Immutable state model for the login form.
/// Holds all synchronous (local) state for the login UI.
class LoginFormState {
  /// The current value of the username or email field.
  final String usernameOrEmail;

  /// The current value of the password field (used on password screen).
  final String password;

  /// Visual state of the username/email field (hint, filled, error, success).
  /// Uses the design system's SDeckTextFieldState for consistency with UI.
  final SDeckTextFieldState usernameFieldState;

  /// Visual state of the password field (hint, filled, error, success).
  /// Uses the design system's SDeckTextFieldState for consistency with UI.
  final SDeckTextFieldState passwordFieldState;

  /// Whether the "Next" button should be enabled (based on field values).
  final bool isNextEnabled;

  /// Constructor with named parameters and sensible defaults.
  const LoginFormState({
    this.usernameOrEmail = '',
    this.password = '',
    this.usernameFieldState = SDeckTextFieldState.hint,
    this.passwordFieldState = SDeckTextFieldState.hint,
    this.isNextEnabled = false,
  });

  /// Returns a copy of this state with the given fields updated.
  /// This is the standard Dart pattern for immutable state.
  LoginFormState copyWith({
    String? usernameOrEmail,
    String? password,
    SDeckTextFieldState? usernameFieldState,
    SDeckTextFieldState? passwordFieldState,
    bool? isNextEnabled,
  }) {
    return LoginFormState(
      usernameOrEmail: usernameOrEmail ?? this.usernameOrEmail,
      password: password ?? this.password,
      usernameFieldState: usernameFieldState ?? this.usernameFieldState,
      passwordFieldState: passwordFieldState ?? this.passwordFieldState,
      isNextEnabled: isNextEnabled ?? this.isNextEnabled,
    );
  }

  // Override equality and hashCode for value comparison (needed for Riverpod)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginFormState &&
          runtimeType == other.runtimeType &&
          usernameOrEmail == other.usernameOrEmail &&
          password == other.password &&
          usernameFieldState == other.usernameFieldState &&
          passwordFieldState == other.passwordFieldState &&
          isNextEnabled == other.isNextEnabled;

  @override
  int get hashCode => Object.hash(
    usernameOrEmail,
    password,
    usernameFieldState,
    passwordFieldState,
    isNextEnabled,
  );
}
 