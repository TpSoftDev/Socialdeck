import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/profile_validation_state.dart';
import 'package:socialdeck/design_system/index.dart';
import '../data/profile_repository.dart';
import '../data/test_profile_repository.dart';

/// StateNotifier that manages validation logic for the profile username step.
/// Handles both sync (format) and async (availability) checks.
class ProfileValidationProvider extends StateNotifier<ProfileValidationState> {
  final ProfileRepository _repository;

  /// Constructor injects the repository and starts with the initial state.
  ProfileValidationProvider(this._repository)
    : super(
        const ProfileValidationState(
          noteMessage: 'Note: Use letters and numbers only',
        ),
      );

  /// Validates the username when the user presses "Next".
  /// 1. Checks format (sync). If invalid, sets error and returns.
  /// 2. If valid, sets loading, checks availability (async), then updates state.
  Future<void> validateUsername(String username) async {
    // Sync format check: only letters and numbers allowed
    final validFormat = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username);
    if (!validFormat) {
      state = state.copyWith(
        usernameFieldState: SDeckTextFieldState.error,
        errorMessage: 'Error: Use letters and numbers only',
        noteMessage: null,
        isLoading: false,
        isUsernameValid: false,
      );
      return;
    }

    // Passed format check, start async check
    // Use 'filled' for the field state during loading, as per design system
    // 'isLoading' is used to show a spinner/disable the button
    state = state.copyWith(
      usernameFieldState: SDeckTextFieldState.filled,
      errorMessage: null,
      noteMessage: null,
      isLoading: true,
      isUsernameValid: false,
    );

    final available = await _repository.isUsernameAvailable(username);
    if (available) {
      state = state.copyWith(
        usernameFieldState: SDeckTextFieldState.success,
        errorMessage: null,
        noteMessage: null,
        isLoading: false,
        isUsernameValid: true,
      );
    } else {
      state = state.copyWith(
        usernameFieldState: SDeckTextFieldState.error,
        errorMessage: 'Error: This username is taken, try another.',
        noteMessage: null,
        isLoading: false,
        isUsernameValid: false,
      );
    }
  }

  /// Resets the validation state to neutral when the user starts typing again.
  void resetUsernameValidation() {
    state = state.copyWith(
      usernameFieldState: SDeckTextFieldState.hint,
      errorMessage: null,
      noteMessage: 'Note: Use letters and numbers only',
      isLoading: false,
      isUsernameValid: false,
    );
  }

  /// Optionally allows updating the note message.
  void setNoteMessage(String note) {
    state = state.copyWith(noteMessage: note);
  }
}

/// Riverpod provider for the ProfileValidationProvider.
final profileValidationProvider =
    StateNotifierProvider<ProfileValidationProvider, ProfileValidationState>(
      (ref) => ProfileValidationProvider(TestProfileRepository()),
    );
