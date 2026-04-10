/*-------------------- sdeck_adjust_profile_card.dart -----------------------*/
// Profile card component for image adjustment interface
// Allows users to scale, move, and rotate profile images using gestures
//
// Backward-compatible refactor notes:
// - Keeps the existing public API:
//    * imagePath
//    * showOverlay
//    * hideOverlay
//    * onTransformChanged(scale, panX, panY)
// - Adds optional newer API for rotation support:
//    * onTransformChangedV2(scale, panX, panY, rotation)
// - Replaces InteractiveViewer with GestureDetector + Transform so rotation
//   is now truly supported.
// - Adds optional sizing props so existing callers keep their old defaults,
//   while screens like Edit Photo can reuse this component at a larger size.
/*--------------------------------------------------------------------------*/

import 'dart:io';
import 'package:flutter/material.dart';
import '../../tokens/index.dart';

//------------------------------- SDeckAdjustProfileCard ---------------------//
class SDeckAdjustProfileCard extends StatefulWidget {
  final String? imagePath;
  final bool showOverlay;
  final VoidCallback? hideOverlay;

  /// Legacy callback kept for backward compatibility.
  final void Function(double scale, double panX, double panY)?
      onTransformChanged;

  /// New callback that also includes rotation in radians.
  final void Function(
    double scale,
    double panX,
    double panY,
    double rotation,
  )? onTransformChangedV2;

  final double initialScale;
  final double initialPanX;
  final double initialPanY;
  final double initialRotation;

  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final double outerBorderRadius;
  final double innerBorderRadius;

  const SDeckAdjustProfileCard({
    super.key,
    this.imagePath,
    this.showOverlay = true,
    this.hideOverlay,
    this.onTransformChanged,
    this.onTransformChangedV2,
    this.initialScale = 1.0,
    this.initialPanX = 0.0,
    this.initialPanY = 0.0,
    this.initialRotation = 0.0,
    this.width = 192,
    this.height = 288,
    this.padding = const EdgeInsets.all(16),
    this.outerBorderRadius = SDeckRadius.borderRadius16,
    this.innerBorderRadius = SDeckRadius.borderRadius8,
  });

  @override
  State<SDeckAdjustProfileCard> createState() => _SDeckAdjustProfileCardState();
}

class _SDeckAdjustProfileCardState extends State<SDeckAdjustProfileCard> {
  //*************************** Transform State *****************************//
  double _scale = 1.0;
  double _rotation = 0.0;
  Offset _offset = Offset.zero;

  // Gesture start snapshots
  double _gestureStartScale = 1.0;
  double _gestureStartRotation = 0.0;
  Offset _gestureStartOffset = Offset.zero;
  Offset _gestureStartFocalPoint = Offset.zero;

  //*************************** UI State ************************************//
  bool _onFirstInteraction = true;

  @override
  void initState() {
    super.initState();

    _scale = widget.initialScale;
    _rotation = widget.initialRotation;
    _offset = Offset(widget.initialPanX, widget.initialPanY);
  }

  void captureCurrentAdjustments() {
    _notifyTransformChanged();
  }

  void _handleFirstInteraction() {
    if (_onFirstInteraction && widget.hideOverlay != null) {
      _onFirstInteraction = false;
      widget.hideOverlay!();
    }
  }

  void _notifyTransformChanged() {
    final double panX = _offset.dx;
    final double panY = _offset.dy;

    if (widget.onTransformChanged != null) {
      widget.onTransformChanged!(_scale, panX, panY);
    }

    if (widget.onTransformChangedV2 != null) {
      widget.onTransformChangedV2!(_scale, panX, panY, _rotation);
    }
  }

  void _onScaleStart(ScaleStartDetails details) {
    _handleFirstInteraction();

    _gestureStartScale = _scale;
    _gestureStartRotation = _rotation;
    _gestureStartOffset = _offset;
    _gestureStartFocalPoint = details.focalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_gestureStartScale * details.scale).clamp(0.5, 4.0);
      _rotation = _gestureStartRotation + details.rotation;

      final Offset focalPointDelta =
          details.focalPoint - _gestureStartFocalPoint;
      _offset = _gestureStartOffset + focalPointDelta;
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    _notifyTransformChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: context.semantic.surfaceVariant,
        borderRadius: BorderRadius.circular(widget.outerBorderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.innerBorderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            //------------------------ Placeholder only ------------------//
            if (widget.imagePath == null)
              Image.asset(
                SDeckIcon.checkeredBackground,
                fit: BoxFit.cover,
              ),

            //------------------------ Image only ------------------------//
            if (widget.imagePath != null)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                onScaleEnd: _onScaleEnd,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..translate(_offset.dx, _offset.dy)
                        ..rotateZ(_rotation)
                        ..scale(_scale),
                      child: SizedBox.expand(
                        child: Image.file(
                          File(widget.imagePath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            //------------------------ Instruction Overlay ----------------//
            if (widget.imagePath != null && widget.showOverlay)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.innerBorderRadius),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        stops: const [0.3, 1.0],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(SDeckSpace.padding16),
                      child: Center(
                        // ✅ FIX: removed fixed SizedBox, added FittedBox
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SDeckIcons(
                                SDeckIcon.pinchAdjust,
                                size: 40, // reduced from SDeckSize.size48
                                color: context.semantic.onPrimary,
                              ),
                              const SizedBox(height: SDeckSpace.gap8),
                              Text(
                                'Scale,\nMove,\nRotate',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium // reduced from bodyLarge
                                    ?.copyWith(
                                      color: context.semantic.onPrimary,
                                    ),
                              ),
                            ],
                          ),
                        ),
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
}