/*------------------------- edit_photo.dart ------------------------------*/
// Edit Photo Page
//
// Purpose:
// - Allows user to preview and adjust their selected image
// - Provides actions:
//    1. "Looks great!" → proceed to Enter Username
//    2. "Change Photo" → reopen image picker
//
// Expected Behavior:
// - Image is passed in from previous screen (Introduce Profile Card)
// - User can visually inspect the chosen image
// - No validation logic here (handled earlier in import flow)
//
// Design System:
// - Uses SDeckMotionDuration for transitions
// - Uses SDeckFadeSwap for content transitions
// - Uses SDeck buttons for consistency
//
// Notes:
// - This version keeps the current preview behavior as-is
// - Gesture support can be layered in later if needed
//--------------------------------------------------------------------------*/

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/enter_username_page.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/import_image_bottom_sheet.dart';
import 'package:socialdeck/features/onboarding/profile/providers/profile_provider.dart';

class EditPhotoPage extends ConsumerStatefulWidget {

  const EditPhotoPage({
    super.key,
  });

  @override
  ConsumerState<EditPhotoPage> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends ConsumerState<EditPhotoPage> {
  //*************************** Local UI State *******************************//
  // Controls fade-in / fade-out of the screen content.
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    _startEntranceAnimation();
  }

  //*************************** Entrance Animation ***************************//
  // Small DS-based entrance fade for the page content.
  void _startEntranceAnimation() async {
    await Future.delayed(SDeckMotionDuration.microDelay);

    if (!mounted) return;

    setState(() {
      _visible = true;
    });
  }

  //*************************** Change Photo Flow ****************************//
  // Reopens the import bottom sheet so the user can choose a different image.
  Future<void> _onChangePhoto() async {
    await showModalBottomSheet<XFile>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      sheetAnimationStyle: const AnimationStyle(
        duration: SDeckMotionDuration.sheet,
        reverseDuration: SDeckMotionDuration.sheet,
      ),
      builder: (context) => const ImportImageBottomSheet(),
    );

    // If the user closed the sheet or cancelled image selection,
    // stay on the current screen with the current image.
    if (!mounted || ref.watch(profileCardProvider).profileImage == null) return;

    //------------------------ Fade old content out ---------------------//
    setState(() {
      _visible = false;
    });

    await Future.delayed(SDeckMotionDuration.fade);

    if (!mounted) return;

    //------------------------ Swap to the new image --------------------//
    setState(() {
      _visible = true;
    });
  }

  //*************************** Confirm Photo *******************************//
  // When the user taps "Looks great!", transition to Enter Username.
  Future<void> _onConfirm() async {
    // Defensive guard:
    // If somehow no image exists, do nothing.
    if (ref.watch(profileCardProvider).profileImage == null) return;

    //------------------------ Fade current content out ------------------//
    setState(() {
      _visible = false;
    });

    await Future.delayed(SDeckMotionDuration.fade);

    if (!mounted) return;

    //------------------------ Navigate to Enter Username ---------------//
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EnterUsernamePage(),
      ),
    );

    //------------------------ Restore when coming back -----------------//
    // If the user returns from Enter Username, restore this screen
    // to a visible state.
    if (!mounted) return;

    setState(() {
      _visible = true;
    });
  }

  //*************************** Build UI ************************************//
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileCardProvider);




    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SDeckSpace.padding16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //------------------------ Title ------------------------//
              Padding(
                padding: const EdgeInsets.only(
                  top: SDeckSpace.padding16,
                  bottom: SDeckSpace.padding12,
                ),
                child: Text(
                  "Edit Photo",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: context.component.textPrimary,
                      ),
                ),
              ),

              //------------------------ Image Preview ----------------//
              // Current implementation:
              // - shows the selected image if available
              // - falls back to the checkered placeholder if not
              //
              // Future enhancements:
              // - pinch zoom
              // - drag / reposition
              // - rotation
              SDeckFadeSwap(
                visible: _visible,
                child: Container(
                  width: 370,
                  height: 370,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      SDeckRadius.borderRadius16,
                    ),
                    image: DecorationImage(
                      image: state.profileImage != null
                          ? FileImage(File(state.profileImage!.path))
                          : const AssetImage(
                              SDeckIcon.checkeredBackground,
                            ) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: SDeckSpace.gap16),

              //------------------------ Instruction Text -------------//
              SDeckFadeSwap(
                visible: _visible,
                child: Text(
                  "Use your fingers to \nmove, zoom, and rotate.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: context.component.textSecondary,
                      ),
                ),
              ),

              const SizedBox(height: SDeckSpace.gap16),

              //------------------------ Primary Button ---------------//
              // Enabled only when an image is present.
              SDeckFadeSwap(
                visible: _visible,
                child: SizedBox(
                  width: 370,
                  child: SDeckSolidButton(
                    text: "Looks great!",
                    size: SDeckButtonSize.large,
                    fullWidth: true,
                    onPressed: state.profileImage == null ? null : _onConfirm,
                    enabled: state.imageSizeCheck && state.imageTypeCheck,
                  ),
                ),
              ),

              const SizedBox(height: SDeckSpace.gap8),

              //------------------------ Secondary Button -------------//
              // Lets the user choose a new image without leaving the page.
              // Redo icon is added on the left of the text.
              SDeckFadeSwap(
                visible: _visible,
                child: SizedBox(
                  width: 370,
                  child: SDeckOutlineButton(
                    iconLocation: SDeckButtonIconLocation.left,
                    icon: SDeckIcons(
                      SDeckIcon.redo,
                      size: SDeckSize.size24,
                      color: context.component.iconPrimary,
                    ),
                    text: "Change Photo",
                    size: SDeckButtonSize.large,
                    fullWidth: true,
                    onPressed: _onChangePhoto,
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}