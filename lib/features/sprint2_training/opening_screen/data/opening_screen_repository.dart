// -----------------------------------------------------------------------------
// opening_screen_repository.dart
// -----------------------------------------------------------------------------
// Abstract repository interface for the opening screen auth check.
// Defines the contract any implementation must follow (test, Firebase, etc.).
// -----------------------------------------------------------------------------

abstract class OpeningScreenRepository {
  Future<bool> isUserLoggedIn();
}

