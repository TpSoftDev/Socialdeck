/*----------------------------- app_colors.dart -----------------------------*/
// A collection of color constants used throughout the application.
// These colors are derived from the Figma design system and provide
// consistent theming across the app.
//
// USAGE GUIDE:
// 1. Static Helpers: Use when you don't have BuildContext or want fixed colors
//    Example: SDeckAppColors.success
//
// 2. Theme-Aware Extensions: Use when you want automatic light/dark mode
//    Example: Theme.of(context).colorScheme.success
/*----------------------------------------------------------------------------*/

//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';
import 'color_palette.dart';

class SDeckAppColors {
  SDeckAppColors._(); // Private constructor to prevent instantiation

  //*************************** Flutter ColorSchemes **************************//
  //
  // PRIMARY/SECONDARY COLOR RATIONALE:
  // Based on analysis of actual onboarding screens, most primary buttons use
  // Cool Gray (#1F1F1F), not Sky Blue. Sky Blue is used for info messages,
  // and Mint Green is used for success states. Therefore:
  // - PRIMARY: Cool Gray (matches actual button usage)
  // - SECONDARY: Lighter Cool Gray (for secondary actions like "No, go back")
  // - Semantic colors (success, info, warning) remain available via extensions
  //

  //------------------------------- Light Theme -----------------------------//
  static final lightTheme = ColorScheme(
    brightness: Brightness.light,

    //------------------------------- Primary Colors -------------------------//
    primary: SDeckColorPalette.coolGray[700]!,
    onPrimary: Colors.white,
    primaryContainer: SDeckColorPalette.coolGray[50]!,
    onPrimaryContainer: SDeckColorPalette.coolGray[950]!,

    //------------------------------- Secondary Colors -----------------------//
    secondary: SDeckColorPalette.coolGray[500]!,
    onSecondary: Colors.white,
    secondaryContainer: SDeckColorPalette.coolGray[50]!,
    onSecondaryContainer: SDeckColorPalette.coolGray[950]!,

    //------------------------------- Error Colors ---------------------------//
    error: SDeckColorPalette.brightCoral[500]!,
    onError: Colors.white,
    errorContainer: SDeckColorPalette.brightCoral[50]!,
    onErrorContainer: SDeckColorPalette.brightCoral[950]!,

    //------------------------------- Background Colors ---------------------//
    surface: SDeckColorPalette.warmOffWhite[500]!,
    onSurface: SDeckColorPalette.coolGray[700]!,
    surfaceContainerHighest: SDeckColorPalette.coolGray[50]!,
    onSurfaceVariant: SDeckColorPalette.coolGray[500]!,

    //------------------------------- Outline Colors ------------------------//
    outline: SDeckColorPalette.coolGray[300]!,
    outlineVariant: SDeckColorPalette.coolGray[100]!,
  );

  //------------------------------- Dark Theme ---------------------------------//
  static final darkTheme = ColorScheme(
    brightness: Brightness.dark,

    //------------------------------- Primary Colors -------------------------//
    primary: SDeckColorPalette.coolGray[300]!,
    onPrimary: SDeckColorPalette.coolGray[950]!,
    primaryContainer: SDeckColorPalette.coolGray[800]!,
    onPrimaryContainer: SDeckColorPalette.coolGray[50]!,

    //------------------------------- Secondary Colors -----------------------//
    secondary: SDeckColorPalette.coolGray[400]!,
    onSecondary: SDeckColorPalette.coolGray[950]!,
    secondaryContainer: SDeckColorPalette.coolGray[800]!,
    onSecondaryContainer: SDeckColorPalette.coolGray[50]!,

    //------------------------------- Error Colors ---------------------------//
    error: SDeckColorPalette.brightCoral[500]!,
    onError: SDeckColorPalette.brightCoral[950]!,
    errorContainer: SDeckColorPalette.brightCoral[900]!,
    onErrorContainer: SDeckColorPalette.brightCoral[50]!,

    //------------------------------- Background Colors ---------------------//
    surface: SDeckColorPalette.slateGray[500]!,
    onSurface: SDeckColorPalette.coolGray[50]!,
    surfaceContainerHighest: SDeckColorPalette.slateGray[800]!,
    onSurfaceVariant: SDeckColorPalette.coolGray[500]!,

    //------------------------------- Outline Colors ------------------------//
    outline: SDeckColorPalette.coolGray[700]!,
    outlineVariant: SDeckColorPalette.coolGray[800]!,
  );

  //****************** Static Color Helpers (Non-Theme-Aware) ******************//
  // Use these when you don't have BuildContext or want fixed colors
  // Example: SDeckAppColors.success, SDeckAppColors.textPrimary

  //------------------------------- Semantic Colors ------------------------//
  static Color get success => SDeckColorPalette.mintGreen[500]!;
  static Color get successLight => SDeckColorPalette.mintGreen[50]!;
  static Color get successDark => SDeckColorPalette.mintGreen[900]!;

  static Color get warning => SDeckColorPalette.vibrantYellow[500]!;
  static Color get warningLight => SDeckColorPalette.vibrantYellow[50]!;
  static Color get warningDark => SDeckColorPalette.vibrantYellow[900]!;

