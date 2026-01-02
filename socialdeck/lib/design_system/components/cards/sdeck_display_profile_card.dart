/*-------------------- sdeck_display_profile_card.dart -----------------------*/
// Profile card component for displaying final adjusted images
// Shows profile images with pre-applied transformations from saved adjustment data
// Non-interactive - displays the final result of user adjustments
//
// Usage: SDeckDisplayProfileCard(imagePath: '/path/to/image.jpg', scale: 1.5, panX: 20, panY: 10)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import '../../tokens/colors/index.dart';
import '../../tokens/index.dart';

//------------------------------- SDeckDisplayProfileCard ---------------------//
/// Profile card component that displays images with pre-applied transformations
/// Takes saved adjustment data (scale, panX, panY) and recreates the user's final adjustments
/// Non-interactive - purely for display purposes
class SDeckDisplayProfileCard extends StatelessWidget {
  //*************************** Properties ******************************//
  /// The path to the image file to be displayed
  final String? imagePath;

  /// Scale level from saved adjustments (1.0 = normal, 1.5 = 150% zoom)
  final double scale;

  /// Horizontal pan offset from saved adjustments (+ = right, - = left)
  final double panX;

  /// Vertical pan offset from saved adjustments (+ = down, - = up)
  final double panY;

  //*************************** Constructor ******************************//
  /// Creates a new instance of [SDeckDisplayProfileCard]
  ///
  /// The [imagePath] parameter specifies the local file path to the image
  /// The [scale] parameter sets the zoom level (default: 1.0 = no zoom)
  /// The [panX] parameter sets horizontal offset (default: 0.0 = centered)
  /// The [panY] parameter sets vertical offset (default: 0.0 = centered)
  const SDeckDisplayProfileCard({
    super.key,
    this.imagePath,
    this.scale = 1.0,
    this.panX = 0.0,
    this.panY = 0.0,
  });

  //*************************** Build Method ******************************//
  /// Builds the widget tree for the profile card display interface
  @override
  Widget build(BuildContext context) {
    //------------------------------- Container ----------------------------//
    return Container(
      width: 192,
      height: 288,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.semantic.surfaceVariant,
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadiusL), // 16px
      ),
      //------------------------------- Stack ----------------------------//
      child: Stack(
        children: [
          //------------------------------- Background Image ----------------------//
          // If imagePath is provided, display the image with transformations
          if (imagePath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(
                SDeckRadius.borderRadiusS,
              ), // 8px
              child: InteractiveViewer(
                transformationController: _createTransformController(),
                panEnabled: false, // Display only - no user interaction
                scaleEnabled: false, // Display only - no user interaction
                child: Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.red.shade100,
                      child: Center(
                        child: Text(
                          'Image Error\n$error',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ] else
            // If no image is provided, display a placeholder text
            Center(child: Text('No image selected')),

          // No border overlay needed for display component
          // This shows the final clean result without adjustment indicators
        ],
      ),
    );
  }

  //*************************** Helper Method ****************************//
  /// Creates a TransformationController with the saved adjustment values
  /// Recreates the exact same transformation from the adjust card
  TransformationController _createTransformController() {
    final controller = TransformationController();

    // Create the same matrix as InteractiveViewer uses internally
    final matrix = Matrix4.identity();
    matrix.scale(scale, scale, 1.0);
    matrix.setTranslation(Vector3(panX, panY, 0.0));

    // Set the transformation
    controller.value = matrix;

    return controller;
  }
}
