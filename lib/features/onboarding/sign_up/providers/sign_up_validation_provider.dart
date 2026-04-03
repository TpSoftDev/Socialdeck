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

  // ---------------------------------------------------------------------------
  // Email field visual state
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
  // Password field visual state
  // ---------------------------------------------------------------------------
  SDeckInputState get passwordFieldState {
    if (state.passwordErrorMessage != null) return SDeckInputState.error;
    final password = _ref.read(signUpFormProvider).password;
    if (password.length >= 8) return SDeckInputState.filled;
    return SDeckInputState.hint;
  }

  // ---------------------------------------------------------------------------
  // Confirm password field visual state
  // ---------------------------------------------------------------------------
  SDeckInputState get confirmPasswordFieldState {
    if (state.confirmPasswordErrorMessage != null) return SDeckInputState.error;
    if (_isConfirmPasswordMatching) return SDeckInputState.filled;
    return SDeckInputState.hint;
  }

  // ---------------------------------------------------------------------------
  // Whether the Next button on the password screen should be enabled
  // ---------------------------------------------------------------------------
  bool get isPasswordNextEnabled {
    final password = _ref.read(signUpFormProvider).password;
    return password.length >= 8 && !state.isLoading;
  }

  // ---------------------------------------------------------------------------
  // Whether the Next button on the confirm password screen should be enabled
  // ---------------------------------------------------------------------------
  bool get canSubmitConfirmPassword =>
      _isConfirmPasswordMatching && !state.isLoading;

  // ---------------------------------------------------------------------------
  // Whether to show the password note (8 character requirement hint)
  // Show when there is no error and the password is not yet 8+ chars
  // ---------------------------------------------------------------------------
  bool get showPasswordNote {
    final password = _ref.read(signUpFormProvider).password;
    return state.passwordErrorMessage == null && password.length < 8;
  }

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
        emailErrorMessage: 'Please enter a valid email address.',
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
          emailErrorMessage:
              'An account with this email already exists. Please use a different email or log in.',
          isEmailValid: false,
        );
      case SignUpRepositoryResult.invalidEmail:
        state = state.copyWith(
          status: SignUpAsyncStatus.failure,
          errorType: SignUpErrorType.invalidEmail,
          emailErrorMessage: 'Please enter a valid email address.',
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
        passwordErrorMessage: 'Password must be at least 8 characters.',
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
  // Reads password from form provider directly.
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
        confirmPasswordErrorMessage: "Passwords don't match.",
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
          emailErrorMessage:
              'An account with this email already exists. Please use a different email or log in.',
          isEmailValid: false,
        );
        return false;
      case SignUpRepositoryResult.weakPassword:
        state = state.copyWith(
          status: SignUpAsyncStatus.failure,
          errorType: SignUpErrorType.weakPassword,
          passwordErrorMessage:
              'Password is too weak. Please choose a stronger password.',
          isPasswordValid: false,
        );
        return false;
      case SignUpRepositoryResult.networkError:
        state = state.copyWith(
          status: SignUpAsyncStatus.failure,
          errorType: SignUpErrorType.networkError,
          emailErrorMessage: 'No internet connection. Please try again.',
        );
        return false;
      default:
        state = state.copyWith(
          status: SignUpAsyncStatus.failure,
          errorType: SignUpErrorType.unknownError,
          emailErrorMessage: 'Something went wrong. Please try again.',
        );
        return false;
    }
  }

  // ===========================================================================
  // Send Verification Email
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Sends a verification email to the current Firebase Auth user.
  // No email param — the repository operates on the current user directly.
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