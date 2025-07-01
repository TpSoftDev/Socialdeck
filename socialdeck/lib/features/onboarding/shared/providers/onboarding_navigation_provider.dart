// -----------------------------------------------------------------------------
// onboarding_navigation_provider.dart
// -----------------------------------------------------------------------------
// Global provider and enum for managing onboarding navigation state.
// This will eventually handle login, sign-up, and profile onboarding steps.
// For now, it only includes login steps.
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum representing all possible steps in the onboarding flow.
/// Organized by flow: login, sign-up, and profile onboarding.
enum OnboardingStep {
  // ===== LOGIN FLOW =====
  loginUsername, // User enters their username/email
  loginCardDisplay, // User sees their card and confirms identity
  loginPassword, // User enters their password
  // ===== SIGN-UP FLOW =====
  signUpEmail, // User enters email for sign-up
  signUpPassword, // User creates password
  signUpConfirmPassword, // User confirms password
  signUpVerifyAccount, // User verifies email account
  signUpRedirecting, // User is redirected after verification
  // ===== PROFILE FLOW =====
  profileUsername, // User sets up profile username
  addProfileCard, // User adds profile photo
  adjustProfile, // User adjusts selected photo
  displayProfile, // User sees final adjusted photo
  inviteFriends, // User invites friends (final step)
}

/// StateNotifier to manage the current onboarding step.
/// Provides methods to navigate between all onboarding steps.
class OnboardingNavigationProvider extends StateNotifier<OnboardingStep> {
  /// Start at the login username entry step.
  OnboardingNavigationProvider() : super(OnboardingStep.loginUsername);

  // ===== LOGIN FLOW NAVIGATION =====

  /// Go to the card display step.
  void goToCardDisplay() => state = OnboardingStep.loginCardDisplay;

  /// Go to the password entry step.
  void goToPasswordEntry() => state = OnboardingStep.loginPassword;

  /// Go back to the username entry step.
  void goToUsernameEntry() => state = OnboardingStep.loginUsername;

  // ===== SIGN-UP FLOW NAVIGATION =====

  /// Start sign-up flow - go to email entry.
  void startSignUp() => state = OnboardingStep.signUpEmail;

  /// Go to password creation step.
  void goToSignUpPassword() => state = OnboardingStep.signUpPassword;

  /// Go to password confirmation step.
  void goToSignUpConfirmPassword() =>
      state = OnboardingStep.signUpConfirmPassword;

  /// Go to email verification step.
  void goToSignUpVerifyAccount() => state = OnboardingStep.signUpVerifyAccount;

  /// Go to redirecting step after verification.
  void goToSignUpRedirecting() => state = OnboardingStep.signUpRedirecting;

  // ===== PROFILE FLOW NAVIGATION =====

  /// Start profile flow - go to username creation.
  void startProfileSetup() => state = OnboardingStep.profileUsername;

  /// Go to profile photo addition step.
  void goToAddProfileCard() => state = OnboardingStep.addProfileCard;

  /// Go to photo adjustment step.
  void goToAdjustProfile() => state = OnboardingStep.adjustProfile;

  /// Go to final photo display step.
  void goToDisplayProfile() => state = OnboardingStep.displayProfile;

  /// Go to invite friends step (final onboarding step).
  void goToInviteFriends() => state = OnboardingStep.inviteFriends;

  // ===== CROSS-FLOW NAVIGATION =====

  /// Complete onboarding and go to main app.
  /// This would typically navigate to the home screen.
  void completeOnboarding() {
    // TODO: Navigate to home screen
    // For now, we'll just stay on the current step
    // In a real implementation, this would trigger navigation to /home
    print('Onboarding completed - should navigate to home');
  }
}

/// Riverpod provider for the onboarding navigation state.
final onboardingNavigationProvider =
    StateNotifierProvider<OnboardingNavigationProvider, OnboardingStep>(
      (ref) => OnboardingNavigationProvider(),
    );
