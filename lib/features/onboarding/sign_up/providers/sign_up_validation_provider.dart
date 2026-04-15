// -----------------------------------------------------------------------------
// sign_up_validation_provider.dart
// -----------------------------------------------------------------------------
// Riverpod StateNotifier for the sign-up flow's async and validation state.
//
// Owns all async operations and validation logic. Reads raw input from the
// form provider via ref.read(). Exposes compatibility getters so page files
// never need to be touched for UI state derivation.
//
// IMPORTANT:
// - No FirebaseAuth imports here — all backend work goes through the repository
// - Use ref.read() inside methods and getters, never ref.watch()
// - UI field visual states (SDeckInputState) live here as getters, never in
//   the domain state classes
// - Branch on SignUpErrorType, never on error message strings
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/sign_up/data/firebase_sign_up_repository.dart';
import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_async_status.dart';
import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_error_type.dart';
import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_repository.dart';
import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_repository_result.dart';
import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_validation_state.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_form_provider.dart';

// -----------------------------------------------------------------------------
// Repository Provider
// -----------------------------------------------------------------------------

final signUpRepositoryProvider = Provider<SignUpRepository>(
  (ref) => FirebaseSignUpRepository(),
);

// -----------------------------------------------------------------------------
// Validation Provider
// -----------------------------------------------------------------------------

final signUpValidationProvider =
    StateNotifierProvider<SignUpValidationNotifier, SignUpValidationState>(
  (ref) => SignUpValidationNotifier(
    repository: ref.read(signUpRepositoryProvider),
    ref: ref,
  ),
);

// -----------------------------------------------------------------------------
// Notifier
// -----------------------------------------------------------------------------

class SignUpValidationNotifier extends StateNotifier<SignUpValidationState> {
  // ---------------------------------------------------------------------------
  // Dependencies
  // ---------------------------------------------------------------------------

  final SignUpRepository _repository;
  final Ref _ref;

  SignUpValidationNotifier({
    required SignUpRepository repository,
    required Ref ref,
  })  : _repository = repository,
        _ref = ref,
        super(const SignUpValidationState());

  // ===========================================================================
  // Compatibility Getters
  // ===========================================================================
  // These derive SDeckInputState from domain state so page files never need
  // to be touched. ref.read() is used — never ref.watch() inside a notifier.

  // ===========================================================================
  // Email Page — Edge Cases
  // ===========================================================================
  // (1) Email - Empty          → field hint, note visible, Next disabled [BACKEND]
  // (2) Email - Selected       → field focused, note visible, Next disabled
  //                              · focused state handled by [FRONTEND]
  //                              · Next disabled handled by [BACKEND] via isNextEnabled on form state
  // (3) Email - Typed          → field hint, note visible, Next enabled [BACKEND]
  //                              · filled state only updates after keyboard closed [FRONTEND]
  // (4) Email - Invalid Email  → field error, invalid email message shown, Next enabled [BACKEND]
  // (5) Email - Email Already Used → field error, already registered message shown, Next enabled [BACKEND]
  // (6) Email - Retype         → user edits after error, field refocused, note returns, Next disabled
  //                              · refocus handled by [FRONTEND]
  //                              · error cleared and note restored by [BACKEND] resetEmailValidation()
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Email field visual state — drives (1)(3)(4)(5)(6)
  // ---------------------------------------------------------------------------
  SDeckInputState get emailFieldState {
    if (state.errorType == SignUpErrorType.duplicateEmail ||
        state.errorType == SignUpErrorType.invalidEmail ||
        state.errorType == SignUpErrorType.emptyEmail) {
      return SDeckInputState.error;
    }
    if (state.isEmailValid) return SDeckInputState.filled;
    return SDeckInputState.hint;
  }

  // ---------------------------------------------------------------------------
  // Email note copy — drives (1)(2)(3)(6)
  // Shown when there is no error on the email field
  // ---------------------------------------------------------------------------
  String get emailNoteMessage => 'Enter a valid email to get started.';

