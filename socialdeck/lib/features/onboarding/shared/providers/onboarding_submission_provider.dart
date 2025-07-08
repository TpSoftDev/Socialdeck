// -----------------------------------------------------------------------------
// onboarding_submission_provider.dart
// -----------------------------------------------------------------------------
// Provider and state management for submitting the full onboarding data.
// Aggregates data from sign-up and profile providers, and handles async
// submission logic (mock for now, Firebase-ready). Follows codebase standards.
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/data/profile_repository.dart';
import '../../profile/data/test_profile_repository.dart';
import '../../sign_up/providers/sign_up_form_provider.dart';
import '../../profile/providers/profile_form_provider.dart';

/// Enum representing the current status of the onboarding submission process.
/// - idle: No submission in progress
/// - loading: Submission in progress
/// - success: Submission completed successfully
/// - error: Submission failed
enum OnboardingSubmissionStatus { idle, loading, success, error }

/// State class for onboarding submission.
/// Holds the current status and an optional error message.
class OnboardingSubmissionState {
  final OnboardingSubmissionStatus status;
  final String? errorMessage;

  /// Constructor with sensible defaults.
  const OnboardingSubmissionState({
    this.status = OnboardingSubmissionStatus.idle,
    this.errorMessage,
  });

  /// Returns a copy of this state with updated fields.
  OnboardingSubmissionState copyWith({
    OnboardingSubmissionStatus? status,
    String? errorMessage,
  }) {
    return OnboardingSubmissionState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

/// StateNotifier that manages the onboarding submission process.
/// Aggregates data from sign-up and profile providers, calls the repository,
/// and updates state for loading, success, and error.
class OnboardingSubmissionNotifier
    extends StateNotifier<OnboardingSubmissionState> {
  final Ref ref;
  final OnboardingSubmissionRepository repository;

  /// Constructor injects the Riverpod ref and repository implementation.
  OnboardingSubmissionNotifier(this.ref, this.repository)
    : super(const OnboardingSubmissionState());

  /// Submits the full onboarding data (email, password, username, photo, etc.).
  /// Returns true on success, false on error. Updates state for UI feedback.
  Future<bool> submit() async {
    // Set state to loading
    state = state.copyWith(
      status: OnboardingSubmissionStatus.loading,
      errorMessage: null,
    );
    try {
      // Gather data from both providers
      final signUp = ref.read(signUpFormProvider);
      final profile = ref.read(profileFormProvider);
      final data = OnboardingSubmissionData(
        email: signUp.email,
        password: signUp.password,
        username: profile.username,
        imagePath: profile.imagePath,
        scale: profile.scale,
        panX: profile.panX,
        panY: profile.panY,
      );
      // Call the repository (mock for now)
      final success = await repository.submitProfile(data);
      if (success) {
        // Submission succeeded
        state = state.copyWith(status: OnboardingSubmissionStatus.success);
        return true;
      } else {
        // Submission failed (repository returned false)
        state = state.copyWith(
          status: OnboardingSubmissionStatus.error,
          errorMessage: 'Submission failed.',
        );
        return false;
      }
    } catch (e) {
      // Catch and report any errors
      state = state.copyWith(
        status: OnboardingSubmissionStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Resets the submission state to idle (useful for retry or navigation).
  void reset() {
    state = const OnboardingSubmissionState();
  }
}

/// Riverpod provider for onboarding submission logic.
/// Uses the mock repository for now; swap for Firebase implementation later.
final onboardingSubmissionProvider = StateNotifierProvider<
  OnboardingSubmissionNotifier,
  OnboardingSubmissionState
>(
  (ref) =>
      OnboardingSubmissionNotifier(ref, TestOnboardingSubmissionRepository()),
);
