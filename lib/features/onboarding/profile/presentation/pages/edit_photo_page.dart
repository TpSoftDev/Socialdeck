import 'package:socialdeck/features/onboarding/profile/utils/fade_swap.dart';
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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
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
  bool _visible = true;
  bool _showGestureOverlay = true;

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
        duration: SDeckMotionDuration.normal,
        reverseDuration: SDeckMotionDuration.normal,
      ),
      builder: (context) => const ImportImageBottomSheet(),
    );

    final state = ref.watch(profileCardProvider);

    if (!mounted || !state.imageSizeCheck || !state.imageTypeCheck) return;

    setState(() {
      _visible = false;
    });

    await Future.delayed(SDeckMotionDuration.normal);

    if (!mounted) return;

    setState(() {
      _resetTransformState();
      _visible = true;
    });
  }

  Future<void> _onConfirm() async {
    final state = ref.watch(profileCardProvider);
    if (state.profileImage == null) return;

    // Decode into the image cache before the route runs so Enter Username does
    // not paint an empty file-decoder frame (common “flash” between screens).
    await precacheImage(FileImage(File(state.profileImage!.path)), context);

    if (!mounted) return;

    context.push(AppPaths.enterUsername);
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
              SDeckTopNavigationBar(
                left: SDeckTopBarLeft.none,
                type: SDeckTopBarType.subpage,
                right: SDeckTopBarRight.none,
                title: 'Edit Photo',
              ),

              FadeSwap(
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

              FadeSwap(
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

              FadeSwap(
                visible: _visible,
                child: SizedBox(
                  width: 370,
                  child: SDeckSolidButton(
                    text: "Looks good!",
                    size: SDeckButtonSize.large,
                    fullWidth: true,
                    onPressed: state.profileImage == null ? null : _onConfirm,
                  ),
                ),
              ),

              const SizedBox(height: SDeckSpace.gap8),

              FadeSwap(
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