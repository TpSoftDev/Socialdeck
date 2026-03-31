// -----------------------------------------------------------------------------
// login_routes.dart
// -----------------------------------------------------------------------------
// Contains GoRoute definitions for the login section of onboarding.
// Simplified flow: username entry → password entry (card display step removed)
// -----------------------------------------------------------------------------

import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/login/presentation/pages/login_page.dart';
import 'package:socialdeck/features/login/presentation/pages/login_password_page.dart';
import 'package:socialdeck/features/login/presentation/pages/login_reveal_profile_card_page.dart';

final List<GoRoute> loginRoutes = [
  // Login page route - username entry
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => const LoginPage(),
  ),

  // Login reveal profile card route - large profile placeholder
  GoRoute(
    path: '/login/reveal-profile-card',
    name: 'loginRevealProfileCard',
    builder: (context, state) => const LoginRevealProfileCardPage(),
  ),

  // Login password page route - password entry (direct from username)
  GoRoute(
    path: '/login/password',
    name: 'loginPassword',
    builder: (context, state) => const LoginPasswordPage(),
  ),
];
