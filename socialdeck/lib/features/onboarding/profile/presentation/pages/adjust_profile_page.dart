/*-------------------- adjust_profile_page.dart -----------------------*/
// Adjust Profile Page for onboarding flow
// Screen 4: User adjusts their selected photo with scale/move/rotate
// Shows photo in adjustment card with "Looks Perfect!" and "Change Picture" buttons
//
// User Journey: Photo selected → User adjusts → "Looks Perfect!" or "Change Picture"
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_profile_card_template.dart';
import 'package:socialdeck/features/onboarding/shared/utils/photo_picker_helper.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/services/profile_photo_picker_service.dart';

class AdjustProfilePage extends ConsumerStatefulWidget {
  /// The router state containing URL parameters (imagePath)
  final GoRouterState state;

  const AdjustProfilePage({super.key, required this.state});

  @override
  ConsumerState<AdjustProfilePage> createState() => _AdjustProfilePageState();
}

class _AdjustProfilePageState extends ConsumerState<AdjustProfilePage> {
  //*************************** Build Method *******************************//

  @override
  Widget build(BuildContext context) {
    // Extract image path from URL parameters
    final String? imagePath = widget.state.uri.queryParameters['imagePath'];

    return OnboardingProfileCardTemplate(
      title: "Adjust Photo",
      profileCard: SDeckAdjustProfileCard(
        key: _adjustCardKey,
        imagePath: imagePath,
        showOverlay: _showOverlay,
        hideOverlay: _hideOverlay,
        onTransformChanged: _onTransformChanged,
      ),
      bottomActions: [
        // Primary action - User is happy with photo
        SDeckSolidButton.large(
          text: "Looks Perfect!",
          fullWidth: true,
          onPressed: _handleLooksPerfect,
        ),

        // Secondary action - User wants different photo
        SDeckHollowButton.large(
          text: "Change Picture",
          fullWidth: true,
          onPressed: _handleChangePicture,
        ),
      ],
    );
  }

  //*************************** Services & Implementation Details ***********//
  /// Photo picker service for "Change Picture" functionality
  final _photoService = ProfilePhotoPickerService();

  /// State for overlay visibility (show instructions initially)
  bool _showOverlay = true;

  /// Captured transform data from user adjustments
  double? _savedScale;
  double? _savedPanX;
  double? _savedPanY;

  /// Key to access adjust card methods (CRITICAL for data capture)
  final GlobalKey _adjustCardKey = GlobalKey();

  /// Hide the overlay when user first touches the photo
  void _hideOverlay() {
    setState(() {
      _showOverlay = false;
    });
  }

  /// Capture transform data when user adjusts photo
  void _onTransformChanged(double scale, double panX, double panY) {
    setState(() {
      _savedScale = scale;
      _savedPanX = panX;
      _savedPanY = panY;
    });
  }

  /// Handle "Looks Perfect!" button press
  /// Navigate to display screen with adjustment data
  void _handleLooksPerfect() {
    print('✅ User happy with photo adjustments');
    print('💾 Capturing current adjustments from card...');

    // Extract image path for navigation
    final String? imagePath = widget.state.uri.queryParameters['imagePath'];

    // CRITICAL: Capture current transform data from the card component
    if (_adjustCardKey.currentState != null) {
      // This triggers onTransformChanged callback with REAL current data
      (_adjustCardKey.currentState as dynamic).captureCurrentAdjustments();

      // Navigate with captured data
      if (_savedScale != null && imagePath != null) {
        final String displayUrl =
            '/profile/display?'
            'imagePath=${Uri.encodeComponent(imagePath)}&'
            'scale=$_savedScale&'
            'panX=$_savedPanX&'
            'panY=$_savedPanY';

        print('🚀 Navigating to display screen: $displayUrl');
        print(
          '📊 Final data: Scale=$_savedScale, PanX=$_savedPanX, PanY=$_savedPanY',
        );
        context.push(displayUrl);
      } else {
        print('⚠️ No transform data captured yet');
      }
    } else {
      print('❌ Could not access adjust card state');
    }
  }

  /// Handle "Change Picture" button press
  /// Shows photo picker modal (same as Screen 2)
  void _handleChangePicture() {
    PhotoPickerHelper.showPhotoPicker(
      context: context,
      title: "Change Picture",
      onCameraPressed: _handleCameraSelection,
      onGalleryPressed: _handleGallerySelection,
    );
  }

  /// Handle camera selection from "Change Picture" modal
  Future<void> _handleCameraSelection() async {
    Navigator.pop(context); // Close modal first

    final photo = await _photoService.pickFromCamera();

    if (photo != null) {
      print('📷 New camera photo selected: ${photo.name}');
      // Replace current photo by navigating to adjust screen with new photo
      if (mounted) {
        context.pushReplacement('/profile/adjust?imagePath=${photo.path}');
      }
    } else {
      print('❌ Camera photo selection failed');
    }
  }

  /// Handle gallery selection from "Change Picture" modal
  Future<void> _handleGallerySelection() async {
    Navigator.pop(context); // Close modal first

    final photo = await _photoService.pickFromGallery();

    if (photo != null) {
      print('🖼️ New gallery photo selected: ${photo.name}');
      // Replace current photo by navigating to adjust screen with new photo
      if (mounted) {
        context.pushReplacement('/profile/adjust?imagePath=${photo.path}');
      }
    } else {
      print('❌ Gallery photo selection failed');
    }
  }
}
