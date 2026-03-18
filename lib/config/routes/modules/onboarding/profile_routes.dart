// -----------------------------------------------------------------------------
// profile_routes.dart
// -----------------------------------------------------------------------------
// Contains GoRoute definitions for the profile section of onboarding.
// Follows the same modularization pattern as login_routes.dart and sign_up_routes.dart.
// -----------------------------------------------------------------------------

import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/profile_username.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/add_profile_card_page.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/adjust_profile_page.dart';
import 'package:socialdeck/features/profile/presentation/profile_redirecting.dart';
import 'package:socialdeck/features/profile/presentation/introduce_profile_card.dart';

final List<GoRoute> profileRoutes = [
  // Profile redirecting page route - for redirecting to profile username
  GoRoute(
    path: '/profile/redirecting',
    name: 'profileRedirecting',
    builder: (context, state) => const ProfileRedirectingPage(),
  ),
  // Introduce profile card page route - for introducing the profile card feature
  GoRoute(
    path: '/profile/introduce-card',
    name: 'introduceProfileCard',
    builder: (context, state) => const IntroduceProfileCardPage(),
  ),
  // Profile username page route - for profile username creation
  GoRoute(
    path: '/profile/username',
    name: 'profileUsername',
    builder: (context, state) => const ProfileUsernamePage(),
  ),

  // Add profile card page route - for adding profile photo
  GoRoute(
    path: '/profile/add-card',
    name: 'addProfileCard',
    builder: (context, state) => const AddProfileCardPage(),
  ),

  // Adjust profile page route - for adjusting selected photo
  // Uses provider state instead of navigation state parameters
  GoRoute(
    path: '/profile/adjust',
    name: 'adjustProfile',
    builder: (context, state) => const AdjustProfilePage(),
  ),
];
