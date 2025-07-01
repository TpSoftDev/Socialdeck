// -----------------------------------------------------------------------------
// login_routes.dart
// -----------------------------------------------------------------------------
// Contains GoRoute definitions for the login section of onboarding.
// -----------------------------------------------------------------------------

import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/onboarding/login/presentation/pages/login_page.dart';
import 'package:socialdeck/features/onboarding/login/presentation/pages/login_card_display_page.dart';
import 'package:socialdeck/features/onboarding/login/presentation/pages/login_password_page.dart';

final List<GoRoute> loginRoutes = [
  // Login page route - for user authentication
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => const LoginPage(),
  ),

  // Login card display page route - for showing user's profile card
  GoRoute(
    path: '/login/card-display',
    name: 'loginCardDisplay',
    builder: (context, state) => const LoginCardDisplayPage(),
  ),

  // Login password page route - for entering password after card confirmation
  GoRoute(
    path: '/login/password',
    name: 'loginPassword',
    builder: (context, state) => const LoginPasswordPage(),
  ),
];
