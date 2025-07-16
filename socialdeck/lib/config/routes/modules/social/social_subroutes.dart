// -----------------------------------------------------------------------------
// social_subroutes.dart
// -----------------------------------------------------------------------------
// Contains sub-route definitions for the Social feature (used within ShellRoute)
// Modularizes social sub-pages for scalability and organization
// -----------------------------------------------------------------------------

import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/social/presentation/pages/social_page.dart';

final List<GoRoute> socialSubRoutes = [
  // Main Social page route (can add more sub-pages here later)
  GoRoute(
    path: '', // This means /social
    builder: (context, state) => const SocialPage(),
  ),
];
