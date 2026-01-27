import 'package:firebase_auth/firebase_auth.dart';
import 'sign_up_repository.dart';

/// FirebaseSignUpRepository implements SignUpRepository using Firebase Auth.
/// This class handles real email/password sign-up and validation with Firebase.
class FirebaseSignUpRepository implements SignUpRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //*************************** Create User ********************************//
  /// Creates a new user account with email and password using Firebase Auth.
  @override
  Future<bool> createUser(String email, String password) async {
    try {
      // Attempt to create the user with Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If we get here, user creation was successful
      // The user is now signed in automatically
      print('User created successfully: ${userCredential.user?.uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      print('Firebase Auth Error: ${e.code} - ${e.message}');

      // Re-throw the exception so the provider can handle it
      // This allows for specific error messages based on the error code
      rethrow;
    } catch (e) {
      // Handle any other unexpected errors
      print('Unexpected error during user creation: $e');
      rethrow;
    }
  }

  //*************************** Validate Password Rules **********************//
  /// Validates password rules (length, complexity, etc.).
  @override
  Future<bool> validatePasswordRules(String password) async {
    return password.length >= 8;
  }

  //*************************** Send Verification Email ********************//
  /// Sends a verification email to the given address.
  @override
  Future<bool> sendVerificationEmail(String email) async {
    try {
      // Get the current user (should be signed in after creation)
      final user = _auth.currentUser;
      if (user != null && user.email == email) {
        // Send verification email
        await user.sendEmailVerification();
        print('Verification email sent to: $email');
        return true;
      } else {
        print('No authenticated user found or email mismatch');
        return false;
      }
    } catch (e) {
      print('Error sending verification email: $e');
      return false;
    }
  }
}
