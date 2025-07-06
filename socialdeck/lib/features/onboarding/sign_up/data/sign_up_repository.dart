// -----------------------------------------------------------------------------
// sign_up_repository.dart
// -----------------------------------------------------------------------------
// Abstract repository interface for sign-up validation in the onboarding flow.
// This abstract class defines the contract that any sign-up repository must follow,
// whether it's using test data, Firebase, or any other data source.
//
// The interface ensures consistency between different implementations and makes
// it easy to swap data sources without changing the validation provider.
// -----------------------------------------------------------------------------

abstract class SignUpRepository {
  // Checks if an email is available (not already registered and valid format).
  Future<bool> checkEmailAvailable(String email);

  // Checks if the password meets all requirements (length, complexity, etc.).
  Future<bool> validatePasswordRules(String password);

  // Simulates sending a verification email (for now).
  // Returns true if "sent" successfully, false if there was an error.
  Future<bool> sendVerificationEmail(String email);
}
