import '../domain/profile_form_state.dart';

/// Abstract repository for async username availability checks and other profile data operations.
/// Implement this interface for different data sources (mock, Firebase, etc.).
abstract class ProfileRepository {
  /// Checks if a username is available (not taken).
  Future<bool> isUsernameAvailable(String username);
  // Add more methods here for photo upload, profile save, etc. as needed.
}

/// Model for aggregating all onboarding data for submission.
class OnboardingSubmissionData {
  final String email;
  final String password;
  final String username;
  final String? imagePath;
  final double? scale;
  final double? panX;
  final double? panY;

  OnboardingSubmissionData({
    required this.email,
    required this.password,
    required this.username,
    this.imagePath,
    this.scale,
    this.panX,
    this.panY,
  });
}

/// Abstract repository for submitting the full onboarding profile data.
/// Implement this for both mock and real (Firebase) backends.
abstract class OnboardingSubmissionRepository {
  /// Submits the full onboarding data. Returns true on success.
  Future<bool> submitProfile(OnboardingSubmissionData data);
}
