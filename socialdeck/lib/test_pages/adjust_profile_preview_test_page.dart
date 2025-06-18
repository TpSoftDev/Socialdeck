import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/components/cards/sdeck_display_profile_card.dart';
import 'package:socialdeck/design_system/index.dart';

class AdjustProfilePreviewTestPage extends StatelessWidget {
  final GoRouterState state;

  const AdjustProfilePreviewTestPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // Extract data from URL parameters
    final String? imagePath = state.uri.queryParameters['imagePath'];
    final double scale =
        double.tryParse(state.uri.queryParameters['scale'] ?? '1.0') ?? 1.0;
    final double panX =
        double.tryParse(state.uri.queryParameters['panX'] ?? '0.0') ?? 0.0;
    final double panY =
        double.tryParse(state.uri.queryParameters['panY'] ?? '0.0') ?? 0.0;

    print('🎯 Preview page received: Scale=$scale, PanX=$panX, PanY=$panY');
    print('📷 Image path received: $imagePath');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.backWithLogo(
              onBackPressed: () => context.pop(),
            ),

            SizedBox(height: SDeckSpacing.x24),

            // Display final result
            Center(
              child: SDeckDisplayProfileCard(
                imagePath: imagePath,
                scale: scale,
                panX: panX,
                panY: panY,
              ),
            ),

            SizedBox(height: SDeckSpacing.x24),

            // Back to adjust button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SDeckSpacing.x16),
              child: SDeckSolidButton.large(
                text: 'Back to Adjust',
                fullWidth: true,
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
