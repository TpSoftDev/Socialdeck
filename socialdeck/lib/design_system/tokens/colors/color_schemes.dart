/*--------------------------- color_schemes.dart ----------------------------*/
// Color schemes built from design tokens
// These create meaningful color schemes using semantic tokens
// Used by themes to define the app's color behavior
//
// Usage: Import in themes to build complete ThemeData objects
/*--------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import '../index.dart';

/*----------------------------- SDeckColorSchemes ----------------------------*/
class SDeckColorSchemes {
  SDeckColorSchemes._(); // Private constructor


  //**************************** LIGHT THEME **********************************//
  static final light = ColorScheme(
    brightness: Brightness.light,

    //------------------------------- Primary Colors -------------------------//
    primary: SDeckMainSemanticColors.primary(Brightness.light),
    onPrimary: SDeckMainSemanticColors.onPrimary(Brightness.light),
    primaryContainer: SDeckMainSemanticColors.primaryContainer(Brightness.light),
    onPrimaryContainer: SDeckMainSemanticColors.onPrimaryContainer(Brightness.light),
    primaryFixed: SDeckBrandColors.coolGrayDarkest(Brightness.light),
    primaryFixedDim: SDeckBrandColors.coolGray(Brightness.light),
    onPrimaryFixed: SDeckBrandColors.warmOffWhite(Brightness.light),
    onPrimaryFixedVariant: SDeckBrandColors.coolGrayDark(Brightness.light),

    //------------------------------- Secondary Colors -----------------------//
    secondary: SDeckMainSemanticColors.secondary(Brightness.light),
    onSecondary: SDeckMainSemanticColors.onSecondary(Brightness.light),
    secondaryContainer: SDeckMainSemanticColors.secondaryContainer(Brightness.light),
    onSecondaryContainer: SDeckMainSemanticColors.onSecondaryContainer(Brightness.light),
    secondaryFixed: SDeckBrandColors.coolGrayLightest(Brightness.light),
    secondaryFixedDim: SDeckBrandColors.coolGrayLight(Brightness.light),
    onSecondaryFixed: SDeckBrandColors.coolGrayLightest(Brightness.light),
    onSecondaryFixedVariant: SDeckBrandColors.warmOffWhite(Brightness.light),

    //------------------------------- Tertiary Colors ------------------------//
    tertiary: SDeckMainSemanticColors.tertiary(Brightness.light),
    onTertiary: SDeckMainSemanticColors.onTertiary(Brightness.light),
    tertiaryContainer: SDeckMainSemanticColors.tertiaryContainer(Brightness.light),
    onTertiaryContainer: SDeckMainSemanticColors.onTertiaryContainer(Brightness.light),
    tertiaryFixed: SDeckBrandColors.coolGrayDark(Brightness.light),
    tertiaryFixedDim: SDeckBrandColors.coolGrayDarkest(Brightness.light),
    onTertiaryFixed: SDeckBrandColors.warmOffWhite(Brightness.light),
    onTertiaryFixedVariant: SDeckBrandColors.coolGrayDarkest(Brightness.light),

    //------------------------------- Error Colors ---------------------------//
    error: SDeckMainSemanticColors.error(Brightness.light),
    onError: SDeckMainSemanticColors.onError(Brightness.light),
    errorContainer: SDeckMainSemanticColors.errorContainer(Brightness.light),
    onErrorContainer: SDeckMainSemanticColors.onErrorContainer(Brightness.light),

    //------------------------------- Surface Colors ------------------------//
    surface: SDeckMainSemanticColors.surface(Brightness.light),
    onSurface: SDeckMainSemanticColors.onSurface(Brightness.light),
    surfaceDim: SDeckBrandColors.coolGray(Brightness.light),
    surfaceBright: SDeckBrandColors.coolGrayLightest(Brightness.light),
    surfaceContainerLowest: SDeckBrandColors.warmOffWhite(Brightness.light),
    surfaceContainerLow: SDeckBrandColors.coolGrayLightest(Brightness.light),
    surfaceContainer: SDeckBrandColors.coolGrayLight(Brightness.light),
    surfaceContainerHigh: SDeckBrandColors.coolGrayDark(Brightness.light),
    surfaceContainerHighest: SDeckBrandColors.coolGrayDarkest(Brightness.light),
    onSurfaceVariant: SDeckMainSemanticColors.onSurfaceVariant(Brightness.light),

    //------------------------------- Outline Colors ------------------------//
    outline: SDeckMainSemanticColors.outline(Brightness.light),
    outlineVariant: SDeckMainSemanticColors.outlineVariant(Brightness.light),

    //------------------------------- Utility Colors ------------------------//
    shadow: SDeckBrandColors.coolGrayDarkest(Brightness.light),
    scrim: SDeckBrandColors.warmOffWhite(Brightness.light),
    inverseSurface: SDeckMainSemanticColors.inverseSurface(Brightness.light),
    onInverseSurface: SDeckMainSemanticColors.onInverseSurface(Brightness.light),
    inversePrimary: SDeckBrandColors.warmOffWhite(Brightness.light),
    surfaceTint: SDeckBrandColors.coolGrayLightest(Brightness.light),
  );

