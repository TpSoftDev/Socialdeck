import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/login_navigation_state.dart'; // Import the enum

/// Provider to manage the current step in the login onboarding flow.
/// Uses StateNotifier so we can add methods for navigation logic.
class LoginNavigationProvider extends StateNotifier<LoginOnboardingStep> {
  /// Start at the username entry step.
  LoginNavigationProvider() : super(LoginOnboardingStep.usernameEntry);

  /// Go to the card display step.
  void goToCardDisplay() => state = LoginOnboardingStep.cardDisplay;

  /// Go to the password entry step.
  void goToPasswordEntry() => state = LoginOnboardingStep.passwordEntry;

  /// Go back to the username entry step.
  void goToUsernameEntry() => state = LoginOnboardingStep.usernameEntry;

  // Add more transitions as needed.
}

/// Riverpod provider for the navigation state.
/// Use this in your UI to watch or update the current step.
final loginNavigationProvider =
    StateNotifierProvider<LoginNavigationProvider, LoginOnboardingStep>(
      (ref) => LoginNavigationProvider(),
    );
