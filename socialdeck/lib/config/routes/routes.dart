// Core Flutter and Riverpod imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// Page imports - all the screens in our app
import 'package:socialdeck/features/welcome/presentation/pages/welcome_page.dart';
import 'package:socialdeck/features/home/presentation/pages/home.dart';
//import 'package:socialdeck/features/onboarding/profile/presentation/pages/invite_friends_page.dart';
import 'package:socialdeck/test_pages/adjust_profile_test_page.dart';
import 'package:socialdeck/test_pages/adjust_profile_preview_test_page.dart';
import 'package:socialdeck/test_pages/profile_card_test_page.dart';
import 'package:socialdeck/features/splash/presentation/pages/splash_page.dart';

// Import route constants and enums
import 'package:socialdeck/config/routes/route_constants.dart'; // AppRoute enum and AppPaths constants

// Import guard functions
import 'package:socialdeck/config/routes/guards/auth_guards.dart'; // Global authentication guards

// Import modularized route modules
import 'package:socialdeck/config/routes/login_routes.dart'; // Login routes
import 'package:socialdeck/config/routes/sign_up_routes.dart'; // Sign-up routes
import 'package:socialdeck/config/routes/profile_routes.dart'; // Profile routes

// Generated file - contains auto-generated code for Riverpod providers
part 'routes.g.dart';

//------------------------------- goRouter variable -----------------------------//
// Riverpod provider that creates and manages our GoRouter instance
// This handles all navigation logic for the entire app
@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/splash', // Start at splash page for auth check
    //------------------------------- redirect -----------------------------//
    // Navigation guards that run on every navigation attempt
    // These guards check authentication and flow integrity in order of priority
    redirect: (context, state) async {
      // Check authentication guards first (most important)
      final authRedirect = await authGuards(ref, context, state);
      if (authRedirect != null) {
        return authRedirect; // Authentication rule applies, redirect and stop
      }

      // No guards apply, allow navigation to proceed normally
      return null;
    },

    //------------------------------- routes -----------------------------//
    routes: [
      // Splash page route - checks auth and routes user
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      // Welcome page route - first screen after app launch
      GoRoute(
        path: AppPaths.welcome,
        name: AppRoute.welcome.name,
        builder: (context, state) => const WelcomePage(),
      ),

      // Insert all login routes from login_routes.dart
      ...loginRoutes,

      // Insert all sign-up routes from sign_up_routes.dart
      ...signUpRoutes,

      // Insert all profile routes from profile_routes.dart
      ...profileRoutes,

      // Home page route - main screen after login
      GoRoute(
        path: AppPaths.home,
        name: AppRoute.home.name,
        builder: (context, state) => const HomePage(),
      ),

      // Test page route - for testing ProfileCard component
      GoRoute(
        path: AppPaths.profileCardTest,
        name: AppRoute.profileCardTest.name,
        builder: (context, state) => const ProfileCardTestPage(),
      ),

      // Test page route - for testing AdjustProfile component
      GoRoute(
        path: AppPaths.adjustProfileTest,
        name: AppRoute.adjustProfileTest.name,
        builder: (context, state) => AdjustProfileTestPage(state: state),
      ),

      // Test page route - for testing AdjustProfile preview component
      GoRoute(
        path: AppPaths.adjustProfilePreviewTest,
        name: AppRoute.adjustProfilePreviewTest.name,
        builder: (context, state) => AdjustProfilePreviewTestPage(state: state),
      ),
    ],
  );
}
