// -----------------------------------------------------------------------------
// sign_up_repository.dart
// -----------------------------------------------------------------------------
// Abstract contract for the sign-up feature's backend operations.
//
// Defines WHAT operations are available — never HOW they are implemented.
// The data layer (firebase_sign_up_repository.dart) provides the concrete impl.
//
// NOTE:
// No Firebase imports are allowed in this file. All callers interact with this
// interface only — FirebaseAuthExceptions must never leak above the data layer.
// All methods return SignUpRepositoryResult so upper layers stay decoupled from
// Firebase error codes.
// -----------------------------------------------------------------------------

import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_repository_result.dart';

abstract class SignUpRepository {
  // ---------------------------------------------------------------------------
  // Checks whether the email address is available for registration.
  // Returns duplicateEmail if already in use, invalidEmail if malformed.
  // ---------------------------------------------------------------------------
  Future<SignUpRepositoryResult> validateEmail(String email);

  // ---------------------------------------------------------------------------
  // Creates a new Firebase Auth user with the given credentials.
  // ---------------------------------------------------------------------------
  Future<SignUpRepositoryResult> createUser({
    required String email,
    required String password,
  });

  // ---------------------------------------------------------------------------
  // Sends a verification email to the currently signed-in user.
  // ---------------------------------------------------------------------------
  Future<SignUpRepositoryResult> sendVerificationEmail();

  // ---------------------------------------------------------------------------
  // Reloads the current Firebase user to pick up the latest emailVerified flag.
  // ---------------------------------------------------------------------------
  Future<SignUpRepositoryResult> reloadCurrentUser();

  // ---------------------------------------------------------------------------
  // Returns success if the current user's email is verified.
  // Returns noCurrentUser if there is no signed-in user.
  // ---------------------------------------------------------------------------
  Future<SignUpRepositoryResult> isCurrentUserEmailVerified();

  // ---------------------------------------------------------------------------
  // Deletes the currently signed-in (unverified) user account.
  // Used when the user chooses to change their email before verifying.
  // ---------------------------------------------------------------------------
  Future<SignUpRepositoryResult> deleteCurrentUser();
}