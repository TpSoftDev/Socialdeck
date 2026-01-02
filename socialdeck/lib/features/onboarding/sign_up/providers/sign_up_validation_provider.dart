// -----------------------------------------------------------------------------
// sign_up_validation_provider.dart
// -----------------------------------------------------------------------------
// Riverpod StateNotifier provider for managing sign-up validation state.
// Handles asynchronous validation logic including loading states, error messages,
// and success feedback. Follows the same pattern as LoginValidationProvider.
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/sign_up_validation_state.dart';
import '../data/sign_up_repository.dart';
import '../data/firebase_sign_up_repository.dart';
import 'package:socialdeck/design_system/components/inputs/sdeck_text_field.dart';
import 'sign_up_form_provider.dart';

//*************************** SignUpValidationProvider *************************//
class SignUpValidationProvider extends StateNotifier<SignUpValidationState> {
  final SignUpRepository _repository;
  final Ref ref; // Ref to access other providers (like form provider)

  // Constructor: injects the repository and ref, starts with the initial blank state.
  SignUpValidationProvider(this._repository, this.ref)
    : super(const SignUpValidationState());

  //------------------------------- validateEmail -----------------------------//
  /// Validates the email field format only (no availability check).
  Future<void> validateEmail(String email) async {
    // Set loading state and field to filled
    state = state.copyWith(
      isLoading: true,
      emailErrorMessage: null,
      isEmailValid: false,
      emailFieldState: SDeckTextFieldState.filled,
    );

    // Basic email format validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final isValidFormat = emailRegex.hasMatch(email);

    // Update state based on format validation
    if (isValidFormat) {
      state = state.copyWith(
        isLoading: false,
        emailErrorMessage: null,
        isEmailValid: true,
        emailFieldState: SDeckTextFieldState.filled,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        emailErrorMessage: "Please enter a valid email address.",
        isEmailValid: false,
        emailFieldState: SDeckTextFieldState.error,
      );
    }
  }

  //------------------------------- createUser -----------------------------//
  /// Creates a new user account with the provided email and password.
  /// This is where email availability is actually checked (during creation).
  Future<bool> createUser(String email, String password) async {
    // Set loading state
    state = state.copyWith(
      isLoading: true,
      emailErrorMessage: null,
      isEmailValid: false,
    );

    try {
      // Attempt to create the user (this will check email availability)
      final success = await _repository.createUser(email, password);

      if (success) {
        // User created successfully
        state = state.copyWith(
          isLoading: false,
          emailErrorMessage: null,
          isEmailValid: true,
        );
        return true;
      } else {
        // User creation failed (repository returned false)
        state = state.copyWith(
          isLoading: false,
          emailErrorMessage: "Failed to create account. Please try again.",
          isEmailValid: false,
        );
        return false;
      }
    } catch (e) {
      // Handle specific error cases
      String errorMessage = "An error occurred. Please try again.";

      if (e.toString().contains('Email is already in use') ||
          e.toString().contains('email-already-in-use')) {
        errorMessage =
            "An account with this email already exists. Please use a different email or log in.";
      } else if (e.toString().contains('Invalid email format') ||
          e.toString().contains('invalid-email')) {
        errorMessage = "Please enter a valid email address.";
      } else if (e.toString().contains('weak-password')) {
        errorMessage =
            "Password is too weak. Please choose a stronger password.";
      }

      state = state.copyWith(
        isLoading: false,
        emailErrorMessage: errorMessage,
        isEmailValid: false,
      );
      return false;
    }
  }

  //------------------------------- validatePassword -----------------------------//
  /// Validates the password field (sync/async).
  /// Checks if the password meets all requirements (length, complexity, etc.).
  Future<void> validatePassword(String password) async {
    // Set loading state and field to filled
    state = state.copyWith(
      isLoading: true,
      passwordErrorMessage: null,
      isPasswordValid: false,
      passwordFieldState: SDeckTextFieldState.filled,
    );

    // Call repository to check password rules
    final isPasswordValid = await _repository.validatePasswordRules(password);

    // Update state based on result
    if (isPasswordValid) {
      state = state.copyWith(
        isLoading: false,
        passwordErrorMessage: null,
        isPasswordValid: true,
        passwordFieldState: SDeckTextFieldState.filled,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        passwordErrorMessage: "Password must be at least 8 characters.",
        isPasswordValid: false,
        passwordFieldState: SDeckTextFieldState.error,
      );
    }
  }

