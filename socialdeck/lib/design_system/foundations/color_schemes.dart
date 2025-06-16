/*--------------------------- color_schemes.dart ----------------------------*/
// Foundation color schemes built from design tokens
// These create meaningful color schemes using the raw token values
// Used by themes to define the app's color behavior
//
// Usage: Import in themes to build complete ThemeData objects
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../tokens/index.dart';

class SDeckColorSchemes {
  SDeckColorSchemes._(); // Private constructor

  //*************************** In-House Theme ColorSchemes ********************//
  //**************************** LIGHT THEME **********************************//
  static final inHouseLight = ColorScheme(
    brightness: Brightness.light,

    //------------------------------- Primary Colors -------------------------//
    primary: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    onPrimary: SDeckColors.warmOffWhite[300]!, // WarmOffWhite - FDFBF5 
    primaryContainer: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    onPrimaryContainer: SDeckColors.warmOffWhite[300]!, // WarmOffWhite - FDFBF5 
    primaryFixed: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    primaryFixedDim: SDeckColors.coolGray[500]!, // CoolGray - 9E9E9E
    onPrimaryFixed: SDeckColors.warmOffWhite[300]!, // WarmOffWhite - FDFBF5 
    onPrimaryFixedVariant: SDeckColors.coolGray[700]!, // CoolGrayDark - 5E5E5E

    //------------------------------- Secondary Colors -----------------------//
    secondary: SDeckColors.coolGray[100]!, // CoolGrayLightest - EBEBEB
    onSecondary: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    secondaryContainer: SDeckColors.coolGray[100]!, // CoolGrayLightest - EBEBEB
    onSecondaryContainer: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    secondaryFixed: SDeckColors.coolGray[100]!, // CoolGrayLightest - EBEBEB
    secondaryFixedDim: SDeckColors.coolGray[300]!, // CoolGrayLight - C4C4C4
    onSecondaryFixed: SDeckColors.coolGray[100]!, // CoolGrayLightest - EBEBEB
    onSecondaryFixedVariant: SDeckColors.warmOffWhite[300]!, // WarmOffWhite - FDFBF5 

    //------------------------------- Tertiary Colors ------------------------//
    tertiary: SDeckColors.coolGray[700]!, // CoolGrayDark - 5E5E5E
    onTertiary: SDeckColors.warmOffWhite[300]!, // WarmOffWhite - FDFBF5 
    tertiaryContainer: SDeckColors.coolGray[700]!, // CoolGrayDark - 5E5E5E
    onTertiaryContainer:SDeckColors.warmOffWhite[300]!, // WarmOffWhite - FDFBF5 
    tertiaryFixed: SDeckColors.coolGray[700]!, // CoolGrayDark - 5E5E5E
    tertiaryFixedDim: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    onTertiaryFixed: SDeckColors.warmOffWhite[300]!, // WarmOffWhite - FDFBF5 
    onTertiaryFixedVariant: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F

    //------------------------------- Error Colors ---------------------------//
    error: SDeckColors.brightCoral[100]!, // CoralLighter - FFE3E0
    onError: SDeckColors.brightCoral[500]!, // Coral - FE6F61
    errorContainer: SDeckColors.brightCoral[100]!, // CoralLighter - FFE3E0
    onErrorContainer: SDeckColors.brightCoral[500]!, // Coral - FE6F61

    //------------------------------- Surface Colors ------------------------//
    surface: SDeckColors.warmOffWhite[300]!, // WarmOffWhite - FDFBF5 
    onSurface: SDeckColors.coolGray[900]!, // 1F1F1F
    surfaceDim: SDeckColors.coolGray[500]!, // 9E9E9E
    surfaceBright: SDeckColors.coolGray[100]!, // EBEBEB
    surfaceContainerLowest: SDeckColors.warmOffWhite[300]!, // WarmOffWhite - FDFBF5 
    surfaceContainerLow:SDeckColors.coolGray[100]!, // CoolGrayLightest - EBEBEB
    surfaceContainer: SDeckColors.coolGray[300]!, // CoolGrayLight - C4C4C4
    surfaceContainerHigh: SDeckColors.coolGray[700]!, // CoolGrayDark - 5E5E5E
    surfaceContainerHighest: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    onSurfaceVariant: SDeckColors.coolGray[300]!, // CoolGrayLight - C4C4C4

    //------------------------------- Outline Colors ------------------------//
    outline: SDeckColors.coolGray[900]!, // 1F1F1F
    outlineVariant: SDeckColors.coolGray[300]!, // C4C4C4

    //------------------------------- Utility Colors ------------------------//
    shadow: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    scrim: SDeckColors.warmOffWhite[300]!, // WarmOffWhite - FDFBF5 
    inverseSurface: SDeckColors.coolGray[900]!, // 1F1F1F
    onInverseSurface: SDeckColors.coolGray[100]!, // EBEBEB
    inversePrimary: SDeckColors.warmOffWhite[300]!, // WarmOffWhite - FDFBF5 
    surfaceTint: SDeckColors.coolGray[100]!, // EBEBEB
  );

//**************************** DARK THEME *************************************//
  static final inHouseDark = ColorScheme(
    brightness: Brightness.dark,

    //------------------------------- Primary Colors -------------------------//
    primary: SDeckColors.coolGray[50]!, // CoolGrayLightest - F5F5F5
    onPrimary: SDeckColors.slateGray[700]!, // SlateGray (Black) - 101822
    primaryContainer: SDeckColors.coolGray[50]!, // CoolGrayLightest - F5F5F5
    onPrimaryContainer: SDeckColors.slateGray[700]!, // SlateGray (Black) - 101822
    primaryFixed: SDeckColors.coolGray[50]!, // CoolGrayLightest - F5F5F5
    primaryFixedDim: SDeckColors.coolGray[500]!, // CoolGray - 9E9E9E
    onPrimaryFixed: SDeckColors.slateGray[700]!, // SlateGray (Black) - 101822
    onPrimaryFixedVariant: SDeckColors.coolGray[300]!, // CoolGrayLight - C4C4C4

    //------------------------------- Secondary Colors -----------------------//
    secondary: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    onSecondary: SDeckColors.coolGray[50]!, // CoolGrayLightest - F5F5F5
    secondaryContainer: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    onSecondaryContainer: SDeckColors.coolGray[50]!, // CoolGrayLightest - F5F5F5
    secondaryFixed: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    secondaryFixedDim: SDeckColors.coolGray[700]!, // CoolGrayDark - 5E5E5E
    onSecondaryFixed: SDeckColors.coolGray[50]!, // CoolGrayLightest - F5F5F5
    onSecondaryFixedVariant: SDeckColors.slateGray[700]!, // SlateGray (Black) - 101822

    //------------------------------- Tertiary Colors ------------------------//
    tertiary: SDeckColors.coolGray[300]!, // CoolGrayLight - C4C4C4
    onTertiary: SDeckColors.slateGray[700]!, // SlateGray (Black) - 101822
    tertiaryContainer: SDeckColors.coolGray[300]!, // CoolGrayLight - C4C4C4
    onTertiaryContainer: SDeckColors.slateGray[700]!, // SlateGray (Black) - 101822
    tertiaryFixed: SDeckColors.coolGray[300]!, // CoolGrayLight - C4C4C4
    tertiaryFixedDim: SDeckColors.coolGray[500]!, // CoolGray - 9E9E9E
    onTertiaryFixed: SDeckColors.slateGray[700]!, // SlateGray (Black) - 101822
    onTertiaryFixedVariant: SDeckColors.coolGray[50]!, // CoolGrayLightest - F5F5F5

    //------------------------------- Error Colors ---------------------------//
    error: SDeckColors.brightCoral[900]!, // CoralDarker - 470600
    onError: SDeckColors.brightCoral[500]!, // Coral - FE6F61
    errorContainer: SDeckColors.brightCoral[900]!, // CoralDarker - 470600
    onErrorContainer: SDeckColors.brightCoral[500]!, // Coral - FE6F61

    //------------------------------- Surface Colors ------------------------//
    surface: SDeckColors.slateGray[700]!, // SlateGray (Black) - 101822
    onSurface: SDeckColors.coolGray[50]!, // CoolGrayLightest - F5F5F5
    surfaceDim: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    surfaceBright: SDeckColors.coolGray[500]!, // CoolGray - 9E9E9E
    surfaceContainerLowest: SDeckColors.slateGray[700]!, // SlateGray (Black) - 101822
    surfaceContainerLow: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    surfaceContainer: SDeckColors.coolGray[700]!, // CoolGrayDark - 5E5E5E
    surfaceContainerHigh: SDeckColors.coolGray[500]!, // CoolGray - 9E9E9E
    surfaceContainerHighest: SDeckColors.coolGray[300]!, // CoolGrayLight - C4C4C4
    onSurfaceVariant: SDeckColors.coolGray[700]!, // CoolGrayDark - 5E5E5E

    //------------------------------- Outline Colors ------------------------//
    outline: SDeckColors.coolGray[50]!, // F5F5F5
    outlineVariant: SDeckColors.coolGray[300]!, // C4C4C4

    //------------------------------- Utility Colors ------------------------//
    shadow: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    scrim: SDeckColors.warmOffWhite[50]!, // WarmOffWhite (White) - FFFFFF
    inverseSurface: SDeckColors.coolGray[50]!, // CoolGrayLightest - F5F5F5
    onInverseSurface: SDeckColors.coolGray[900]!, // CoolGrayDarkest - 1F1F1F
    inversePrimary:SDeckColors.warmOffWhite[50]!, // WarmOffWhite (White) - FFFFFF
    surfaceTint: SDeckColors.coolGray[100]!, // CoolGrayLightest - EBEBEB
  );
}
