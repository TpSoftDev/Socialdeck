// -----------------------------------------------------------------------------
// profile_routes.dart
// -----------------------------------------------------------------------------
// Contains GoRoute definitions for the profile section of onboarding.
// Follows the same modularization pattern as login_routes.dart and sign_up_routes.dart.
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/introduce_profile_card.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/edit_photo_page.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/enter_username_page.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/profile_redirecting.dart';

final List<GoRoute> profileRoutes = [
  // Introduce profile card page route - for introducing the profile card feature
  GoRoute(
    path: AppPaths.introduceProfileCard,
    name: AppRoute.introduceProfileCard.name,
    builder: (context, state) => const IntroduceProfileCardPage(),
  ),
  GoRoute(
    path: AppPaths.editPhoto,
    name: AppRoute.editPhoto.name,
    builder: (context, state) => const EditPhotoPage(),
  ),
  GoRoute(
    path: AppPaths.profileRedirect,
    name: AppRoute.profileRedirect.name,
    builder: (context, state) => const ProfileRedirectingPage(),
  ),
  GoRoute(
    path: AppPaths.enterUsername,
    name: AppRoute.enterUsername.name,
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: const EnterUsernamePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: SDeckMotionDuration.normal,
      reverseTransitionDuration: SDeckMotionDuration.normal,
    ),
  ),
];
