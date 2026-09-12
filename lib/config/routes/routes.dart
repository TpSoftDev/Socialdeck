// -----------------------------------------------------------------------------
// routes.dart
// -----------------------------------------------------------------------------
// Main routing configuration for the Social Deck app.
// - Uses ShellRoute for persistent bottom navigation bar.
// - Modularizes sub-routes for scalability (e.g., decksSubRoutes).
// - Only onboarding/login/test routes and the ShellRoute are at the top level.
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socialdeck/features/welcome/presentation/pages/welcome_page.dart';
import 'package:socialdeck/features/home/presentation/pages/home.dart';
import 'package:socialdeck/test_pages/adjust_profile_test_page.dart';
import 'package:socialdeck/test_pages/adjust_profile_preview_test_page.dart';
import 'package:socialdeck/test_pages/profile_card_test_page.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/social/presentation/pages/social_page.dart';
import 'package:socialdeck/features/social/presentation/pages/find_friends_page.dart';
import 'package:socialdeck/features/social/presentation/pages/social_inbox_page.dart';
import 'package:socialdeck/features/decks/decks_home/decks_page.dart';
import 'package:socialdeck/features/store/presentation/pages/store_page.dart';
import 'package:socialdeck/features/profile/presentation/profile_page.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/unable_to_continue.dart';
import 'package:socialdeck/test_pages/toast_test_page.dart';
import 'package:socialdeck/test_pages/playing_card_test_page.dart';
import 'package:socialdeck/test_pages/color_picker_test_page.dart';
import 'package:socialdeck/test_pages/deck_target_test_page.dart';
import 'package:socialdeck/test_pages/dev_hub_page.dart';
import 'package:socialdeck/features/decks/quick_pics/quick_pics_page.dart';
import 'package:socialdeck/features/decks/shared/camera_roll/camera_roll_page.dart';
import 'package:socialdeck/features/decks/decks_home/create_deck/new_deck_color_page.dart';
import 'package:socialdeck/features/decks/decks_home/create_deck/new_deck_name_page.dart';
import 'package:socialdeck/features/decks/decks_home/deck_cards_page.dart';
import 'package:socialdeck/test_pages/input_dialog_test_page.dart';
import 'package:socialdeck/test_pages/dialog_test_page.dart';
import 'package:socialdeck/test_pages/step_dialog_test_page.dart';
import 'package:socialdeck/test_pages/home_tutorial_step_dialog_test_page.dart';
import 'package:socialdeck/test_pages/home_tutorial_completed_page.dart';
import 'package:socialdeck/test_pages/home_return_test_page.dart';
import 'package:socialdeck/test_pages/home_in_party_test_page.dart';
//Training Routes
import 'package:socialdeck/features/sprint2_training/reference/invite_friends/presentation/pages/invite_friends_page.dart';




// Only import subroutes for features that actually have sub-pages
import 'package:socialdeck/config/routes/modules/decks/decks_subroutes.dart'; // Decks sub-routes
import 'package:socialdeck/config/routes/constants/route_constants.dart'; // AppRoute enum and AppPaths constants
import 'package:socialdeck/config/routes/guards/auth_guards.dart'; // Global authentication guards
import 'package:socialdeck/config/routes/modules/login/login_routes.dart'; // Login routes
import 'package:socialdeck/config/routes/modules/onboarding/sign_up_routes.dart'; // Sign-up routes
import 'package:socialdeck/config/routes/modules/onboarding/profile_routes.dart'; // Profile routes
import 'package:socialdeck/features/login/providers/password_reset_oob_provider.dart';
part 'routes.g.dart';

/// SDeckNavbarShell
/// This widget wraps the bottom navigation bar and displays the current tab's content.
/// The [child] is the content for the current route.
class SDeckNavbarShell extends StatelessWidget {
  final Widget child;
  const SDeckNavbarShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    // Use GoRouterState.of(context).uri.toString() for current location (go_router v15+)
    final String location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/social'))
      currentIndex = 1;
    else if (location.startsWith('/decks'))
      currentIndex = 2;
    else if (location.startsWith('/store'))
      currentIndex = 3;
    else if (location.startsWith('/profile'))
      currentIndex = 4;

