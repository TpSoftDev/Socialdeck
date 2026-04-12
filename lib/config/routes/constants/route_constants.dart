// -----------------------------------------------------------------------------
// app_routes.dart
// -----------------------------------------------------------------------------
// Contains route enums and constants for the entire app
// This file centralizes all route names and makes them easy to reference
// -----------------------------------------------------------------------------

//------------------------------- AppRoute Enum -----------------------------//
/// Enum defining all the named routes in our app
enum AppRoute {
  // Welcome and Authentication Routes
  welcome,
  // Login Flow Routes
  login,
  loginRevealProfileCard,
  loginPassword,
  // Signup Flow Routes
  signUp,
  signUpPassword,
  signUpConfirmPassword,
  signUpVerifyAccount,
  signUpRedirecting,
  // Profile Creation Flow Routes
  profileUsername,
  introduceProfileCard,
  addProfileCard,
  editPhoto,
  enterUsername,
  unableToContinue,
  adjustProfile,
  displayProfile,
  inviteFriends,

  // Main App Routes
  home,
  profile,
  decks,
  social,
  store,

  // Test Routes (for development)
  profileCardTest,
  adjustProfileTest,
  adjustProfilePreviewTest,
  toastTest,

  // Training (reference demo)
  inviteFriendsPage,

}

//------------------------------- Route Paths -----------------------------//
/// Centralized route path constants
class AppPaths {
  // Welcome and Authentication
  static const String welcome = '/welcome';

  // Login Flow
  static const String login = '/login';
  static const String loginRevealProfileCard = '/login/reveal-profile-card';
  static const String loginPassword = '/login/password';

  // Signup Flow
  static const String signUp = '/sign-up';
  static const String signUpPassword = '/sign-up/password';
  static const String signUpConfirmPassword = '/sign-up/confirm-password';
  static const String signUpVerifyAccount = '/sign-up/verify-account';
  static const String signUpRedirecting = '/sign-up/redirecting';

  // Profile Creation Flow
  static const String profileUsername = '/profile/username';
  static const String introduceProfileCard = '/profile/introduce-card';
  /// Shown from Home (dev entry) and from add-photo flow when permissions are denied.
  static const String unableToContinue = '/home/unable-to-continue';
  static const String addProfileCard = '/profile/add-card';
  static const String editPhoto = '/profile/edit-photo';
  static const String enterUsername = '/profile/enter-username';
  static const String adjustProfile = '/profile/adjust';
  static const String displayProfile = '/profile/display';
  static const String inviteFriends = '/profile/invite-friends';

  // Main App
  static const String home = '/home';
  static const String profile = '/profile';
  static const String decks = '/decks';
  static const String social = '/social';
  static const String store = '/store';

  // Test Routes
  static const String profileCardTest = '/test/profile-card';
  static const String adjustProfileTest = '/test/adjust-profile';
  static const String adjustProfilePreviewTest = '/test/adjust-profile-preview';
  static const String toastTest = '/test/toast';
  //Training Routes
  static const String inviteFriendsPage = '/training/invite-friends';
}
