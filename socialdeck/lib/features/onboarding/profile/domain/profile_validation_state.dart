import 'package:socialdeck/design_system/components/inputs/sdeck_text_field.dart';

/// Holds the validation state for the profile username step.
/// Used by the ProfileValidationProvider to drive UI feedback and logic.
class ProfileValidationState {
  /// Controls the visual state of the username text field (neutral, error, success, loading).
  final SDeckTextFieldState usernameFieldState;

  /// Error message to display below the field (if any).
  final String? errorMessage;

  /// Note message to display below the field (if any, and no error).
  final String? noteMessage;

  /// Whether an async check (e.g., username availability) is in progress.
  final bool isLoading;

  /// Whether the username is valid and available.
  final bool isUsernameValid;

  /// Constructor with named parameters and sensible defaults.
  const ProfileValidationState({
    this.usernameFieldState = SDeckTextFieldState.hint,
    this.errorMessage,
    this.noteMessage,
    this.isLoading = false,
    this.isUsernameValid = false,
  });

  /// Returns a copy of this state with the given fields updated.
  /// This is the standard Dart pattern for immutable state updates.
  ProfileValidationState copyWith({
    SDeckTextFieldState? usernameFieldState,
    String? errorMessage,
    String? noteMessage,
    bool? isLoading,
    bool? isUsernameValid,
  }) {
    return ProfileValidationState(
      usernameFieldState: usernameFieldState ?? this.usernameFieldState,
      errorMessage: errorMessage ?? this.errorMessage,
      noteMessage: noteMessage ?? this.noteMessage,
      isLoading: isLoading ?? this.isLoading,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
    );
  }

  /// Override equality and hashCode for value comparison.
  /// This is needed for Riverpod and Flutter to detect state changes correctly.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileValidationState &&
          runtimeType == other.runtimeType &&
          usernameFieldState == other.usernameFieldState &&
          errorMessage == other.errorMessage &&
          noteMessage == other.noteMessage &&
          isLoading == other.isLoading &&
          isUsernameValid == other.isUsernameValid;

  @override
  int get hashCode => Object.hash(
    usernameFieldState,
    errorMessage,
    noteMessage,
    isLoading,
    isUsernameValid,
  );
}
