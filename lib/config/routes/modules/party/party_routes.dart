// -----------------------------------------------------------------------------
// party_routes.dart
// -----------------------------------------------------------------------------
// Nested under /dev/tools. Prompt Setup Host, Custom Setup, Default Party,
// and Invite Sheet. Custom setup uses a sequential fade through surface.
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/dev_tools/party_dev_tools_page.dart';
import 'package:socialdeck/features/games/presentation/pages/default_party_page.dart';
import 'package:socialdeck/features/games/presentation/pages/invite_sheet_page.dart';
import 'package:socialdeck/features/games/presentation/pages/prompt_custom_setup_page.dart';
import 'package:socialdeck/features/games/presentation/pages/prompt_setup_host_page.dart';

CustomTransitionPage<void> _partyFadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    opaque: false,
    transitionDuration: SDeckMotionDuration.slower,
    reverseTransitionDuration: SDeckMotionDuration.slower,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final Animation<double> fadeIn = CurveTween(
        curve: const Interval(0.5, 1.0, curve: SDeckMotionCurve.easeIn),
      ).animate(animation);
      final Animation<double> fadeCovered = ReverseAnimation(
        CurveTween(
          curve: const Interval(0.0, 0.5, curve: SDeckMotionCurve.easeIn),
        ).animate(secondaryAnimation),
      );

      return FadeTransition(
        opacity: fadeIn,
        child: ColoredBox(
          color: context.semantic.surface,
          child: FadeTransition(
            opacity: fadeCovered,
            child: child,
          ),
        ),
      );
    },
  );
}

final List<GoRoute> partyRoutes = [
  GoRoute(
    path: 'party',
    name: AppRoute.partyDevTools.name,
    builder: (context, state) => const PartyDevToolsPage(),
    routes: [
      GoRoute(
        path: 'prompt-setup-host',
        name: AppRoute.promptSetupHostDev.name,
        builder: (context, state) => const PromptSetupHostPage(),
        routes: [
          GoRoute(
            path: 'custom-setup',
            name: AppRoute.promptCustomSetupDev.name,
            pageBuilder: (context, state) {
              return _partyFadePage(
                key: state.pageKey,
                child: const PromptCustomSetupPage(),
              );
            },
            routes: [
              GoRoute(
                path: 'other',
                name: AppRoute.promptCustomSetupOtherDev.name,
                pageBuilder: (context, state) {
                  return _partyFadePage(
                    key: state.pageKey,
                    child: const PromptCustomSetupOtherPage(),
                  );
                },
              ),
              GoRoute(
                path: 'mood',
                name: AppRoute.promptCustomSetupMoodDev.name,
                pageBuilder: (context, state) {
                  return _partyFadePage(
                    key: state.pageKey,
                    child: const PromptCustomSetupMoodPage(),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'other',
                    name: AppRoute.promptCustomSetupMoodOtherDev.name,
                    pageBuilder: (context, state) {
                      return _partyFadePage(
                        key: state.pageKey,
                        child: const PromptCustomSetupMoodOtherPage(),
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'keywords',
                name: AppRoute.promptCustomSetupKeywordsDev.name,
                pageBuilder: (context, state) {
                  return _partyFadePage(
                    key: state.pageKey,
                    child: const PromptCustomSetupKeywordsPage(),
                  );
                },
              ),
              GoRoute(
                path: 'generating',
                name: AppRoute.promptCustomSetupGeneratingDev.name,
                pageBuilder: (context, state) {
                  return _partyFadePage(
                    key: state.pageKey,
                    child: const PromptCustomSetupGeneratingPage(),
                  );
                },
              ),
              GoRoute(
                path: 'finalizing',
                name: AppRoute.promptCustomSetupFinalizingDev.name,
                pageBuilder: (context, state) {
                  return _partyFadePage(
                    key: state.pageKey,
                    child: const PromptCustomSetupFinalizingPage(),
                  );
                },
              ),
              GoRoute(
                path: 'complete',
                name: AppRoute.promptCustomSetupCompleteDev.name,
                pageBuilder: (context, state) {
                  return _partyFadePage(
                    key: state.pageKey,
                    child: const PromptCustomSetupCompletePage(),
                  );
                },
              ),
              GoRoute(
                path: 'example',
                name: AppRoute.promptCustomSetupExampleDev.name,
                pageBuilder: (context, state) {
                  return _partyFadePage(
                    key: state.pageKey,
                    child: const PromptCustomSetupExamplePage(),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: AppRoute.promptCustomSetupExampleEditDev.name,
                    pageBuilder: (context, state) {
                      return _partyFadePage(
                        key: state.pageKey,
                        child: const PromptCustomSetupExampleEditPage(),
                      );
                    },
                  ),
                  GoRoute(
                    path: '2',
                    name: AppRoute.promptCustomSetupExample2Dev.name,
                    pageBuilder: (context, state) {
                      return _partyFadePage(
                        key: state.pageKey,
                        child: const PromptCustomSetupExample2Page(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        name: AppRoute.promptCustomSetupExample2EditDev.name,
                        pageBuilder: (context, state) {
                          return _partyFadePage(
                            key: state.pageKey,
                            child: const PromptCustomSetupExample2EditPage(),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: '3',
                    name: AppRoute.promptCustomSetupExample3Dev.name,
                    pageBuilder: (context, state) {
                      return _partyFadePage(
                        key: state.pageKey,
                        child: const PromptCustomSetupExample3Page(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        name: AppRoute.promptCustomSetupExample3EditDev.name,
                        pageBuilder: (context, state) {
                          return _partyFadePage(
                            key: state.pageKey,
                            child: const PromptCustomSetupExample3EditPage(),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: 'default-party',
        name: AppRoute.defaultPartyDev.name,
        pageBuilder: (context, state) {
          return _partyFadePage(
            key: state.pageKey,
            child: const DefaultPartyPage(),
          );
        },
      ),
      GoRoute(
        path: 'invite-sheet',
        name: AppRoute.inviteSheetDev.name,
        builder: (context, state) => const InviteSheetPage(),
      ),
    ],
  ),
];
