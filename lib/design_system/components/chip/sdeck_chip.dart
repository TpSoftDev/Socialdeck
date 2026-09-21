/*------------------------------ sdeck_chip.dart -----------------------------*/
// Chip component — a small pill holding a single label on a solid brand fill.
// Used to surface short, non-interactive tags such as the play styles a party
// was built from.
//
// Usage:
//   SDeckChip(label: 'Coworkers')
//   SDeckChip(label: 'Dark Humor', color: SDeckChipColor.mintGreen)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../themes/text_theme.dart';
import '../../tokens/index.dart';

//============================== SDeckChipColor ==============================//
// The closed set of brand fills a chip can take. Order matches Figma left to
// right and mirrors SDeckColorPickerColor.
enum SDeckChipColor {
  brightCoral,
  tangerine,
  vibrantYellow,
  mintGreen,
  skyBlue,
  lavender,
  coolGray,
  inverse,
}

//================================= SDeckChip ================================//
class SDeckChip extends StatelessWidget {
  //------------------------------- Properties -------------------------------//

  /// Text shown inside the pill. Truncates rather than wrapping, since the
  /// chip is meant to stay a single line.
  final String label;

  final SDeckChipColor color;

  //------------------------------- Constructor ------------------------------//
  const SDeckChip({
    super.key,
    required this.label,
    this.color = SDeckChipColor.tangerine,
  });

  //*************************** Build *****************************************//
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SDeckSpace.padding12,
        vertical: SDeckSpace.padding4,
      ),
      decoration: BoxDecoration(
        color: _resolveSurface(context),
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius12),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.footer.copyWith(
              color: context.semantic.onPrimary,
            ),
      ),
    );
  }

  //*************************** Helper Methods ********************************//
  Color _resolveSurface(BuildContext context) {
    // Tangerine has no semantic alias yet, so it comes straight off the brand
    // palette the way the color picker resolves it.
    final Brightness brightness = Theme.of(context).brightness;
    return switch (color) {
      SDeckChipColor.brightCoral => context.semantic.error,
      SDeckChipColor.tangerine => SDeckBrandColors.tangerine(brightness),
      SDeckChipColor.vibrantYellow => context.semantic.warning,
      SDeckChipColor.mintGreen => context.semantic.success,
      SDeckChipColor.skyBlue => context.semantic.info,
      SDeckChipColor.lavender => context.semantic.link,
      SDeckChipColor.coolGray => context.semantic.secondaryVariant,
      SDeckChipColor.inverse => context.semantic.surfaceInverse,
    };
  }
}
