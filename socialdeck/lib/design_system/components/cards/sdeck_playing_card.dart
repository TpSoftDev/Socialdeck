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
import '../../foundations/index.dart';

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
  final List<BoxShadow>? boxShadow;

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
    this.boxShadow,
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
         padding: SDeckSpacing.x24,
         borderRadius: SDeckRadius.s,
         innerRadius: SDeckRadius.xs,
         boxShadow: null,
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
         padding: SDeckSpacing.x16,
         borderRadius: SDeckRadius.xs,
         innerRadius: SDeckRadius.xxs,
         boxShadow: SDeckShadows.playingCard,
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
         padding: SDeckSpacing.x8, // Design system token
         borderRadius: SDeckRadius.xxs, // Design system token (8px)
         innerRadius: SDeckRadius.xxxs, // Design system token (4px)
         boxShadow: SDeckShadows.playingCard, // Shadow per Figma
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
         padding: SDeckSpacing.x8, 
         borderRadius: SDeckRadius.xxs, 
         innerRadius: SDeckRadius.xxxs, 
         boxShadow: SDeckShadows.playingCard, 
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
         padding: SDeckSpacing.x6, 
         borderRadius: SDeckRadius.xxs, //8px
         innerRadius: SDeckRadius.xxxs, //4px
         boxShadow: SDeckShadows.playingCard, 
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
         borderRadius: SDeckRadius.xxxs, //4px
         innerRadius: 2,
         boxShadow: SDeckShadows.playingCard, 
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
          color: Theme.of(context).colorScheme.playingCardBackground,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: boxShadow,
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
                    child: Image.file(
                      File(imagePath!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        // If image fails to load, show checkered background instead
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(SDeckAssets.checkeredBackground),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(innerRadius),
                          ),
                        );
                      },
                    ),
                  ),
                )
                : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(SDeckAssets.checkeredBackground),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(innerRadius),
                  ),
                ),
      ),
    );
  }

  //*************************** Helper Method ****************************//
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
}
