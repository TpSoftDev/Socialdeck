// -----------------------------------------------------------------------------
// test_login_repository.dart
// -----------------------------------------------------------------------------
// This class implements the LoginRepository interface with real logic
// that uses our test users for validation during development.
//
// Later, when you add Firebase, you'll create a FirebaseLoginRepository
// that implements the same interface but uses real Firebase data.
// -----------------------------------------------------------------------------

import 'login_repository.dart';
import 'test_users.dart';

/// Test implementation of LoginRepository using test data.
class TestLoginRepository implements LoginRepository {
  /// Checks if a username exists in our test user database.
  /// This method simulates a network call by adding a delay, then checks
  /// if the username exists in our testUsers Map.
  @override
  Future<bool> checkUsernameExists(String username) async {
    // Simulate network delay for realistic loading states
    //await Future.delayed(Duration(seconds: 2));
    return testUsers.containsKey(username);
  }

  /// Validates a username/password combination against our test data.
  /// This method simulates a network call by adding a delay, then validates
  /// the credentials against our testUsers Map.
  /// Returns:
  /// - Future<bool>: true if credentials match test data, false if not
  @override
  Future<bool> validatePassword(String username, String password) async {
    // Simulate network delay for realistic loading states
    //await Future.delayed(Duration(seconds: 2));
    if (!testUsers.containsKey(username)) {
      return false;
    }
    return testUsers[username] == password;
  }
}
