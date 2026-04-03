// -----------------------------------------------------------------------------
// sign_up_form_provider.dart
// -----------------------------------------------------------------------------
// Riverpod StateNotifier for the sign-up form's synchronous state.
//
// Owns all raw input mutations — nothing else. No async calls, no Firebase,
// no validation logic, no design system imports touching the state shape.
//
// NOTE:
// isNextEnabled is only meaningful on the email screen. updatePassword() and
// updateConfirmPassword() do not touch it — those screens gate their buttons
// via compatibility getters on the validation provider instead.
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_form_state.dart';

// -----------------------------------------------------------------------------
// Provider
// -----------------------------------------------------------------------------

final signUpFormProvider =
    StateNotifierProvider<SignUpFormNotifier, SignUpFormState>(
  (ref) => SignUpFormNotifier(),
);

// -----------------------------------------------------------------------------
// Notifier
// -----------------------------------------------------------------------------

class SignUpFormNotifier extends StateNotifier<SignUpFormState> {
  SignUpFormNotifier() : super(const SignUpFormState());

  // ---------------------------------------------------------------------------
  // Update email
  // Sets isNextEnabled — the only screen that uses this flag.
  // ---------------------------------------------------------------------------
  void updateEmail(String value) {
    state = state.copyWith(
      email: value,
      isNextEnabled: value.isNotEmpty,
    );
  }

  // ---------------------------------------------------------------------------
  // Update password
  // Does not touch isNextEnabled — gated by isPasswordNextEnabled on the
  // validation provider instead.
  // ---------------------------------------------------------------------------
  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  // ---------------------------------------------------------------------------
  // Update confirm password
  // Does not touch isNextEnabled — gated by canSubmitConfirmPassword on the
  // validation provider instead.
  // ---------------------------------------------------------------------------
  void updateConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value);
  }

  // ---------------------------------------------------------------------------
  // Reset — clears all fields back to initial state.
  // ---------------------------------------------------------------------------
  void reset() {
    state = const SignUpFormState();
  }
}