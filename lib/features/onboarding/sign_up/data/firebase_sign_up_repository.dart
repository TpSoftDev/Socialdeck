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
// validateEmail() uses a fake sign-in probe to check email availability.
// fetchSignInMethodsForEmail() was tried but always returns an empty list when
// Firebase's "User enumeration protection" is enabled — making it useless for
// duplicate detection. The probe approach is restored with updated error code
// mapping: invalid-credential is treated as duplicateEmail (safe default with
// a fake probe password), and only user-not-found confirms the email is free.
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
  // Attempts a sign-in with a fake probe password to trigger Firebase error codes.
  // - wrong-password / invalid-credential → email exists → duplicateEmail
  // - user-not-found → email is free → success
  // Should never reach the success return — the probe password is always wrong.
  // ---------------------------------------------------------------------------
  @override
  Future<SignUpRepositoryResult> validateEmail(String email) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: '___probe___',
      );
      // Should never reach here — probe password is always wrong
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
  // Maps FirebaseAuthException codes specific to the email probe in validateEmail.
  //
  // invalid-credential is treated as duplicateEmail — safe because the probe
  // password is always fake. Firebase returns this code for existing accounts
  // when user enumeration protection is enabled (instead of wrong-password).
  // Only user-not-found explicitly confirms the email is free to register.
  // ---------------------------------------------------------------------------
  SignUpRepositoryResult _mapValidateEmailException(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
      case 'email-already-in-use':
      case 'invalid-credential':
        return SignUpRepositoryResult.duplicateEmail;
      case 'user-not-found':
        return SignUpRepositoryResult.success;
      case 'invalid-email':
        return SignUpRepositoryResult.invalidEmail;
      case 'network-request-failed':
        return SignUpRepositoryResult.networkError;
      default:
        return SignUpRepositoryResult.unknownError;
    }
  }
}