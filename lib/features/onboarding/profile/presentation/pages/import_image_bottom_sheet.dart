/*-------------------- import_image_bottom_sheet.dart --------------------*/
// Import Image Bottom Sheet
//
// Purpose:
// - Appears when the user taps "Add a Photo"
// - Lets the user choose between Camera Roll and Take a Picture
// - Requests permission while the bottom sheet is still visible
// - If permission is granted:
//     -> opens gallery/camera
//     -> validates the selected image
//     -> returns the selected/captured image to the parent page if valid
// - If permission is denied:
//     -> closes the modal
//     -> navigates to Unable to Continue screen
//
// Validation behavior:
// - File too large -> show DS error toast, keep bottom sheet open
// - Unsupported file type -> show DS error toast, keep bottom sheet open
//
// Notes:
// - Supports both Android and iOS
// - Native permission dialogs appear above this bottom sheet
// - Uses reusable DS toast display helper instead of local banners
// - This file now uses the reusable SDeckBottomSheet design-system component
//   as the outer shell, rather than re-implementing the sheet container here.
/*-----------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

/// Validates a picked image before the app accepts it.
///
/// Returns:
/// - true  -> image is valid and can continue
/// - false -> image is invalid and an error toast has been shown
///
/// Validation rules:
/// - max size: 5 MB
/// - supported formats: .jpg, .jpeg, .png, .webp
///
/// Why this is top-level instead of inside the widget:
/// - easier to read
/// - reusable if this validation is needed somewhere else later
Future<bool> _validatePickedImage(
  BuildContext context,
  XFile image,
) async {
  //------------------------ File Size Check ------------------------------//
  // XFile.length() is async, so we await it before validating.
  final int fileSizeInBytes = await image.length();

  // Since we awaited above, always check context.mounted before using context.
  if (!context.mounted) return false;

  // 5 MB maximum
  const int maxBytes = 5 * 1024 * 1024;

  if (fileSizeInBytes > maxBytes) {
    await showSDeckToast(
      context: context,
      status: SDeckToastStatus.error,
      title: 'File too large',
      description:
          'This image exceeds the size limit of 5 MB.\nPlease choose a smaller image.',
    );
    return false;
  }

  //------------------------ File Type Check ------------------------------//
  // Basic extension-based validation.
  //
  // Note:
  // This is a good first-pass check for the UI flow.
  // If your team later wants stricter validation, you could inspect MIME type too.
  final String lowerPath = image.path.toLowerCase();

  final bool supported =
      lowerPath.endsWith('.jpg') ||
      lowerPath.endsWith('.jpeg') ||
      lowerPath.endsWith('.png') ||
      lowerPath.endsWith('.webp');

  if (!supported) {
    await showSDeckToast(
      context: context,
      status: SDeckToastStatus.error,
      title: 'Can’t upload image',
      description: 'That file type isn’t supported. Try a different format.',
    );
    return false;
  }

  //------------------------ Passed Validation ----------------------------//
  return true;
}

class ImportImageBottomSheet extends StatelessWidget {
  const ImportImageBottomSheet({super.key});

  //*************************** Figma Size Constants ***************************//
  /// Placeholder image shown in the tip section.
  static const double _kVisualPlaceholderSize = 92.5;

  /// Max width for the helper/description text.
  /// This keeps the Figma feel while still allowing responsive wrapping.
  static const double _kTipDescriptionMaxWidth = 237.5;

  //*************************** Camera Roll Flow *******************************//
  /// Requests photo permission and opens the gallery if allowed.
  ///
  /// Flow:
  /// 1. Ask for photo permission
  /// 2. If granted -> open gallery picker
  /// 3. If user picks an image -> validate it
  /// 4. If valid -> close sheet and return image to parent
  /// 5. If invalid -> show DS toast and keep sheet open
  /// 6. If denied -> close sheet and go to UnableToContinue screen
  Future<void> _handleCameraRoll(BuildContext context) async {
    final PermissionStatus status = await Permission.photos.request();

    //------------------------ Permission Granted ------------------------//
    if (status.isGranted || status.isLimited) {
      final ImagePicker picker = ImagePicker();

      // Open the native gallery picker.
      final XFile? selectedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );

      // If the user cancelled the picker, do nothing.
      // The bottom sheet stays open so the user can choose again.
      if (selectedImage == null) return;

      // Validate the selected image.
      final bool isValid = await _validatePickedImage(context, selectedImage);

      // If validation failed, the toast was already shown and the sheet stays open.
      if (!isValid) return;

      // Validation passed, so return the image to the parent screen.
      if (context.mounted) {
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
  /// Requests camera permission and opens the camera if allowed.
  ///
  /// Flow:
  /// 1. Ask for camera permission
  /// 2. If granted -> open native camera
  /// 3. If user takes a photo -> validate it
  /// 4. If valid -> close sheet and return image to parent
  /// 5. If invalid -> show DS toast and keep sheet open
  /// 6. If denied -> close sheet and go to UnableToContinue screen
  Future<void> _handleTakePicture(BuildContext context) async {
    final PermissionStatus status = await Permission.camera.request();

    //------------------------ Permission Granted ------------------------//
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();

      // Open the native camera.
      final XFile? capturedImage = await picker.pickImage(
        source: ImageSource.camera,
      );

      // If user cancelled camera flow, do nothing.
      // Keep the bottom sheet open so they can choose again.
      if (capturedImage == null) return;

      // Validate the captured image.
      final bool isValid = await _validatePickedImage(context, capturedImage);

      // If validation failed, the sheet remains open and toast is already shown.
      if (!isValid) return;

      // Validation passed, so return the image to the parent screen.
      if (context.mounted) {
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
    return SDeckBottomSheet(
      //------------------------ Reusable DS Sheet Header -------------------//
      // This title is rendered by the shared design-system shell.
      title: 'Import Image',

      //------------------------ Shared Close Action ------------------------//
      // Let the reusable shell handle the close button, but route the action here.
      onClosePressed: () => Navigator.of(context).pop(),

      //------------------------ Sheet Body Content -------------------------//
      // Only the feature-specific content lives here.
      child: Column(
        // Bottom sheets should shrink-wrap to their content.
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //------------------------ Tip Section ----------------------------//
          // This content sits inside the reusable SDeckBottomSheet body area.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //------------------------ Small Placeholder ----------------//
              Container(
                width: _kVisualPlaceholderSize,
                height: _kVisualPlaceholderSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    SDeckRadius.borderRadius16,
                  ),
                  image: const DecorationImage(
                    image: AssetImage(SDeckIcon.checkeredBackground),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: SDeckSpace.gap12),

              //------------------------ Tip Text -------------------------//
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //------------------------ Tip Title Row --------------//
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: context.component.textPrimary,
                                  ),
                        ),
                      ],
                    ),

                    const SizedBox(height: SDeckSpace.gap4),

                    //------------------------ Tip Description ------------//
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: _kTipDescriptionMaxWidth,
                      ),
                      child: Text(
                        'This works best with head-and-shoulders photos.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.component.textSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: SDeckSpace.gap16),

          //------------------------ Camera Roll Button --------------------//
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
                // IMPORTANT:
                // Do NOT close the bottom sheet first.
                // The native permission dialog should appear on top
                // of the bottom sheet to match the Figma behavior.
                await _handleCameraRoll(context);
              },
            ),
          ),

          const SizedBox(height: SDeckSpace.gap8),

          //------------------------ Take a Picture Button -----------------//
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
                // request permission while the bottom sheet is still visible.
                await _handleTakePicture(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}