    return Scaffold(
      // Lets the body extend behind the nav bar so the gradient fade is visible
      // as content scrolls under it — matches Figma's absolute-positioned nav bar.
      extendBody: true,
      body: SafeArea(child: child),
      bottomNavigationBar: SDeckBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Switch tabs using context.go
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/social');
              break;
            case 2:
              context.go('/decks');
              break;
            case 3:
              context.go('/store');
              break;
            case 4:
              context.go('/profile');
              break;
          }
        },
        items: SDeckBottomNavBar.defaultItems,
      ),
    );
  }
}

//------------------------------- goRouter variable -----------------------------//
// Riverpod provider that creates and manages our GoRouter instance
// This handles all navigation logic for the entire app
@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/home', // Start at home page
    redirect: (context, state) async {
      // Navigation guards for authentication and onboarding
      final authRedirect = await authGuards(ref, context, state);
      if (authRedirect != null) {
        return authRedirect;
      }
      return null;
    },
    errorBuilder: (context, state) {
      final loc = state.uri.toString();
      if (loc.contains('/__/auth/')) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(passwordResetOobProvider.notifier).tryIngestResetLink(state.uri);
          if (context.mounted) {
            GoRouter.of(context).go(AppPaths.loginResetPassword);
          }
        });
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SelectableText(
              'Page not found\n${state.error}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    },
    routes: [
      // Welcome page route - first screen after app launch
      GoRoute(
        path: AppPaths.welcome,
        name: AppRoute.welcome.name,
        builder: (context, state) => const WelcomePage(),
      ),
      // Onboarding and login routes (modularized for organization)
      ...loginRoutes,
      ...signUpRoutes,
      ...profileRoutes,
      GoRoute(
        path: AppPaths.unableToContinue,
        name: AppRoute.unableToContinue.name,
        builder: (context, state) => const UnableToContinuePage(),
      ),
      // ------------------- Main App ShellRoute ------------------- //
      // All main tabs and their sub-pages are children of this ShellRoute.
      // The bottom nav bar stays persistent for all these routes.
      ShellRoute(
        builder: (context, state, child) => SDeckNavbarShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/social',
            builder: (context, state) => const SocialPage(),
            routes: [
              GoRoute(
                path: 'find-friends',
                builder: (context, state) => const FindFriendsPage(),
              ),
              GoRoute(
                path: 'inbox',
                builder: (context, state) => const SocialInboxPage(),
              ),
            ],
          ),
          GoRoute(
            path: '/decks',
            builder: (context, state) => const DecksPage(),
          ),
          GoRoute(
            path: '/store',
            builder: (context, state) => const StorePage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      // ------------------- Decks Feature Routes (outside shell) ------------------- //
      GoRoute(
        path: AppPaths.quickPics,
        name: AppRoute.quickPics.name,
        builder: (context, state) => const QuickPicsPage(),
      ),
      GoRoute(
        path: AppPaths.cameraRoll,
        name: AppRoute.cameraRoll.name,
        builder: (context, state) => const CameraRollPage(),
      ),
      GoRoute(
        path: AppPaths.newDeckColor,
        name: AppRoute.newDeckColor.name,
        builder: (context, state) => const NewDeckColorPage(),
      ),
      GoRoute(
        path: AppPaths.newDeckName,
        name: AppRoute.newDeckName.name,
        builder: (context, state) {
          final color = state.extra is SDeckColorPickerColor
              ? state.extra as SDeckColorPickerColor
              : SDeckColorPickerColor.brightCoral;
          return NewDeckNamePage(selectedColor: color);
        },
      ),
      GoRoute(
        path: AppPaths.deckCards,
        name: AppRoute.deckCards.name,
        builder: (context, state) {
          final extra = state.extra;
          String deckName = 'Your Deck';
          SDeckColorPickerColor color = SDeckColorPickerColor.brightCoral;
          if (extra is Map) {
            final name = extra['name'];
            if (name is String && name.trim().isNotEmpty) {
              deckName = name.trim();
            }
            final selected = extra['color'];
            if (selected is SDeckColorPickerColor) {
              color = selected;
            }
          }
          return DeckCardsPage(
            deckName: deckName,
            selectedColor: color,
          );
        },
      ),
      // ------------------- Test/Dev Routes (outside shell) ------------------- //
      GoRoute(
        path: AppPaths.profileCardTest,
        name: AppRoute.profileCardTest.name,
        builder: (context, state) => const ProfileCardTestPage(),
      ),
      GoRoute(
        path: AppPaths.adjustProfileTest,
        name: AppRoute.adjustProfileTest.name,
        builder: (context, state) => AdjustProfileTestPage(state: state),
      ),
      GoRoute(
        path: AppPaths.adjustProfilePreviewTest,
        name: AppRoute.adjustProfilePreviewTest.name,
        builder: (context, state) => AdjustProfilePreviewTestPage(state: state),
      ),
      GoRoute(
        path: AppPaths.inviteFriendsPage,
        name: AppRoute.inviteFriendsPage.name,
        builder: (context, state) => const InviteFriendsPage(),
      ),
      GoRoute(
        path: AppPaths.toastTest,
        name: AppRoute.toastTest.name,
        builder: (context, state) => const ToastTestPage(),
      ),
      GoRoute(
        path: AppPaths.playingCardTest,
        name: AppRoute.playingCardTest.name,
        builder: (context, state) => const PlayingCardTestPage(),
      ),
      GoRoute(
        path: AppPaths.colorPickerTest,
        name: AppRoute.colorPickerTest.name,
        builder: (context, state) => const ColorPickerTestPage(),
      ),
      GoRoute(
        path: AppPaths.deckTargetTest,
        name: AppRoute.deckTargetTest.name,
        builder: (context, state) => const DeckTargetTestPage(),
      ),
      GoRoute(
        path: AppPaths.devHub,
        name: AppRoute.devHub.name,
        builder: (context, state) => const DevHubPage(),
      ),
      // ------------------- Decks Test Routes (outside shell, reference only) ------------------- //
      ...decksSubRoutes,
      GoRoute(
        path: AppPaths.inputDialogTest,
        name: AppRoute.inputDialogTest.name,
        builder: (context, state) => const InputDialogTestPage(),
      ),
      GoRoute(
        path: AppPaths.dialogTest,
        name: AppRoute.dialogTest.name,
        builder: (context, state) => const DialogTestPage(),
      ),
      GoRoute(
        path: AppPaths.stepDialogTest,
        name: AppRoute.stepDialogTest.name,
        builder: (context, state) => const StepDialogTestPage(),
      ),
      GoRoute(
        path: AppPaths.homeTutorialStepDialogTest,
        name: AppRoute.homeTutorialStepDialogTest.name,
        builder: (context, state) => const HomeTutorialStepDialogTestPage(),
      ),
      GoRoute(
        path: AppPaths.homeTutorialCompleted,
        name: AppRoute.homeTutorialCompleted.name,
        builder: (context, state) => const HomeTutorialCompletedPage(),
      ),
      GoRoute(
        path: AppPaths.homeReturnTest,
        name: AppRoute.homeReturnTest.name,
        builder: (BuildContext context, GoRouterState state) {
          final Object? extra = state.extra;
          final HomeReturnTestRouteArgs? args =
              extra is HomeReturnTestRouteArgs ? extra : null;
          return HomeReturnTestPage(
            key: ValueKey<int>(
              Object.hash(
                args?.showReturnToGame ?? false,
                args?.returnGameDescription ?? '',
              ),
            ),
            showReturnToGame: args?.showReturnToGame ?? false,
            returnGameDescription:
                args?.returnGameDescription ?? "Prompt'd - Round 1",
          );
        },
      ),
      GoRoute(
        path: AppPaths.homeInPartyTest,
        name: AppRoute.homeInPartyTest.name,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final Object? extra = state.extra;
          final Widget child = extra is HomeInPartyRouteArgs
              ? HomeInPartyTestPage(
                  partyTitle: extra.partyTitle,
                  partySubtitle: extra.partySubtitle,
                )
              : const HomeInPartyTestPage();
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: child,
            transitionDuration: SDeckMotionDuration.normal,
            reverseTransitionDuration: SDeckMotionDuration.normal,
            transitionsBuilder:
                (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
              final CurvedAnimation curved = CurvedAnimation(
                parent: animation,
                curve: SDeckMotionCurve.easeIn,
              );
              return FadeTransition(opacity: curved, child: child);
            },
          );
        },
      ),
    ],
  );
}
