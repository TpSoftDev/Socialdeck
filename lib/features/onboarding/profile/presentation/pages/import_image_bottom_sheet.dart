/*-------------------- import_image_bottom_sheet.dart --------------------*/
// Import Image Bottom Sheet
//
// Purpose:
// - Appears when the user taps "Add a Photo"
// - Lets the user choose between Camera Roll and Take a Picture
// - Requests permission while the bottom sheet is still visible
// - If permission is granted:
//     -> opens gallery/camera
//     -> returns the selected/captured image to the parent page
// - If permission is denied:
//     -> closes the modal
//     -> navigates to Unable to Continue screen
//
// Notes:
// - Supports both Android and iOS
// - Native permission dialogs appear above this bottom sheet
/*-----------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

class ImportImageBottomSheet extends StatelessWidget {
  const ImportImageBottomSheet({super.key});

  //*************************** Figma Size Constants ***************************//
  // Placeholder image shown in the tip section.
  static const double _kVisualPlaceholderSize = 92.5;

  // Max width for the helper/description text.
  // This keeps the Figma feel while still allowing responsive wrapping.
  static const double _kTipDescriptionMaxWidth = 237.5;

  //*************************** Camera Roll Flow *******************************//
  // Requests photo permission and opens the gallery if allowed.
  Future<void> _handleCameraRoll(BuildContext context) async {
    final PermissionStatus status = await Permission.photos.request();

    //------------------------ Permission Granted ------------------------//
    if (status.isGranted || status.isLimited) {
      final ImagePicker picker = ImagePicker();

      // Open the native gallery picker.
      final XFile? selectedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );

      // If the user chose an image, return it to the parent screen.
      if (selectedImage != null && context.mounted) {
        Navigator.of(context).pop(selectedImage);
      }

      return;
    }

    //------------------------ Permission Denied -------------------------//
    // Figma edge case:
    // close modal and bring user to "Unable to Continue"
    if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
      if (context.mounted) {
        Navigator.of(context).pop();
        context.goNamed(AppRoute.unableToContinue.name);
      }
    }
  }

  //*************************** Camera Flow **********************************//
  // Requests camera permission and opens the camera if allowed.
  Future<void> _handleTakePicture(BuildContext context) async {
    final PermissionStatus status = await Permission.camera.request();

    //------------------------ Permission Granted ------------------------//
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();

      // Open the native camera.
      final XFile? capturedImage = await picker.pickImage(
        source: ImageSource.camera,
      );

      // If the user took a photo successfully, return it to the parent screen.
      if (capturedImage != null && context.mounted) {
        Navigator.of(context).pop(capturedImage);
      }

      return;
    }

    //------------------------ Permission Denied -------------------------//
    if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
      if (context.mounted) {
        Navigator.of(context).pop();
        context.goNamed(AppRoute.unableToContinue.name);
      }
    }
  }

  //*************************** Build Method *******************************//
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Bottom sheet surface color.
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(SDeckRadius.borderRadius16),
          topRight: Radius.circular(SDeckRadius.borderRadius16),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            SDeckSpace.padding24,
            SDeckSpace.padding24,
            SDeckSpace.padding24,
            SDeckSpace.padding48,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //------------------------ Header + Tip Section ------------------------//
              // Stack lets the close button sit top-right without affecting
              // the title/tip spacing.
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: SDeckSpace.padding48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //------------------------ Title ------------------------//
                        Text(
                          'Import Image',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: context.component.textPrimary,
                              ),
                        ),

                        const SizedBox(height: SDeckSpace.padding16),

                        //------------------------ Tip Row ------------------------//
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //------------------------ Small Placeholder --------//
                            Container(
                              width: _kVisualPlaceholderSize,
                              height: _kVisualPlaceholderSize,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  SDeckRadius.borderRadius16,
                                ),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    SDeckIcon.checkeredBackground,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(width: SDeckSpace.gap12),

                            //------------------------ Tip Text ------------------//
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        size: 18,
                                        color: context.component.iconPrimary,
                                      ),
                                      const SizedBox(width: SDeckSpace.gap8),
                                      Text(
                                        'Comedy Tip',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: context
                                                  .component.textPrimary,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: SDeckSpace.gap4),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: _kTipDescriptionMaxWidth,
                                    ),
                                    child: Text(
                                      'This works best with head-and-shoulders photos.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: context
                                                .component.textSecondary,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  //------------------------ Close Button ------------------------//
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: context.component.iconPrimary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: SDeckSpace.gap16),

              //------------------------ Camera Roll Button ------------------------//
              SizedBox(
                width: double.infinity,
                child: SDeckSolidButton(
                  text: 'Camera Roll',
                  size: SDeckButtonSize.large,
                  fullWidth: true,
                  iconLocation: SDeckButtonIconLocation.left,
                  icon: SDeckIcons(
                    SDeckIcon.grid,
                    size: SDeckSize.size24,
                    color: context.component.iconPrimary,
                  ),
                  onPressed: () async {
                    // Native permission dialog should appear on top of
                    // the bottom sheet, so do NOT close the bottom sheet first.
                    await _handleCameraRoll(context);
                  },
                ),
              ),

              const SizedBox(height: SDeckSpace.gap8),

              //------------------------ Take a Picture Button ----------------------//
              SizedBox(
                width: double.infinity,
                child: SDeckOutlineButton(
                  text: 'Take a Picture',
                  size: SDeckButtonSize.large,
                  fullWidth: true,
                  iconLocation: SDeckButtonIconLocation.left,
                  icon: SDeckIcons(
                    SDeckIcon.camera,
                    size: SDeckSize.size24,
                    color: context.component.iconPrimary,
                  ),
                  onPressed: () async {
                    // Same as gallery flow:
                    // request permission while the sheet is still visible.
                    await _handleTakePicture(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}