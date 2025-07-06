// -----------------------------------------------------------------------------
// sign_up_form_provider.dart
// -----------------------------------------------------------------------------
// Riverpod StateNotifier provider for managing the sign-up form's synchronous state.
// Holds and updates the SignUpFormState, which is defined in the domain layer.
// Exposes methods to update the form fields and their UI state.
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/sign_up_form_state.dart';
import 'package:socialdeck/design_system/components/inputs/sdeck_text_field.dart';

class SignUpFormProvider extends StateNotifier<SignUpFormState> {
  // Constructor: starts with the initial blank state.
  SignUpFormProvider() : super(const SignUpFormState());

  /// Updates the email field and its visual state.
  void updateEmail(String value) {
    final isFilled = value.isNotEmpty;
    state = state.copyWith(
      email: value,
      emailFieldState:
          isFilled ? SDeckTextFieldState.filled : SDeckTextFieldState.hint,
      // Enable Next if email is filled (further validation handled by validation provider)
      isNextEnabled: isFilled,
    );
  }

  /// Updates the password field and its visual state.
  void updatePassword(String value) {
    final isFilled = value.isNotEmpty;
    state = state.copyWith(
      password: value,
      passwordFieldState:
          isFilled ? SDeckTextFieldState.filled : SDeckTextFieldState.hint,
      // Enable Next if password is filled (further validation handled by validation provider)
      isNextEnabled: isFilled,
    );
  }

  /// Updates the confirm password field and its visual state.
  void updateConfirmPassword(String value) {
    final isFilled = value.isNotEmpty;
    state = state.copyWith(
      confirmPassword: value,
      confirmPasswordFieldState:
          isFilled ? SDeckTextFieldState.filled : SDeckTextFieldState.hint,
      // Enable Next if confirm password is filled (further validation handled by validation provider)
      isNextEnabled: isFilled,
    );
  }

  /// Resets the sign-up form state to its default values (empty fields, hint state, button disabled).
  void reset() {
    state = const SignUpFormState();
  }
}

// -----------------------------------------------------------------------------
// Riverpod provider variable for the sign-up form
// -----------------------------------------------------------------------------
final signUpFormProvider =
    StateNotifierProvider<SignUpFormProvider, SignUpFormState>(
      (ref) => SignUpFormProvider(),
    );
