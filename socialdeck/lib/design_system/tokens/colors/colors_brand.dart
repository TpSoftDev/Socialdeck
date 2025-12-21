/*----------------------------- colors_brand.dart -----------------------------*/
// Brand Color Palette - Identity layer
// Semantic color names that reference Base Color Palette tokens
// Matches Figma: Brand Color Palette (Identity group)
//
// Usage: Use these semantic names instead of numeric indices
// Example: SDeckBrandColors.brightCoralLightest (not SDeckBaseColors.brightCoral[100]!)
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import 'colors_base.dart';

//------------------------------- SDeckBrandColors ------------------------------//
class SDeckBrandColors {
  SDeckBrandColors._(); // Private constructor - prevents instantiation

  //*************************** Bright Coral **********************************//
  //----------------------------- Bright Coral Lightest -----------------------//
  /// Bright Coral Lightest - Light mode: brightCoral100, Dark mode: brightCoral50
  static Color brightCoralLightest(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.brightCoral[100]!
          : SDeckBaseColors.brightCoral[50]!;

  //----------------------------- Bright Coral Light ---------------------------//
  /// Bright Coral Light - Light mode: brightCoral300, Dark mode: brightCoral200
  static Color brightCoralLight(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.brightCoral[300]!
          : SDeckBaseColors.brightCoral[200]!;

  //----------------------------- Bright Coral --------------------------------//
  /// Bright Coral - Light mode: brightCoral500, Dark mode: brightCoral400
  static Color brightCoral(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.brightCoral[500]!
          : SDeckBaseColors.brightCoral[400]!;

  //----------------------------- Bright Coral Dark ----------------------------//
  /// Bright Coral Dark - Light mode: brightCoral700, Dark mode: brightCoral600
  static Color brightCoralDark(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.brightCoral[700]!
          : SDeckBaseColors.brightCoral[600]!;

  //----------------------------- Bright Coral Darkest ------------------------//
  /// Bright Coral Darkest - Light mode: brightCoral900, Dark mode: brightCoral900
  static Color brightCoralDarkest(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.brightCoral[900]!
          : SDeckBaseColors.brightCoral[900]!;

  //*************************** Tangerine **************************************//
  //----------------------------- Tangerine Lightest --------------------------//
  /// Tangerine Lightest - Light mode: tangerine100, Dark mode: tangerine50
  static Color tangerineLightest(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.tangerine[100]!
          : SDeckBaseColors.tangerine[50]!;

  //----------------------------- Tangerine Light -----------------------------//
  /// Tangerine Light - Light mode: tangerine300, Dark mode: tangerine200
  static Color tangerineLight(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.tangerine[300]!
          : SDeckBaseColors.tangerine[200]!;

  //----------------------------- Tangerine -----------------------------------//
  /// Tangerine - Light mode: tangerine500, Dark mode: tangerine400
  static Color tangerine(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.tangerine[500]!
          : SDeckBaseColors.tangerine[400]!;

  //----------------------------- Tangerine Dark -------------------------------//
  /// Tangerine Dark - Light mode: tangerine700, Dark mode: tangerine600
  static Color tangerineDark(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.tangerine[700]!
          : SDeckBaseColors.tangerine[600]!;

  //----------------------------- Tangerine Darkest ---------------------------//
  /// Tangerine Darkest - Light mode: tangerine900, Dark mode: tangerine800
  static Color tangerineDarkest(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.tangerine[900]!
          : SDeckBaseColors.tangerine[800]!;

  //*************************** Vibrant Yellow *********************************//
  //----------------------------- Vibrant Yellow Lightest ----------------------//
  /// Vibrant Yellow Lightest - Light mode: vibrantYellow100, Dark mode: vibrantYellow50
  static Color vibrantYellowLightest(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.vibrantYellow[100]!
          : SDeckBaseColors.vibrantYellow[50]!;

  //----------------------------- Vibrant Yellow Light -------------------------//
  /// Vibrant Yellow Light - Light mode: vibrantYellow300, Dark mode: vibrantYellow200
  static Color vibrantYellowLight(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.vibrantYellow[300]!
          : SDeckBaseColors.vibrantYellow[200]!;

  //----------------------------- Vibrant Yellow --------------------------------//
  /// Vibrant Yellow - Light mode: vibrantYellow500, Dark mode: vibrantYellow400
  static Color vibrantYellow(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.vibrantYellow[500]!
          : SDeckBaseColors.vibrantYellow[400]!;

  //----------------------------- Vibrant Yellow Dark --------------------------//
  /// Vibrant Yellow Dark - Light mode: vibrantYellow700, Dark mode: vibrantYellow600
  static Color vibrantYellowDark(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.vibrantYellow[700]!
          : SDeckBaseColors.vibrantYellow[600]!;

  //----------------------------- Vibrant Yellow Darkest -----------------------//
  /// Vibrant Yellow Darkest - Light mode: vibrantYellow900, Dark mode: vibrantYellow800
  static Color vibrantYellowDarkest(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.vibrantYellow[900]!
          : SDeckBaseColors.vibrantYellow[800]!;

  //*************************** Mint Green *************************************//
  //----------------------------- Mint Green Lightest --------------------------//
  /// Mint Green Lightest - Light mode: mintGreen100, Dark mode: mintGreen50
  static Color mintGreenLightest(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.mintGreen[100]!
          : SDeckBaseColors.mintGreen[50]!;

  //----------------------------- Mint Green Light -----------------------------//
  /// Mint Green Light - Light mode: mintGreen300, Dark mode: mintGreen200
  static Color mintGreenLight(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.mintGreen[300]!
          : SDeckBaseColors.mintGreen[200]!;

  //----------------------------- Mint Green ------------------------------------//
  /// Mint Green - Light mode: mintGreen500, Dark mode: mintGreen400
  static Color mintGreen(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.mintGreen[500]!
          : SDeckBaseColors.mintGreen[400]!;

  //----------------------------- Mint Green Dark -------------------------------//
  /// Mint Green Dark - Light mode: mintGreen700, Dark mode: mintGreen600
  static Color mintGreenDark(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.mintGreen[700]!
          : SDeckBaseColors.mintGreen[600]!;

  //----------------------------- Mint Green Darkest ---------------------------//
  /// Mint Green Darkest - Light mode: mintGreen900, Dark mode: mintGreen900
  static Color mintGreenDarkest(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.mintGreen[900]!
          : SDeckBaseColors.mintGreen[900]!;

  //*************************** Sky Blue **************************************//
  //----------------------------- Sky Blue Lightest ---------------------------//
  /// Sky Blue Lightest - Light mode: skyBlue100, Dark mode: skyBlue50
  static Color skyBlueLightest(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.skyBlue[100]!
          : SDeckBaseColors.skyBlue[50]!;

  //----------------------------- Sky Blue Light ------------------------------//
  /// Sky Blue Light - Light mode: skyBlue300, Dark mode: skyBlue200
  static Color skyBlueLight(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.skyBlue[300]!
          : SDeckBaseColors.skyBlue[200]!;

  //----------------------------- Sky Blue ------------------------------------//
  /// Sky Blue - Light mode: skyBlue500, Dark mode: skyBlue400
  static Color skyBlue(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.skyBlue[500]!
          : SDeckBaseColors.skyBlue[400]!;

  //----------------------------- Sky Blue Dark -------------------------------//
  /// Sky Blue Dark - Light mode: skyBlue700, Dark mode: skyBlue600
  static Color skyBlueDark(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.skyBlue[700]!
          : SDeckBaseColors.skyBlue[600]!;

  //----------------------------- Sky Blue Darkest ----------------------------//
  /// Sky Blue Darkest - Light mode: skyBlue900, Dark mode: skyBlue800
  static Color skyBlueDarkest(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.skyBlue[900]!
          : SDeckBaseColors.skyBlue[800]!;

  //*************************** Lavender **************************************//
  //----------------------------- Lavender Lightest ---------------------------//
  /// Lavender Lightest - Light mode: lavender100, Dark mode: lavender50
  static Color lavenderLightest(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.lavender[100]!
          : SDeckBaseColors.lavender[50]!;

  //----------------------------- Lavender Light ------------------------------//
  /// Lavender Light - Light mode: lavender300, Dark mode: lavender200
  static Color lavenderLight(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.lavender[300]!
          : SDeckBaseColors.lavender[200]!;

  //----------------------------- Lavender ------------------------------------//
  /// Lavender - Light mode: lavender500, Dark mode: lavender400
  static Color lavender(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.lavender[500]!
          : SDeckBaseColors.lavender[400]!;

  //----------------------------- Lavender Dark -------------------------------//
  /// Lavender Dark - Light mode: lavender700, Dark mode: lavender600
  static Color lavenderDark(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.lavender[700]!
          : SDeckBaseColors.lavender[600]!;

  //----------------------------- Lavender Darkest ----------------------------//
  /// Lavender Darkest - Light mode: lavender900, Dark mode: lavender800
  static Color lavenderDarkest(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.lavender[900]!
          : SDeckBaseColors.lavender[800]!;

  //*************************** Cool Gray **************************************//
  //----------------------------- Cool Gray Lightest ---------------------------//
  /// Cool Gray Lightest - Light mode: coolGray100, Dark mode: coolGray50
  static Color coolGrayLightest(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.coolGray[100]!
          : SDeckBaseColors.coolGray[50]!;

  //----------------------------- Cool Gray Light ------------------------------//
  /// Cool Gray Light - Light mode: coolGray300, Dark mode: coolGray200
  static Color coolGrayLight(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.coolGray[300]!
          : SDeckBaseColors.coolGray[200]!;

  //----------------------------- Cool Gray -------------------------------------//
  /// Cool Gray - Light mode: coolGray500, Dark mode: coolGray400
  static Color coolGray(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.coolGray[500]!
          : SDeckBaseColors.coolGray[400]!;

  //----------------------------- Cool Gray Dark --------------------------------//
  /// Cool Gray Dark - Light mode: coolGray700, Dark mode: coolGray600
  static Color coolGrayDark(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.coolGray[700]!
          : SDeckBaseColors.coolGray[600]!;

  //----------------------------- Cool Gray Darkest -----------------------------//
  /// Cool Gray Darkest - Light mode: coolGray900, Dark mode: coolGray800
  static Color coolGrayDarkest(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.coolGray[900]!
          : SDeckBaseColors.coolGray[800]!;

  //*************************** Warm Off White **********************************//
  //----------------------------- Warm Off White --------------------------------//
  /// Warm Off White - Same value for both light and dark mode: warmOffWhite400
  static Color warmOffWhite(Brightness brightness) =>
      SDeckBaseColors.warmOffWhite[400]!;

  //*************************** Slate Gray **************************************//
  //----------------------------- Slate Gray ------------------------------------//
  /// Slate Gray - Light mode: slateGray800, Dark mode: slateGray700
  /// Used primarily in dark mode for backgrounds and surfaces
  static Color slateGray(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBaseColors.slateGray[800]! // slateGray800 - 0C1118
          : SDeckBaseColors.slateGray[700]!; // slateGray700 - 101822
}