  //------------------------------- validateConfirmPassword -----------------------------//
  /// Validates that the confirm password matches the password.
  void validateConfirmPassword(String password, String confirmPassword) {
    // Clear previous error
    state = state.copyWith(
      confirmPasswordErrorMessage: null,
      isConfirmPasswordValid: false,
    );

    // Check if passwords match
    if (password == confirmPassword && confirmPassword.isNotEmpty) {
      state = state.copyWith(
        confirmPasswordErrorMessage: null,
        isConfirmPasswordValid: true,
      );
    } else {
      state = state.copyWith(
        confirmPasswordErrorMessage: "Passwords don't match.",
        isConfirmPasswordValid: false,
      );
    }
  }

  //------------------------------- sendVerificationEmail -----------------------------//
  /// Sends a verification email to the given address.
  Future<void> sendVerificationEmail(String email) async {
    // Set loading state
    state = state.copyWith(isLoading: true, isVerificationSent: false);

    // Call repository to send verification email
    final sent = await _repository.sendVerificationEmail(email);

    // Update state based on result
    state = state.copyWith(isLoading: false, isVerificationSent: sent);
  }

  //------------------------------- resetEmailValidation -----------------------------//
  /// Resets the email validation state (clears error/loading and sets field to hint).
  void resetEmailValidation() {
    state = state.copyWith(
      emailErrorMessage: null,
      isEmailValid: false,
      isLoading: false,
      emailFieldState: SDeckTextFieldState.hint,
    );
  }

  //------------------------------- resetPasswordValidation -----------------------------//
  /// Resets the password validation state (clears error/loading and sets field to hint).
  void resetPasswordValidation() {
    state = state.copyWith(
      passwordErrorMessage: null,
      isPasswordValid: false,
      isLoading: false,
      passwordFieldState: SDeckTextFieldState.hint,
    );
  }

  //------------------------------- resetConfirmPasswordValidation -----------------------------//
  /// Resets the confirm password validation state (clears error).
  void resetConfirmPasswordValidation() {
    state = state.copyWith(
      confirmPasswordErrorMessage: null,
      isConfirmPasswordValid: false,
    );
  }

  //------------------------------- resetAll -----------------------------//
  /// Resets all validation state to initial values.
  void resetAll() {
    state = const SignUpValidationState();
  }

  //==================== Computed Getters for Password UI Logic ====================//

  /// Gets the current password from the form provider
  String get password => ref.watch(signUpFormProvider).password;

  /// Gets the current confirm password from the form provider
  String get confirmPassword => ref.watch(signUpFormProvider).confirmPassword;

  //------------------------------- isConfirmPasswordMatching -----------------------------//
  /// Whether the confirm password matches the original password and is not empty
  bool get isConfirmPasswordMatching =>
      confirmPassword.isNotEmpty && confirmPassword == password;

  //------------------------------- canSubmitConfirmPassword -----------------------------//
  /// Whether the Next button should be enabled on the confirm password page
  /// (Only enabled if confirm password matches and is not empty)
  bool get canSubmitConfirmPassword => isConfirmPasswordMatching;

  //------------------------------- confirmPasswordFieldState -----------------------------//
  /// Field state for the confirm password field:
  /// - Green (success) if passwords match
  /// - Neutral (hint) otherwise
  SDeckTextFieldState get confirmPasswordFieldState =>
      isConfirmPasswordMatching
          ? (SDeckTextFieldState.values.contains(SDeckTextFieldState.success)
              ? SDeckTextFieldState.success
              : SDeckTextFieldState.filled)
          : SDeckTextFieldState.hint;

  //------------------------------- showPasswordNote -----------------------------//
  /// Whether to show the password note (length requirement)
  /// Show if there's no error and password is empty or <8 chars
  bool get showPasswordNote =>
      state.passwordErrorMessage == null &&
      (password.isEmpty || password.length < 8);

  //------------------------------- isPasswordNextEnabled -----------------------------//
  /// Whether the Next button should be enabled (password 8+ chars and not loading)
  bool get isPasswordNextEnabled => password.length >= 8 && !state.isLoading;

  //------------------------------- passwordFieldState -----------------------------//
  /// Field state: error if error, green if valid, neutral otherwise
  SDeckTextFieldState get passwordFieldState =>
      state.passwordErrorMessage != null
          ? SDeckTextFieldState.error
          : password.length >= 8
          ? (SDeckTextFieldState.values.contains(SDeckTextFieldState.success)
              ? SDeckTextFieldState.success
              : SDeckTextFieldState.filled)
          : SDeckTextFieldState.hint;
}

// -----------------------------------------------------------------------------
// Riverpod provider variable for the sign-up validation
// -----------------------------------------------------------------------------
//Switch to test repository when testing locally
final signUpValidationProvider =
    StateNotifierProvider<SignUpValidationProvider, SignUpValidationState>(
      (ref) => SignUpValidationProvider(FirebaseSignUpRepository(), ref),
    );
