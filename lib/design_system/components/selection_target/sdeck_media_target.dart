/*-------------------------- sdeck_media_target.dart ------------------------*/
// mediaTarget is one photo cell in the Camera Roll grid.
// A selected cell uses the playing-card selected border and the low sky-blue
// outer glow. Unselected cells show the photo only.
//
// Usage:
//   SDeckMediaTarget(
//     image: MemoryImage(bytes),
//     selected: true,
//     corner: SDeckMediaTargetCorner.topRight,
//     onTap: () {},
//   )
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';

import '../../helpers/index.dart';
import '../../tokens/index.dart';
import 'media_target_enums.dart';

//------------------------------- SDeckMediaTarget --------------------------//
class SDeckMediaTarget extends StatelessWidget {
  //------------------------------- Properties --------------------------------//

  /// Photo to show. Null shows the checkered placeholder.
  final ImageProvider? image;

  /// Selected cells draw the sky-blue border and glow.
  final bool selected;

  /// Which outer corner is rounded. Center cells use none.
  final SDeckMediaTargetCorner corner;

  /// Called when the cell is tapped.
  final VoidCallback? onTap;

  //------------------------------- Constructor -------------------------------//
  const SDeckMediaTarget({
    super.key,
    this.image,
    this.selected = false,
    this.corner = SDeckMediaTargetCorner.none,
    this.onTap,
  });

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    final radius = _cornerRadius(corner);
    final borderColor = context.component.playingCardBorderSelected;

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: selected
                ? Border.all(color: borderColor, width: SDeckSize.size4)
                : null,
            boxShadow: selected
                ? SDeckOuterGlows.outerGlowLowSkyBlue(borderColor)
                : null,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: image == null
                ? Image.asset(
                    SDeckIcon.checkeredBackground,
                    fit: BoxFit.cover,
                  )
                : Image(
                    image: image!,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  //*************************** Corner Radius *********************************//
  BorderRadius _cornerRadius(SDeckMediaTargetCorner corner) {
    const radius = Radius.circular(SDeckRadius.borderRadius16);
    switch (corner) {
      case SDeckMediaTargetCorner.topLeft:
        return const BorderRadius.only(topLeft: radius);
      case SDeckMediaTargetCorner.topRight:
        return const BorderRadius.only(topRight: radius);
      case SDeckMediaTargetCorner.bottomLeft:
        return const BorderRadius.only(bottomLeft: radius);
      case SDeckMediaTargetCorner.bottomRight:
        return const BorderRadius.only(bottomRight: radius);
      case SDeckMediaTargetCorner.none:
        return BorderRadius.zero;
    }
  }
}
