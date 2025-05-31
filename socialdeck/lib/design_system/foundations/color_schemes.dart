/*--------------------------- color_schemes.dart ----------------------------*/
// Foundation color schemes built from design tokens
// These create meaningful color schemes using the raw token values
// Used by themes to define the app's color behavior
//
// Usage: Import in themes to build complete ThemeData objects
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../tokens/index.dart';

/// Foundation color schemes for the SocialDeck design system
/// Built using pure color tokens to create meaningful theme definitions
class SDeckColorSchemes {
  SDeckColorSchemes._(); // Private constructor

  //*************************** In-House Theme ColorSchemes ********************//
  //
  // IN-HOUSE THEME RATIONALE:
  // The in-house theme serves as the default professional theme for the app.
  // Uses Cool Gray as primary colors with carefully selected semantic colors
  // for consistent user experience across home, settings, and profile screens.
  //

  //------------------------------- In-House Light Theme -------------------//
  static final light = ColorScheme(
    brightness: Brightness.light,

    //------------------------------- Primary Colors -------------------------//
    primary: SDeckColors.coolGray[900]!, // 1F1F1F
    onPrimary: SDeckColors.warmOffWhite[50]!, // FFFFFF
    primaryContainer: SDeckColors.coolGray[300]!, // C4C4C4
    onPrimaryContainer: SDeckColors.coolGray[900]!, // 1F1F1F
    //------------------------------- Secondary Colors -----------------------//
    secondary: SDeckColors.coolGray[100]!, // EBEBEB
    onSecondary: SDeckColors.coolGray[900]!, // 1F1F1F
    secondaryContainer: SDeckColors.coolGray[100]!, // EBEBEB
    onSecondaryContainer: SDeckColors.coolGray[900]!, // 1F1F1F
    //------------------------------- Tertiary Colors ------------------------//
    tertiary: SDeckColors.warmOffWhite[50]!, // FFFFFF
    onTertiary: SDeckColors.slateGray[500]!, // 1B2838
    tertiaryContainer: SDeckColors.warmOffWhite[50]!, // FFFFFF
    onTertiaryContainer: SDeckColors.coolGray[900]!, // 1F1F1F
    //------------------------------- Error Colors ---------------------------//
    error: SDeckColors.brightCoral[600]!, // FF2C1A
    onError: SDeckColors.brightCoral[100]!, // FFE3E0
    errorContainer: SDeckColors.brightCoral[100]!, // FFE3E0
    onErrorContainer: SDeckColors.brightCoral[950]!, // 240300
    //------------------------------- Surface Colors ------------------------//
    surface: SDeckColors.warmOffWhite[300]!,
    onSurface: SDeckColors.coolGray[900]!, // 1F1F1F
    surfaceDim: SDeckColors.coolGray[500]!, // 9E9E9E
    surfaceBright: SDeckColors.coolGray[100]!, // EBEBEB
    surfaceContainerLowest: SDeckColors.warmOffWhite[50]!, // FFFFFF
    surfaceContainerLow: SDeckColors.coolGray[100]!, // EBEBEB
    surfaceContainer: SDeckColors.coolGray[300]!, // C4C4C4
    surfaceContainerHigh: SDeckColors.coolGray[200]!, // D9D9D9
    surfaceContainerHighest: SDeckColors.coolGray[100]!, // EBEBEB
    onSurfaceVariant: SDeckColors.coolGray[300]!, // C4C4C4
    //------------------------------- Outline Colors ------------------------//
    outline: SDeckColors.coolGray[900]!, // 1F1F1F
    outlineVariant: SDeckColors.coolGray[300]!, // C4C4C4
    //------------------------------- Utility Colors ------------------------//
    shadow: SDeckColors.coolGray[900]!, // 1F1F1F
    scrim: SDeckColors.warmOffWhite[50]!, // FFFFFF
    inverseSurface: SDeckColors.coolGray[900]!, // 1F1F1F
    onInverseSurface: SDeckColors.coolGray[100]!, // EBEBEB
    inversePrimary: SDeckColors.warmOffWhite[50]!, // FFFFFF
    surfaceTint: SDeckColors.coolGray[100]!, // EBEBEB
  );

  //------------------------------- In-House Dark Theme --------------------//
  static final dark = ColorScheme(
    brightness: Brightness.dark,

    //------------------------------- Primary Colors -------------------------//
    primary: SDeckColors.coolGray[50]!, // F5F5F5
    onPrimary: SDeckColors.slateGray[800]!, // 0C1118
    primaryContainer: SDeckColors.coolGray[500]!, // 9E9E9E
    onPrimaryContainer: SDeckColors.coolGray[50]!, // F5F5F5
    //------------------------------- Secondary Colors -----------------------//
    secondary: SDeckColors.coolGray[800]!, // 404040
    onSecondary: SDeckColors.coolGray[50]!, // F5F5F5
    secondaryContainer: SDeckColors.coolGray[800]!, // 404040
    onSecondaryContainer: SDeckColors.coolGray[50]!, // F5F5F5
    //------------------------------- Tertiary Colors ------------------------//
    tertiary: SDeckColors.slateGray[800]!, // 0C1118
    onTertiary: SDeckColors.coolGray[50]!, // F5F5F5
    tertiaryContainer: SDeckColors.slateGray[800]!, // 0C1118
    onTertiaryContainer: SDeckColors.coolGray[50]!, // F5F5F5
    //------------------------------- Error Colors ---------------------------//
    error: SDeckColors.brightCoral[400]!, // FF8A80
    onError: SDeckColors.brightCoral[900]!, // 470600
    errorContainer: SDeckColors.brightCoral[900]!, // 470600
    onErrorContainer: SDeckColors.brightCoral[400]!, // FF8A80
    //------------------------------- Surface Colors ------------------------//
    surface: SDeckColors.slateGray[700]!, // 101822
    onSurface: SDeckColors.coolGray[50]!, // F5F5F5
    surfaceDim: SDeckColors.coolGray[500]!, // 9E9E9E
    surfaceBright: SDeckColors.coolGray[500]!, // 9E9E9E
    surfaceContainerLowest: SDeckColors.slateGray[800]!, // 0C1118
    surfaceContainerLow: SDeckColors.coolGray[800]!, // 404040
    surfaceContainer: SDeckColors.coolGray[600]!, // 808080
    surfaceContainerHigh: SDeckColors.coolGray[500]!, // 9E9E9E
    surfaceContainerHighest: SDeckColors.coolGray[900]!, // 1F1F1F
    onSurfaceVariant: SDeckColors.coolGray[300]!, // C4C4C4
    //------------------------------- Outline Colors ------------------------//
    outline: SDeckColors.coolGray[50]!, // F5F5F5
    outlineVariant: SDeckColors.coolGray[300]!, // C4C4C4
    //------------------------------- Utility Colors ------------------------//
    shadow: SDeckColors.coolGray[900]!, // 1F1F1F
    scrim: SDeckColors.slateGray[800]!, // 0C1118
    inverseSurface: SDeckColors.coolGray[50]!, // F5F5F5
    onInverseSurface: SDeckColors.coolGray[800]!, // 404040
    inversePrimary: SDeckColors.slateGray[800]!, // 0C1118
    surfaceTint: SDeckColors.coolGray[100]!, // EBEBEB
  );
}
