/*-------------------- add_profile_card_page.dart -----------------------*/
// Add Profile Card Onboarding Page
// First screen in profile photo onboarding flow
// Shows empty profile card with "Add Card" button
//
// User Journey: Empty card → User taps "Add Card" → Photo picker modal
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_profile_card_template.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/services/profile_photo_picker_service.dart';
import 'package:socialdeck/features/onboarding/shared/utils/photo_picker_helper.dart';

class AddProfileCardPage extends ConsumerStatefulWidget {
  const AddProfileCardPage({super.key});

  @override
  ConsumerState<AddProfileCardPage> createState() => _AddProfileCardPageState();
}

class _AddProfileCardPageState extends ConsumerState<AddProfileCardPage> {
  //*************************** Build Method *******************************//

  @override
  Widget build(BuildContext context) {
    return OnboardingProfileCardTemplate(
      title: "Profile Card",
      subtitle: "Upload a picture to help others find and identify you.",
      profileCard: SDeckCreateProfileCard(
        onTap: _showPhotoPickerModal, // Shows modal using helper
      ),
      // bottomActions: [] - Empty for Screen 1 (modal triggered by card tap)
    );
  }

  //*************************** Services & Implementation Details ***********//
  /// Photo picker service handles camera/gallery business logic
  /// Service pattern: UI logic stays in page, business logic in service
  final _photoService = ProfilePhotoPickerService();

  /// Shows photo picker modal using the shared PhotoPickerHelper
  /// Delegates to helper for consistent modal UI across app
  void _showPhotoPickerModal() {
    PhotoPickerHelper.showPhotoPicker(
      context: context,
      title: "Insert Photo",
      onCameraPressed: _handleCameraSelection,
      onGalleryPressed: _handleGallerySelection,
    );
  }

  /// Handles camera button press from modal
  /// Closes modal, picks photo from camera, navigates on success
  Future<void> _handleCameraSelection() async {
    Navigator.pop(context); // Close modal first

    // Use service to pick photo from camera
    final photo = await _photoService.pickFromCamera();

    if (photo != null) {
      print('📷 Camera photo selected: ${photo.name}');
      // Navigate to adjustment screen with photo path
      if (mounted) {
        context.push('/profile/adjust?imagePath=${photo.path}');
      }
    } else {
      // Handle error case (permissions denied, no camera, etc.)
      print('❌ Camera photo selection failed');
      // TODO: Remove SnackBar 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not access camera. Please check permissions.'),
          ),
        );
      }
    }
  }

  /// Handles gallery button press from modal
  /// Closes modal, picks photo from gallery, navigates on success
  Future<void> _handleGallerySelection() async {
    Navigator.pop(context); // Close modal first

    // Use service to pick photo from gallery
    final photo = await _photoService.pickFromGallery();

    if (photo != null) {
      print('🖼️ Gallery photo selected: ${photo.name}');
      // Navigate to adjustment screen with photo path
      if (mounted) {
        context.push('/profile/adjust?imagePath=${photo.path}');
      }
    } else {
      // Handle error case (permissions denied, cancelled, etc.)
      print('❌ Gallery photo selection failed');
      // TODO: Remove SnackBar 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not access gallery. Please check permissions.',
            ),
          ),
        );
      }
    }
  }
}
