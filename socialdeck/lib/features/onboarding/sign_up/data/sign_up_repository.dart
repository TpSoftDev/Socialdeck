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
  // Creates a new user account with email and password.
  // Returns true on success, false on failure.
  // Throws FirebaseAuthException with specific error codes for different failures.
  Future<bool> createUser(String email, String password);

  // Checks if the password meets all requirements (length, complexity, etc.).
  Future<bool> validatePasswordRules(String password);

  // Sends a verification email to the given address (stub for now).
  // Returns true if "sent" successfully, false if there was an error.
  Future<bool> sendVerificationEmail(String email);
}
