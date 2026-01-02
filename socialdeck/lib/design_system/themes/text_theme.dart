/*----------------------------- text_theme.dart ------------------------------*/
// Text theme definitions for the app
// Builds TextTheme objects from typography tokens
// Matches Figma: Text Styles (H1-H6, Body Large/Medium/Small, Caption, Label Large/Small)
//
// IMPORTANT: This TextTheme defines typography only (fontSize, fontWeight, height, letterSpacing).
// Colors are handled by components using semantic colors from ThemeExtensions.
//----------------------------------------------------------------------------//

//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';
import '../tokens/typography/index.dart';

//----------------------------- SDeckTextTheme ------------------------------//
/// Utility class that provides predefined text themes based on the Figma design.
///
/// This theme defines typography properties only. Components must explicitly
/// apply semantic colors using ThemeExtensions (e.g., context.semantic.onPrimary, context.semantic.onSurface).
class SDeckTextTheme {
  SDeckTextTheme._(); // Private constructor

  //*************************** Consolidated Text Theme **************************/
  /// Single TextTheme for both light and dark modes.
  /// Colors are handled by components using semantic colors from ThemeExtensions.
  static TextTheme get theme => TextTheme(
    //------------------------------- H1 ----------------------------------------//
    // Matches Figma: H1 - Bold (700), Font Size: 64px, Line Height: 80px
    displayLarge: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.h1,
      fontWeight: SDeckFontWeights.bold,
      height: SDeckLineHeights.h1 / SDeckFontSizes.h1,
      letterSpacing: 0, // Matches Figma: letterSpacing: 0
      // Color handled by components using semantic colors
    ),

    //------------------------------- H2 ----------------------------------------//
    // Matches Figma: H2 - Bold (700), Font Size: 48px, Line Height: 60px
    displayMedium: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.h2,
      fontWeight: SDeckFontWeights.bold,
      height: SDeckLineHeights.h2 / SDeckFontSizes.h2,
      letterSpacing: 0, // Matches Figma: letterSpacing: 0
      // Color handled by components using semantic colors
    ),

    //------------------------------- H3 ----------------------------------------//
    // Matches Figma: H3 - SemiBold (600), Font Size: 40px, Line Height: 48px
    displaySmall: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.h3,
      fontWeight: SDeckFontWeights.semiBold,
      height: SDeckLineHeights.h3 / SDeckFontSizes.h3,
      letterSpacing: 0, // Matches Figma: letterSpacing: 0
      // Color handled by components using semantic colors
    ),

    //------------------------------- H4 ----------------------------------------//
    // Matches Figma: H4 - SemiBold (600), Font Size: 32px, Line Height: 40px
    headlineLarge: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.h4,
      fontWeight: SDeckFontWeights.semiBold,
      height: SDeckLineHeights.h4 / SDeckFontSizes.h4,
      letterSpacing: 0, // Matches Figma: letterSpacing: 0
      // Color handled by components using semantic colors
    ),

    //------------------------------- H5 ----------------------------------------//
    // Matches Figma: H5 - SemiBold (600), Font Size: 28px, Line Height: 36px
    headlineMedium: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.h5,
      fontWeight: SDeckFontWeights.semiBold,
      height: SDeckLineHeights.h5 / SDeckFontSizes.h5,
      letterSpacing: 0, // Matches Figma: letterSpacing: 0
      // Color handled by components using semantic colors
    ),

    //------------------------------- H6 ----------------------------------------//
    // Matches Figma: H6 - SemiBold (600), Font Size: 24px, Line Height: 30px
    headlineSmall: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.h6,
      fontWeight: SDeckFontWeights.semiBold,
      height: SDeckLineHeights.h6 / SDeckFontSizes.h6,
      letterSpacing: 0, // Matches Figma: letterSpacing: 0
      // Color handled by components using semantic colors
    ),

    //------------------------------- Body Large --------------------------------//
    // Matches Figma: Body Large - Medium (500), Font Size: 20px, Line Height: 24px
    bodyLarge: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.bodyLarge,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.bodyLarge / SDeckFontSizes.bodyLarge,
      letterSpacing: 0, // Matches Figma: letterSpacing: 0
      // Color handled by components using semantic colors
    ),

    //------------------------------- Body Medium --------------------------------//
    // Matches Figma: Body Medium - Medium (500), Font Size: 18px, Line Height: 22px
    bodyMedium: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.bodyMedium,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.bodyMedium / SDeckFontSizes.bodyMedium,
      letterSpacing: 0, // Matches Figma: letterSpacing: 0
      // Color handled by components using semantic colors
    ),

    //------------------------------- Body Small ---------------------------------//
    // Matches Figma: Body Small - Medium (500), Font Size: 16px, Line Height: 20px
    bodySmall: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.bodySmall,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.bodySmall / SDeckFontSizes.bodySmall,
      letterSpacing: 0, // Matches Figma: letterSpacing: 0
      // Color handled by components using semantic colors
    ),

    //-------------------------------- Caption -----------------------------------//
    // Matches Figma: Caption - Medium (500), Font Size: 14px, Line Height: 18px
    labelLarge: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.caption,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.caption / SDeckFontSizes.caption,
      letterSpacing: 0, // Matches Figma: letterSpacing: 0
      // Color handled by components using semantic colors
    ),

    //------------------------------- Label Large ---------------------------------//
    // Matches Figma: Label Large - Medium (500), Font Size: 14px, Line Height: 18px
    titleSmall: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.labelLarge,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.labelLarge / SDeckFontSizes.labelLarge,
      letterSpacing: 0, // Matches Figma: letterSpacing: 0
      // Color handled by components using semantic colors
    ),

    //------------------------------- Label Small (Footer) -----------------------//
    // Matches Figma: Label Small - Medium (500), Font Size: 12px, Line Height: 16px
    labelMedium: const TextStyle().copyWith(
      fontFamily: SDeckFontFamily.poppins,
      fontSize: SDeckFontSizes.labelSmall,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.labelSmall / SDeckFontSizes.labelSmall,
      letterSpacing: 0, // Matches Figma: letterSpacing: 0
      // Color handled by components using semantic colors
    ),
  );
}

/*----------------------------- FigmaTextTheme ------------------------------*/
// Extension to add Figma naming to Flutter's TextTheme
extension FigmaTextTheme on TextTheme {
  TextStyle get h1 => displayLarge!;
  TextStyle get h2 => displayMedium!;
  TextStyle get h3 => displaySmall!;
  TextStyle get h4 => headlineLarge!;
  TextStyle get h5 => headlineMedium!;
  TextStyle get h6 => headlineSmall!;
  TextStyle get body => bodyLarge!;
  TextStyle get bodyMediumFigma => bodyMedium!; // Non-recursive version
  TextStyle get bodySmallFigma => bodySmall!; // Non-recursive version
  TextStyle get caption => labelLarge; // Maps to Caption style (14px, Medium, 18px line height)
  TextStyle get labelLarge => titleSmall!; // Maps to Label Large style (14px, Medium, 18px line height)
  TextStyle get footer => labelMedium!; // Maps to Label Small style (12px, Medium, 16px line height)
}
