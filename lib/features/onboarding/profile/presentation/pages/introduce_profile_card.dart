/*-------------------- introduce_profile_card.dart -----------------------*/
// Introduce Profile Card Page
//
// Purpose:
// - Handles the onboarding introduction for the user's profile card
// - Reveals the "Add a Photo" state after timed dialogue
// - Opens the Import Image bottom sheet
// - Handles the Skip confirmation flow
// - Hands off to Edit Photo after a valid image is selected
// - Hosts the PROJECT'S EXISTING SDeckToast so backend logic can trigger it
//
// Current screen states:
// 1. Initial intro state
//    - Placeholder is visible
//    - Text fades in: "Hi there! I’m your profile card."
//
// 2. Generic-message state
//    - First text fades out
//    - Second text fades in:
//      "I’m feeling a bit… generic.\nLet’s personalize me."
//
// 3. Add-photo state
//    - Title + bottom actions fade in
//    - User can tap "Add a Photo"
//    - User can tap "Skip"
//
// 4. Give-temporary-image state
//    - Triggered when user confirms "Skip"
//    - Title and bottom actions disappear
//    - Text changes to:
//      "Looks like I’ll just take\nthis look for now."
//
// 5. Toast state
//    - This page now hosts the existing design-system SDeckToast
//    - The toast stays hidden until logic explicitly triggers it
//    - Later, backend wiring can call the same method to show it
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialdeck/design_system/components/dialog/index.dart';
import 'package:socialdeck/design_system/components/toast/sdeck_toast.dart';
import 'package:socialdeck/design_system/components/toast/toast_enums.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/edit_photo_page.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/import_image_bottom_sheet.dart';

class IntroduceProfileCardPage extends ConsumerStatefulWidget {
  const IntroduceProfileCardPage({super.key});

  @override
  ConsumerState<IntroduceProfileCardPage> createState() =>
      _IntroduceProfileCardPageState();
}

