import '../domain/profile_form_state.dart';
import 'profile_repository.dart';

/// Mock implementation of ProfileRepository for testing username availability.
/// Simulates a network/database call by checking a hardcoded list of taken usernames.
/// Replace this with a real Firebase implementation when ready.
class TestProfileRepository implements ProfileRepository {
  // Hardcoded list of taken usernames for simulation
  final List<String> _takenUsernames = ['takenname', 'admin', 'user123'];

  /// Simulates an async check for username availability.
  /// Returns true if the username is NOT taken, false if it is taken.
  @override
  Future<bool> isUsernameAvailable(String username) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    // Check if username is in the taken list (case-insensitive)
    return !_takenUsernames.contains(username.toLowerCase());
  }
}

/// Mock implementation of OnboardingSubmissionRepository for testing.
/// Simulates a network call and always returns success.
class TestOnboardingSubmissionRepository
    implements OnboardingSubmissionRepository {
  @override
  Future<bool> submitProfile(OnboardingSubmissionData data) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Print submitted data for debug
    print('Mock submitProfile called with:');
    print('  email: ${data.email}');
    print('  password: ${data.password}');
    print('  username: ${data.username}');
    print('  imagePath: ${data.imagePath}');
    print('  scale: ${data.scale}');
    print('  panX: ${data.panX}');
    print('  panY: ${data.panY}');
    // Always succeed for now
    return true;
  }
}
