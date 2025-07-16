// -----------------------------------------------------------------------------
// social_routes.dart
// -----------------------------------------------------------------------------
// Contains GoRoute definitions for the Social feature of the main app.
// Follows the same modularization, documentation, and spacing pattern as other
// route modules (e.g., profile_routes.dart, login_routes.dart).
// -----------------------------------------------------------------------------

import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/social/presentation/pages/social_page.dart';

final List<GoRoute> socialRoutes = [
  // Social main page route - shows social feed/interactions (placeholder for now)
  GoRoute(
    path: '/social',
    name: 'social',
    builder: (context, state) => const SocialPage(),
  ),
];
