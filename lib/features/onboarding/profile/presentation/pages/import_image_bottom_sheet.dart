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
// - Uses the EXISTING SDeckToast widget directly
// - Uses the reusable SDeckBottomSheet design-system component as the shell
/*-----------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/components/toast/sdeck_toast.dart';
import 'package:socialdeck/design_system/components/toast/toast_enums.dart';
import 'package:socialdeck/design_system/index.dart';

class ImportImageBottomSheet extends StatefulWidget {
  const ImportImageBottomSheet({super.key});

  @override
  State<ImportImageBottomSheet> createState() => _ImportImageBottomSheetState();
}

class _ImportImageBottomSheetState extends State<ImportImageBottomSheet> {
  //*************************** Figma Size Constants ***************************//
  static const double _kVisualPlaceholderSize = 92.5;
  static const double _kTipDescriptionMaxWidth = 237.5;

  //*************************** Toast State ***********************************//
  bool _showToast = false;
  SDeckToastStatus _toastStatus = SDeckToastStatus.error;
  String _toastTitle = '';
  String _toastDescription = '';

  //*************************** Validation ************************************//
  Future<bool> _validatePickedImage(XFile image) async {
    //------------------------ File Size Check ------------------------------//
    final int fileSizeInBytes = await image.length();

    if (!mounted) return false;

    const int maxBytes = 5 * 1024 * 1024;

    if (fileSizeInBytes > maxBytes) {
      setState(() {
        _toastStatus = SDeckToastStatus.error;
        _toastTitle = 'File too large';
        _toastDescription =
            'This image exceeds the size limit of 5 MB.\nPlease choose a smaller image.';
        _showToast = true;
      });
      return false;
    }

    //------------------------ File Type Check ------------------------------//
    final String lowerPath = image.path.toLowerCase();

    final bool supported =
        lowerPath.endsWith('.jpg') ||
        lowerPath.endsWith('.jpeg') ||
        lowerPath.endsWith('.png') ||
        lowerPath.endsWith('.webp');

    if (!supported) {
      setState(() {
        _toastStatus = SDeckToastStatus.error;
        _toastTitle = 'Can’t upload image';
        _toastDescription =
            'That file type isn’t supported. Try a different format.';
        _showToast = true;
      });
      return false;
    }

    //------------------------ Passed Validation ----------------------------//
    return true;
  }

  //*************************** Camera Roll Flow *******************************//
  Future<void> _handleCameraRoll() async {
    final PermissionStatus status = await Permission.photos.request();

    //------------------------ Permission Granted ------------------------//
    if (status.isGranted || status.isLimited) {
      final ImagePicker picker = ImagePicker();

      final XFile? selectedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (!mounted) return;

      if (selectedImage == null) return;

      setState(() {
        _showToast = false;
      });

      final bool isValid = await _validatePickedImage(selectedImage);

      if (!mounted) return;
      if (!isValid) return;

      Navigator.of(context).pop(selectedImage);
      return;
    }

    //------------------------ Permission Denied -------------------------//
    if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
      if (mounted) {
        Navigator.of(context).pop();
        context.goNamed(AppRoute.unableToContinue.name);
      }
    }
  }

  //*************************** Camera Flow **********************************//
  Future<void> _handleTakePicture() async {
    final PermissionStatus status = await Permission.camera.request();

    //------------------------ Permission Granted ------------------------//
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();

      final XFile? capturedImage = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (!mounted) return;

      if (capturedImage == null) return;

      setState(() {
        _showToast = false;
      });

      final bool isValid = await _validatePickedImage(capturedImage);

      if (!mounted) return;
      if (!isValid) return;

      Navigator.of(context).pop(capturedImage);
      return;
    }

    //------------------------ Permission Denied -------------------------//
    if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
      if (mounted) {
        Navigator.of(context).pop();
        context.goNamed(AppRoute.unableToContinue.name);
      }
    }
  }

  //*************************** Build Method *********************************//
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //------------------------ Bottom Sheet Placement -------------------//
        // SDeckBottomSheet is only a styled container.
        // It does NOT automatically anchor itself to the bottom of the screen,
        // so we must position it explicitly here.
        Align(
          alignment: Alignment.bottomCenter,
          child: SDeckBottomSheet(
            title: 'Import Image',
            onClosePressed: () => Navigator.of(context).pop(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //---------------------- Tip Section ---------------------------//
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //-------------------- Small Placeholder -----------------//
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

                    //-------------------- Tip Text --------------------------//
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //------------------ Tip Title Row -----------------//
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
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                      color: context.component.textPrimary,
                                    ),
                              ),
                            ],
                          ),

                          const SizedBox(height: SDeckSpace.gap4),

                          //------------------ Tip Description --------------//
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: _kTipDescriptionMaxWidth,
                            ),
                            child: Text(
                              'This works best with head-and-shoulders photos.',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
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

                //---------------------- Camera Roll Button -------------------//
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
                      await _handleCameraRoll();
                    },
                  ),
                ),

                const SizedBox(height: SDeckSpace.gap8),

                //---------------------- Take a Picture Button ----------------//
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
                      await _handleTakePicture();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        //------------------------ Toast Overlay ------------------------------//
        IgnorePointer(
          ignoring: !_showToast,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                top: SDeckSpace.padding16,
                left: SDeckSpace.padding16,
                right: SDeckSpace.padding16,
              ),
              child: SDeckFadeSwap(
                visible: _showToast,
                child: SDeckToast(
                  status: _toastStatus,
                  title: _toastTitle,
                  description: _toastDescription,
                  onDismiss: () {
                    if (!mounted) return;
                    setState(() {
                      _showToast = false;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}