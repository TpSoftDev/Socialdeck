import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

import 'home_in_party_test_page.dart';
import 'home_party_flow_dialogs.dart';

//------------------------------- HomeReturnTestPage -------------------------//
/// Stateless preview of the Figma **Home – Returning** screen (top bar
/// 314:2814, carousel 314:2816, selection targets, bottom nav 314:2819).
/// Vertical rhythm: `Space/Gap/gap8` between carousel and cards; `padding16`
/// above the bottom nav (Dev Mode).
/// Pushed from [HomePage] via [AppPaths.homeReturnTest].
///
/// **Join a Party** → Let's Begin → Enter Code → pushes **Home – In Party**
///
/// **Create Party** → **Let's Begin!** → **Home – In Party** with the typed
/// in-game name on the party strip.
class HomeReturnTestPage extends StatelessWidget {
  const HomeReturnTestPage({super.key});


  static double _carouselHeightForLayout(double maxViewportY) {
    const double approxHugSelectionRow = 84.0;
    const double reservedExcludingCarousel =
        SDeckSpace.gap8 + // under top bar
        SDeckSpace.gap8 + // under carousel
        approxHugSelectionRow * 2 +
        SDeckSpace.gap8 + // between selection targets
        SDeckSpace.padding16;

    if (!maxViewportY.isFinite || maxViewportY <= 0) {
      return 400;
    }
    final double fill = maxViewportY - reservedExcludingCarousel;
    return fill.clamp(220.0, 520.0);
  }

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
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double carouselH = _carouselHeightForLayout(
                    constraints.maxHeight,
                  );
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SDeckSpace.padding16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: SDeckSpace.gap8),
                        SizedBox(
                          height: carouselH,
                          child: SDeckCarouselCard(
                            title: "What's New?",
                            description:
                                "Here's an update on what's going on...",
                            totalSegments: 3,
                            currentIndex: 0,
                            height: carouselH,
                            backgroundAssetPath:
                                SDeckIcon.checkeredBackground,
                            onPrevious: () {},
                            onNext: () {},
                          ),
                        ),
                        const SizedBox(height: SDeckSpace.gap8),
                        SDeckSelectionTargetCard(
                          title: 'Create Party',
                          description: 'Start a new game',
                          backgroundAssetPath:
                              SDeckIcon.checkeredBackground,
                          onTap: () => HomePartyFlowDialogs.showCreatePartyLetsBegin(
                                context,
                                onNamedComplete:
                                    (BuildContext ctx, String inGameName) {
                                  ctx.push(
                                    AppPaths.homeInPartyTest,
                                    extra:
                                        HomeInPartyRouteArgs.fromCreatedPartyInGameName(
                                      inGameName,
                                    ),
                                  );
                                },
                              ),
                        ),
                        const SizedBox(height: SDeckSpace.gap8),
                        SDeckSelectionTargetCard(
                          title: 'Join a Party',
                          description: 'Insert a game code',
                          backgroundAssetPath:
                              SDeckIcon.checkeredBackground,
                          onTap: () => HomePartyFlowDialogs.showJoinPartyFlow(
                            context,
                            onJoinCompleted:
                                (BuildContext ctx, String _, String __) {
                              ctx.push(
                                AppPaths.homeInPartyTest,
                                extra: const HomeInPartyRouteArgs(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: SDeckSpace.padding16),
                      ],
                    ),
                  );
                },
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
