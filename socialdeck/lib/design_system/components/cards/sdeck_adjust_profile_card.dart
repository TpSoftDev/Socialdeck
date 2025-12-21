/*-------------------- sdeck_adjust_profile_card.dart -----------------------*/
// Profile card component for image adjustment interface
// Allows users to scale, move, and rotate profile images using gestures
// Built with interactive viewer for touch manipulation and visual guidance
//
// Usage: SDeckAdjustProfileCard(imagePath: '/path/to/image.jpg')
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';
import '../../foundations/index.dart';
import '../icons/sdeck_icon.dart';

//------------------------------- SDeckAdjustProfileCard ---------------------//
/// Profile card component that allows users to scale, move, and rotate images
/// Supports dynamic overlay hiding when user interacts with the image
/// Captures transform data using TransformationController for persistence
class SDeckAdjustProfileCard extends StatefulWidget {
  //*************************** Properties ******************************//
  /// The path to the image file to be displayed and adjusted in the card
  final String? imagePath;

  /// Whether to show the instruction overlay with gradient and text
  /// When false, overlay is hidden for clear image manipulation
  final bool showOverlay;

  /// Callback to hide the overlay when user touches the image
  /// Called only once on first touch to remove instruction overlay
  final VoidCallback? hideOverlay;

  /// Callback that receives transform data when user finishes adjusting
  /// Passes scale (zoom level), panX (horizontal), panY (vertical) values
  final void Function(double scale, double panX, double panY)?
  onTransformChanged;

  //*************************** Constructor ******************************//
  const SDeckAdjustProfileCard({
    super.key,
    this.imagePath,
    this.showOverlay = true,
    this.hideOverlay,
    this.onTransformChanged,
  });

  //*************************** Create State ******************************//
  @override
  State<SDeckAdjustProfileCard> createState() => _SDeckAdjustProfileCardState();
}

//------------------------------- State Class ----------------------------//
/// State class that manages the TransformationController and handles
/// user interaction data extraction from the InteractiveViewer
class _SDeckAdjustProfileCardState extends State<SDeckAdjustProfileCard> {
  //*************************** Controller ******************************//
  /// TransformationController tracks all user gestures (zoom, pan, rotation)
  /// "recording device" that captures user adjustments
  final TransformationController _transformationController =
      TransformationController();

  //*************************** State Variables ******************************//
  /// Track if this is the user's first interaction (for overlay hiding)
  bool _onFirstInteraction = true;

  //*************************** Lifecycle Methods ******************************//
  /// Clean up the controller when widget is disposed to prevent memory leaks
  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  //*************************** Build Method ******************************//
  /// Builds the widget tree for the profile card adjustment interface
  @override
  Widget build(BuildContext context) {
    //------------------------------- Container ----------------------------//
    return Container(
      width: 192,
      height: 288,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.createProfileCardBackground,
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadiusL), // 16px
      ),
      //------------------------------- Stack ----------------------------//
      child: Stack(
        children: [
          //------------------------------- Background Image ----------------------//
          // If imagePath is provided, display the image
          if (widget.imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(
                SDeckRadius.borderRadiusS,
              ), // 8px
              child: InteractiveViewer(
                // Connect controller to track user gestures
                transformationController: _transformationController,
                minScale: 0.5, // Can zoom out to 50%
                maxScale:
                    2.0, // Can zoom in to 200% (better for small container)
                panEnabled: true,
                scaleEnabled: true,

                // Triggered when the user starts interacting with the image
                onInteractionStart: (details) {
                  // Only hide overlay on FIRST touch, not every touch
                  if (_onFirstInteraction && widget.hideOverlay != null) {
                    _onFirstInteraction =
                        false; // Mark as no longer first interaction
                    widget.hideOverlay!(); // Hide overlay (only once)
                  }
                },

                // Note: No onInteractionEnd - we capture manually when user clicks save
                // This prevents constant callbacks during adjustment process
                // Rotate the image to match the user's gesture
                child: Transform.rotate(
                  angle: 0.0, // For now, static - we'll make this dynamic later
                  // Display the image
                  child: Image.file(
                    File(widget.imagePath!),
                    fit: BoxFit.cover, // Fill the container properly
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            )
          else
            // If no image is provided, display a placeholder text
            Center(child: Text('No image selected')),

          //---------------------------- Dotted Border Overlay ---------------//
          // If imagePath is provided, display the dotted border overlay
          // Ignore pointer to prevent interaction with the image
          IgnorePointer(
            child: DottedBorder(
              color: Theme.of(context).colorScheme.createProfileCardBorder,
              strokeWidth: 3,
              dashPattern: [16, 7],
              borderType: BorderType.RRect,
              radius: Radius.circular(SDeckRadius.borderRadiusS), // 8px
              child: Container(
                // Add rounded corners to the container
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    SDeckRadius.borderRadiusS,
                  ), // 8px
                ),
              ),
            ),
          ),

          //------------------------ Text Overlay with Gradient --------------//
          // Show guidance text based on showOverlay prop from parent
          // If imagePath is provided, display the text overlay
          if (widget.imagePath != null && widget.showOverlay)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      SDeckRadius.borderRadiusS,
                    ), // 8px
                    // Gradient to create a fade effect
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
                    padding: EdgeInsets.all(SDeckSpace.paddingM), // 16px
                    // Sized box to contain the column
                    child: SizedBox(
                      width: 123,
                      height: 116,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //----------------------- Hand Gesture Icon ---------//
                          SDeckIcon(
                            context.icons.pinchAdjust,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),

                          SizedBox(height: SDeckSpace.gapXS),

                          //------------------------------- Instruction Text ---------//
                          Text(
                            'Scale,\nMove,\nRotate',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  //*************************** Manual Transform Capture ****************************//
  /// Public method to capture current adjustments when user clicks save
  /// Call this from your save button to get the final adjustment values
  void captureCurrentAdjustments() {
    _captureTransformData();
  }

  /// Extracts simple numbers from the complex Matrix4 transformation data
  /// This converts the current "recording" into understandable scale and pan values
  void _captureTransformData() {
    // Get the current transformation matrix from the controller
    final Matrix4 transform = _transformationController.value;

    // Extract simple values from the complex matrix:
    final double scale =
        transform.getMaxScaleOnAxis(); // Zoom level (1.0 = normal, 1.5 = 150%)
    final double panX =
        transform
            .getTranslation()
            .x; // Horizontal movement (+ = right, - = left)
    final double panY =
        transform.getTranslation().y; // Vertical movement (+ = down, - = up)

    // Optional: Enable for debugging transform capture
    // print('🔍 Transform Data: Scale=${scale.toStringAsFixed(2)}x, PanX=${panX.toStringAsFixed(1)}px, PanY=${panY.toStringAsFixed(1)}px');

    // Pass the final data to parent component (triggered by save button)
    if (widget.onTransformChanged != null) {
      widget.onTransformChanged!(scale, panX, panY);
    }
  }
}
