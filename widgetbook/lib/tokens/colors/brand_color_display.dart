/*----------------------------- brand_color_display.dart --------------------------------*/
// Reusable widget for displaying Brand Color Palette variations in Widgetbook
// Shows all brand color variations (Lightest, Light, base, Dark, Darkest) with
// side-by-side comparison of Light Mode and Dark Mode values
//
// Usage: Pass brand color functions to display theme-aware color variations
/*--------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/tokens/colors/index.dart';
import 'package:socialdeck/design_system/tokens/spacing/index.dart';

/*----------------------------- BrandColorDisplay ------------------------------*/
/// Displays a brand color's variations with light/dark mode comparison
/// Shows each variation (Lightest, Light, base, Dark, Darkest) with
/// side-by-side swatches for Light Mode and Dark Mode values
class BrandColorDisplay extends StatelessWidget {
  const BrandColorDisplay({
    super.key,
    required this.brandColorName,
    required this.lightest,
    required this.light,
    required this.base,
    required this.dark,
    required this.darkest,
  });

  //*************************** Properties **********************************//
  /// The name of the brand color (e.g., "Bright Coral")
  final String brandColorName;

  /// Function that returns the Lightest variation color
  final Color Function(Brightness) lightest;

  /// Function that returns the Light variation color
  final Color Function(Brightness) light;

  /// Function that returns the base/default variation color
  final Color Function(Brightness) base;

  /// Function that returns the Dark variation color
  final Color Function(Brightness) dark;

  /// Function that returns the Darkest variation color
  final Color Function(Brightness) darkest;

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Container(
      //----------------------------- Background -------------------------------//
      // Uses design system surface color (warmOffWhite light, slateGray dark)
      color: context.semantic.surface,
      child: Padding(
        padding: const EdgeInsets.all(SDeckSpace.padding32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //----------------------------- Brand Color Name ---------------------------//
            Text(
              brandColorName,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: context.component.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: SDeckSize.size32),
            //----------------------------- Variations Table ---------------------------//
            _VariationsTable(
              lightest: lightest,
              light: light,
              base: base,
              dark: dark,
              darkest: darkest,
            ),
          ],
        ),
      ),
    );
  }
}

/*----------------------------- _VariationsTable ------------------------------*/
/// Clean table-like layout for brand color variations
class _VariationsTable extends StatelessWidget {
  const _VariationsTable({
    required this.lightest,
    required this.light,
    required this.base,
    required this.dark,
    required this.darkest,
  });

  final Color Function(Brightness) lightest;
  final Color Function(Brightness) light;
  final Color Function(Brightness) base;
  final Color Function(Brightness) dark;
  final Color Function(Brightness) darkest;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //----------------------------- Table Header -----------------------//
        _TableHeader(),
        //----------------------------- Table Rows -----------------------//
        _TableRow(
          variationName: 'Lightest',
          lightModeColor: lightest(Brightness.light),
          darkModeColor: lightest(Brightness.dark),
        ),
        _Divider(),
        _TableRow(
          variationName: 'Light',
          lightModeColor: light(Brightness.light),
          darkModeColor: light(Brightness.dark),
        ),
        _Divider(),
        _TableRow(
          variationName: 'Base',
          lightModeColor: base(Brightness.light),
          darkModeColor: base(Brightness.dark),
        ),
        _Divider(),
        _TableRow(
          variationName: 'Dark',
          lightModeColor: dark(Brightness.light),
          darkModeColor: dark(Brightness.dark),
        ),
        _Divider(),
        _TableRow(
          variationName: 'Darkest',
          lightModeColor: darkest(Brightness.light),
          darkModeColor: darkest(Brightness.dark),
        ),
      ],
    );
  }
}

/*----------------------------- _TableHeader ------------------------------*/
/// Table header row
class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: SDeckSpace.padding16,
        right: SDeckSpace.padding16,
        bottom: SDeckSpace.padding12,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              'Variation',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: context.component.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Light Mode',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: context.component.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              'Dark Mode',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: context.component.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/*----------------------------- _TableRow ------------------------------*/
/// Table row for a single variation
class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.variationName,
    required this.lightModeColor,
    required this.darkModeColor,
  });

  final String variationName;
  final Color lightModeColor;
  final Color darkModeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SDeckSpace.padding16,
        vertical: SDeckSpace.padding24,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //----------------------------- Variation Name -----------------------//
          SizedBox(
            width: 140,
            child: Text(
              variationName,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: context.component.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          //----------------------------- Light Mode Swatch -----------------------//
          Expanded(child: _ColorSwatchDisplay(color: lightModeColor)),
          SizedBox(width: SDeckSize.size24),
          //----------------------------- Dark Mode Swatch -----------------------//
          Expanded(child: _ColorSwatchDisplay(color: darkModeColor)),
        ],
      ),
    );
  }
}

/*----------------------------- _ColorSwatchDisplay ------------------------------*/
/// Clean color swatch with hex value
class _ColorSwatchDisplay extends StatelessWidget {
  const _ColorSwatchDisplay({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final hexValue =
        '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //----------------------------- Color Swatch -----------------------//
        Container(
          width: double.infinity,
          height: 72,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        SizedBox(height: SDeckSize.size12),
        //----------------------------- Hex Value ---------------------------//
        Text(
          hexValue,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontFamily: 'monospace',
            color: context.component.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/*----------------------------- _Divider ------------------------------*/
/// Table row divider
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
      color: context.semantic.outlineVariant.withValues(alpha: 0.3),
    );
  }
}
