/*----------------------------- text_theme.dart ---------------------------------*/
// Text theme definitions build TextTheme objects from typography tokens, creating
// reusable typography rules that set hierarchy, font family, and sizing. They ensure
// consistency across components by applying the same visual system to headings,
// body text, and captions.
//
// This TextTheme defines typography only (fontSize, fontWeight, height, letterSpacing).
// Colors are handled by components using semantic colors from ThemeExtensions.
//
// Usage:
//   Theme.of(context).textTheme.h1
//   context.textTheme.h4
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import '../tokens/typography/index.dart';

//------------------------------- SDeckTextTheme ------------------------------//
class SDeckTextTheme {
  SDeckTextTheme._();

  //*************************** Text Theme **********************************//
  /// Single TextTheme for both light and dark modes.
  /// Colors are handled by components using semantic colors from ThemeExtensions.
  static TextTheme get theme => TextTheme(
    //------------------------------- H1 ----------------------------------------//
    displayLarge: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.h1,
      fontWeight: SDeckFontWeights.bold,
      height: SDeckLineHeights.h1 / SDeckFontSizes.h1,
      letterSpacing: 0,
    ),

    //------------------------------- H2 ----------------------------------------//
    displayMedium: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.h2,
      fontWeight: SDeckFontWeights.bold,
      height: SDeckLineHeights.h2 / SDeckFontSizes.h2,
      letterSpacing: 0,
    ),

    //------------------------------- H3 ----------------------------------------//
    displaySmall: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.h3,
      fontWeight: SDeckFontWeights.semiBold,
      height: SDeckLineHeights.h3 / SDeckFontSizes.h3,
      letterSpacing: 0,
    ),

    //------------------------------- H4 ----------------------------------------//
    headlineLarge: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.h4,
      fontWeight: SDeckFontWeights.semiBold,
      height: SDeckLineHeights.h4 / SDeckFontSizes.h4,
      letterSpacing: 0,
    ),

    //------------------------------- H5 ----------------------------------------//
    headlineMedium: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.h5,
      fontWeight: SDeckFontWeights.semiBold,
      height: SDeckLineHeights.h5 / SDeckFontSizes.h5,
      letterSpacing: 0,
    ),

    //------------------------------- H6 ----------------------------------------//
    headlineSmall: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.h6,
      fontWeight: SDeckFontWeights.semiBold,
      height: SDeckLineHeights.h6 / SDeckFontSizes.h6,
      letterSpacing: 0,
    ),

    //------------------------------- Body Large --------------------------------//
    bodyLarge: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.bodyLarge,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.bodyLarge / SDeckFontSizes.bodyLarge,
      letterSpacing: 0,
    ),

    //------------------------------- Body Medium --------------------------------//
    bodyMedium: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.bodyMedium,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.bodyMedium / SDeckFontSizes.bodyMedium,
      letterSpacing: 0,
    ),

    //------------------------------- Body Small ---------------------------------//
    bodySmall: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.bodySmall,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.bodySmall / SDeckFontSizes.bodySmall,
      letterSpacing: 0,
    ),

    //-------------------------------- Caption -----------------------------------//
    labelLarge: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.caption,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.caption / SDeckFontSizes.caption,
      letterSpacing: 0,
    ),

    //------------------------------- Label Large ---------------------------------//
    titleSmall: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.labelLarge,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.labelLarge / SDeckFontSizes.labelLarge,
      letterSpacing: 0,
    ),

    //------------------------------- Label Small --------------------------------//
    labelMedium: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.labelSmall,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.labelSmall / SDeckFontSizes.labelSmall,
      letterSpacing: 0,
    ),
  );
}

//------------------------------- FigmaTextTheme Extension ------------------------------//
/// Extension to add Figma naming conventions to Flutter's TextTheme.
/// Provides convenient accessors that map Figma text style names to Flutter's
/// TextTheme properties.
extension FigmaTextTheme on TextTheme {
  TextStyle get h1 => displayLarge!;
  TextStyle get h2 => displayMedium!;
  TextStyle get h3 => displaySmall!;
  TextStyle get h4 => headlineLarge!;
  TextStyle get h5 => headlineMedium!;
  TextStyle get h6 => headlineSmall!;
  TextStyle get body => bodyLarge!;
  TextStyle get bodyMediumFigma => bodyMedium!;
  TextStyle get bodySmallFigma => bodySmall!;
  TextStyle get caption => labelLarge;
  TextStyle get labelLarge => titleSmall!;
  TextStyle get footer => labelMedium!;
}
