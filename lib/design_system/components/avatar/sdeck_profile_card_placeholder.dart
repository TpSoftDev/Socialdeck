/*------------------- sdeck_profile_card_placeholder.dart -------------------*/
// Figma profileCard / profileCardPlaceholder — shows a user's saved profile
// image with Firestore transform data, or the checkered placeholder when empty.
//
// Two variants:
//   fixed      — explicit pixel size, rounded-square corners. Use in tight
//                layouts like the top bar or list rows.
//   responsive — fills the parent width, always a perfect circle. Use inside
//                grids or any scaling container.
//
// Usage:
//   SDeckProfileCardPlaceholder()
//   SDeckProfileCardPlaceholder(variant: SDeckProfileCardVariant.responsive)
//   SDeckProfileCardPlaceholder(
//     photoUrl: user.photoUrl,
//     scale: user.scale,
//     panX: user.panX,
//     panY: user.panY,
//     rotation: user.rotation,
//     variant: SDeckProfileCardVariant.fixed,
//     size: 48,
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../placeholders/sdeck_visual_placeholder.dart';
import 'profile_card_enums.dart';

//====================== SDeckProfileCardPlaceholder =========================//
class SDeckProfileCardPlaceholder extends StatelessWidget {
  //------------------------------- Properties --------------------------------//

  // Viewport used when profile transforms are saved (edit photo flow).
  static const double _transformReferenceSize = 370.0;

  final SDeckProfileCardVariant variant;

  // Only applies to the fixed variant. The responsive variant ignores this
  // and fills its parent instead.
  final double size;

  // Firebase Storage URL. When null or empty, shows the checkered placeholder.
  final String? photoUrl;

  // Saved profile adjustment values from Firestore users doc.
  final double scale;
  final double panX;
  final double panY;
  final double rotation;

  //------------------------------- Constructor -------------------------------//
  const SDeckProfileCardPlaceholder({
    super.key,
    this.variant = SDeckProfileCardVariant.fixed,
    this.size = 48,
    this.photoUrl,
    this.scale = 1.0,
    this.panX = 0.0,
    this.panY = 0.0,
    this.rotation = 0.0,
  });

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      SDeckProfileCardVariant.fixed => _buildFixed(),
      SDeckProfileCardVariant.responsive => _buildResponsive(),
    };
  }

  //*************************** Variants **************************************//

  Widget _buildFixed() {
    return _buildFramedContent(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24),
    );
  }

  Widget _buildResponsive() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius999),
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final dimension = constraints.maxWidth;
            return _buildContent(width: dimension, height: dimension);
          },
        ),
      ),
    );
  }

  Widget _buildFramedContent({
    required double width,
    required double height,
    required BorderRadius borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: _buildContent(width: width, height: height),
      ),
    );
  }

  Widget _buildContent({required double width, required double height}) {
    final trimmedUrl = photoUrl?.trim();
    final hasPhoto = trimmedUrl != null && trimmedUrl.isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        const SDeckVisualPlaceholder(borderRadius: BorderRadius.zero),
        if (hasPhoto)
          _buildTransformedImage(url: trimmedUrl, width: width, height: height),
      ],
    );
  }

  Widget _buildTransformedImage({
    required String url,
    required double width,
    required double height,
  }) {
    final scaledPanX = panX * (width / _transformReferenceSize);
    final scaledPanY = panY * (height / _transformReferenceSize);

    return ClipRect(
      child: Transform(
        alignment: Alignment.center,
        transform:
            Matrix4.identity()
              ..translate(scaledPanX, scaledPanY)
              ..rotateZ(rotation)
              ..scale(scale),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: width,
          height: height,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
