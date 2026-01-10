/*----------------------------- neutral_base_color_palette.dart --------------------------------*/
// Neutral Base Color Palette use cases for Widgetbook
// Displays Neutral Base Color Palette MaterialColor swatches and single colors
// Matches design system: lib/design_system/tokens/colors/colors_base.dart
// Matches Figma: Neutral Base Color Palette
//
// Usage: Shows Neutral Base Color Palette tokens with their complete shade scales
// Includes grayscale colors and single colors (Black, White)
/*--------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:socialdeck/design_system/tokens/colors/index.dart';
import 'color_swatch_display.dart';

/*----------------------------- NeutralBaseColorPalette ------------------------------*/
/// Component for displaying Neutral Base Color Palette tokens
/// Includes grayscale colors and single colors (Black, White)
/// Matches Figma: Neutral Base Color Palette
class NeutralBaseColorPalette {}

/*----------------------------- Use Cases ------------------------------*/
//*************************** Neutral Base Color Palette **********************//
//----------------------------- Warm Off White -------------------------------//
@widgetbook.UseCase(name: 'Warm Off White', type: NeutralBaseColorPalette)
Widget buildWarmOffWhiteUseCase(BuildContext context) {
  return ColorSwatchDisplay(
    color: SDeckBaseColors.warmOffWhite,
    colorName: 'Warm Off White',
  );
}

//----------------------------- Cool Gray -----------------------------------//
@widgetbook.UseCase(name: 'Cool Gray', type: NeutralBaseColorPalette)
Widget buildCoolGrayUseCase(BuildContext context) {
  return ColorSwatchDisplay(
    color: SDeckBaseColors.coolGray,
    colorName: 'Cool Gray',
  );
}

//----------------------------- Slate Gray -----------------------------------//
@widgetbook.UseCase(name: 'Slate Gray', type: NeutralBaseColorPalette)
Widget buildSlateGrayUseCase(BuildContext context) {
  return ColorSwatchDisplay(
    color: SDeckBaseColors.slateGray,
    colorName: 'Slate Gray',
  );
}

//----------------------------- Black ----------------------------------------//
@widgetbook.UseCase(name: 'Black', type: NeutralBaseColorPalette)
Widget buildBlackUseCase(BuildContext context) {
  // Black is a single Color, not a MaterialColor
  return Container(
    //----------------------------- Background -------------------------------//
    // Uses design system surface color (warmOffWhite light, slateGray dark)
    color: context.semantic.surface,
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Black', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: SDeckBaseColors.black,
                    //----------------------------- Border ---------------------------//
                    // Uses design system outline color (theme-aware)
                    border: Border.all(
                      color: context.semantic.outlineVariant,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '#000000',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

//----------------------------- White ----------------------------------------//
@widgetbook.UseCase(name: 'White', type: NeutralBaseColorPalette)
Widget buildWhiteUseCase(BuildContext context) {
  // White is a single Color, not a MaterialColor
  return Container(
    //----------------------------- Background -------------------------------//
    // Uses design system surface color (warmOffWhite light, slateGray dark)
    color: context.semantic.surface,
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('White', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: SDeckBaseColors.white,
                    //----------------------------- Border ---------------------------//
                    // Uses design system outline color (theme-aware)
                    border: Border.all(
                      color: context.semantic.outlineVariant,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '#FFFFFF',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
