// -----------------------------------------------------------------------------
// login_form_provider.dart
// -----------------------------------------------------------------------------
// Riverpod StateNotifier provider for managing the login form's synchronous state.
// This provider holds and updates the LoginFormState, which is defined in the
// domain layer. It exposes methods to update the form fields and their UI state.
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/login_form_state.dart';
import 'package:socialdeck/design_system/components/inputs/sdeck_text_field.dart';

/// The LoginFormProvider is responsible for managing the state of the login form.
/// It extends StateNotifier, which is a Riverpod class for managing state.
/// The state it manages is a LoginFormState (our immutable state model).
class LoginFormProvider extends StateNotifier<LoginFormState> {
  /// The constructor initializes the provider with the default state.
  LoginFormProvider() : super(const LoginFormState());

  /// Updates the username/email field value in the state.
  ///
  /// This method should be called whenever the user types in the username/email field.
  /// It updates the field value, sets the field visual state to 'filled' if not empty,
  /// or 'hint' if empty, and recalculates whether the Next button should be enabled.
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

  /// Updates the password field value in the state.
  ///
  /// This method should be called whenever the user types in the password field.
  /// It updates the field value, sets the field visual state to 'filled' if not empty,
  /// or 'hint' if empty, and recalculates whether the Next button should be enabled
  /// (for the password screen).
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
}

// -----------------------------------------------------------------------------
// Riverpod provider variable for the login form
// -----------------------------------------------------------------------------
// This is what you use in your UI to watch or update the login form state.
// Example usage:
//   final formState = ref.watch(loginFormProvider);
//   ref.read(loginFormProvider.notifier).updateUsernameOrEmail(value);
final loginFormProvider =
    StateNotifierProvider<LoginFormProvider, LoginFormState>(
      (ref) => LoginFormProvider(),
    );
