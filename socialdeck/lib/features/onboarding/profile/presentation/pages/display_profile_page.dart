/*-------------------- display_profile_page.dart -----------------------*/
// Display Profile Page for onboarding flow
// Screen 6: Shows final adjusted photo in clean display format
// No borders, overlays, or adjustment controls - just the beautiful result
//
// User Journey: Adjustments complete → "Looks Perfect!" → Clean final display
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_profile_card_template.dart';
import '../services/test_profile_storage.dart';

class DisplayProfilePage extends ConsumerStatefulWidget {
  /// The router state containing URL parameters (imagePath, scale, panX, panY)
  final GoRouterState state;

  const DisplayProfilePage({super.key, required this.state});

  @override
  ConsumerState<DisplayProfilePage> createState() => _DisplayProfilePageState();
}

class _DisplayProfilePageState extends ConsumerState<DisplayProfilePage> {
  //*************************** Build Method *******************************//

  @override
  Widget build(BuildContext context) {
    // Extract all adjustment data from URL parameters
    final String? imagePath = widget.state.uri.queryParameters['imagePath'];
    final double scale =
        double.tryParse(widget.state.uri.queryParameters['scale'] ?? '1.0') ??
        1.0;
    final double panX =
        double.tryParse(widget.state.uri.queryParameters['panX'] ?? '0.0') ??
        0.0;
    final double panY =
        double.tryParse(widget.state.uri.queryParameters['panY'] ?? '0.0') ??
        0.0;

    return OnboardingProfileCardTemplate(
      title: "Perfect!",
      profileCard: SDeckDisplayProfileCard(
        imagePath: imagePath,
        scale: scale,
        panX: panX,
        panY: panY,
      ),
      bottomActions: [
        // Primary action - Continue to next step (Invite Friends)
        SDeckSolidButton.large(
          text: "Continue",
          fullWidth: true,
          onPressed: _handleContinue,
        ),

        // Secondary action - Go back to make more adjustments
        SDeckHollowButton.large(
          text: "Adjust Again",
          fullWidth: true,
          onPressed: _handleAdjustAgain,
        ),
      ],
    );
  }

  //*************************** Implementation Details *********************//

  /// Handle "Continue" button press
  /// Navigate to final onboarding screen (Invite Friends - Screen 7)
  void _handleContinue() async {
    print('✅ User satisfied with photo - continuing to invite friends');

    // Extract the profile data from URL parameters (same as build method)
    final String? imagePath = widget.state.uri.queryParameters['imagePath'];
    final double scale =
        double.tryParse(widget.state.uri.queryParameters['scale'] ?? '1.0') ??
        1.0;
    final double panX =
        double.tryParse(widget.state.uri.queryParameters['panX'] ?? '0.0') ??
        0.0;
    final double panY =
        double.tryParse(widget.state.uri.queryParameters['panY'] ?? '0.0') ??
        0.0;

    // Save the profile data to device storage for testing
    if (imagePath != null) {
      await TestProfileStorage.saveProfile(
        imagePath: imagePath,
        scale: scale,
        panX: panX,
        panY: panY,
      );
      print('💾 Profile data saved for login testing!');
    }

    if (mounted) {
      // Navigate to invite friends page (final onboarding step)
      context.push('/profile/invite-friends');
    }
  }

  /// Handle "Adjust Again" button press
  /// Navigate back to adjustment screen with same photo
  void _handleAdjustAgain() {
    final String? imagePath = widget.state.uri.queryParameters['imagePath'];

    if (imagePath != null) {
      print('🔄 User wants to adjust photo again');
      // Navigate back to adjust screen with original photo
      context.pushReplacement(
        '/profile/adjust?imagePath=${Uri.encodeComponent(imagePath)}',
      );
    } else {
      print('❌ No image path available for re-adjustment');
    }
  }
}
