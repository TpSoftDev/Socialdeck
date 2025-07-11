// -----------------------------------------------------------------------------
// firebase_login_repository.dart
// -----------------------------------------------------------------------------
// Firebase implementation of LoginRepository using Firebase Auth and Firestore.
// This class handles real email/password login validation and retrieves user
// profile data from Firestore after successful authentication.
//
// This replaces TestLoginRepository with real Firebase backend integration.
// -----------------------------------------------------------------------------

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_repository.dart';

/// FirebaseLoginRepository implements LoginRepository using Firebase Auth and Firestore.
/// This class handles real email/password login and retrieves user profile data.
class FirebaseLoginRepository implements LoginRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //------------------------------- checkUsernameExists -----------------------------//
  /// Checks if a username or email exists by querying Firestore directly.
  /// This is more reliable than dummy sign-in attempts and avoids credential errors.
  @override
  Future<bool> checkUsernameExists(String usernameOrEmail) async {
    try {
      if (usernameOrEmail.contains('@')) {
        // Input looks like an email - check if any user has this email
        final querySnapshot =
            await _firestore
                .collection('users')
                .where('email', isEqualTo: usernameOrEmail)
                .limit(1)
                .get();

        return querySnapshot.docs.isNotEmpty;
      } else {
        // Input looks like a username - check if any user has this username
        final querySnapshot =
            await _firestore
                .collection('users')
                .where('username', isEqualTo: usernameOrEmail)
                .limit(1)
                .get();

        return querySnapshot.docs.isNotEmpty;
      }
    } catch (e) {
      // Handle any Firestore errors
      print('Error checking username/email existence: $e');
      return false;
    }
  }

  //------------------------------- validatePassword -----------------------------//
  /// Validates the password by actually signing in the user with Firebase Auth.
  /// If successful, the user will be logged in and ready to access the app.
  @override
  Future<bool> validatePassword(String usernameOrEmail, String password) async {
    try {
      String? emailToCheck;

      if (usernameOrEmail.contains('@')) {
        // Input looks like an email, use it directly
        emailToCheck = usernameOrEmail;
      } else {
        // Input looks like a username, find the associated email in Firestore
        emailToCheck = await findEmailByUsername(usernameOrEmail);
        if (emailToCheck == null) {
          // Username not found in Firestore
          print('Username not found in Firestore: $usernameOrEmail');
          return false;
        }
      }

      // Attempt to sign in with the actual credentials
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailToCheck,
        password: password,
      );

      // If we get here, sign-in was successful
      final user = userCredential.user;
      if (user != null) {
        print('Login successful for user: ${user.email}');

        // Optionally, you could retrieve and cache user profile data here
        // await _getUserProfileData(user.uid);

        return true;
      } else {
        // Shouldn't happen, but handle null user
        print('Login successful but user is null');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      switch (e.code) {
        case 'wrong-password':
          print('Login failed: Wrong password');
          return false;
        case 'user-not-found':
          print('Login failed: User not found');
          return false;
        case 'invalid-email':
          print('Login failed: Invalid email format');
          return false;
        case 'user-disabled':
          print('Login failed: User account disabled');
          return false;
        case 'too-many-requests':
          print('Login failed: Too many requests');
          return false;
        default:
          print(
            'Firebase Auth Error in validatePassword: ${e.code} - ${e.message}',
          );
          return false;
      }
    } catch (e) {
      // Handle any other unexpected errors
      print('Unexpected error in validatePassword: $e');
      return false;
    }
  }

  //------------------------------- getUserProfileData -----------------------------//
  /// Retrieves user profile data from Firestore.
  /// This can be used to get username, profile photo URL, and other data
  /// to display in the login flow or after successful login.
  Future<Map<String, dynamic>?> getUserProfileData(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        print('Retrieved user profile data: $data');
        return data;
      } else {
        print('No profile data found for user: $uid');
        return null;
      }
    } catch (e) {
      print('Error retrieving user profile data: $e');
      return null;
    }
  }

  //------------------------------- findEmailByUsername -----------------------------//
  /// Future method: Query Firestore to find email by username.
  /// This would allow users to login with username instead of email.
  /// For now, we assume username input is actually email.
  Future<String?> findEmailByUsername(String username) async {
    try {
      // Query the users collection where username field matches
      final querySnapshot =
          await _firestore
              .collection('users')
              .where('username', isEqualTo: username)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        return userData['email'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error finding email by username: $e');
      return null;
    }
  }
}
