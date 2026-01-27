/*----------------------------- base_color_palette.dart --------------------------------*/
// Base Color Palette use cases for Widgetbook
// Displays Base Color Palette MaterialColor swatches
// Matches design system: lib/design_system/tokens/colors/colors_base.dart
// Matches Figma: Base Color Palette
//
// Usage: Shows Base Color Palette tokens with their complete shade scales.
/*--------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:socialdeck/design_system/tokens/colors/colors_base.dart';
import 'color_swatch_display.dart';

/*----------------------------- BaseColorPalette ------------------------------*/
/// Component for displaying Base Color Palette tokens
/// Each use case shows one color's complete shade scale
/// Matches Figma: Base Color Palette
class BaseColorPalette {}

/*----------------------------- Use Cases ------------------------------*/
//*************************** Base Color Palette **************************//
//----------------------------- Bright Coral -------------------------------//
@widgetbook.UseCase(name: 'Bright Coral', type: BaseColorPalette)
Widget buildBrightCoralUseCase(BuildContext context) {
  return ColorSwatchDisplay(
    color: SDeckBaseColors.brightCoral,
    colorName: 'Bright Coral',
  );
}

//----------------------------- Tangerine -----------------------------------//
@widgetbook.UseCase(name: 'Tangerine', type: BaseColorPalette)
Widget buildTangerineUseCase(BuildContext context) {
  return ColorSwatchDisplay(
    color: SDeckBaseColors.tangerine,
    colorName: 'Tangerine',
  );
}

//----------------------------- Vibrant Yellow ------------------------------//
@widgetbook.UseCase(name: 'Vibrant Yellow', type: BaseColorPalette)
Widget buildVibrantYellowUseCase(BuildContext context) {
  return ColorSwatchDisplay(
    color: SDeckBaseColors.vibrantYellow,
    colorName: 'Vibrant Yellow',
  );
}

//----------------------------- Mint Green -----------------------------------//
@widgetbook.UseCase(name: 'Mint Green', type: BaseColorPalette)
Widget buildMintGreenUseCase(BuildContext context) {
  return ColorSwatchDisplay(
    color: SDeckBaseColors.mintGreen,
    colorName: 'Mint Green',
  );
}

//----------------------------- Sky Blue ------------------------------------//
@widgetbook.UseCase(name: 'Sky Blue', type: BaseColorPalette)
Widget buildSkyBlueUseCase(BuildContext context) {
  return ColorSwatchDisplay(
    color: SDeckBaseColors.skyBlue,
    colorName: 'Sky Blue',
  );
}

//----------------------------- Lavender ------------------------------------//
@widgetbook.UseCase(name: 'Lavender', type: BaseColorPalette)
Widget buildLavenderUseCase(BuildContext context) {
  return ColorSwatchDisplay(
    color: SDeckBaseColors.lavender,
    colorName: 'Lavender',
  );
}

