/*------------------- sdeck_profile_card_placeholder.dart -------------------*/
// Static stand-in for the profileCard Rive animation. Will be swapped out
// once the Rive component is ready.
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
//   SDeckProfileCardPlaceholder(size: 96)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../placeholders/sdeck_visual_placeholder.dart';
import 'profile_card_enums.dart';

//====================== SDeckProfileCardPlaceholder =========================//
class SDeckProfileCardPlaceholder extends StatelessWidget {
  //------------------------------- Properties --------------------------------//

  final SDeckProfileCardVariant variant;

  /// Only applies to the fixed variant. The responsive variant ignores this
  /// and fills its parent instead.
  final double size;

  //------------------------------- Constructor -------------------------------//
  const SDeckProfileCardPlaceholder({
    super.key,
    this.variant = SDeckProfileCardVariant.fixed,
    this.size = 48,
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24),
      child: SizedBox(
        width: size,
        height: size,
        child: const SDeckVisualPlaceholder(),
      ),
    );
  }

  Widget _buildResponsive() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius999),
      child: const AspectRatio(
        aspectRatio: 1,
        child: SDeckVisualPlaceholder(),
      ),
    );
  }
}
