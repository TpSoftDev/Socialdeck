/*----------------------------- color_swatch_display.dart --------------------------------*/
// Reusable widget for displaying MaterialColor swatches in Widgetbook
// Shows all shades (50-950) in a row with hex values
//
// Usage: Pass a MaterialColor to display its complete shade scale
/*--------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/tokens/colors/index.dart';

/*----------------------------- ColorSwatchDisplay ------------------------------*/
/// Displays a MaterialColor's complete shade scale (50-950)
/// Shows color swatches in a row with shade numbers and hex values
class ColorSwatchDisplay extends StatelessWidget {
  const ColorSwatchDisplay({
    super.key,
    required this.color,
    required this.colorName,
  });

  //*************************** Properties **********************************//
  /// The MaterialColor to display
  final MaterialColor color;

  /// The name of the color (e.g., "Bright Coral")
  final String colorName;

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    //----------------------------- Shade Keys -------------------------------//
    // All available shade keys in order
    final shadeKeys = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950];

    return Container(
      //----------------------------- Background -------------------------------//
      // Uses design system surface color (warmOffWhite light, slateGray dark)
      color: context.semantic.surface,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //----------------------------- Color Name ---------------------------//
            Text(colorName, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            //----------------------------- Swatch Row ---------------------------//
            Wrap(
              spacing: 8.0,
              runSpacing: 16.0,
              children: shadeKeys.map((shade) {
                final colorValue = color[shade];
                if (colorValue == null) return const SizedBox.shrink();

                return _ColorSwatchItem(color: colorValue, shade: shade);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/*----------------------------- _ColorSwatchItem ------------------------------*/
/// Individual color swatch item showing color, shade number, and hex value
class _ColorSwatchItem extends StatelessWidget {
  const _ColorSwatchItem({required this.color, required this.shade});

  final Color color;
  final int shade;

  @override
  Widget build(BuildContext context) {
    //----------------------------- Hex Value -------------------------------//
    // Use toARGB32() instead of deprecated .value property
    final hexValue =
        '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

    return SizedBox(
      width: 100,
      child: Column(
        children: [
          //----------------------------- Color Square -----------------------//
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: color,
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
          //----------------------------- Shade Number -----------------------//
          Text('$shade', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          //----------------------------- Hex Value ---------------------------//
          Text(
            hexValue,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}
