// -----------------------------------------------------------------------------
// profile_main_routes.dart
// -----------------------------------------------------------------------------
// Contains GoRoute definitions for the main app profile features.
// Separate from onboarding profile routes in onboarding/profile_routes.dart.
// This handles logged-in user profile functionality.
// -----------------------------------------------------------------------------

import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/route_constants.dart';
import 'package:socialdeck/features/profile/presentation/profile_page.dart';
// TODO: Import ProfilePage when created
// import 'package:socialdeck/features/profile/presentation/pages/profile_page.dart';

final List<GoRoute> profileMainRoutes = [
  // Main profile page route - shows current user's profile
  GoRoute(
    path: AppPaths.profile,
    name: AppRoute.profile.name,
    builder:
        (context, state) => const ProfilePage(), 
  ),

  // Future profile routes can be added here:
  // - Profile edit page
  // - Profile settings
  // - View other user profiles
  // - Profile achievements/stats
];
