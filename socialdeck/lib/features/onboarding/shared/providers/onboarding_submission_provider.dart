// -----------------------------------------------------------------------------
// onboarding_submission_provider.dart
// -----------------------------------------------------------------------------
// Provider and state management for submitting the full onboarding data.
// Aggregates data from sign-up and profile providers, and writes to Firestore.
// This is now a production-ready provider using Firebase Firestore.
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sign_up/providers/sign_up_form_provider.dart';
import '../../profile/providers/profile_form_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../profile/services/firebase_storage_service.dart';

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
/// Aggregates data from sign-up and profile providers, writes to Firestore,
/// and updates state for loading, success, and error.
class OnboardingSubmissionNotifier
    extends StateNotifier<OnboardingSubmissionState> {
  final Ref ref;

  /// Constructor injects the Riverpod ref.
  OnboardingSubmissionNotifier(this.ref)
    : super(const OnboardingSubmissionState());

  /// Submits the full onboarding data (email, username, photo, etc.) to Firestore.
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

      // ================== Firebase Storage Upload Logic ================= //
      // Get the current Firebase user (must be logged in)
      final user = ref.read(currentUserProvider);
      if (user == null) {
        state = state.copyWith(
          status: OnboardingSubmissionStatus.error,
          errorMessage: 'User not logged in.',
        );
        return false;
      }

      // Upload profile image to Firebase Storage (if user selected one)
      String? photoDownloadUrl;
      if (profile.imagePath != null) {
        print('📤 Uploading profile image to Firebase Storage...');

        final storageService = FirebaseStorageService();
        final imageFile = XFile(profile.imagePath!);

        photoDownloadUrl = await storageService.uploadProfileImage(
          imageFile,
          user.uid,
        );

        if (photoDownloadUrl == null) {
          // Image upload failed - don't fail the entire onboarding
          print('⚠️ Image upload failed, continuing without profile photo');
        } else {
          print('✅ Profile image uploaded successfully: $photoDownloadUrl');
        }
      } else {
        print('📷 No profile image selected, skipping upload');
      }

      // ================== Firestore Write Logic ===================== //
      // Prepare the data to write to Firestore
      // Use email from Firebase Auth (works for both Google and email/password users)
      final userData = {
        'email': user.email ?? signUp.email,
        'username': profile.username,
        'photoUrl':
            photoDownloadUrl, // Save Firebase Storage URL (not temp path!)
        'scale': profile.scale,
        'panX': profile.panX,
        'panY': profile.panY,
        'onboardingComplete': true, // <--- The key flag!
        'createdAt': FieldValue.serverTimestamp(),
      };
      // Write the data to Firestore under users/{uid}
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));
      // ================== End Firestore Write Logic ================= //

      // Submission succeeded
      state = state.copyWith(status: OnboardingSubmissionStatus.success);
      return true;
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
final onboardingSubmissionProvider = StateNotifierProvider<
  OnboardingSubmissionNotifier,
  OnboardingSubmissionState
>((ref) => OnboardingSubmissionNotifier(ref));
