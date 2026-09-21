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
  loginConfirmProfile,
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
  profileRedirect,

  // Main App Routes
  home,
  homeInParty,
  profile,
  decks,
  social,
  store,

  // Decks Feature Routes
  quickPics,
  cameraRoll,
  // Create Deck Flow Routes
  newDeckColor,
  newDeckName,
  deckCards,

  // Test Routes (for development)
  devTools,
  decksDevTools,
  homeDevTools,
  partyDevTools,
  promptSetupHostDev,
  promptCustomSetupDev,
  promptCustomSetupOtherDev,
  promptCustomSetupMoodDev,
  promptCustomSetupMoodOtherDev,
  promptCustomSetupKeywordsDev,
  promptCustomSetupGeneratingDev,
  promptCustomSetupExampleDev,
  promptCustomSetupExampleEditDev,
  promptCustomSetupExample2Dev,
  promptCustomSetupExample2EditDev,
  promptCustomSetupExample3Dev,
  promptCustomSetupExample3EditDev,
  promptCustomSetupFinalizingDev,
  promptCustomSetupCompleteDev,
  defaultPartyDev,
  inviteSheetDev,
  inviteSheetPlayerDev,
  profileCardTest,
  adjustProfileTest,
  adjustProfilePreviewTest,
  toastTest,
  playingCardTest,
  colorPickerTest,
  deckTargetTest,
  inputDialogTest,
  dialogTest,
  stepDialogTest,
  homeTutorialStepDialogTest,
  homeTutorialCompleted,

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
  static const String loginConfirmProfile = '/login/confirm-profile';
  static const String loginPassword = '/login/password';
  static const String loginForgotPassword = '/login/forgot-password';
  static const String loginResetPassword = '/login/reset-password';

  // Signup Flow
  static const String signUp = '/sign-up';
  static const String signUpPassword = '/sign-up/password';
  static const String signUpConfirmPassword = '/sign-up/confirm-password';
  static const String signUpVerifyAccount = '/sign-up/verify-account';
  static const String signUpRedirecting = '/sign-up/redirecting';

  // Profile Creation Flow
  static const String introduceProfileCard = '/profile/introduce-card';
  /// Shown from Home (dev entry) and from add-photo flow when permissions are denied.
  static const String unableToContinue = '/home/unable-to-continue';
  static const String addProfileCard = '/profile/add-card';
  static const String editPhoto = '/profile/edit-photo';
  static const String enterUsername = '/profile/enter-username';
  static const String adjustProfile = '/profile/adjust';
  static const String displayProfile = '/profile/display';
  static const String inviteFriends = '/profile/invite-friends';
  static const String profileRedirect = '/profile/redirecting';

  // Main App
  static const String home = '/home';
  static const String homeInParty = '/home/in-party';
  static const String profile = '/profile';
  static const String decks = '/decks';
  static const String social = '/social';
  static const String store = '/store';

  // Decks Feature
  static const String quickPics = '/decks/quick-pics';
  static const String cameraRoll = '/decks/quick-pics/camera-roll';

  // Create Deck Flow
  static const String newDeckColor = '/decks/new-deck/color';
  static const String newDeckName = '/decks/new-deck/name';
  static const String deckCards = '/decks/cards';

  // Test Routes
  static const String devTools = '/dev/tools';
  static const String decksDevTools = '/dev/tools/decks';
  static const String homeDevTools = '/dev/tools/home';
  static const String partyDevTools = '/dev/tools/party';
  static const String promptSetupHostDev = '/dev/tools/party/prompt-setup-host';
  static const String promptCustomSetupDev =
      '/dev/tools/party/prompt-setup-host/custom-setup';
  static const String promptCustomSetupOtherDev =
      '/dev/tools/party/prompt-setup-host/custom-setup/other';
  static const String promptCustomSetupMoodDev =
      '/dev/tools/party/prompt-setup-host/custom-setup/mood';
  static const String promptCustomSetupMoodOtherDev =
      '/dev/tools/party/prompt-setup-host/custom-setup/mood/other';
  static const String promptCustomSetupKeywordsDev =
      '/dev/tools/party/prompt-setup-host/custom-setup/keywords';
  static const String promptCustomSetupGeneratingDev =
      '/dev/tools/party/prompt-setup-host/custom-setup/generating';
  static const String promptCustomSetupExampleDev =
      '/dev/tools/party/prompt-setup-host/custom-setup/example';
  static const String promptCustomSetupExampleEditDev =
      '/dev/tools/party/prompt-setup-host/custom-setup/example/edit';
  static const String promptCustomSetupExample2Dev =
      '/dev/tools/party/prompt-setup-host/custom-setup/example/2';
  static const String promptCustomSetupExample2EditDev =
      '/dev/tools/party/prompt-setup-host/custom-setup/example/2/edit';
  static const String promptCustomSetupExample3Dev =
      '/dev/tools/party/prompt-setup-host/custom-setup/example/3';
  static const String promptCustomSetupExample3EditDev =
      '/dev/tools/party/prompt-setup-host/custom-setup/example/3/edit';
  static const String promptCustomSetupFinalizingDev =
      '/dev/tools/party/prompt-setup-host/custom-setup/finalizing';
  static const String promptCustomSetupCompleteDev =
      '/dev/tools/party/prompt-setup-host/custom-setup/complete';
  static const String defaultPartyDev = '/dev/tools/party/default-party';
  static const String inviteSheetDev = '/dev/tools/party/invite-sheet';
  static const String inviteSheetPlayerDev =
      '/dev/tools/party/invite-sheet/player';
  static const String profileCardTest = '/test/profile-card';
  static const String adjustProfileTest = '/test/adjust-profile';
  static const String adjustProfilePreviewTest = '/test/adjust-profile-preview';
  static const String toastTest = '/test/toast';
  static const String playingCardTest = '/test/playing-card';
  static const String colorPickerTest = '/test/color-picker';
  static const String deckTargetTest = '/test/deck-target';
  static const String inputDialogTest = '/test/input-dialog';
  static const String dialogTest = '/test/dialog';
  static const String stepDialogTest = '/test/step-dialog';
  static const String homeTutorialStepDialogTest =
      '/test/home-tutorial-step-dialog';
  static const String homeTutorialCompleted = '/test/home-tutorial-completed';
  //Training Routes
  static const String inviteFriendsPage = '/training/invite-friends';
}
