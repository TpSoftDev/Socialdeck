import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

import 'home_party_flow_dialogs.dart';

//--------------------------- HomeInPartyRouteArgs ---------------------------//
class HomeInPartyRouteArgs {
  const HomeInPartyRouteArgs({
    this.partyTitle = "eth6nhunt's Party",
    this.partySubtitle = "Prompt'd",
  });

  final String partyTitle;
  final String partySubtitle;

  /// Party strip title after **Create Party** → in-game name (e.g. `Alex` →
  /// **Alex's Party**), same subtitle as default until a game is chosen.
  factory HomeInPartyRouteArgs.fromCreatedPartyInGameName(String inGameName) {
    final String n = inGameName.trim();
    return HomeInPartyRouteArgs(
      partyTitle: "$n's Party",
      partySubtitle: "Prompt'd",
    );
  }
}

//----------------------------- HomeInPartyTestPage --------------------------//
/// Home – In Party
/// Top: **Home** + avatar; then current party card, **What’s New?** carousel,
/// **Create Party** / **Join a Party**; bottom nav matches shell tabs.
/// The carousel sits in an [Expanded] so its height **fills whatever space is
/// left** after the three cards and gaps (Figma may show a fixed artboard
/// height; in Flutter this tracks the real viewport and keyboard).
class HomeInPartyTestPage extends StatelessWidget {
  const HomeInPartyTestPage({
    super.key,
    this.partyTitle = "eth6nhunt's Party",
    this.partySubtitle = "Prompt'd",
  });

  /// Leader party title (e.g. `eth6nhunt's Party`).
  final String partyTitle;

  /// Secondary line (e.g. selected game `Prompt'd`).
  final String partySubtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SDeckTopNavigationBar.titleWithAvatar(
              title: 'Home',
              showBottomFade: true,
              avatar: Image.asset(
                SDeckIcon.checkeredBackground,
                fit: BoxFit.cover,
              ),
              onActionPressed: null,
            ),
            Expanded(
              child: Padding(
                // Figma (Home): `Space/Padding/padding16` between last card
                // (Join) and `bottomNavBar`; bar uses `padding24` top / `padding16`
                // bottom internally (node 314:2819).
                padding: const EdgeInsets.fromLTRB(
                  SDeckSpace.padding16,
                  SDeckSpace.gap8,
                  SDeckSpace.padding16,
                  SDeckSpace.padding16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SDeckSelectionTargetCard(
                      title: partyTitle,
                      description: partySubtitle,
                      backgroundAssetPath:
                          SDeckIcon.checkeredBackground,
                      onTap: () {},
                    ),
                    const SizedBox(height: SDeckSpace.gap8),
                    Expanded(
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return SDeckCarouselCard(
                            title: "What's New?",
                            description:
                                "Here's an update on what's going on...",
                            totalSegments: 3,
                            currentIndex: 0,
                            height: constraints.maxHeight,
                            backgroundAssetPath:
                                SDeckIcon.checkeredBackground,
                            onPrevious: () {},
                            onNext: () {},
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: SDeckSpace.gap8),
                    SDeckSelectionTargetCard(
                      title: 'Create Party',
                      description: 'Start a new game',
                      backgroundAssetPath:
                          SDeckIcon.checkeredBackground,
                          onTap: () => HomePartyFlowDialogs.showLeavePartyThen(
                            context,
                            onLeaveParty: () =>
                                HomePartyFlowDialogs.showCreatePartyLetsBegin(
                              context,
                              onNamedComplete:
                                  (BuildContext ctx, String inGameName) {
                                ctx.go(
                                  AppPaths.homeInPartyTest,
                                  extra:
                                      HomeInPartyRouteArgs.fromCreatedPartyInGameName(
                                    inGameName,
                                  ),
                                );
                              },
                            ),
                            onDisbandParty: () =>
                                context.go(AppPaths.homeReturnTest),
                          ),
                    ),
                    const SizedBox(height: SDeckSpace.gap8),
                    SDeckSelectionTargetCard(
                      title: 'Join a Party',
                      description: 'Insert a game code',
                      backgroundAssetPath:
                          SDeckIcon.checkeredBackground,
                      onTap: () => HomePartyFlowDialogs.showLeavePartyThen(
                            context,
                            onLeaveParty: () =>
                                HomePartyFlowDialogs.showJoinPartyFlow(
                              context,
                            ),
                            onDisbandParty: () =>
                                context.go(AppPaths.homeReturnTest),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SDeckBottomNavBar(
        currentIndex: 0,
        items: SDeckBottomNavBar.defaultItems,
        onTap: (int index) {
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
      ),
    );
  }
}
