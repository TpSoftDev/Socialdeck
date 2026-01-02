/*----------------------- sdeck_playing_card.dart ---------------------------*/
// Playing card component for the SocialDeck design system
// Displays profile photos in a card format with support for saved adjustments
// Used for login display, deck building, and game interfaces
//
// Usage: SDeckPlayingCard.large(imagePath: '/path/to/image.jpg', scale: 1.5, panX: 20, panY: 10)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import '../../tokens/index.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/effects/index.dart';

//------------------------------- SDeckPlayingCard ---------------------------//
/// Playing card component that displays images with optional saved adjustments
/// Supports multiple sizes and reuses profile photo transformation logic
/// Non-interactive display - purely for showing final photo results
class SDeckPlayingCard extends StatelessWidget {
  //*************************** Properties ******************************//
  /// Card dimensions - set by named constructors
  final double width;
  final double height;

  /// Visual styling - set by named constructors
  final double padding;
  final double borderRadius;
  final double innerRadius;
  final bool hasShadow;

  /// Content parameters - passed by user
  final String? imagePath;
  final double scale;
  final double panX;
  final double panY;

  /// Interaction parameter - for future use
  final VoidCallback? onTap;

  //*************************** Private Constructor ******************************//
  /// Private constructor ensures all variants use consistent internal logic
  /// Named constructors (below) provide the public API with exact measurements
  const SDeckPlayingCard._({
    super.key,
    required this.width,
    required this.height,
    required this.padding,
    required this.borderRadius,
    required this.innerRadius,
    this.hasShadow = false,
    this.imagePath,
    this.scale = 1.0,
    this.panX = 0.0,
    this.panY = 0.0,
    this.onTap,
  });

  //*************************** Named Constructors ***************************//

  //------------------------------- Large Size --------------------------//
  const SDeckPlayingCard.large({
    Key? key,
    String? imagePath,
    double scale = 1.0,
    double panX = 0.0,
    double panY = 0.0,
    VoidCallback? onTap,
  }) : this._(
         key: key,
         width: 336,
         height: 480,
        padding: SDeckSpace.paddingL,
        borderRadius: SDeckRadius.borderRadiusS,
        innerRadius: SDeckRadius.borderRadiusXS,
        hasShadow: false,
         imagePath: imagePath,
         scale: scale,
         panX: panX,
         panY: panY,
         onTap: onTap,
       );

  //------------------------------- Medium Size --------------------------//
  const SDeckPlayingCard.medium({
    Key? key,
    String? imagePath,
    double scale = 1.0,
    double panX = 0.0,
    double panY = 0.0,
    VoidCallback? onTap,
  }) : this._(
         key: key,
         width: 224,
         height: 320,
        padding: SDeckSpace.paddingM,
        borderRadius: SDeckRadius.borderRadiusXS,
        innerRadius: SDeckRadius.borderRadiusXXS,
        hasShadow: true,
         imagePath: imagePath,
         scale: scale,
         panX: panX,
         panY: panY,
         onTap: onTap,
       );

  //------------------------------- Small Size --------------------------//

  const SDeckPlayingCard.small({
    Key? key,
    String? imagePath,
    double scale = 1.0,
    double panX = 0.0,
    double panY = 0.0,
    VoidCallback? onTap,
  }) : this._(
         key: key,
         width: 112, // Calculated: 96 + 8*2 padding = 112px
         height: 160, // Calculated: 144 + 8*2 padding = 160px
        padding: SDeckSpace.paddingXS, // Design system token
        borderRadius: SDeckRadius.borderRadiusXXS, // Design system token (8px)
        innerRadius: SDeckRadius.borderRadiusXS, // Design system token (4px)
        hasShadow: true,
         imagePath: imagePath,
         scale: scale,
         panX: panX,
         panY: panY,
         onTap: onTap,
       );
  //------------------------------- Smaller Size --------------------------//

