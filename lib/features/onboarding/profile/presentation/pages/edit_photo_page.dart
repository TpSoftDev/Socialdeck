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

class EditPhotoPage extends ConsumerStatefulWidget {
  final XFile? image;

  const EditPhotoPage({
    super.key,
    this.image,
  });

  @override
  ConsumerState<EditPhotoPage> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends ConsumerState<EditPhotoPage> {
  bool _visible = false;
  XFile? _currentImage;
  bool _showGestureOverlay = true;

  double _scale = 1.0;
  double _panX = 0.0;
  double _panY = 0.0;
  double _rotation = 0.0;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.image;
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
    _scale = scale;
    _panX = panX;
    _panY = panY;
  }

  void _onTransformChangedV2(
    double scale,
    double panX,
    double panY,
    double rotation,
  ) {
    _scale = scale;
    _panX = panX;
    _panY = panY;
    _rotation = rotation;

    // TODO (BACKEND):
    // These values represent the user's final image adjustments.
    // Backend should store:
    // - scale
    // - panX
    // - panY
    // - rotation
    //
    // Suggested usage:
    // - Save alongside uploaded profile image
    // - Or store in user profile settings
  }

  void _resetTransformState() {
    _scale = 1.0;
    _panX = 0.0;
    _panY = 0.0;
    _rotation = 0.0;
    _showGestureOverlay = true;
  }

  Future<void> _onChangePhoto() async {
    final XFile? newImage = await showModalBottomSheet<XFile>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      sheetAnimationStyle: const AnimationStyle(
        duration: SDeckMotionDuration.sheet,
        reverseDuration: SDeckMotionDuration.sheet,
      ),
      builder: (context) => const ImportImageBottomSheet(),
    );

    if (!mounted || newImage == null) return;

    setState(() {
      _visible = false;
    });

    await Future.delayed(SDeckMotionDuration.fade);

    if (!mounted) return;

    setState(() {
      _currentImage = newImage;
      _resetTransformState();
      _visible = true;
    });
  }

  Future<void> _onConfirm() async {
    if (_currentImage == null) return;

    // TODO (BACKEND):
    // Send the following data to backend when user confirms:
    // - image file (_currentImage)
    // - scale (_scale)
    // - panX (_panX)
    // - panY (_panY)
    // - rotation (_rotation)
    //
    // Example payload:
    // {
    //   image: file,
    //   scale: double,
    //   panX: double,
    //   panY: double,
    //   rotation: double
    // }
    //
    // Backend can:
    // - Store raw image + transform values
    // - OR apply transformation and store processed image

    setState(() {
      _visible = false;
    });

    await Future.delayed(SDeckMotionDuration.fade);

    if (!mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EnterUsernamePage(
          image: _currentImage,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {
      _visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    imagePath: _currentImage?.path,
                    showOverlay: _showGestureOverlay,
                    hideOverlay: _hideGestureOverlay,
                    onTransformChanged: _onTransformChangedLegacy,
                    onTransformChangedV2: _onTransformChangedV2,
                    width: 370,
                    height: 370,
                    padding: EdgeInsets.zero,
                    outerBorderRadius: SDeckRadius.borderRadius16,
                    innerBorderRadius: SDeckRadius.borderRadius16,
                    initialScale: _scale,
                    initialPanX: _panX,
                    initialPanY: _panY,
                    initialRotation: _rotation,
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
                    onPressed: _currentImage == null ? null : _onConfirm,
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