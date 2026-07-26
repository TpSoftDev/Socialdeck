/*----------------------- sdeck_playing_card.dart ---------------------------*/
// Playing card component for the SocialDeck design system.
// Framed photo card with size, shadow, and state variants. Supports optional
// saved photo adjustments (scale / pan) for profile and deck flows.
//
// Usage:
//   SDeckPlayingCard(
//     size: SDeckPlayingCardSize.small,
//     shadow: SDeckPlayingCardShadow.none,
//     state: SDeckPlayingCardState.default_,
//     imagePath: '/path/to/image.jpg',
//   )
/*--------------------------------------------------------------------------*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import '../../tokens/index.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/effects/index.dart';
import '../../tokens/icons/index.dart';
import 'playing_card_enums.dart';

//------------------------------- SDeckPlayingCard ---------------------------//
class SDeckPlayingCard extends StatelessWidget {
  //*************************** Properties ******************************//

  // Matches the Size / Shadow / State playground controls.
  final SDeckPlayingCardSize size;
  final SDeckPlayingCardShadow shadow;
  final SDeckPlayingCardState state;

  // Content. Null imagePath shows the checkered placeholder.
  final String? imagePath;
  final double scale;
  final double panX;
  final double panY;

  // Interaction.
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  //*************************** Constructor ******************************//
  const SDeckPlayingCard({
    super.key,
    this.size = SDeckPlayingCardSize.extraLarge,
    this.shadow = SDeckPlayingCardShadow.none,
    this.state = SDeckPlayingCardState.default_,
    this.imagePath,
    this.scale = 1.0,
    this.panX = 0.0,
    this.panY = 0.0,
    this.onTap,
    this.onRemove,
  });

  //*************************** Geometry *********************************//
  // Every size is one unit value times fixed multipliers (29w / 39h / 2pad /
  // 4 outer radius / 2 inner radius). Border width for Selected and Move is
  // one unit, which matches the drawn Small (4) and Medium (6) borders.
  static double _unitFor(SDeckPlayingCardSize size) {
    switch (size) {
      case SDeckPlayingCardSize.extraSmall:
        return 3;
      case SDeckPlayingCardSize.small:
        return 4;
      case SDeckPlayingCardSize.medium:
        return 6;
      case SDeckPlayingCardSize.large:
        return 8;
      case SDeckPlayingCardSize.extraLarge:
        return 10;
    }
  }

  //*************************** Build Method ******************************//
  @override
  Widget build(BuildContext context) {
    final unit = _unitFor(size);
    final width = 29 * unit;
    final height = 39 * unit;
    final padding = 2 * unit;
    final outerRadius = 4 * unit;
    final innerRadius = 2 * unit;
    final borderWidth = unit;

    final decoration = _resolveDecoration(
      context: context,
      outerRadius: outerRadius,
      borderWidth: borderWidth,
    );

    Widget card = Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: decoration,
      child: _buildImageSlot(context, innerRadius),
    );

    if (state == SDeckPlayingCardState.remove) {
      card = SizedBox(
        width: width,
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            card,
            Positioned(
              top: padding,
              right: padding,
              child: GestureDetector(
                onTap: onRemove,
                behavior: HitTestBehavior.opaque,
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: SDeckIcons(SDeckIcon.delete, size: 24),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(onTap: onTap, child: card);
  }

  //*************************** Helper Methods ****************************//

  BoxDecoration _resolveDecoration({
    required BuildContext context,
    required double outerRadius,
    required double borderWidth,
  }) {
    final component = context.component;
    final radius = BorderRadius.circular(outerRadius);

    switch (state) {
      case SDeckPlayingCardState.selected:
        return BoxDecoration(
          color: component.playingCardTrim,
          borderRadius: radius,
          border: Border.all(
            color: component.playingCardBorderSelected,
            width: borderWidth,
          ),
          boxShadow: SDeckOuterGlows.outerGlowLowSkyBlue(
            component.playingCardBorderSelected,
          ),
        );
      case SDeckPlayingCardState.moveHeld:
        return BoxDecoration(
          color: component.playingCardTrim,
          borderRadius: radius,
          border: Border.all(
            color: component.playingCardBorderMove,
            width: borderWidth,
          ),
          boxShadow: SDeckOuterGlows.outerGlowHighVibrantYellow(
            component.playingCardBorderMove,
          ),
        );
      case SDeckPlayingCardState.default_:
      case SDeckPlayingCardState.remove:
        return BoxDecoration(
          color: component.playingCardTrim,
          borderRadius: radius,
          boxShadow: _resolveElevationShadow(context),
        );
    }
  }

  List<BoxShadow> _resolveElevationShadow(BuildContext context) {
    final shadowColor = context.semantic.shadow;
    switch (shadow) {
      case SDeckPlayingCardShadow.none:
        return SDeckBoxShadows.noShadow();
      case SDeckPlayingCardShadow.low:
        return SDeckBoxShadows.boxShadowLow(shadowColor);
      case SDeckPlayingCardShadow.medium:
        return SDeckBoxShadows.boxShadow(shadowColor);
      case SDeckPlayingCardShadow.high:
        return SDeckBoxShadows.boxShadowHigh(shadowColor);
    }
  }

  Widget _buildImageSlot(BuildContext context, double innerRadius) {
    final radius = BorderRadius.circular(innerRadius);

    if (imagePath == null) {
      return _buildCheckeredPlaceholder(radius);
    }

    return ClipRRect(
      borderRadius: radius,
      child: InteractiveViewer(
        transformationController: _createTransformController(),
        panEnabled: false,
        scaleEnabled: false,
        child: _buildImageWidget(innerRadius),
      ),
    );
  }

  Widget _buildCheckeredPlaceholder(BorderRadius radius) {
    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage(SDeckIcon.checkeredBackground),
          fit: BoxFit.cover,
        ),
        borderRadius: radius,
      ),
    );
  }

  TransformationController _createTransformController() {
    final controller = TransformationController();
    final matrix = Matrix4.identity();
    matrix.scale(scale, scale, 1.0);
    matrix.setTranslation(Vector3(panX, panY, 0.0));
    controller.value = matrix;
    return controller;
  }

  Widget _buildImageWidget(double innerRadius) {
    final isNetworkUrl =
        imagePath!.startsWith('http://') || imagePath!.startsWith('https://');
    final isAssetPath = imagePath!.startsWith('assets/');

    if (isNetworkUrl) {
      return Image.network(
        imagePath!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
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
          return _buildCheckeredPlaceholder(BorderRadius.circular(innerRadius));
        },
      );
    }

    if (isAssetPath) {
      return Image.asset(
        imagePath!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildCheckeredPlaceholder(BorderRadius.circular(innerRadius));
        },
      );
    }

    return Image.file(
      File(imagePath!),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return _buildCheckeredPlaceholder(BorderRadius.circular(innerRadius));
      },
    );
  }
}
