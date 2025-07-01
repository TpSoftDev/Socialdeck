// -----------------------------------------------------------------------------
// login_repository.dart
// -----------------------------------------------------------------------------
// Abstract repository interface for login validation in the onboarding flow.
// This abstract class defines the contract that any login repository must follow,
// whether it's using test data, Firebase, or any other data source.
//
// The interface ensures consistency between different implementations and makes
// it easy to swap data sources without changing the validation provider.
// -----------------------------------------------------------------------------

/// Abstract repository interface for login validation.
///
/// This interface defines the contract that any login repository must implement.
/// It specifies WHAT methods must exist, but not HOW they work. This allows us
/// to easily swap between test data and Firebase later without changing the
/// validation provider.
///
/// Example implementations:
/// - TestLoginRepository: Uses test data for development
/// - FirebaseLoginRepository: Uses Firebase for production
abstract class LoginRepository {
  /// Checks if a username exists in the user database.
  ///
  /// This method should be called when validating username existence.
  /// It simulates a network call, so it returns a Future.
  ///
  /// Parameters:
  /// - username: The username to check for existence
  ///
  /// Returns:
  /// - Future<bool>: true if username exists, false if not
  ///
  /// Why Future<bool> instead of bool?
  /// - Real validation involves network calls (API requests, database queries)
  /// - Network calls take time and are asynchronous
  /// - Future allows us to show loading states while waiting
  /// - Later with Firebase, this will be a real network call
  /// - For now, we simulate the delay with Future.delayed()
  Future<bool> checkUsernameExists(String username);

  /// Validates a username/password combination.
  ///
  /// This method should be called when validating password correctness.
  /// It simulates a network call, so it returns a Future.
  ///
  /// Parameters:
  /// - username: The username to validate
  /// - password: The password to check against
  ///
  /// Returns:
  /// - Future<bool>: true if credentials are valid, false if not
  ///
  /// Why Future<bool> instead of bool?
  /// - Real validation involves network calls (API requests, database queries)
  /// - Network calls take time and are asynchronous
  /// - Future allows us to show loading states while waiting
  /// - Later with Firebase, this will be a real network call
  /// - For now, we simulate the delay with Future.delayed()
  Future<bool> validatePassword(String username, String password);
}