class _IntroduceProfileCardPageState
    extends ConsumerState<IntroduceProfileCardPage> {
  //*************************** Constants ***********************************//
  static const String _firstIntroText = "Hi there! I’m your profile card.";
  static const String _secondIntroText =
      "I’m feeling a bit… generic.\nLet’s personalize me.";
  static const String _temporaryImageText =
      "Looks like I’ll just take\nthis look for now.";

  //*************************** Local UI State *******************************//
  // Whether the body text is currently visible.
  bool _isTextVisible = false;

  // Whether the top title and bottom actions are currently visible.
  bool _showInteractiveUi = false;

  // Whether the page is currently in the temporary-image state after skip.
  bool _showTemporaryImageState = false;

  // The current body text being displayed.
  String _displayText = _firstIntroText;

  // If the user already selected/captured an image, show it in the placeholder.
  XFile? _selectedImage;

  // Temporary placeholder state for the “skip” path.
  bool _useTemporaryGenericImage = false;

  //*************************** Toast State *********************************//
  // These fields control the EXISTING project toast.
  //
  // Why keep this state here?
  // - Frontend can render the toast immediately
  // - Backend can later trigger it by calling the same method
  // - We avoid inventing another toast implementation
  bool _showToast = false;
  SDeckToastStatus _toastStatus = SDeckToastStatus.info;
  String _toastTitle = '';
  String _toastDescription = '';

  @override
  void initState() {
    super.initState();
    _startSequence();

    // ---------------------------------------------------------------------
    // FRONTEND-ONLY NOTE:
    // Leave the toast hidden by default.
    //
    // When backend wiring is added later, they can trigger the toast by
    // calling the same logic that eventually reaches _showPageToast(...).
    //
    // Example temporary manual test:
    //
    // Future.delayed(const Duration(seconds: 1), () {
    //   if (!mounted) return;
    //   _showPageToast(
    //     status: SDeckToastStatus.warning,
    //     title: 'Photo upload unavailable',
    //     description: 'Please try again in a moment.',
    //   );
    // });
    // ---------------------------------------------------------------------
  }

  //*************************** Toast Helpers *******************************//
  /// Shows the EXISTING project toast on this page.
  ///
  /// This is the single method the backend flow can eventually trigger.
  /// For now, frontend keeps it ready; backend decides WHEN to call it.
  void _showPageToast({
    required SDeckToastStatus status,
    required String title,
    required String description,
  }) {
    if (!mounted) return;

    setState(() {
      _toastStatus = status;
      _toastTitle = title;
      _toastDescription = description;
      _showToast = true;
    });
  }

  /// Hides the currently visible toast.
  void _dismissToast() {
    if (!mounted) return;

    setState(() {
      _showToast = false;
    });
  }

  //*************************** Intro Sequence *******************************//
  // Required timing:
  // 1. First line displays for 2 seconds
  // 2. First line fades out for 300ms
  // 3. Second line fades in for 300ms
  // 4. Second line remains fully visible for 2 seconds
  // 5. Then title + actions begin fading in
  Future<void> _startSequence() async {
    //------------------------ Initial micro delay ------------------------//
    await Future.delayed(SDeckMotionDuration.microDelay);
    if (!mounted) return;

    //------------------------ Show first line ----------------------------//
    setState(() {
      _displayText = _firstIntroText;
      _isTextVisible = true;
    });

    //------------------------ Keep first line visible for 2s ------------//
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    //------------------------ Fade first line out -----------------------//
    setState(() {
      _isTextVisible = false;
    });

    await Future.delayed(SDeckMotionDuration.fade);
    if (!mounted) return;

    //------------------------ Show second line --------------------------//
    setState(() {
      _displayText = _secondIntroText;
      _isTextVisible = true;
    });

    //------------------------ Wait for second line fade-in -------------//
    await Future.delayed(SDeckMotionDuration.fade);
    if (!mounted) return;

    //------------------------ Keep second line visible for 2s ----------//
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    //------------------------ Reveal title + buttons -------------------//
    setState(() {
      _showInteractiveUi = true;
    });
  }

  //*************************** Add Photo Flow *******************************//
  /// Opens the feature-specific import-image bottom sheet.
  ///
  /// Important architecture note:
  /// - This page does NOT build the sheet UI itself.
  /// - The feature sheet widget handles permission flow, validation,
  ///   and returning an XFile result.
  /// - The feature sheet itself now uses the reusable SDeckBottomSheet
  ///   design-system component internally.
  Future<void> _onAddPhoto() async {
    final XFile? pickedImage = await showModalBottomSheet<XFile>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      // Use the design-system motion timing for open/close.
      sheetAnimationStyle: const AnimationStyle(
        duration: SDeckMotionDuration.sheet,
        reverseDuration: SDeckMotionDuration.sheet,
      ),

      // Keep this page clean by delegating the actual sheet content
      // to ImportImageBottomSheet.
      builder: (context) => const ImportImageBottomSheet(),
    );

    if (!mounted) return;

    // If the user dismissed the sheet or cancelled image selection,
    // stay on the current screen.
    if (pickedImage == null) {
      // -----------------------------------------------------------------
      // OPTIONAL PLACEHOLDER FOR BACKEND-DRIVEN TOAST:
      // If product/backend later wants a toast when no image is returned,
      // they can call _showPageToast(...) from the place where that logic
      // is actually decided.
      // -----------------------------------------------------------------
      return;
    }

    //------------------------ Reflect image immediately -----------------//
    // This updates the placeholder right away before transitioning
    // into the next onboarding step.
    setState(() {
      _selectedImage = pickedImage;
      _useTemporaryGenericImage = false;
    });

    //------------------------ Hand off to next screen -------------------//
    await _handleSuccessfulImageSelection(pickedImage);
  }

  //*************************** Successful Image Handoff *********************//
  // This method owns the transition from Introduce Profile Card -> Edit Photo.
  //
  // Flow:
  // 1. Fade out the current text and action area
  // 2. Wait for the fade duration
  // 3. Push EditPhotoPage and pass the selected image
  Future<void> _handleSuccessfulImageSelection(XFile pickedImage) async {
    //------------------------ Fade out current lower content ------------//
    setState(() {
      _isTextVisible = false;
      _showInteractiveUi = false;
      _showToast = false; // Hide any page toast before moving forward
    });

    await Future.delayed(SDeckMotionDuration.fade);

    if (!mounted) return;

    //------------------------ Navigate to Edit Photo --------------------//
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPhotoPage(image: pickedImage),
      ),
    );

    //------------------------ Optional restore when returning -----------//
    // If the user comes back from Edit Photo, restore the add-photo state.
    if (!mounted) return;

    setState(() {
      _selectedImage = pickedImage;
      _displayText = _secondIntroText;
      _isTextVisible = true;
      _showInteractiveUi = true;
      _showTemporaryImageState = false;
      _useTemporaryGenericImage = false;
    });
  }

  //*************************** Skip Flow ***********************************//
  Future<void> _onSkip() async {
    final bool? shouldSkip = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => SDeckDialog(
        title: 'Wait!',
        description:
            'Are you sure you want to skip decorating your profile card?',
        semanticsLabel: 'Skip confirmation dialog',
        preview: Container(
          width: double.infinity,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
            image: const DecorationImage(
              image: AssetImage(SDeckIcon.checkeredBackground),
              fit: BoxFit.cover,
            ),
          ),
        ),
        secondaryButtonText: 'Back',
        primaryButtonText: 'Skip',
        onClose: () {
          Navigator.of(context).pop(false);
        },
        onSecondaryPressed: () {
          Navigator.of(context).pop(false);
        },
        onPrimaryPressed: () {
          Navigator.of(context).pop(true);
        },
      ),
    );

    if (!mounted) return;

    // If skip was confirmed, switch to the temporary-image state.
    if (shouldSkip == true) {
      setState(() {
        _isTextVisible = false;
        _showToast = false; // Remove toast when state changes
      });

      await Future.delayed(SDeckMotionDuration.fade);

      if (!mounted) return;

      setState(() {
        _showTemporaryImageState = true;
        _showInteractiveUi = false;
        _displayText = _temporaryImageText;
        _selectedImage = null;
        _useTemporaryGenericImage = true;
        _isTextVisible = true;
      });
    }
  }

  //*************************** Build Method *******************************//
  @override
  Widget build(BuildContext context) {
    final bool showActionArea =
        _showInteractiveUi && !_showTemporaryImageState;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            //---------------------- Main Screen Content --------------------//
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SDeckSpace.padding16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //---------------------- Top Title Area --------------------//
                  // Appears only in the add-photo state.
                  SDeckFadeSwap(
                    visible: showActionArea,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: SDeckSpace.padding16,
                        bottom: SDeckSpace.padding12,
                      ),
                      child: Text(
                        'Profile Card',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: context.component.textPrimary,
                            ),
                      ),
                    ),
                  ),

                  //---------------------- Visual Placeholder ----------------//
                  buildVisualPlaceholder(context),

                  const SizedBox(height: SDeckSpace.gap16),

                  //---------------------- Body Text -------------------------//
                  // Fixed height prevents layout jumping between 1-line and 2-line text.
                  SizedBox(
                    width: 370,
                    height: 56,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SDeckFadeSwap(
                        visible: _isTextVisible,
                        child: Text(
                          _displayText,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: context.component.textSecondary,
                              ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: SDeckSpace.gap16),

                  //---------------------- Bottom Actions --------------------//
                  SDeckFadeSwap(
                    visible: showActionArea,
                    child: IgnorePointer(
                      ignoring: !showActionArea,
                      child: Column(
                        children: [
                          //---------------- Add a Photo -------------------//
                          SizedBox(
                            width: 370,
                            child: SDeckSolidButton(
                              text: "Add a Photo",
                              size: SDeckButtonSize.large,
                              fullWidth: true,
                              onPressed: _onAddPhoto,
                            ),
                          ),

                          const SizedBox(height: SDeckSpace.gap8),

                          //---------------- Skip --------------------------//
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                SDeckRadius.borderRadius16,
                              ),
                              onTap: _onSkip,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SDeckSpace.padding24,
                                  vertical: SDeckSpace.padding16,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Skip',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color:
                                                context.component.textPrimary,
                                          ),
                                    ),
                                    const SizedBox(width: SDeckSpace.gap8),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 22,
                                      color: context.component.iconPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //---------------------- Toast Overlay --------------------------//
            // Uses the PROJECT'S EXISTING toast component.
            //
            // Positioned near the top so it feels like a real page-level toast.
            // IgnorePointer prevents this invisible layer from blocking touches
            // when the toast is hidden.
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
                      onDismiss: _dismissToast,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //*************************** Placeholder Helper **************************//
  Widget buildVisualPlaceholder(BuildContext context) {
    ImageProvider imageProvider;

    //------------------------ Selected/Captured Image --------------------//
    if (_selectedImage != null) {
      imageProvider = FileImage(File(_selectedImage!.path));
    }
    //------------------------ Temporary Generic Image --------------------//
    else if (_useTemporaryGenericImage) {
      imageProvider = const AssetImage(SDeckIcon.checkeredBackground);
    }
    //------------------------ Default Placeholder ------------------------//
    else {
      imageProvider = const AssetImage(SDeckIcon.checkeredBackground);
    }

    return Container(
      width: 370,
      height: 370,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}