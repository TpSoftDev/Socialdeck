// -----------------------------------------------------------------------------
// firebase_sign_up_repository.dart
// -----------------------------------------------------------------------------
// Concrete Firebase Auth implementation of SignUpRepository.
//
// This is the only file in the data layer for the sign-up feature. There is no
// Firestore model or mapper because sign-up only uses Firebase Auth — no
// documents are read or written at this stage.
//
// All FirebaseAuthExceptions are caught here and mapped to SignUpRepositoryResult.
// Nothing above this layer ever sees a FirebaseAuthException or imports
// firebase_auth.
//
// NOTE:
// FirebaseAuth is constructor-injected so this class can be tested without
// hitting Firebase. In production, the default (FirebaseAuth.instance) is used
// automatically via the repository provider in sign_up_validation_provider.dart.
//
// NOTE:
// validateEmail() uses createUserWithEmailAndPassword as the availability probe
// instead of signInWithEmailAndPassword. The sign-in probe broke when Firebase
// enabled user enumeration protection — it returns invalid-credential for both
// existing and non-existing emails, making them indistinguishable.
// createUserWithEmailAndPassword is not affected by enumeration protection —
// it always returns email-already-in-use for duplicate emails regardless of
// the setting. If the probe succeeds (email is free), the temporary account
// is immediately deleted before returning success.
// -----------------------------------------------------------------------------

import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_repository.dart';
import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_repository_result.dart';

class FirebaseSignUpRepository implements SignUpRepository {
  // ---------------------------------------------------------------------------
  // Dependencies
  // ---------------------------------------------------------------------------

  final FirebaseAuth _auth;

  FirebaseSignUpRepository({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  // ===========================================================================
  // Validate Email
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Checks whether the email is available for registration.
  // Attempts to create a temporary account with a probe password.
  // - email-already-in-use → email is taken → duplicateEmail
  // - success → email is free → delete the temp account → return success
  // This approach works regardless of Firebase user enumeration protection.
  // ---------------------------------------------------------------------------
  @override
  Future<SignUpRepositoryResult> validateEmail(String email) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: '___probe___Aa1!',
      );
      // Email is free — delete the temporary account immediately
      await credential.user?.delete();
      return SignUpRepositoryResult.success;
    } on FirebaseAuthException catch (e) {
      return _mapValidateEmailException(e);
    } catch (_) {
      return SignUpRepositoryResult.unknownError;
    }
  }

  // ===========================================================================
  // Create User
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Creates a new Firebase Auth user with the given credentials.
  // The user is signed in automatically on success.
  // ---------------------------------------------------------------------------
  @override
  Future<SignUpRepositoryResult> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return SignUpRepositoryResult.success;
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseAuthException(e);
    } catch (_) {
      return SignUpRepositoryResult.unknownError;
    }
  }

  // ===========================================================================
  // Send Verification Email
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Sends a verification email to the currently signed-in user.
  // No email param — the address is already on the current user object.
  // ---------------------------------------------------------------------------
  @override
  Future<SignUpRepositoryResult> sendVerificationEmail() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return SignUpRepositoryResult.noCurrentUser;
      await user.sendEmailVerification();
      return SignUpRepositoryResult.success;
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseAuthException(e);
    } catch (_) {
      return SignUpRepositoryResult.unknownError;
    }
  }

  // ===========================================================================
  // Reload Current User
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Reloads the current user to pick up the latest emailVerified flag.
  // ---------------------------------------------------------------------------
  @override
  Future<SignUpRepositoryResult> reloadCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return SignUpRepositoryResult.noCurrentUser;
      await user.reload();
      return SignUpRepositoryResult.success;
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseAuthException(e);
    } catch (_) {
      return SignUpRepositoryResult.unknownError;
    }
  }

  // ===========================================================================
  // Is Current User Email Verified
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Returns success if the current user's email is verified, failure otherwise.
  // Call reloadCurrentUser() first to ensure the flag is fresh from Firebase.
  // ---------------------------------------------------------------------------
  @override
  Future<SignUpRepositoryResult> isCurrentUserEmailVerified() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return SignUpRepositoryResult.noCurrentUser;
      return user.emailVerified
          ? SignUpRepositoryResult.success
          : SignUpRepositoryResult.userNotFound;
    } catch (_) {
      return SignUpRepositoryResult.unknownError;
    }
  }

  // ===========================================================================
  // Delete Current User
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Deletes the currently signed-in (unverified) user.
  // Called when the user chooses to change their email before verifying.
  // ---------------------------------------------------------------------------
  @override
  Future<SignUpRepositoryResult> deleteCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return SignUpRepositoryResult.noCurrentUser;
      await user.delete();
      return SignUpRepositoryResult.success;
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseAuthException(e);
    } catch (_) {
      return SignUpRepositoryResult.unknownError;
    }
  }

  // ===========================================================================
  // Exception Mappers
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Maps FirebaseAuthException codes to SignUpRepositoryResult.
  // Used by createUser, sendVerificationEmail, reloadCurrentUser, deleteCurrentUser.
  // ---------------------------------------------------------------------------
  SignUpRepositoryResult _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return SignUpRepositoryResult.duplicateEmail;
      case 'invalid-email':
        return SignUpRepositoryResult.invalidEmail;
      case 'weak-password':
        return SignUpRepositoryResult.weakPassword;
      case 'user-not-found':
        return SignUpRepositoryResult.userNotFound;
      case 'network-request-failed':
        return SignUpRepositoryResult.networkError;
      default:
        return SignUpRepositoryResult.unknownError;
    }
  }

  // ---------------------------------------------------------------------------
  // Maps FirebaseAuthException codes for the createUserWithEmailAndPassword probe
  // in validateEmail. Only email-already-in-use is meaningful here —
  // all other errors are infrastructure or input problems.
  // ---------------------------------------------------------------------------
  SignUpRepositoryResult _mapValidateEmailException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return SignUpRepositoryResult.duplicateEmail;
      case 'invalid-email':
        return SignUpRepositoryResult.invalidEmail;
      case 'network-request-failed':
        return SignUpRepositoryResult.networkError;
      default:
        return SignUpRepositoryResult.unknownError;
    }
  }
}