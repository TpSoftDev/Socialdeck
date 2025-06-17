import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';
import '../../foundations/index.dart';
import '../icons/sdeck_icon.dart';

class SDeckAdjustProfileCard extends StatelessWidget {
  //*************************** Properties ******************************//
  /// The path to the image to be displayed in the card.
  final String? imagePath;

  //*************************** Constructor ******************************//
  /// Creates a new instance of [SDeckAdjustProfileCard].
  const SDeckAdjustProfileCard({super.key, this.imagePath});

  //*************************** Build Method ******************************//
  /// Builds the widget tree for the [SDeckAdjustProfileCard].
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 192,
      height: 288,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.createProfileCardBackground,
        borderRadius: BorderRadius.circular(SDeckRadius.xs), // 16px
      ),

      child: Stack(
        children: [
          // Background Image
          if (imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(SDeckRadius.xxs), // 8px
              child: InteractiveViewer(
                minScale: 0.5, // Can zoom out to 50%
                maxScale: 3.0, // Can zoom in to 300%
                panEnabled: true,
                scaleEnabled: true,
                child: Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            )
          else
            Center(child: Text('No image selected')),

          // Dotted Border Overlay
          DottedBorder(
            color: Theme.of(context).colorScheme.createProfileCardBorder,
            strokeWidth: 3,
            dashPattern: [16, 7],
            borderType: BorderType.RRect,
            radius: Radius.circular(SDeckRadius.xxs), // 8px
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SDeckRadius.xxs), // 8px
              ),
            ),
          ),

          // Text Overlay with Gradient (only show if we have an image)
          if (imagePath != null)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SDeckRadius.xxs), // 8px
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
                    padding: EdgeInsets.all(SDeckSpacing.x16),
                    child: SizedBox(
                      width: 123,
                      height: 116,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Hand gesture icon
                          SDeckIcon(
                            context.icons.pinchAdjust,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),

                          SizedBox(height: SDeckSpacing.x8),

                          // Instruction text
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
}
