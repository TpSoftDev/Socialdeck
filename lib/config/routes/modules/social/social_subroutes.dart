// -----------------------------------------------------------------------------
// social_subroutes.dart
// -----------------------------------------------------------------------------
// Contains sub-route definitions for the Social feature (used within ShellRoute)
// Modularizes social sub-pages for scalability and organization
// -----------------------------------------------------------------------------

import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/social/presentation/pages/find_friends_page.dart';
import 'package:socialdeck/features/social/presentation/pages/social_page.dart';

final List<GoRoute> socialSubRoutes = [
  GoRoute(
    path: '',
    builder: (context, state) => const SocialPage(),
  ),
  GoRoute(
    path: 'find-friends',
    builder: (context, state) => const FindFriendsPage(),
  ),
];
