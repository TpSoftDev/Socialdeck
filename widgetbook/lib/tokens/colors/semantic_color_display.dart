/*----------------------------- semantic_color_display.dart --------------------------------*/
// Reusable widget for displaying Semantic Color Palette in Widgetbook
// Shows semantic colors organized by their purpose/meaning with light/dark mode comparison
//
// Usage: Displays semantic colors grouped by category
/*--------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/tokens/colors/index.dart';
import 'package:socialdeck/design_system/tokens/spacing/index.dart';

/*----------------------------- SemanticColorItem ------------------------------*/
/// Data class for semantic color item
class SemanticColorItem {
  const SemanticColorItem({
    required this.name,
    required this.lightColor,
    required this.darkColor,
  });

  final String name;
  final Color lightColor;
  final Color darkColor;
}

/*----------------------------- SemanticColorDisplay ------------------------------*/
/// Displays semantic colors organized by category with light/dark mode comparison
class SemanticColorDisplay extends StatelessWidget {
  const SemanticColorDisplay.category({
    super.key,
    required this.categoryName,
    required this.colors,
  });

  final String categoryName;
  final List<SemanticColorItem> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.semantic.surface,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(SDeckSpace.padding32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //----------------------------- Category Name ---------------------------//
              Text(
                categoryName,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: context.component.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: SDeckSize.size32),
              //----------------------------- Colors Table ---------------------------//
              _SemanticColorsTable(colors: colors),
            ],
          ),
        ),
      ),
    );
  }
}

/*----------------------------- _SemanticColorsTable ------------------------------*/
/// Clean table-like layout for semantic colors
class _SemanticColorsTable extends StatelessWidget {
  const _SemanticColorsTable({required this.colors});

  final List<SemanticColorItem> colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //----------------------------- Table Header -----------------------//
        _TableHeader(),
        //----------------------------- Table Rows -----------------------//
        _TableRow(
          colorName: colors[0].name,
          lightModeColor: colors[0].lightColor,
          darkModeColor: colors[0].darkColor,
        ),
        ...colors.skip(1).map(
              (color) => [
                _Divider(),
                _TableRow(
                  colorName: color.name,
                  lightModeColor: color.lightColor,
                  darkModeColor: color.darkColor,
                ),
              ],
            ).expand((x) => x),
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
              'Token',
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
/// Table row for a single semantic color
class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.colorName,
    required this.lightModeColor,
    required this.darkModeColor,
  });

  final String colorName;
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
          //----------------------------- Color Name -----------------------//
          SizedBox(
            width: 140,
            child: Text(
              colorName,
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

