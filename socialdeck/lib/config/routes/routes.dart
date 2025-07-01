// Core Flutter and Riverpod imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socialdeck/config/routes/go_router_refresh_stream.dart';
// Page imports - all the screens in our app
import 'package:socialdeck/features/welcome/presentation/pages/welcome_page.dart';
import 'package:socialdeck/features/home/presentation/pages/home.dart';
//import 'package:socialdeck/features/onboarding/profile/presentation/pages/invite_friends_page.dart';
import 'package:socialdeck/test_pages/adjust_profile_test_page.dart';
import 'package:socialdeck/test_pages/adjust_profile_preview_test_page.dart';
import 'package:socialdeck/test_pages/profile_card_test_page.dart';

// Import modularized route modules
import 'package:socialdeck/config/routes/login_routes.dart'; // Login routes
import 'package:socialdeck/config/routes/sign_up_routes.dart'; // Sign-up routes
import 'package:socialdeck/config/routes/profile_routes.dart'; // Profile routes
import 'package:socialdeck/features/onboarding/shared/providers/auth_state_provider.dart'; // Auth state provider

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

// Riverpod provider that creates and manages our GoRouter instance
// This handles all navigation logic for the entire app
@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/welcome', // Start at welcome page
    debugLogDiagnostics: false, // Turn off GoRouter debug logs
    // Authentication-based navigation protection
    // Redirects users based on their login status
    redirect: (context, state) {
      // Check if user is currently logged in using our auth provider
      final isLoggedIn = ref.read(authStateProvider);

      // If user IS logged in but tries to visit login/signup pages
      // → Redirect them to home (they don't need to log in again)
      if (isLoggedIn &&
          (state.uri.toString() == '/login' ||
              state.uri.toString() == '/sign-up')) {
        return '/home';
      }
      // If user is NOT logged in but tries to visit protected pages
      // → Redirect them to welcome (they must authenticate first)
      else if (!isLoggedIn && state.uri.toString().startsWith('/home')) {
        return '/welcome';
      }

      // If no redirect needed, return null (let navigation proceed normally)
      return null;
    },

    // No refresh listener needed since we're using our own auth state provider
    routes: [
      // Welcome page route - first screen after app launch
      GoRoute(
        path: '/welcome',
        name: AppRoute.welcome.name,
        builder: (context, state) => const WelcomePage(),
      ),

      // Insert all login routes from login_routes.dart
      ...loginRoutes,

      // Insert all sign-up routes from sign_up_routes.dart
      ...signUpRoutes,

      // Insert all profile routes from profile_routes.dart
      ...profileRoutes,

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
