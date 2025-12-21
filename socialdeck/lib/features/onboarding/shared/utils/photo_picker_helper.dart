/*-------------------- photo_picker_helper.dart -----------------------*/
// Photo Picker Helper Utility for onboarding screens
// Reusable modal logic that handles photo selection UI
// Used by multiple screens: "Insert Photo" and "Change Picture" flows
//
// Usage:
//   PhotoPickerHelper.showPhotoPicker(
//     context: context,
//     title: "Insert Photo",
//     onCameraPressed: () => _handleCamera(),
//     onGalleryPressed: () => _handleGallery(),
//   );
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class PhotoPickerHelper {
  // Private constructor to prevent instantiation (utility class)
  PhotoPickerHelper._();

  //*************************** Public Static Methods *********************//

  /// Shows the photo picker modal with camera and gallery options
  /// Uses SDeckBottomSheet for consistent design system styling
  ///
  /// Parameters:
  /// - [context]: BuildContext for showing the modal
  /// - [title]: Modal title ("Insert Photo" vs "Change Picture")
  /// - [onCameraPressed]: Callback when "Take a Photo!" button is pressed
  /// - [onGalleryPressed]: Callback when "View Camera Roll" button is pressed
  static void showPhotoPicker({
    required BuildContext context,
    required String title,
    required VoidCallback onCameraPressed,
    required VoidCallback onGalleryPressed,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent, // Let SDeckBottomSheet handle background
      builder:
          (context) => SDeckBottomSheet(
            title: title,
            showHomeIndicator: false, // Let iOS handle its own home indicator
            child: Column(
              children: [
                // Primary action - Take a Photo
                SDeckSolidButton.large(
                  text: "Take a Photo!",
                  fullWidth: true,
                  onPressed: onCameraPressed,
                ),

                SizedBox(height: SDeckSpace.gapXS), // 8px gap between buttons
                // Secondary action - View Camera Roll
                SDeckHollowButton.large(
                  text: "View Camera Roll",
                  fullWidth: true,
                  onPressed: onGalleryPressed,
                ),
              ],
            ),
          ),
    );
  }
}
