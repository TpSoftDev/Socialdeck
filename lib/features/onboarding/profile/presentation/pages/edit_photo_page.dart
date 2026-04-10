/*------------------------- edit_photo_page.dart ----------------------------*/
// Edit Photo Page
//
// Purpose:
// - Allows user to preview and adjust their selected image
// - Provides actions:
//    1. "Looks great!" → proceed to Enter Username
//    2. "Change Photo" → reopen image picker
//
// Updated behavior:
// - Uses SDeckAdjustProfileCard for actual pinch-zoom, drag, and rotation
// - Stores the latest transform values locally for future persistence
// - If there is no image, only shows the placeholder
// - If there is an image, only shows the image
/*--------------------------------------------------------------------------*/

import 'dart:async';

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
  bool _visible = false;
  bool _showGestureOverlay = true;

  @override
  void initState() {
    super.initState();
    _startEntranceAnimation();
  }

  void _startEntranceAnimation() async {
    await Future.delayed(SDeckMotionDuration.microDelay);

    if (!mounted) return;

    setState(() {
      _visible = true;
    });
  }

  void _hideGestureOverlay() {
    if (!_showGestureOverlay) return;

    setState(() {
      _showGestureOverlay = false;
    });
  }

  void _onTransformChangedLegacy(double scale, double panX, double panY) {
    ref.read(profileCardProvider.notifier).updateImagePosition(panX, panY, scale, 0.0);
  }

  void _onTransformChangedV2(
    double scale,
    double panX,
    double panY,
    double rotation,
  ) {
    ref.read(profileCardProvider.notifier).updateImagePosition(panX, panY, scale, rotation);
  }

  void _resetTransformState() {
    ref.read(profileCardProvider.notifier).resetImagePosition();
    _showGestureOverlay = true;
  }

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

    final state = ref.watch(profileCardProvider);

    if (!mounted || !state.imageSizeCheck || !state.imageTypeCheck) return;

    setState(() {
      _visible = false;
    });

    await Future.delayed(SDeckMotionDuration.fade);

    if (!mounted) return;

    setState(() {
      _resetTransformState();
      _visible = true;
    });
  }

  Future<void> _onConfirm() async {
    if (ref.watch(profileCardProvider).profileImage == null) return;

    setState(() {
      _visible = false;
    });

    await Future.delayed(SDeckMotionDuration.fade);

    if (!mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EnterUsernamePage(),
      ),
    );

    if (!mounted) return;

    setState(() {
      _visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    //Backend state variable
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

              SDeckFadeSwap(
                visible: _visible,
                child: Center(
                  child: SDeckAdjustProfileCard(
                    imagePath: state.profileImage?.path,
                    showOverlay: _showGestureOverlay,
                    hideOverlay: _hideGestureOverlay,
                    onTransformChanged: _onTransformChangedLegacy,
                    onTransformChangedV2: _onTransformChangedV2,
                    width: 370,
                    height: 370,
                    padding: EdgeInsets.zero,
                    outerBorderRadius: SDeckRadius.borderRadius16,
                    innerBorderRadius: SDeckRadius.borderRadius16,
                    initialScale: state.scale,
                    initialPanX: state.panX,
                    initialPanY: state.panY,
                    initialRotation: state.rotation,
                  ),
                ),
              ),

              const SizedBox(height: SDeckSpace.gap16),

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

              SDeckFadeSwap(
                visible: _visible,
                child: SizedBox(
                  width: 370,
                  child: SDeckSolidButton(
                    text: "Looks great!",
                    size: SDeckButtonSize.large,
                    fullWidth: true,
                    onPressed: state.profileImage == null ? null : _onConfirm,
                  ),
                ),
              ),

              const SizedBox(height: SDeckSpace.gap8),

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