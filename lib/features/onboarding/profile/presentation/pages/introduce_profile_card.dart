/*-------------------- introduce_profile_card.dart -----------------------*/
// Introduce Profile Card Page
//
// This screen covers multiple states in one continuous onboarding step:
//
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
//    - After 300ms, title + bottom actions fade in
//    - User can tap "Add a Photo"
//    - User can tap "Skip"
//
// 4. Give-temporary-image state
//    - Triggered when user confirms "Skip" in the confirmation modal
//    - Title and bottom actions disappear
//    - Text changes to:
//      "Looks like I’ll just take\nthis look for now."
//    - Later, a generic temporary profile image can replace the placeholder
//
// Notes:
// - This file keeps everything in one screen because your team decided
//   that "Add Photo" is the final revealed state of the same onboarding step.
// - Image selection/capture returns an XFile from the bottom sheet.
// - Skip opens a confirmation dialog.
// - Error banner/toast support is included through _showTopErrorBanner(...).
/*--------------------------------------------------------------------------*/

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/import_image_bottom_sheet.dart';

class IntroduceProfileCardPage extends ConsumerStatefulWidget {
  const IntroduceProfileCardPage({super.key});

  @override
  ConsumerState<IntroduceProfileCardPage> createState() =>
      _IntroduceProfileCardPageState();
}