  static Color get info => SDeckColorPalette.skyBlue[500]!;
  static Color get infoLight => SDeckColorPalette.skyBlue[50]!;
  static Color get infoDark => SDeckColorPalette.skyBlue[900]!;

  static Color get links => SDeckColorPalette.lavender[500]!;
  static Color get linksLight => SDeckColorPalette.lavender[50]!;
  static Color get linksDark => SDeckColorPalette.lavender[900]!;

  static Color get tangerine => SDeckColorPalette.tangerine[500]!;
  static Color get tangerineLight => SDeckColorPalette.tangerine[50]!;
  static Color get tangerineDark => SDeckColorPalette.tangerine[900]!;

  //------------------------------- Background Colors ---------------------//
  static Color get backgroundLight => SDeckColorPalette.warmOffWhite[500]!;
  static Color get backgroundLighter => SDeckColorPalette.warmOffWhite[50]!;
  static Color get backgroundDark => SDeckColorPalette.slateGray[500]!;
  static Color get backgroundDarker => SDeckColorPalette.slateGray[800]!;

  //------------------------------- Text Colors ----------------------------//
  static Color get textPrimary => SDeckColorPalette.coolGray[700]!;
  static Color get textSecondary => SDeckColorPalette.coolGray[500]!;
  static Color get textTertiary => SDeckColorPalette.coolGray[300]!;
  static Color get textLight => SDeckColorPalette.coolGray[50]!;
  static Color get textDark => SDeckColorPalette.coolGray[900]!;

  //------------------------------- Border Colors -------------------------//
  static Color get borderLight => SDeckColorPalette.coolGray[100]!;
  static Color get borderMedium => SDeckColorPalette.coolGray[300]!;
  static Color get borderDark => SDeckColorPalette.coolGray[700]!;
}

//*************** Theme-Aware Color Extensions (Auto Light/Dark) *************//
// Use these when you want automatic light/dark mode switching
// Example: Theme.of(context).colorScheme.success

extension SDeckColorScheme on ColorScheme {
  //------------------------------- Semantic Colors ------------------------//
  Color get success => SDeckColorPalette.mintGreen[500]!;

  Color get onSuccess => Colors.white;

  Color get successContainer =>
      brightness == Brightness.light
          ? SDeckColorPalette.mintGreen[50]!
          : SDeckColorPalette.mintGreen[900]!;

  Color get warning => SDeckColorPalette.vibrantYellow[500]!;

  Color get onWarning => Colors.black;

  Color get warningContainer =>
      brightness == Brightness.light
          ? SDeckColorPalette.vibrantYellow[50]!
          : SDeckColorPalette.vibrantYellow[900]!;

  Color get info => SDeckColorPalette.skyBlue[500]!;

  Color get onInfo => Colors.white;

  Color get infoContainer =>
      brightness == Brightness.light
          ? SDeckColorPalette.skyBlue[50]!
          : SDeckColorPalette.skyBlue[900]!;

  Color get links => SDeckColorPalette.lavender[500]!;

  Color get onLinks => Colors.white;

  Color get linksContainer =>
      brightness == Brightness.light
          ? SDeckColorPalette.lavender[50]!
          : SDeckColorPalette.lavender[900]!;

  Color get tangerine => SDeckColorPalette.tangerine[500]!;

  Color get onTangerine => Colors.white;

  Color get tangerineContainer =>
      brightness == Brightness.light
          ? SDeckColorPalette.tangerine[50]!
          : SDeckColorPalette.tangerine[900]!;

  //------------------------------- Background Colors ---------------------//
  Color get backgroundPrimary =>
      brightness == Brightness.light
          ? SDeckColorPalette.warmOffWhite[500]!
          : SDeckColorPalette.slateGray[500]!;

  Color get backgroundSecondary =>
      brightness == Brightness.light
          ? SDeckColorPalette.warmOffWhite[50]!
          : SDeckColorPalette.slateGray[800]!;

  Color get backgroundTertiary =>
      brightness == Brightness.light
          ? SDeckColorPalette.coolGray[50]!
          : SDeckColorPalette.slateGray[900]!;

  //------------------------------- Text Colors ----------------------------//
  Color get textPrimary =>
      brightness == Brightness.light
          ? SDeckColorPalette.coolGray[700]!
          : SDeckColorPalette.coolGray[50]!;

  Color get textSecondary =>
      brightness == Brightness.light
          ? SDeckColorPalette.coolGray[500]!
          : SDeckColorPalette.coolGray[300]!;

  Color get textTertiary =>
      brightness == Brightness.light
          ? SDeckColorPalette.coolGray[300]!
          : SDeckColorPalette.coolGray[500]!;

  //------------------------------- Border Colors -------------------------//
  Color get borderPrimary =>
      brightness == Brightness.light
          ? SDeckColorPalette.coolGray[300]!
          : SDeckColorPalette.coolGray[700]!;

  Color get borderSecondary =>
      brightness == Brightness.light
          ? SDeckColorPalette.coolGray[100]!
          : SDeckColorPalette.coolGray[800]!;

  Color get borderTertiary =>
      brightness == Brightness.light
          ? SDeckColorPalette.coolGray[50]!
          : SDeckColorPalette.coolGray[900]!;
}
