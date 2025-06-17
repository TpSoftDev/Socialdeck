import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/components/cards/sdeck_adjust_profile_card.dart';
import 'package:socialdeck/design_system/index.dart';

class AdjustProfileTestPage extends StatelessWidget {
  final GoRouterState state;

  const AdjustProfileTestPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // Extract image path from URL parameters
    final String? imagePath = state.uri.queryParameters['imagePath'];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.logoWithSkip(),

            SizedBox(height: SDeckSpacing.x16),
            Center(child: SDeckAdjustProfileCard(imagePath: imagePath)),

          ],
        ),
      ),
    );
  }
}