  const SDeckPlayingCard.smaller({
    Key? key,
    String? imagePath,
    double scale = 1.0,
    double panX = 0.0,
    double panY = 0.0,
    VoidCallback? onTap,
  }) : this._(
         key: key,
         width: 100,
         height: 142,
        padding: SDeckSpace.paddingXS,
        borderRadius: SDeckRadius.borderRadiusXXS,
        innerRadius: SDeckRadius.borderRadiusXS,
        hasShadow: true,
         imagePath: imagePath,
         scale: scale,
         panX: panX,
         panY: panY,
         onTap: onTap,
       );

  //------------------------------- Smallest Size --------------------------//

  const SDeckPlayingCard.smallest({
    Key? key,
    String? imagePath,
    double scale = 1.0,
    double panX = 0.0,
    double panY = 0.0,
    VoidCallback? onTap,
  }) : this._(
         key: key,
         width: 68,
         height: 96,
        padding:
            SDeckSpace.paddingXS, // Note: x6 not in Figma, using closest (8px)
        borderRadius: SDeckRadius.borderRadiusXXS, //8px
        innerRadius: SDeckRadius.borderRadiusXS, //4px
        hasShadow: true,
         imagePath: imagePath,
         scale: scale,
         panX: panX,
         panY: panY,
         onTap: onTap,
       );

  //------------------------------- mini Size --------------------------//

  const SDeckPlayingCard.mini({
    Key? key,
    String? imagePath,
    double scale = 1.0,
    double panX = 0.0,
    double panY = 0.0,
    VoidCallback? onTap,
  }) : this._(
         key: key,
         width: 34,
         height: 48,
        padding: 3,
        borderRadius: SDeckRadius.borderRadiusXS, //4px
        innerRadius: 2,
        hasShadow: true,
         imagePath: imagePath,
         scale: scale,
         panX: panX,
         panY: panY,
         onTap: onTap,
       );

  //*************************** Build Method ******************************//
  /// Builds the widget tree for the playing card display
  @override
  Widget build(BuildContext context) {
    //------------------------------- Main Container -------------------------//
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: context.semantic.surfaceVariant,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: hasShadow
              ? SDeckBoxShadows.boxShadowLow(context.semantic.shadow)
              : null,
        ),
        //------------------------------- Image Container --------------------//
        child:
            imagePath != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(innerRadius),
                  child: InteractiveViewer(
                    transformationController: _createTransformController(),
                    panEnabled: false, // Display only - no user interaction
                    scaleEnabled: false, // Display only - no user interaction
                    child: _buildImageWidget(),
                  ),
                )
                : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(SDeckIcons.checkeredBackground),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(innerRadius),
                  ),
                ),
      ),
    );
  }

  //*************************** Helper Methods ****************************//
  /// Creates a TransformationController with the saved adjustment values
  /// Recreates the exact same transformation from profile adjustment flow
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

  /// Builds the appropriate image widget based on imagePath type
  /// Uses Image.network for Firebase URLs, Image.asset for asset paths, Image.file for local paths
  Widget _buildImageWidget() {
    // Determine if imagePath is a network URL, asset path, or local file path
    final isNetworkUrl =
        imagePath!.startsWith('http://') || imagePath!.startsWith('https://');
    final isAssetPath = imagePath!.startsWith('assets/');

    if (isNetworkUrl) {
      // Firebase Storage URL - use Image.network
      return Image.network(
        imagePath!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          // Show loading indicator while downloading
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(innerRadius),
            ),
            child: Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorFallback();
        },
      );
    } else if (isAssetPath) {
      // Asset path - use Image.asset
      return Image.asset(
        imagePath!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorFallback();
        },
      );
    } else {
      // Local file path - use Image.file
      return Image.file(
        File(imagePath!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorFallback();
        },
      );
    }
  }

  /// Builds the error fallback widget (checkered background)
  Widget _buildErrorFallback() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(SDeckIcons.checkeredBackground),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(innerRadius),
      ),
    );
  }
}
