/*--------------------------------------------------------------- app_colors.dart ---------------------------------------------------------------*/
// A collection of semantic color assignments used throughout the Social Deck application.
// These colors are derived from the Figma design system and provide
// consistent theming across the app with meaningful color roles.
/*-------------------------------------------------------------------------------------------------------------------------------------------*/

//--------------------------------------------------------------- Imports ---------------------------------------------------------------//
import 'package:flutter/material.dart';
import 'color_palette.dart';

class SDeckAppColors {
  SDeckAppColors._(); // Private constructor to prevent instantiation

  //--------------------------------------------------------------- Primary Brand Colors ---------------------------------------------------------------//
  static final Color primaryBrightCoral = SDeckColorPalette.brightCoral[500]!;
  static final Color primaryVibrantYellow = SDeckColorPalette.vibrantYellow[500]!;
  static final Color primarySkyBlue = SDeckColorPalette.skyBlue[500]!;

  //--------------------------------------------------------------- Secondary Brand Colors ---------------------------------------------------------------//
  static final Color secondaryTangerine = SDeckColorPalette.tangerine[500]!;
  static final Color secondaryMintGreen = SDeckColorPalette.mintGreen[500]!;
  static final Color secondaryLavender = SDeckColorPalette.lavender[500]!;

  //--------------------------------------------------------------- Status Colors ---------------------------------------------------------------//
  static final Color errorColor = SDeckColorPalette.brightCoral[500]!;
  static final Color errorColorLight = SDeckColorPalette.brightCoral[100]!;
  static final Color errorColorDark = SDeckColorPalette.brightCoral[700]!;

  static final Color warningColor = SDeckColorPalette.vibrantYellow[500]!;
  static final Color warningColorLight = SDeckColorPalette.vibrantYellow[100]!;
  static final Color warningColorDark = SDeckColorPalette.vibrantYellow[700]!;

  static final Color successColor = SDeckColorPalette.mintGreen[500]!;
  static final Color successColorLight = SDeckColorPalette.mintGreen[100]!;
  static final Color successColorDark = SDeckColorPalette.mintGreen[700]!;

  static final Color infoColor = SDeckColorPalette.skyBlue[500]!;
  static final Color infoColorLight = SDeckColorPalette.skyBlue[100]!;
  static final Color infoColorDark = SDeckColorPalette.skyBlue[700]!;

  //--------------------------------------------------------------- Text Colors ---------------------------------------------------------------//
  static final Color textPrimary = SDeckColorPalette.coolGray[900]!;
  static final Color textSecondary = SDeckColorPalette.coolGray[700]!;
  static final Color textTertiary = SDeckColorPalette.coolGray[500]!;
  static final Color textDisabled = SDeckColorPalette.coolGray[400]!;
  static final Color textOnDark = SDeckColorPalette.warmOffWhite[50]!;
  static final Color textOnLight = SDeckColorPalette.slateGray[900]!;

  //--------------------------------------------------------------- Background Colors ---------------------------------------------------------------//
  static final Color backgroundLight = SDeckColorPalette.warmOffWhite[500]!;
  static final Color backgroundDark = SDeckColorPalette.slateGray[500]!;
  static final Color backgroundSurface = SDeckColorPalette.warmOffWhite[100]!;
  static final Color backgroundCard = SDeckColorPalette.warmOffWhite[50]!;

  //--------------------------------------------------------------- Container Colors ---------------------------------------------------------------//
  static final Color containerPrimary = SDeckColorPalette.warmOffWhite[200]!;
  static final Color containerSecondary = SDeckColorPalette.coolGray[100]!;
  static final Color containerTertiary = SDeckColorPalette.coolGray[50]!;

  //--------------------------------------------------------------- Button Colors ---------------------------------------------------------------//
  static final Color buttonPrimary = SDeckColorPalette.brightCoral[500]!;
  static final Color buttonPrimaryHover = SDeckColorPalette.brightCoral[600]!;
  static final Color buttonPrimaryPressed = SDeckColorPalette.brightCoral[700]!;
  static final Color buttonPrimaryDisabled = SDeckColorPalette.coolGray[300]!;