  //**************************** DARK THEME *************************************//
  static final dark = ColorScheme(
    brightness: Brightness.dark,

    //------------------------------- Primary Colors -------------------------//
    primary: SDeckMainSemanticColors.primary(Brightness.dark),
    onPrimary: SDeckMainSemanticColors.onPrimary(Brightness.dark),
    primaryContainer: SDeckMainSemanticColors.primaryContainer(Brightness.dark),
    onPrimaryContainer: SDeckMainSemanticColors.onPrimaryContainer(
      Brightness.dark,
    ),
    primaryFixed: SDeckBrandColors.coolGrayLightest(Brightness.dark),
    primaryFixedDim: SDeckBrandColors.coolGray(Brightness.dark),
    onPrimaryFixed: SDeckBrandColors.slateGray(Brightness.dark),
    onPrimaryFixedVariant: SDeckBrandColors.coolGrayLight(Brightness.dark),

    //------------------------------- Secondary Colors -----------------------//
    secondary: SDeckMainSemanticColors.secondary(Brightness.dark),
    onSecondary: SDeckMainSemanticColors.onSecondary(Brightness.dark),
    secondaryContainer: SDeckMainSemanticColors.secondaryContainer(Brightness.dark),
    onSecondaryContainer: SDeckMainSemanticColors.onSecondaryContainer(Brightness.dark),
    secondaryFixed: SDeckBrandColors.coolGrayDarkest(Brightness.dark),
    secondaryFixedDim: SDeckBrandColors.coolGrayDark(Brightness.dark),
    onSecondaryFixed: SDeckBrandColors.coolGrayLightest(Brightness.dark),
    onSecondaryFixedVariant: SDeckBrandColors.slateGray(Brightness.dark),

    //------------------------------- Tertiary Colors ------------------------//
    tertiary: SDeckMainSemanticColors.tertiary(Brightness.dark),
    onTertiary: SDeckMainSemanticColors.onTertiary(Brightness.dark),
    tertiaryContainer: SDeckMainSemanticColors.tertiaryContainer(Brightness.dark),
    onTertiaryContainer: SDeckMainSemanticColors.onTertiaryContainer(Brightness.dark),
    tertiaryFixed: SDeckBrandColors.coolGrayLight(Brightness.dark),
    tertiaryFixedDim: SDeckBrandColors.coolGray(Brightness.dark),
    onTertiaryFixed: SDeckBrandColors.slateGray(Brightness.dark),
    onTertiaryFixedVariant: SDeckBrandColors.coolGrayLightest(Brightness.dark),

    //------------------------------- Error Colors ---------------------------//
    error: SDeckMainSemanticColors.error(Brightness.dark),
    onError: SDeckMainSemanticColors.onError(Brightness.dark),
    errorContainer: SDeckMainSemanticColors.errorContainer(Brightness.dark),
    onErrorContainer: SDeckMainSemanticColors.onErrorContainer(Brightness.dark),

    //------------------------------- Surface Colors ------------------------//
    surface: SDeckMainSemanticColors.surface(Brightness.dark),
    onSurface: SDeckMainSemanticColors.onSurface(Brightness.dark),
    surfaceDim: SDeckBrandColors.coolGrayDarkest(Brightness.dark),
    surfaceBright: SDeckBrandColors.coolGray(Brightness.dark),
    surfaceContainerLowest: SDeckBrandColors.slateGray(Brightness.dark),
    surfaceContainerLow: SDeckBrandColors.coolGrayDarkest(Brightness.dark),
    surfaceContainer: SDeckBrandColors.coolGrayDark(Brightness.dark),
    surfaceContainerHigh: SDeckBrandColors.coolGray(Brightness.dark),
    surfaceContainerHighest: SDeckBrandColors.coolGrayLight(Brightness.dark),
    onSurfaceVariant: SDeckMainSemanticColors.onSurfaceVariant(Brightness.dark),

    //------------------------------- Outline Colors ------------------------//
    outline: SDeckMainSemanticColors.outline(Brightness.dark),
    outlineVariant: SDeckMainSemanticColors.outlineVariant(Brightness.dark),

    //------------------------------- Utility Colors ------------------------//
    shadow: SDeckBrandColors.coolGrayDarkest(Brightness.dark),
    scrim: SDeckBrandColors.warmOffWhite(Brightness.dark),
    inverseSurface: SDeckMainSemanticColors.inverseSurface(Brightness.dark),
    onInverseSurface: SDeckMainSemanticColors.onInverseSurface(Brightness.dark),
    inversePrimary: SDeckBrandColors.warmOffWhite(Brightness.dark),
    surfaceTint: SDeckBrandColors.coolGrayLightest(Brightness.dark),
  );
}