  // ===========================================================================
  // Password Page — Edge Cases
  // ===========================================================================
  // (1) Password - Empty          → field hint, note visible, Next disabled [BACKEND]
  // (2) Password - Selected       → field focused, note visible, Next disabled
  //                                 · focused state handled by [FRONTEND]
  //                                 · Next disabled handled by [BACKEND] isPasswordNextEnabled
  // (3) Password - Typed          → field hint→filled, note visible, Next enabled [BACKEND]
  // (4) Password - Toggle         → plain text revealed [FRONTEND]
  // (5) Password - Invalid        → field error, error message shown, Next enabled [BACKEND]
  // (6) Password - Action Unavail → field error, unavailable message shown, Next enabled [BACKEND]
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Password field visual state — drives (1)(3)(5)(6)
  // ---------------------------------------------------------------------------
  SDeckInputState get passwordFieldState {
    if (state.passwordErrorMessage != null) return SDeckInputState.error;
    final password = _ref.read(signUpFormProvider).password;
    if (password.length >= 8) return SDeckInputState.filled;
    return SDeckInputState.hint;
  }

  // ---------------------------------------------------------------------------
  // Whether the Next button on the password screen should be enabled
  // Drives (1)(2) → disabled · (3) → enabled
  // ---------------------------------------------------------------------------
  bool get isPasswordNextEnabled {
    final password = _ref.read(signUpFormProvider).password;
    return password.length >= 8 && !state.isLoading;
  }

  // ---------------------------------------------------------------------------
  // Whether to show the password note — drives (1)(2)(3)
  // Shown when there is no error and the password is not yet 8+ chars
  // ---------------------------------------------------------------------------
  bool get showPasswordNote {
    final password = _ref.read(signUpFormProvider).password;
    return state.passwordErrorMessage == null && password.length < 8;
  }

  // ---------------------------------------------------------------------------
  // Password note copy — drives (1)(2)(3)
  // ---------------------------------------------------------------------------
  String get passwordNoteMessage =>
      'Create a strong password: 8+ characters with letters, numbers & symbols.';

  // ===========================================================================
  // Confirm Password Page — Edge Cases
  // ===========================================================================
  // (1) Confirm Password - Empty         → confirm hint, note visible, Next disabled [BACKEND]
  // (2) Confirm Password - Selected      → confirm focused, note visible, Next disabled
  //                                        · focused state handled by [FRONTEND]
  //                                        · Next disabled handled by [BACKEND] canSubmitConfirmPassword
  // (3) Confirm Password - Typed         → confirm hint→filled, note visible, Next enabled [BACKEND]
  // (4) Confirm Password - Toggle        → plain text revealed [FRONTEND]
  // (5) Confirm Password - Does Not Match → confirm error, mismatch message, Next enabled [BACKEND]
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Confirm password field visual state — drives (1)(3)(5)
  // ---------------------------------------------------------------------------
  SDeckInputState get confirmPasswordFieldState {
    if (state.confirmPasswordErrorMessage != null) return SDeckInputState.error;
    if (_isConfirmPasswordMatching) return SDeckInputState.filled;
    return SDeckInputState.hint;
  }

  // ---------------------------------------------------------------------------
  // Whether the Next button on the confirm password screen should be enabled
  // Drives (1)(2) → disabled · (3) → enabled
  // ---------------------------------------------------------------------------
  bool get canSubmitConfirmPassword =>
      _isConfirmPasswordMatching && !state.isLoading;

  // ---------------------------------------------------------------------------
  // Confirm password note copy — drives (1)(2)(3)
  // ---------------------------------------------------------------------------
  String get confirmPasswordNoteMessage =>
      'Re-enter your password to confirm it matches.';

  // ---------------------------------------------------------------------------
  // Private helper — whether confirm password matches password
  // ---------------------------------------------------------------------------
  bool get _isConfirmPasswordMatching {
    final form = _ref.read(signUpFormProvider);
    return form.confirmPassword.isNotEmpty &&
        form.confirmPassword == form.password;
  }

