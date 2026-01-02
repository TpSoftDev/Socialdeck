// -----------------------------------------------------------------------------
// login_form_provider.dart
// -----------------------------------------------------------------------------
// Riverpod StateNotifier provider for managing the login form's synchronous state.
// This provider holds and updates the LoginFormState, which is defined in the
// domain layer. It exposes methods to update the form fields and their UI state.
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/login_form_state.dart';
import 'package:socialdeck/design_system/index.dart';

class LoginFormProvider extends StateNotifier<LoginFormState> {
  //------------------------------- Constructor -----------------------------//
  LoginFormProvider() : super(const LoginFormState());

  //------------------------------- updateUsernameOrEmail -----------------------------//
  void updateUsernameOrEmail(String value) {
    // Determine the new visual state for the field
    final isFilled = value.isNotEmpty;
    // Update the state using copyWith (immutable update)
    state = state.copyWith(
      usernameOrEmail: value,
      usernameFieldState:
          isFilled ? SDeckTextFieldState.filled : SDeckTextFieldState.hint,
      // Next button is enabled if the field is not empty
      isNextEnabled: isFilled,
    );
  }

  //------------------------------- updatePassword -----------------------------//
  void updatePassword(String value) {
    // The ternary operator below is a shorthand for:
    // if (isFilled) use SDeckTextFieldState.filled, else use SDeckTextFieldState.hint
    final isFilled = value.isNotEmpty;
    state = state.copyWith(
      password: value,
      passwordFieldState:
          isFilled ? SDeckTextFieldState.filled : SDeckTextFieldState.hint,
      // On the password screen, Next is enabled if password is not empty
      isNextEnabled: isFilled,
    );
  }

  //------------------------------- reset -----------------------------//
  /// Resets the login form state to its default values (empty fields, hint state, button disabled).
  void reset() {
    state = const LoginFormState();
  }
}

// -----------------------------------------------------------------------------
// Riverpod provider variable for the login form
// -----------------------------------------------------------------------------
final loginFormProvider =
    StateNotifierProvider<LoginFormProvider, LoginFormState>(
      (ref) => LoginFormProvider(),
    );
