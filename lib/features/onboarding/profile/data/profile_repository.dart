import 'package:image_picker/image_picker.dart';

/// Abstract repository for async username availability checks and other profile data operations.
/// Implement this interface for different data sources (mock, Firebase, etc.).
abstract class ProfileRepository {
  // Checks if a username is available (not taken).
  Future<bool> isUsernameAvailable(String username);

  //Uploads the photo data to Firebase Storage, returns a string path to upload to the database
  Future<String?> uploadPhotoToStorage(XFile? profilePhoto, String userID);

  // Submits the full onboarding data. Returns true on success.
  Future<bool> submitProfile(OnboardingSubmissionData data, uid);
}

/// Model for aggregating all onboarding data for submission.
class OnboardingSubmissionData {
  final String username;
  final String? imagePath;
  final double? scale;
  final double? panX;
  final double? panY;
  final double? rotation;

  OnboardingSubmissionData({
    required this.username,
    this.imagePath,
    this.scale,
    this.panX,
    this.panY,
    this.rotation,
  });
}