import 'opening_screen_repository.dart';

/// Mock implementation of OpeningScreenRepository for testing.
/// Simulates a network/auth check with a fake delay.
/// Replace with a real Firebase implementation when ready.
class TestOpeningScreenRepository implements OpeningScreenRepository {
  @override
  Future<bool> isUserLoggedIn() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 3));
    // Hardcoded: user is NOT logged in — screen stays visible while building
    // Flip to true to test the redirect path
    return false;
  }
}