  // ===========================================================================
  // Email Validation
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Validates the email field.
  // Local format check first — only hits the backend if format passes.
  // ---------------------------------------------------------------------------
  Future<void> validateEmail(String email) async {
    final trimmed = email.trim();

    // ------------------------- Local validation ------------------------------//
    if (trimmed.isEmpty) {
      state = state.copyWith(
        status: SignUpAsyncStatus.failure,
        errorType: SignUpErrorType.emptyEmail,
        emailErrorMessage: 'Please enter your email address.',
        isEmailValid: false,
      );
      return;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(trimmed)) {
      state = state.copyWith(
        status: SignUpAsyncStatus.failure,
        errorType: SignUpErrorType.invalidEmail,
        // Figma: Email - Invalid Email
        emailErrorMessage: "Hmm, that doesn't look like a real email. Try again.",
        isEmailValid: false,
      );
      return;
    }

    // ------------------------- Backend validation ----------------------------//
    state = state.copyWith(
      status: SignUpAsyncStatus.loading,
      errorType: SignUpErrorType.none,
      emailErrorMessage: null,
      isEmailValid: false,
    );

    final result = await _repository.validateEmail(trimmed);

    switch (result) {
      case SignUpRepositoryResult.success:
        state = state.copyWith(
          status: SignUpAsyncStatus.success,
          errorType: SignUpErrorType.none,
          emailErrorMessage: null,
          isEmailValid: true,
        );
      case SignUpRepositoryResult.duplicateEmail:
        state = state.copyWith(
          status: SignUpAsyncStatus.failure,
          errorType: SignUpErrorType.duplicateEmail,
          // Figma: Email - Email Already Used
          emailErrorMessage: 'Oops! That email is already registered.',
          isEmailValid: false,
        );
      case SignUpRepositoryResult.invalidEmail:
        state = state.copyWith(
          status: SignUpAsyncStatus.failure,
          errorType: SignUpErrorType.invalidEmail,
          // Figma: Email - Invalid Email
          emailErrorMessage: "Hmm, that doesn't look like a real email. Try again.",
          isEmailValid: false,
        );
      case SignUpRepositoryResult.networkError:
        state = state.copyWith(
          status: SignUpAsyncStatus.failure,
          errorType: SignUpErrorType.networkError,
          emailErrorMessage: 'No internet connection. Please try again.',
          isEmailValid: false,
        );
      default:
        state = state.copyWith(
          status: SignUpAsyncStatus.failure,
          errorType: SignUpErrorType.unknownError,
          emailErrorMessage: 'Something went wrong. Please try again.',
          isEmailValid: false,
        );
    }
  }

  // ===========================================================================
  // Password Validation
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Validates the password field.
  // Pure local logic — no backend call needed for password rules.
  // Drives password page edge case (5) Invalid Password
  // ---------------------------------------------------------------------------
  Future<void> validatePassword(String password) async {
    // ------------------------- Local validation ------------------------------//
    if (password.isEmpty) {
      state = state.copyWith(
        status: SignUpAsyncStatus.failure,
        errorType: SignUpErrorType.emptyPassword,
        passwordErrorMessage: 'Please enter a password.',
        isPasswordValid: false,
      );
      return;
    }

    if (password.length < 8) {
      state = state.copyWith(
        status: SignUpAsyncStatus.failure,
        errorType: SignUpErrorType.weakPassword,
        // Figma: Password - Invalid Password (5)
        passwordErrorMessage:
            'Oops! Make it 8+ characters with letters, numbers & symbols.',
        isPasswordValid: false,
      );
      return;
    }

    state = state.copyWith(
      status: SignUpAsyncStatus.success,
      errorType: SignUpErrorType.none,
      passwordErrorMessage: null,
      isPasswordValid: true,
    );
  }

  // ===========================================================================
  // Confirm Password Validation
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Validates that confirm password matches the password field.
  // Reads both fields from form provider directly.
  // Drives confirm password page edge case (5) Does Not Match
  // ---------------------------------------------------------------------------
  void validateConfirmPassword() {
    final form = _ref.read(signUpFormProvider);

    if (form.confirmPassword.isEmpty) {
      state = state.copyWith(
        status: SignUpAsyncStatus.failure,
        errorType: SignUpErrorType.emptyConfirmPassword,
        confirmPasswordErrorMessage: 'Please confirm your password.',
        isConfirmPasswordValid: false,
      );
      return;
    }

    if (form.confirmPassword != form.password) {
      state = state.copyWith(
        status: SignUpAsyncStatus.failure,
        errorType: SignUpErrorType.passwordMismatch,
        // Figma: Confirm Password - Does Not Match (5)
        confirmPasswordErrorMessage:
            'Re-enter your password to confirm it matches.',
        isConfirmPasswordValid: false,
      );
      return;
    }

    state = state.copyWith(
      status: SignUpAsyncStatus.success,
      errorType: SignUpErrorType.none,
      confirmPasswordErrorMessage: null,
      isConfirmPasswordValid: true,
    );
  }

