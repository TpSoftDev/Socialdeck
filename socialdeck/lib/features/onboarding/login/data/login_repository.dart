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

abstract class LoginRepository {
  //------------------------------- Methods -----------------------------//
  
  Future<bool> checkUsernameExists(String username);

  Future<bool> validatePassword(String username, String password);
}
