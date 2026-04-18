import 'package:socialdeck/features/onboarding/profile/utils/fade_swap.dart';
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
//    - After 2 seconds, navigates to Enter Username
//
// 5. Toast state
//    - This page now hosts the existing design-system SDeckToast
//    - The toast stays hidden until logic explicitly triggers it
//    - Later, backend wiring can call the same method to show it
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/components/dialog/index.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/edit_photo_page.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/import_image_bottom_sheet.dart';
import 'package:socialdeck/features/onboarding/profile/providers/profile_provider.dart';

class IntroduceProfileCardPage extends ConsumerStatefulWidget {
  const IntroduceProfileCardPage({super.key});

  @override
  ConsumerState<IntroduceProfileCardPage> createState() =>
      _IntroduceProfileCardPageState();
}

class _IntroduceProfileCardPageState
    extends ConsumerState<IntroduceProfileCardPage> {
  static const String _firstIntroText = "Hi there! I’m your profile card.";
  static const String _secondIntroText =
      "I’m feeling a bit… generic.\nLet’s personalize me.";
  static const String _temporaryImageText =
      "Looks like I’ll just take\nthis look for now.";

  bool _isTextVisible = false;
  bool _showInteractiveUi = false;
  bool _showTemporaryImageState = false;
  String _displayText = _firstIntroText;

  bool _showToast = false;
  SDeckToastStatus _toastStatus = SDeckToastStatus.info;
  String _toastTitle = '';
  String _toastDescription = '';

  @override
  void initState() {
    super.initState();
    _resetDomains();
    _startSequence();
  }

  Future<void> _resetDomains() async {
    ref.read(introduceProfileCardProvider.notifier).resetDomain();
    ref.read(profileCardProvider.notifier).resetDomain();
  }

  Future<void> _startSequence() async {
    await Future.delayed(SDeckMotionDuration.microDelay);
    if (!mounted) return;

    setState(() {
      _displayText = _firstIntroText;
      _isTextVisible = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      _isTextVisible = false;
    });

    await Future.delayed(SDeckMotionDuration.fade);
    if (!mounted) return;

    setState(() {
      _displayText = _secondIntroText;
      _isTextVisible = true;
    });

    await Future.delayed(SDeckMotionDuration.fade);
    if (!mounted) return;

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      _showInteractiveUi = true;
    });
    ref.read(introduceProfileCardProvider.notifier).advanceState();
  }

  //*************************** Add Photo Flow *******************************//
  Future<void> _onAddPhoto() async {
    var handedOffToEdit = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      sheetAnimationStyle: const AnimationStyle(
        duration: SDeckMotionDuration.sheet,
        reverseDuration: SDeckMotionDuration.sheet,
      ),
      builder: (context) => ImportImageBottomSheet(
        onValidImageReadyForEdit: () {
          handedOffToEdit = true;
          _navigateToEditPhotoAfterValidPick();
        },
      ),
    );

    if (!mounted) return;
    if (handedOffToEdit) return;

    final state = ref.read(profileCardProvider);

    if (state.profileImage == null ||
        !state.imageSizeCheck ||
        !state.imageTypeCheck) {
      return;
    }

    setState(() {
      _showToast = false;
    });
  }

  /// Pushed synchronously from [ImportImageBottomSheet] right after pop so the
  /// transition runs sheet → edit without an intermediate frame on this page.
  void _navigateToEditPhotoAfterValidPick() {
    if (!mounted) return;

    setState(() {
      _showToast = false;
    });

    final state = ref.watch(profileCardProvider);
    if (state.profileImage != null) {
      unawaited(precacheImage(FileImage(File(state.profileImage!.path)), context));
    }

    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => const EditPhotoPage(),
      ),
    )
        .then((_) {
      if (!mounted) return;
      setState(() {
        _displayText = _secondIntroText;
        _isTextVisible = true;
        _showInteractiveUi = true;
        _showTemporaryImageState = false;
      });
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

    if (shouldSkip == true) {
      setState(() {
        _isTextVisible = false;
        _showToast = false;
      });

      await Future.delayed(SDeckMotionDuration.fade);

      if (!mounted) return;

      setState(() {
        _showTemporaryImageState = true;
        _showInteractiveUi = false;
        _displayText = _temporaryImageText;
        _isTextVisible = true;
      });

      await ref.read(profileCardProvider.notifier).useGenericImage();

      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      context.push(AppPaths.enterUsername);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showActionArea =
        _showInteractiveUi && !_showTemporaryImageState;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SDeckSpace.padding16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeSwap(
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

                  buildVisualPlaceholder(context),

                  const SizedBox(height: SDeckSpace.gap16),

                  SizedBox(
                    width: 370,
                    height: 56,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: FadeSwap(
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

                  FadeSwap(
                    visible: showActionArea,
                    child: IgnorePointer(
                      ignoring: !showActionArea,
                      child: Column(
                        children: [
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
                  child: FadeSwap(
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
        ),
      ),
    );
  }

  Widget buildVisualPlaceholder(BuildContext context) {
    final state = ref.watch(profileCardProvider);
    ImageProvider imageProvider;

    if (state.profileImage != null && state.imageSizeCheck && state.imageTypeCheck) {
      imageProvider = FileImage(File(state.profileImage!.path));
    } else if (state.useTempImage) {
      // TODO: When the user taps Skip, this temporary picture replaces the default
      // placeholder (see _onSkip → useGenericImage). Replace this static asset with a
      // Rive animation once the .riv asset and motion spec are ready.
      imageProvider = const AssetImage(SDeckIcon.checkeredBackground);
    } else {
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