  // ===========================================================================
  // Create User
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Creates the Firebase Auth user.
  // Returns true on success so the page can navigate immediately.
  // Sets errorType so the confirm password page can branch on it, not on
  // error message strings.
  // Drives password page edge cases (5) Invalid Password · (6) Action Unavailable
  // ---------------------------------------------------------------------------
  Future<bool> createUser(String email, String password) async {
    state = state.copyWith(
      status: SignUpAsyncStatus.loading,
      errorType: SignUpErrorType.none,
      emailErrorMessage: null,
    );

    final result = await _repository.createUser(
      email: email,
      password: password,
    );

    switch (result) {
      case SignUpRepositoryResult.success:
        state = state.copyWith(
          status: SignUpAsyncStatus.success,
          errorType: SignUpErrorType.none,
          isEmailValid: true,
        );
        return true;
      case SignUpRepositoryResult.duplicateEmail:
        state = state.copyWith(
          status: SignUpAsyncStatus.failure,
          errorType: SignUpErrorType.duplicateEmail,
          // Figma: Email - Email Already Used
          emailErrorMessage: 'Oops! That email is already registered.',
          isEmailValid: false,
        );
        return false;
      case SignUpRepositoryResult.weakPassword:
        state = state.copyWith(
          status: SignUpAsyncStatus.failure,
          errorType: SignUpErrorType.weakPassword,
          // Figma: Password - Invalid Password (5)
          passwordErrorMessage:
              'Oops! Make it 8+ characters with letters, numbers & symbols.',
          isPasswordValid: false,
        );
        return false;
      case SignUpRepositoryResult.networkError:
        state = state.copyWith(
          status: SignUpAsyncStatus.failure,
          errorType: SignUpErrorType.networkError,
          // Figma: Password - Action Unavailable (6)
          emailErrorMessage:
              "This action isn't available right now. Try again shortly.",
        );
        return false;
      default:
        state = state.copyWith(
          status: SignUpAsyncStatus.failure,
          errorType: SignUpErrorType.unknownError,
          // Figma: Password - Action Unavailable (6)
          emailErrorMessage:
              "This action isn't available right now. Try again shortly.",
        );
        return false;
    }
  }

  // ===========================================================================
  // Send Verification Email
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Sends a verification email to the current Firebase Auth user.
  // The email param is accepted for call-site compatibility but not used —
  // the repository operates on the current user directly.
  // ---------------------------------------------------------------------------
  Future<void> sendVerificationEmail(String email) async {
    state = state.copyWith(
      status: SignUpAsyncStatus.loading,
      isVerificationSent: false,
    );

    final result = await _repository.sendVerificationEmail();

    switch (result) {
      case SignUpRepositoryResult.success:
        state = state.copyWith(
          status: SignUpAsyncStatus.success,
          isVerificationSent: true,
        );
      default:
        state = state.copyWith(
          status: SignUpAsyncStatus.failure,
          isVerificationSent: false,
        );
    }
  }

  // ===========================================================================
  // Check Verification Status
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Reloads the current user and checks emailVerified.
  // Called by the redirecting page on its polling timer.
  // ---------------------------------------------------------------------------
  Future<void> checkVerificationStatus() async {
    await _repository.reloadCurrentUser();
    final result = await _repository.isCurrentUserEmailVerified();

    if (result == SignUpRepositoryResult.success) {
      state = state.copyWith(
        status: SignUpAsyncStatus.success,
        isEmailVerified: true,
      );
    }
  }

  // ===========================================================================
  // Delete Current User
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Deletes the unverified user — called when changing email before verifying.
  // ---------------------------------------------------------------------------
  Future<void> deleteCurrentUser() async {
    await _repository.deleteCurrentUser();
  }

  // ===========================================================================
  // Reset Methods
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Resets email validation only
  // ---------------------------------------------------------------------------
  void resetEmailValidation() {
    state = state.copyWith(
      status: SignUpAsyncStatus.idle,
      errorType: SignUpErrorType.none,
      emailErrorMessage: null,
      isEmailValid: false,
    );
  }

  // ---------------------------------------------------------------------------
  // Resets password validation only
  // ---------------------------------------------------------------------------
  void resetPasswordValidation() {
    state = state.copyWith(
      status: SignUpAsyncStatus.idle,
      errorType: SignUpErrorType.none,
      passwordErrorMessage: null,
      isPasswordValid: false,
    );
  }

  // ---------------------------------------------------------------------------
  // Resets confirm password validation only
  // ---------------------------------------------------------------------------
  void resetConfirmPasswordValidation() {
    state = state.copyWith(
      status: SignUpAsyncStatus.idle,
      errorType: SignUpErrorType.none,
      confirmPasswordErrorMessage: null,
      isConfirmPasswordValid: false,
    );
  }

  // ---------------------------------------------------------------------------
  // Resets everything back to initial state
  // ---------------------------------------------------------------------------
  void resetAll() {
    state = const SignUpValidationState();
  }
}