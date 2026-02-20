// -----------------------------------------------------------------------------
// login_form_state.dart
// -----------------------------------------------------------------------------
// Domain model for the login form's synchronous state in the onboarding flow.
// This class holds all the data needed for the login form UI, including field
// values and their visual state. It is immutable and designed for use with
// Riverpod's StateNotifier, but is not tied to any specific state management.
// -----------------------------------------------------------------------------

// Import the design system's text field state enum for visual consistency
import 'package:socialdeck/design_system/index.dart';

//------------------------------- Enums -------------------------------------//
enum LoginFieldVisualState { hint, filled }

//------------------------------- LoginFormState -----------------------------//

// IA: Learned that the domain layer keeps UI state independent from data sources, 
// so this class is purely about the login form's state and doesn't know about repositories or services. 
//This makes it reusable and testable without any dependencies on the rest of the app.
class LoginFormState {
  //------------------------------- Properties -----------------------------//
  final String usernameOrEmail;
  final String password;

  final SDeckTextFieldState usernameFieldState;
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
