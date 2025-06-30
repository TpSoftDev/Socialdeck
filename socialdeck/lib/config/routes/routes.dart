// Core Flutter and Riverpod imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socialdeck/config/routes/go_router_refresh_stream.dart';
import 'package:socialdeck/features/home/presentation/pages/home.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign_up_confirm_password.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign_up_redirecting.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign_up_verify.dart';

// Page imports - all the screens in our app
import 'package:socialdeck/features/welcome/presentation/pages/welcome_page.dart';
import 'package:socialdeck/features/onboarding/login/presentation/pages/login_page.dart';
import 'package:socialdeck/features/onboarding/login/presentation/pages/login_card_display_page.dart';
import 'package:socialdeck/features/onboarding/login/presentation/pages/login_password_page.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign_up_email.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign_up_password_page.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/profile_username.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/add_profile_card_page.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/adjust_profile_page.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/display_profile_page.dart';
//import 'package:socialdeck/features/onboarding/profile/presentation/pages/invite_friends_page.dart';
import 'package:socialdeck/test_pages/adjust_profile_test_page.dart';
import 'package:socialdeck/test_pages/adjust_profile_preview_test_page.dart';
import 'package:socialdeck/test_pages/profile_card_test_page.dart';

// Generated file - contains auto-generated code for Riverpod providers
part 'routes.g.dart';

// Enum defining all the named routes in our app
// Makes it easier to reference routes by name instead of hardcoded strings
enum AppRoute {
  welcome, // Welcome page route
  login, // Login page route
  loginCardDisplay, // Login card display page route
  loginPassword, // Login password page route
  signUp, // Sign up page route
  signUpPassword, // Sign up password page route
  signUpConfirmPassword, // Sign up confirm password page route
  signUpVerifyAccount, // Sign up verify account page route
  signUpRedirecting, // Sign up redirecting page route
  profileUsername, // Profile username page route
  addProfileCard, // Add profile card page route
  adjustProfile, // Adjust profile photo page route
  displayProfile, // Display final profile photo page route
  inviteFriends, // Invite friends page route (final onboarding step)
  home, // Home page route
  profileCardTest, // Test page for ProfileCard component
  adjustProfileTest, // Test page for AdjustProfile component
  adjustProfilePreviewTest, // Test page for AdjustProfile preview component
}

// Firebase Auth provider - gives us access to authentication state
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Riverpod provider that creates and manages our GoRouter instance
// This handles all navigation logic for the entire app
@riverpod
GoRouter goRouter(Ref ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);

  return GoRouter(
    initialLocation: '/welcome', // Start at welcome page
    debugLogDiagnostics: true,

    // TEMPORARILY DISABLED for UI testing
    // Authentication-based navigation protection
    // Redirects users based on their login status
    // redirect: (context, state) {
    //   // Check if user is currently logged in
    //   final isLoggedIn = firebaseAuth.currentUser != null;

    //   // If user IS logged in but tries to visit login/signup pages
    //   // → Redirect them to home (they don't need to log in again)
    //   if (isLoggedIn &&
    //       (state.uri.toString() == '/login' ||
    //           state.uri.toString() == '/sign-up')) {
    //     return '/home';
    //   }
    //   // If user is NOT logged in but tries to visit protected pages
    //   // → Redirect them to login (they must authenticate first)
    //   else if (!isLoggedIn && state.uri.toString().startsWith('/home')) {
    //     return '/login';
    //   }

    //   // If no redirect needed, return null (let navigation proceed normally)
    //   return null;
    // },
    refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),

    routes: [
      // Welcome page route - first screen after app launch
      GoRoute(
        path: '/welcome',
        name: AppRoute.welcome.name,
        builder: (context, state) => const WelcomePage(),
      ),

      // Login page route - for user authentication
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginPage(),
      ),

      // Login card display page route - for showing user's profile card
      GoRoute(
        path: '/login/card-display',
        name: AppRoute.loginCardDisplay.name,
        builder: (context, state) => const LoginCardDisplayPage(),
      ),

      // Login password page route - for entering password after card confirmation
      GoRoute(
        path: '/login/password',
        name: AppRoute.loginPassword.name,
        builder: (context, state) => const LoginPasswordPage(),
      ),

      // Sign up page route - for new user registration
      GoRoute(
        path: '/sign-up',
        name: AppRoute.signUp.name,
        builder: (context, state) => const SignUpPage(),
      ),

      // Sign up password page route - for password creation
      GoRoute(
        path: '/sign-up/password',
        name: AppRoute.signUpPassword.name,
        builder: (context, state) => const SignUpPasswordPage(),
      ),

      // Sign up confirm password page route - for password confirmation
      GoRoute(
        path: '/sign-up/confirm-password',
        name: AppRoute.signUpConfirmPassword.name,
        builder: (context, state) => const SignUpConfirmPasswordPage(),
      ),

      // Sign up verify page route - for email verification
      GoRoute(
        path: '/sign-up/verify-account',
        name: AppRoute.signUpVerifyAccount.name,
        builder: (context, state) => const SignUpVerifyPage(),
      ),

      // Sign up redirecting page route - for redirecting to home
      GoRoute(
        path: '/sign-up/redirecting',
        name: AppRoute.signUpRedirecting.name,
        builder: (context, state) => const SignUpRedirectingPage(),
      ),

      // Profile username page route - for profile username
      GoRoute(
        path: '/profile/username',
        name: AppRoute.profileUsername.name,
        builder: (context, state) => const ProfileUsernamePage(),
      ),

      // Add profile card page route - for adding profile photo
      GoRoute(
        path: '/profile/add-card',
        name: AppRoute.addProfileCard.name,
        builder: (context, state) => const AddProfileCardPage(),
      ),

      // Adjust profile page route - for adjusting selected photo
      GoRoute(
        path: '/profile/adjust',
        name: AppRoute.adjustProfile.name,
        builder: (context, state) => AdjustProfilePage(state: state),
      ),

      // Display profile page route - for showing final adjusted photo
      GoRoute(
        path: '/profile/display',
        name: AppRoute.displayProfile.name,
        builder: (context, state) => DisplayProfilePage(state: state),
      ),

      // Invite friends page route - final onboarding step
      //GoRoute(
      //path: '/profile/invite-friends',
      //name: AppRoute.inviteFriends.name,
      //builder: (context, state) => const InviteFriendsPage(),
      //),

      // Home page route - main screen after login
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        builder: (context, state) => const HomePage(),
      ),

      // Test page route - for testing ProfileCard component
      GoRoute(
        path: '/test/profile-card',
        name: AppRoute.profileCardTest.name,
        builder: (context, state) => const ProfileCardTestPage(),
      ),

      // Test page route - for testing AdjustProfile component
      GoRoute(
        path: '/test/adjust-profile',
        name: AppRoute.adjustProfileTest.name,
        builder: (context, state) => AdjustProfileTestPage(state: state),
      ),

      // Test page route - for testing AdjustProfile preview component
      GoRoute(
        path: '/test/adjust-profile-preview',
        name: AppRoute.adjustProfilePreviewTest.name,
        builder: (context, state) => AdjustProfilePreviewTestPage(state: state),
      ),
    ],
  );
}
