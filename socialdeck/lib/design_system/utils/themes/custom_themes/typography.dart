//----------------------------- Typography.dart ------------------------------//
// This file defines the typography for the app.
// It includes the font families and styles used in the app.
// It also includes the text styles for the app.
// It is used to ensure that the typography is consistent across the app.
//----------------------------------------------------------------------------//

//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';

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
  TextStyle get caption => labelLarge!;
  TextStyle get footer => labelMedium!;
}

//----------------------------- SDeckTypography ------------------------------//
/// A utility class that provides predefined text themes based on the Figma design.
/// This ensures typography consistency throughout the app and makes it easier
/// to maintain the design system.

class SDeckTypography {
  SDeckTypography._(); // Private constructor to prevent instantiation

  //*************************** Light Text Themes *******************************/
  static TextTheme lightTextTheme = TextTheme(
    //------------------------------- H1 ----------------------------------------//
    displayLarge: const TextStyle().copyWith(
      fontSize: 60,
      fontWeight: FontWeight.bold,
      height: 88 / 60,
      color: Colors.black, // Primary heading color for light theme
    ),

    //------------------------------- H2 ----------------------------------------//
    displayMedium: const TextStyle().copyWith(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      height: 72 / 48,
      color: Colors.black,
    ),

    //------------------------------- H3 ----------------------------------------//
    displaySmall: const TextStyle().copyWith(
      fontSize: 40,
      fontWeight: FontWeight.w600, //Semi Bold to match Figma
      height: 60 / 40,
      color: Colors.black,
    ),

    //------------------------------- H4 ----------------------------------------//
    headlineLarge: const TextStyle().copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w600, //Semi Bold to match Figma
      height: 48 / 32,
      color: Colors.black,
    ),

    //------------------------------- H5 ----------------------------------------//
    headlineMedium: const TextStyle().copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w600, //Semi Bold
      height: 40 / 28,
      color: Colors.black,
    ),

    //------------------------------- H6 ----------------------------------------//
    headlineSmall: const TextStyle().copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 36 / 24,
      color: Colors.black,
    ),

    //------------------------------- Body --------------------------------------//
    bodyLarge: const TextStyle().copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 24 / 18,
      letterSpacing: 0,
      color: Colors.black,
    ),

    //------------------------------- Body Medium --------------------------------//
    bodyMedium: const TextStyle().copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600, //Semi Bold to match Figma
      height: 24 / 16,
      letterSpacing: 0,
      color: Colors.black,
    ),

    //------------------------------- Body Small ---------------------------------//
    bodySmall: const TextStyle().copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600, //Semi Bold to match Figma
      height: 24 / 14,
      letterSpacing: 0,
      color: Colors.black,
    ),

    //-------------------------------- Caption -----------------------------------//
    labelLarge: const TextStyle().copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500, //Medium
      height: 20 / 14,
      letterSpacing: 0,
      color: Colors.black87, // Slightly lower opacity for secondary text
    ),

    //------------------------------- Footer -------------------------------------//
    labelMedium: const TextStyle().copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 18 / 12,
      letterSpacing: 0,
      color: Colors.black87, // Slightly lower opacity for tertiary text
    ),
  );

  //*************************** Dark Text Themes ********************************/
  static TextTheme darkTextTheme = TextTheme(
    //------------------------------- H1 -----------------------------------------//
    displayLarge: const TextStyle().copyWith(
      fontSize: 60,
      fontWeight: FontWeight.bold,
      height: 88 / 60,
      color: Colors.white, // Primary heading color for dark theme
    ),

    //------------------------------- H2 -----------------------------------------//
    displayMedium: const TextStyle().copyWith(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      height: 72 / 48,
      color: Colors.white,
    ),

    //------------------------------- H3 -----------------------------------------//
    displaySmall: const TextStyle().copyWith(
      fontSize: 40,
      fontWeight: FontWeight.w600, //Semi Bold to match Figma
      height: 60 / 40,
      color: Colors.white,
    ),

    //------------------------------- H4 -----------------------------------------//
    headlineLarge: const TextStyle().copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w600, //Semi Bold to match Figma
      height: 48 / 32,
      color: Colors.white,
    ),

    //------------------------------- H5 -----------------------------------------//
    headlineMedium: const TextStyle().copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w600, //Semi Bold
      height: 40 / 28,
      color: Colors.white,
    ),

    //------------------------------- H6 -----------------------------------------//
    headlineSmall: const TextStyle().copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 36 / 24,
      color: Colors.white,
    ),

    //------------------------------- Body --------------------------------------//
    bodyLarge: const TextStyle().copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 24 / 18,
      letterSpacing: 0,
      color: Colors.white,
    ),

    //------------------------------- Body Medium --------------------------------//
    bodyMedium: const TextStyle().copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600, //Semi Bold to match Figma
      height: 24 / 16,
      letterSpacing: 0,
      color: Colors.white,
    ),

    //------------------------------- Body Small ---------------------------------//
    bodySmall: const TextStyle().copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600, //Semi Bold to match Figma
      height: 24 / 14,
      letterSpacing: 0,
      color: Colors.white,
    ),

    //-------------------------------- Caption -----------------------------------//
    labelLarge: const TextStyle().copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500, //Medium
      height: 20 / 14,
      letterSpacing: 0,
      color: Colors.white70, // Slightly lower opacity for secondary text
    ),

    //-------------------------------- Footer ------------------------------------//
    labelMedium: const TextStyle().copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 18 / 12,
      letterSpacing: 0,
      color: Colors.white70, // Slightly lower opacity for tertiary text
    ),
  );
}
