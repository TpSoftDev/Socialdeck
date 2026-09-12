/*----------------------- sdeck_visual_placeholder.dart ---------------------*/
// Figma-style media placeholder: neutral fill with checkered overlay.
// Use [heightForGridRow] when the height should match one row of an N-column grid.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../tokens/index.dart';
import '../../helpers/index.dart';

//--------------------------- SDeckVisualPlaceholder ------------------------//
class SDeckVisualPlaceholder extends StatelessWidget {
  const SDeckVisualPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  /// When null, expands to the maximum width of the parent (e.g. column).
  final double? width;

  /// When null, expands to fill the parent's height constraint.
  /// Wrap with [AspectRatio] or [SizedBox] to control the height responsively.
  final double? height;

  /// Defaults to [SDeckRadius.borderRadius16].
  final BorderRadius? borderRadius;

  /// Height of one row when the content width is split into [columnCount] equal
  /// columns (e.g. Figma 1×4 strip: [columnCount] = 4).
  static double heightForGridRow(
    BuildContext context, {
    double horizontalMargin = SDeckSpace.margin16,
    int columnCount = 4,
  }) {
    final w = MediaQuery.sizeOf(context).width - (2 * horizontalMargin);
    return w / columnCount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius:
            borderRadius ?? BorderRadius.circular(SDeckRadius.borderRadius16),
        color: context.semantic.surfaceVariant,
        image: const DecorationImage(
          image: AssetImage(SDeckIcon.checkeredBackground),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
