import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- HomeReturnTestPage -------------------------//
/// Stateless preview of the Figma **Home – Returning** screen (top bar
/// 314:2814, carousel 314:2816, selection targets, bottom nav 314:2819).
/// Pushed from [HomePage] via [AppPaths.homeReturnTest].
///
/// Top bar: [SDeckTopNavigationBar.titleWithAvatar] — **Home** (H4) and
/// profile placeholder, **no back chevron** (per Figma). Use the system back
/// gesture / Android back to return from this pushed route.
///
/// Bottom bar matches the main shell tabs so you can jump to other tabs
/// ([SDeckBottomNavBar]); **Home** uses [context.go] to `/home` (leaves this
/// test route).
class HomeReturnTestPage extends StatelessWidget {
  const HomeReturnTestPage({super.key});

  /// Carousel height from content width (Figma card is roughly square).
  static double _carouselHeightForWidth(double width) {
    return (width * 1.0).clamp(240.0, 440.0);
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
                  final double w = constraints.maxWidth -
                      2 * SDeckSpace.padding16;
                  final double carouselH = _carouselHeightForWidth(w);
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SDeckSpace.padding16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: SDeckSpace.gap12),
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
                        const SizedBox(height: SDeckSpace.gap12),
                        SDeckSelectionTargetCard(
                          title: 'Create Party',
                          description: 'Start a new game',
                          backgroundAssetPath:
                              SDeckIcon.checkeredBackground,
                          onTap: () => _showSnack(context, 'Create Party'),
                        ),
                        const SizedBox(height: SDeckSpace.gap12),
                        SDeckSelectionTargetCard(
                          title: 'Join a Party',
                          description: 'Insert a game code',
                          backgroundAssetPath:
                              SDeckIcon.checkeredBackground,
                          onTap: () => _showSnack(context, 'Join a Party'),
                        ),
                        const SizedBox(height: SDeckSpace.gap16),
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

  static void _showSnack(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label tapped')),
    );
  }
}
