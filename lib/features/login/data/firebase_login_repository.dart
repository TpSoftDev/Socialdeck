// -----------------------------------------------------------------------------
// firebase_login_repository.dart
// -----------------------------------------------------------------------------
// Firebase implementation of LoginRepository using Firebase Auth and Firestore.
// This class handles real email/password login validation and retrieves user
// profile data from Firestore after successful authentication.
// -----------------------------------------------------------------------------

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialdeck/config/firebase_auth_email_links.dart';
import 'login_repository.dart';

//------------------------------- FirebaseLoginRepository -----------------------------//
class FirebaseLoginRepository implements LoginRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //------------------------------- checkUsernameExists -----------------------------//
  /// Checks if a username or email exists by querying Firestore directly.
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

  //------------------------------- sendPasswordResetEmail -----------------------------//
  /// Sends a reset email. [handleCodeInApp] is true so the link can open this app
  /// once Android/iOS intent filters / universal links are configured.
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    final trimmed = email.trim();
    final actionCodeSettings = ActionCodeSettings(
      url: kFirebaseAuthEmailContinueUrl,
      handleCodeInApp: true,
      androidPackageName: 'com.socialdeck.app',
      androidInstallApp: true,
      androidMinimumVersion: '1',
      iOSBundleId: 'com.socialdeck.app',
    );
    await _auth.sendPasswordResetEmail(
      email: trimmed,
      actionCodeSettings: actionCodeSettings,
    );
  }

  //------------------------------- confirmPasswordReset -----------------------------//
  @override
  Future<void> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  }) async {
    await _auth.confirmPasswordReset(code: oobCode, newPassword: newPassword);
  }

  //------------------------------- getRevealProfileByEmail -----------------------------//
  /// Fetches lightweight profile data needed for the "Reveal Profile Card" step.
  /// This runs before authentication, so lookup is based on the entered email.
  @override
  Future<Map<String, dynamic>?> getRevealProfileByEmail(String email) async {
    try {
      // Normalize input so lookup is stable across user typing variations.
      final normalizedEmail = email.trim().toLowerCase();

      // Pre-auth lookup in users collection by email.
      final querySnapshot =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: normalizedEmail)
              .get();

      if (querySnapshot.docs.isEmpty) {
        print('No reveal profile found for email: $normalizedEmail');
        return null;
      }

      // Prefer a doc that has completed onboarding and a usable photoUrl.
      // This avoids selecting stale duplicate docs that may have null photoUrl.
      final docs = querySnapshot.docs.map((doc) => doc.data()).toList();

      Map<String, dynamic>? preferred;
      for (final data in docs) {
        final hasPhotoUrl =
            (data['photoUrl'] is String) &&
            (data['photoUrl'] as String).trim().isNotEmpty;
        final onboardingComplete = data['onboardingComplete'] == true;
        if (onboardingComplete && hasPhotoUrl) {
          preferred = data;
          break;
        }
      }

      final data = preferred ?? docs.first;
      print('Retrieved reveal profile data: $data');
      return data;
    } catch (e) {
      print('Error retrieving reveal profile data: $e');
      return null;
    }
  }

  //------------------------------- getUserProfileData -----------------------------//
  /// Retrieves user profile data from Firestore.
  /// This can be used to get username, profile photo URL, and other data
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

  //------------------------------- signInWithGoogle -----------------------------//
  /// Signs in user with Google OAuth and creates/links Firebase account.
  /// Returns UserCredential if successful, null if cancelled or failed.
  ///
  /// This method handles the complete Google OAuth flow:
  /// 1. Shows Google account picker
  /// 2. Gets Google authentication tokens
  /// 3. Links with Firebase Auth
  /// 4. Returns the signed-in Firebase user
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('🔄 Starting Google sign-in process...');

      // Step 1: Trigger Google account picker and authentication
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // User cancelled the sign-in process
      if (googleUser == null) {
        print('❌ Google sign-in cancelled by user');
        return null;
      }

      print('✅ Google account selected: ${googleUser.email}');

      // Step 2: Get Google authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Step 3: Create Firebase credential from Google tokens
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🔐 Created Firebase credential from Google tokens');

      // Step 4: Sign in to Firebase with Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      print(
        '🎉 Google sign-in successful for user: ${userCredential.user?.email}',
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      print(
        '❌ Firebase Auth Error during Google sign-in: ${e.code} - ${e.message}',
      );
      return null;
    } catch (e) {
      // Handle any other errors (network, Google API, etc.)
      print('❌ Unexpected error during Google sign-in: $e');
      return null;
    }
  }

  //------------------------------- signOutFromGoogle -----------------------------//
  /// Signs out from Google completely and clears cached account.
  /// This allows users to choose different Google accounts on next sign-in.
  /// Perfect for testing with multiple accounts during development.
  Future<void> signOutFromGoogle() async {
    try {
      print('🚪 Signing out from Google and clearing account cache...');

      // Sign out from Google SDK (clears cached account)
      await _googleSignIn.signOut();

      print('✅ Successfully signed out from Google');
    } catch (e) {
      print('❌ Error signing out from Google: $e');
    }
  }
}