  static final Color buttonSecondary = SDeckColorPalette.skyBlue[500]!;
  static final Color buttonSecondaryHover = SDeckColorPalette.skyBlue[600]!;
  static final Color buttonSecondaryPressed = SDeckColorPalette.skyBlue[700]!;

  static final Color buttonTertiary = SDeckColorPalette.coolGray[200]!;
  static final Color buttonTertiaryHover = SDeckColorPalette.coolGray[300]!;
  static final Color buttonTertiaryPressed = SDeckColorPalette.coolGray[400]!;

  //--------------------------------------------------------------- Border Colors ---------------------------------------------------------------//
  static final Color borderPrimary = SDeckColorPalette.coolGray[300]!;
  static final Color borderSecondary = SDeckColorPalette.coolGray[200]!;
  static final Color borderFocus = SDeckColorPalette.skyBlue[500]!;
  static final Color borderError = SDeckColorPalette.brightCoral[500]!;
  static final Color borderSuccess = SDeckColorPalette.mintGreen[500]!;

  //--------------------------------------------------------------- Link Colors ---------------------------------------------------------------//
  static final Color linkDefault = SDeckColorPalette.lavender[500]!;
  static final Color linkHover = SDeckColorPalette.lavender[600]!;
  static final Color linkPressed = SDeckColorPalette.lavender[700]!;
  static final Color linkVisited = SDeckColorPalette.lavender[800]!;

  //--------------------------------------------------------------- Neutral Shades - Light Theme ---------------------------------------------------------------//
  static final Color neutralLightest = SDeckColorPalette.warmOffWhite[50]!;
  static final Color neutralLighter = SDeckColorPalette.warmOffWhite[100]!;
  static final Color neutralLight = SDeckColorPalette.warmOffWhite[200]!;
  static final Color neutralMedium = SDeckColorPalette.coolGray[500]!;
  static final Color neutralDark = SDeckColorPalette.coolGray[700]!;
  static final Color neutralDarker = SDeckColorPalette.coolGray[800]!;
  static final Color neutralDarkest = SDeckColorPalette.coolGray[900]!;

  //--------------------------------------------------------------- Neutral Shades - Dark Theme ---------------------------------------------------------------//
  static final Color neutralDarkThemeLightest = SDeckColorPalette.slateGray[50]!;
  static final Color neutralDarkThemeLighter =  SDeckColorPalette.slateGray[100]!;
  static final Color neutralDarkThemeLight = SDeckColorPalette.slateGray[200]!;
  static final Color neutralDarkThemeMedium = SDeckColorPalette.slateGray[500]!;
  static final Color neutralDarkThemeDark = SDeckColorPalette.slateGray[700]!;
  static final Color neutralDarkThemeDarker = SDeckColorPalette.slateGray[800]!;
  static final Color neutralDarkThemeDarkest = SDeckColorPalette.slateGray[900]!;

  //--------------------------------------------------------------- Theme-specific Colors ---------------------------------------------------------------//
  static final Color lightThemePrimary = SDeckColorPalette.warmOffWhite[500]!;
  static final Color lightThemeSecondary = SDeckColorPalette.coolGray[100]!;
  static final Color lightThemeSurface = SDeckColorPalette.warmOffWhite[50]!;

  static final Color darkThemePrimary = SDeckColorPalette.slateGray[500]!;
  static final Color darkThemeSecondary = SDeckColorPalette.slateGray[300]!;
  static final Color darkThemeSurface = SDeckColorPalette.slateGray[800]!;

  //--------------------------------------------------------------- Accent Colors ---------------------------------------------------------------//
  static final Color accentTangerine = SDeckColorPalette.tangerine[500]!;
  static final Color accentTangerineLight = SDeckColorPalette.tangerine[200]!;
  static final Color accentTangerineDark = SDeckColorPalette.tangerine[700]!;
}
