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

  //*************************** In-House Theme ColorSchemes ********************//
  //
  // IN-HOUSE THEME RATIONALE:
  // The in-house theme serves as the default professional theme for the app.
  // Uses Cool Gray as primary colors with carefully selected semantic colors
  // for consistent user experience across home, settings, and profile screens.
  //

  //------------------------------- In-House Light Theme -------------------//
  static final inHouseLightTheme = ColorScheme(
    brightness: Brightness.light,

    //------------------------------- Primary Colors -------------------------//
    primary: SDeckColorPalette.coolGray[900]!, // 1F1F1F
    onPrimary: SDeckColorPalette.warmOffWhite[50]!, // FFFFFF
    primaryContainer: SDeckColorPalette.coolGray[300]!, // C4C4C4
    onPrimaryContainer: SDeckColorPalette.coolGray[900]!, // 1F1F1F
    //------------------------------- Secondary Colors -----------------------//
    secondary: SDeckColorPalette.coolGray[100]!, // EBEBEB
    onSecondary: SDeckColorPalette.coolGray[900]!, // 1F1F1F
    secondaryContainer: SDeckColorPalette.coolGray[100]!, // EBEBEB
    onSecondaryContainer: SDeckColorPalette.coolGray[900]!, // 1F1F1F
    //------------------------------- Tertiary Colors ------------------------//
    tertiary: SDeckColorPalette.warmOffWhite[50]!, // FFFFFF
    onTertiary: SDeckColorPalette.slateGray[500]!, // 1B2838
    tertiaryContainer: SDeckColorPalette.warmOffWhite[50]!, // FFFFFF
    onTertiaryContainer: SDeckColorPalette.coolGray[900]!, // 1F1F1F
    //------------------------------- Error Colors ---------------------------//
    error: SDeckColorPalette.brightCoral[600]!, // FF2C1A
    onError: SDeckColorPalette.brightCoral[100]!, // FFE3E0
    errorContainer: SDeckColorPalette.brightCoral[100]!, // FFE3E0
    onErrorContainer: SDeckColorPalette.brightCoral[950]!, // 240300
    //------------------------------- Surface Colors ------------------------//
    surface: SDeckColorPalette.warmOffWhite[300]!, 
    onSurface: SDeckColorPalette.coolGray[900]!, // 1F1F1F
    surfaceDim: SDeckColorPalette.coolGray[500]!, // 9E9E9E
    surfaceBright: SDeckColorPalette.coolGray[100]!, // EBEBEB
    surfaceContainerLowest: SDeckColorPalette.warmOffWhite[50]!, // FFFFFF
    surfaceContainerLow: SDeckColorPalette.coolGray[100]!, // EBEBEB
    surfaceContainer: SDeckColorPalette.coolGray[300]!, // C4C4C4
    surfaceContainerHigh: SDeckColorPalette.coolGray[200]!, // D9D9D9
    surfaceContainerHighest: SDeckColorPalette.coolGray[100]!, // EBEBEB
    onSurfaceVariant: SDeckColorPalette.coolGray[300]!, // C4C4C4
    //------------------------------- Outline Colors ------------------------//
    outline: SDeckColorPalette.coolGray[900]!, // 1F1F1F
    outlineVariant: SDeckColorPalette.coolGray[300]!, // C4C4C4
    //------------------------------- Utility Colors ------------------------//
    shadow: SDeckColorPalette.coolGray[900]!, // 1F1F1F
    scrim: SDeckColorPalette.warmOffWhite[50]!, // FFFFFF
    inverseSurface: SDeckColorPalette.coolGray[900]!, // 1F1F1F
    onInverseSurface: SDeckColorPalette.coolGray[100]!, // EBEBEB
    inversePrimary: SDeckColorPalette.warmOffWhite[50]!, // FFFFFF
    surfaceTint: SDeckColorPalette.coolGray[100]!, // EBEBEB
  );

  //------------------------------- In-House Dark Theme --------------------//
  static final inHouseDarkTheme = ColorScheme(
    brightness: Brightness.dark,

    //------------------------------- Primary Colors -------------------------//
    primary: SDeckColorPalette.coolGray[50]!, // F5F5F5
    onPrimary: SDeckColorPalette.slateGray[800]!, // 0C1118
    primaryContainer: SDeckColorPalette.coolGray[500]!, // 9E9E9E
    onPrimaryContainer: SDeckColorPalette.coolGray[50]!, // F5F5F5
    //------------------------------- Secondary Colors -----------------------//
    secondary: SDeckColorPalette.coolGray[800]!, // 404040
    onSecondary: SDeckColorPalette.coolGray[50]!, // F5F5F5
    secondaryContainer: SDeckColorPalette.coolGray[800]!, // 404040
    onSecondaryContainer: SDeckColorPalette.coolGray[50]!, // F5F5F5
    //------------------------------- Tertiary Colors ------------------------//
    tertiary: SDeckColorPalette.slateGray[800]!, // 0C1118
    onTertiary: SDeckColorPalette.coolGray[50]!, // F5F5F5
    tertiaryContainer: SDeckColorPalette.slateGray[800]!, // 0C1118
    onTertiaryContainer: SDeckColorPalette.coolGray[50]!, // F5F5F5
    //------------------------------- Error Colors ---------------------------//
    error: SDeckColorPalette.brightCoral[400]!, // FF8A80
    onError: SDeckColorPalette.brightCoral[900]!, // 470600
    errorContainer: SDeckColorPalette.brightCoral[900]!, // 470600
    onErrorContainer: SDeckColorPalette.brightCoral[400]!, // FF8A80
    //------------------------------- Surface Colors ------------------------//
    surface: SDeckColorPalette.slateGray[700]!, // 101822
    onSurface: SDeckColorPalette.coolGray[50]!, // F5F5F5
    surfaceDim: SDeckColorPalette.coolGray[500]!, // 9E9E9E
    surfaceBright: SDeckColorPalette.coolGray[500]!, // 9E9E9E
    surfaceContainerLowest: SDeckColorPalette.slateGray[800]!, // 0C1118
    surfaceContainerLow: SDeckColorPalette.coolGray[800]!, // 404040
    surfaceContainer: SDeckColorPalette.coolGray[600]!, // 808080
    surfaceContainerHigh: SDeckColorPalette.coolGray[500]!, // 9E9E9E
    surfaceContainerHighest: SDeckColorPalette.coolGray[900]!, // 1F1F1F
    onSurfaceVariant: SDeckColorPalette.coolGray[300]!, // C4C4C4
    //------------------------------- Outline Colors ------------------------//
    outline: SDeckColorPalette.coolGray[50]!, // F5F5F5
    outlineVariant: SDeckColorPalette.coolGray[300]!, // C4C4C4
    //------------------------------- Utility Colors ------------------------//
    shadow: SDeckColorPalette.coolGray[900]!, // 1F1F1F
    scrim: SDeckColorPalette.slateGray[800]!, // 0C1118
    inverseSurface: SDeckColorPalette.coolGray[50]!, // F5F5F5
    onInverseSurface: SDeckColorPalette.coolGray[800]!, // 404040
    inversePrimary: SDeckColorPalette.slateGray[800]!, // 0C1118
    surfaceTint: SDeckColorPalette.coolGray[100]!, // EBEBEB
  );
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