class _IntroduceProfileCardPageState
    extends ConsumerState<IntroduceProfileCardPage> {
  //*************************** Local UI State *******************************//
  // Controls whether the main onboarding text is visible.
  bool _isTextVisible = false;

  // Controls whether the "Profile Card" title and bottom action area are shown.
  bool _showInteractiveUi = false;

  // Controls whether the screen has moved into the "temporary image" state.
  bool _showTemporaryImageState = false;

  // Stores the current body text shown on the screen.
  String _displayText = "Hi there! I’m your profile card.";

  // Stores the selected or captured image from the bottom sheet.
  // If null, the placeholder asset is shown.
  XFile? _selectedImage;

  // Optional: when your team provides a generic fallback asset, turn this on
  // and swap the placeholder image in buildVisualPlaceholder(...).
  bool _useTemporaryGenericImage = false;

  // Timers used for the intro text sequence.
  Timer? _initialFadeInTimer;
  Timer? _textVisibleTimer;
  Timer? _textFadeOutTimer;
  Timer? _interactiveUiTimer;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  //*************************** Intro Sequence Logic *************************//
  // Sequence:
  // 1. Fade in first text
  // 2. Keep it for 2 seconds
  // 3. Fade it out
  // 4. Replace it with the second text and fade that in
  // 5. After 300ms, fade in title + bottom actions
  void _startSequence() {
    _initialFadeInTimer = Timer(const Duration(milliseconds: 50), () {
      if (!mounted) return;

      setState(() {
        _isTextVisible = true;
      });
    });

    _textVisibleTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      // Fade out the first line.
      setState(() {
        _isTextVisible = false;
      });

      _textFadeOutTimer = Timer(const Duration(milliseconds: 300), () {
        if (!mounted) return;

        // Swap to the second onboarding message and fade it in.
        setState(() {
          _displayText = "I’m feeling a bit… generic.\nLet’s personalize me.";
          _isTextVisible = true;
        });

        // Reveal title + buttons 300ms later.
        _interactiveUiTimer = Timer(const Duration(milliseconds: 300), () {
          if (!mounted) return;

          setState(() {
            _showInteractiveUi = true;
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _initialFadeInTimer?.cancel();
    _textVisibleTimer?.cancel();
    _textFadeOutTimer?.cancel();
    _interactiveUiTimer?.cancel();
    super.dispose();
  }

  //*************************** Add Photo Flow *******************************//
  // Opens the Import Image bottom sheet and waits for an image to come back.
  Future<void> _onAddPhoto() async {
    final XFile? pickedImage = await showModalBottomSheet<XFile>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ImportImageBottomSheet(),
    );

    if (!mounted) return;

    // If the user successfully picked or captured an image,
    // show it in the main placeholder.
    if (pickedImage != null) {
      // Example validation hook:
      // if (await _isFileTooLarge(pickedImage)) {
      //   _showTopErrorBanner(
      //     title: 'File too large',
      //     message:
      //         'This image exceeds the size limit of 5 MB.\nPlease choose a smaller image.',
      //   );
      //   return;
      // }

      setState(() {
        _selectedImage = pickedImage;
        _useTemporaryGenericImage = false;
      });
    }
  }

  //*************************** Skip Flow ***********************************//
  // Opens the confirmation dialog when the user taps "Skip".
  Future<void> _onSkip() async {
    final bool? shouldSkip = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const _SkipConfirmationDialog(),
    );

    if (!mounted) return;

    // If the user confirmed Skip, enter the "Give Temporary Image" state.
    if (shouldSkip == true) {
      // Fade current text out first.
      setState(() {
        _isTextVisible = false;
      });

      // After fade-out, update the state and fade the new message in.
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;

        setState(() {
          _showTemporaryImageState = true;

          // Hide title + bottom action area.
          _showInteractiveUi = false;

          // Update text to the temporary-image message.
          _displayText = "Looks like I’ll just take\nthis look for now.";

          // Clear any user-selected image if your flow wants the temp image
          // to replace it. Adjust this behavior if needed.
          _selectedImage = null;

          // Turn on the future temporary generic image state.
          _useTemporaryGenericImage = true;

          // Fade the new text back in.
          _isTextVisible = true;
        });
      });
    }
  }

  //*************************** Top Error Banner *****************************//
  // This is a simple way to create the Figma-like top error notification.
  //
  // Use it for:
  // - file too large
  // - unsupported file type
  //
  // Example:
  // _showTopErrorBanner(
  //   title: 'File too large',
  //   message: 'This image exceeds the size limit of 5 MB.\nPlease choose a smaller image.',
  // );
  void _showTopErrorBanner({
    required String title,
    required String message,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    // Clear any previous banner first so they do not stack awkwardly.
    messenger.clearMaterialBanners();

    messenger.showMaterialBanner(
      MaterialBanner(
        backgroundColor: const Color(0xFFFFE9E7),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF5A1F1B),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF5A1F1B),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        leading: null,
        actions: [
          IconButton(
            onPressed: () {
              messenger.hideCurrentMaterialBanner();
            },
            icon: const Icon(
              Icons.close,
              color: Color(0xFFE66A5C),
            ),
          ),
        ],
      ),
    );

    // Auto-dismiss after a short delay to behave more like a toast.
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    });
  }

  //*************************** Build Method *******************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //------------------------ Top Title Area ------------------------//
              // Visible only in the add-photo state.
              AnimatedOpacity(
                opacity:
                    (_showInteractiveUi && !_showTemporaryImageState) ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: SDeckSpace.padding16,
                    bottom: SDeckSpace.padding12,
                  ),
                  child: Text(
                    'Profile Card',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: context.component.textPrimary,
                        ),
                  ),
                ),
              ),

              //------------------------ Visual Placeholder -------------------//
              buildVisualPlaceholder(context),

              const SizedBox(height: SDeckSpace.gap16),

              //------------------------ Body Text ----------------------------//
              // Fixed height prevents layout jump when changing text.
              SizedBox(
                width: 370,
                height: 56,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                    opacity: _isTextVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
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

              //------------------------ Bottom Actions -----------------------//
              // Hide these when in the temporary-image state.
              AnimatedOpacity(
                opacity:
                    (_showInteractiveUi && !_showTemporaryImageState) ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: IgnorePointer(
                  ignoring:
                      !(_showInteractiveUi && !_showTemporaryImageState),
                  child: Column(
                    children: [
                      //------------------------ Add a Photo ----------------//
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

                      //------------------------ Skip ----------------------//
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
                                        color: context.component.textPrimary,
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
      ),
    );
  }

  //*************************** Placeholder Helper **************************//
  Widget buildVisualPlaceholder(BuildContext context) {
    ImageProvider imageProvider;

    // Highest priority: user selected or captured image.
    if (_selectedImage != null) {
      imageProvider = FileImage(File(_selectedImage!.path));
    }
    // Next priority: temporary generic image state.
    else if (_useTemporaryGenericImage) {
      // TODO:
      // Replace this asset with the real generic temporary image once available.
      imageProvider = const AssetImage(SDeckIcon.checkeredBackground);
    }
    // Default placeholder.
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

//*************************** Skip Confirmation Dialog *********************//
// This dialog appears when the user taps "Skip".
class _SkipConfirmationDialog extends StatelessWidget {
  const _SkipConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //------------------------ Title ------------------------//
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Wait!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: context.component.textPrimary,
                    ),
              ),
            ),

            const SizedBox(height: SDeckSpace.gap16),

            //------------------------ Visual Preview ---------------//
            Container(
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

            const SizedBox(height: SDeckSpace.gap16),

            //------------------------ Body Text --------------------//
            Text(
              'Are you sure you want to skip decorating your profile card?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.component.textSecondary,
                  ),
            ),

            const SizedBox(height: SDeckSpace.gap16),

            //------------------------ Actions ----------------------//
            Row(
              children: [
                Expanded(
                  child: SDeckOutlineButton(
                    text: 'Back',
                    size: SDeckButtonSize.medium,
                    fullWidth: true,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                const SizedBox(width: SDeckSpace.gap8),
                Expanded(
                  child: SDeckSolidButton(
                    text: 'Skip',
                    size: SDeckButtonSize.medium,
                    fullWidth: true,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}