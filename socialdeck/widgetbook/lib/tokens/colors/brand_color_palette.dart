/*----------------------------- brand_color_palette.dart --------------------------------*/
// Brand Color Palette use cases for Widgetbook
// Displays Brand Color Palette variations with light/dark mode comparison
// Matches design system: lib/design_system/tokens/colors/colors_brand.dart
// Matches Figma: Brand Color Palette
//
// Usage: Shows Brand Color Palette tokens with theme-aware variations
// Each brand color displays Lightest, Light, Base, Dark, and Darkest variations
// with side-by-side Light Mode and Dark Mode values
/*--------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:socialdeck/design_system/tokens/colors/index.dart';
import 'brand_color_display.dart';

/*----------------------------- BrandColorPalette ------------------------------*/
/// Component for displaying Brand Color Palette tokens
/// Shows theme-aware color variations with light/dark mode comparison
/// Matches Figma: Brand Color Palette
class BrandColorPalette {}

/*----------------------------- Use Cases ------------------------------*/
//*************************** Brand Color Palette **********************//

//----------------------------- Bright Coral -------------------------------//
@widgetbook.UseCase(name: 'Bright Coral', type: BrandColorPalette)
Widget buildBrightCoralUseCase(BuildContext context) {
  return BrandColorDisplay(
    brandColorName: 'Bright Coral',
    lightest: SDeckBrandColors.brightCoralLightest,
    light: SDeckBrandColors.brightCoralLight,
    base: SDeckBrandColors.brightCoral,
    dark: SDeckBrandColors.brightCoralDark,
    darkest: SDeckBrandColors.brightCoralDarkest,
  );
}

//----------------------------- Tangerine -----------------------------------//
@widgetbook.UseCase(name: 'Tangerine', type: BrandColorPalette)
Widget buildTangerineUseCase(BuildContext context) {
  return BrandColorDisplay(
    brandColorName: 'Tangerine',
    lightest: SDeckBrandColors.tangerineLightest,
    light: SDeckBrandColors.tangerineLight,
    base: SDeckBrandColors.tangerine,
    dark: SDeckBrandColors.tangerineDark,
    darkest: SDeckBrandColors.tangerineDarkest,
  );
}

//----------------------------- Vibrant Yellow ------------------------------//
@widgetbook.UseCase(name: 'Vibrant Yellow', type: BrandColorPalette)
Widget buildVibrantYellowUseCase(BuildContext context) {
  return BrandColorDisplay(
    brandColorName: 'Vibrant Yellow',
    lightest: SDeckBrandColors.vibrantYellowLightest,
    light: SDeckBrandColors.vibrantYellowLight,
    base: SDeckBrandColors.vibrantYellow,
    dark: SDeckBrandColors.vibrantYellowDark,
    darkest: SDeckBrandColors.vibrantYellowDarkest,
  );
}

//----------------------------- Mint Green -----------------------------------//
@widgetbook.UseCase(name: 'Mint Green', type: BrandColorPalette)
Widget buildMintGreenUseCase(BuildContext context) {
  return BrandColorDisplay(
    brandColorName: 'Mint Green',
    lightest: SDeckBrandColors.mintGreenLightest,
    light: SDeckBrandColors.mintGreenLight,
    base: SDeckBrandColors.mintGreen,
    dark: SDeckBrandColors.mintGreenDark,
    darkest: SDeckBrandColors.mintGreenDarkest,
  );
}

//----------------------------- Sky Blue ------------------------------------//
@widgetbook.UseCase(name: 'Sky Blue', type: BrandColorPalette)
Widget buildSkyBlueUseCase(BuildContext context) {
  return BrandColorDisplay(
    brandColorName: 'Sky Blue',
    lightest: SDeckBrandColors.skyBlueLightest,
    light: SDeckBrandColors.skyBlueLight,
    base: SDeckBrandColors.skyBlue,
    dark: SDeckBrandColors.skyBlueDark,
    darkest: SDeckBrandColors.skyBlueDarkest,
  );
}

//----------------------------- Lavender ------------------------------------//
@widgetbook.UseCase(name: 'Lavender', type: BrandColorPalette)
Widget buildLavenderUseCase(BuildContext context) {
  return BrandColorDisplay(
    brandColorName: 'Lavender',
    lightest: SDeckBrandColors.lavenderLightest,
    light: SDeckBrandColors.lavenderLight,
    base: SDeckBrandColors.lavender,
    dark: SDeckBrandColors.lavenderDark,
    darkest: SDeckBrandColors.lavenderDarkest,
  );
}

//----------------------------- Cool Gray -----------------------------------//
@widgetbook.UseCase(name: 'Cool Gray', type: BrandColorPalette)
Widget buildCoolGrayUseCase(BuildContext context) {
  return BrandColorDisplay(
    brandColorName: 'Cool Gray',
    lightest: SDeckBrandColors.coolGrayLightest,
    light: SDeckBrandColors.coolGrayLight,
    base: SDeckBrandColors.coolGray,
    dark: SDeckBrandColors.coolGrayDark,
    darkest: SDeckBrandColors.coolGrayDarkest,
  );
}

//----------------------------- Warm Off White -------------------------------//
@widgetbook.UseCase(name: 'Warm Off White', type: BrandColorPalette)
Widget buildWarmOffWhiteUseCase(BuildContext context) {
  // Warm Off White only has one variation (same for light/dark)
  return BrandColorDisplay(
    brandColorName: 'Warm Off White',
    lightest: SDeckBrandColors.warmOffWhite,
    light: SDeckBrandColors.warmOffWhite,
    base: SDeckBrandColors.warmOffWhite,
    dark: SDeckBrandColors.warmOffWhite,
    darkest: SDeckBrandColors.warmOffWhite,
  );
}

//----------------------------- Slate Gray -----------------------------------//
@widgetbook.UseCase(name: 'Slate Gray', type: BrandColorPalette)
Widget buildSlateGrayUseCase(BuildContext context) {
  // Slate Gray only has one variation (different for light/dark)
  return BrandColorDisplay(
    brandColorName: 'Slate Gray',
    lightest: SDeckBrandColors.slateGray,
    light: SDeckBrandColors.slateGray,
    base: SDeckBrandColors.slateGray,
    dark: SDeckBrandColors.slateGray,
    darkest: SDeckBrandColors.slateGray,
  );
}
