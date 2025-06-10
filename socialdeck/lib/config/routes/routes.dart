// Core Flutter and Riverpod imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socialdeck/config/routes/go_router_refresh_stream.dart';

// Page imports - all the screens in our app
import 'package:socialdeck/features/onboarding/welcome/presentation/pages/welcome_page.dart';
import 'package:socialdeck/features/onboarding/login/presentation/pages/login_page.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign-up_page.dart';
import 'package:socialdeck/features/onboarding/sign_up/presentation/pages/sign_up_password_page.dart';

// Generated file - contains auto-generated code for Riverpod providers
part 'routes.g.dart';

// Enum defining all the named routes in our app
// Makes it easier to reference routes by name instead of hardcoded strings
enum AppRoute {
  welcome, // Welcome page route
  login, // Login page route
  signUp, // Sign up page route
  signUpPassword, // Sign up password page route
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
      // Home page route - main screen after login
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
    ],
  );
}
