/*----------------------------- colors_main_semantic.dart ----------------------*/
// Main Semantic Color Palette - Map layer
// Maps Material Design 3 semantic properties to Brand Color Palette tokens
// Matches Figma: Main Semantic Color Palette (Map group)
//
// Usage: Use these semantic names that reference Brand Color Palette
// Example: SDeckMainSemanticColors.primary(brightness)
//          → Returns SDeckBrandColors.coolGrayDarkest(brightness)
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import 'colors_brand.dart';

//------------------------------- SDeckMainSemanticColors ------------------------------//
class SDeckMainSemanticColors {
  SDeckMainSemanticColors._(); // Private constructor - prevents instantiation

  //*************************** Background & Surface **************************//
  //----------------------------- Background ---------------------------------//
  /// Background - Light mode: warmOffWhite, Dark mode: slateGray
  static Color background(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.warmOffWhite(brightness)
          : SDeckBrandColors.slateGray(brightness);

  //----------------------------- On Background -------------------------------//
  /// On Background - Light mode: coolGrayDarkest, Dark mode: coolGrayLightest
  static Color onBackground(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayDarkest(brightness)
          : SDeckBrandColors.coolGrayLightest(brightness);

  //----------------------------- Surface -------------------------------------//
  /// Surface - Light mode: warmOffWhite, Dark mode: slateGray
  static Color surface(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.warmOffWhite(brightness)
          : SDeckBrandColors.slateGray(brightness);

  //----------------------------- On Surface ----------------------------------//
  /// On Surface - Light mode: coolGrayDarkest, Dark mode: coolGrayLightest
  static Color onSurface(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayDarkest(brightness)
          : SDeckBrandColors.coolGrayLightest(brightness);

  //----------------------------- Surface Variant -----------------------------//
  /// Surface Variant - Light mode: coolGrayLightest, Dark mode: coolGrayDark
  static Color surfaceVariant(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayLightest(brightness)
          : SDeckBrandColors.coolGrayDark(brightness);

  //----------------------------- On Surface Variant --------------------------//
  /// On Surface Variant - Light mode: coolGray, Dark mode: coolGray
  static Color onSurfaceVariant(Brightness brightness) =>
      SDeckBrandColors.coolGray(brightness);

  //----------------------------- Inverse Surface -----------------------------//
  /// Inverse Surface - Light mode: slateGray, Dark mode: warmOffWhite
  static Color inverseSurface(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.slateGray(brightness)
          : SDeckBrandColors.warmOffWhite(brightness);

  //----------------------------- On Inverse Surface --------------------------//
  /// On Inverse Surface - Light mode: coolGrayLightest, Dark mode: coolGrayDarkest
  static Color onInverseSurface(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayLightest(brightness)
          : SDeckBrandColors.coolGrayDarkest(brightness);

  //*************************** Primary Colors *********************************//
  //----------------------------- Primary -------------------------------------//
  /// Primary - Light mode: coolGrayDarkest, Dark mode: coolGrayLightest
  static Color primary(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayDarkest(brightness)
          : SDeckBrandColors.coolGrayLightest(brightness);

  //----------------------------- On Primary -----------------------------------//
  /// On Primary - Light mode: warmOffWhite, Dark mode: slateGray
  static Color onPrimary(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.warmOffWhite(brightness)
          : SDeckBrandColors.slateGray(brightness);

  //----------------------------- Primary Container ----------------------------//
  /// Primary Container - Light mode: coolGrayDarkest, Dark mode: coolGrayLightest
  static Color primaryContainer(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayDarkest(brightness)
          : SDeckBrandColors.coolGrayLightest(brightness);

  //----------------------------- On Primary Container -------------------------//
  /// On Primary Container - Light mode: warmOffWhite, Dark mode: slateGray
  static Color onPrimaryContainer(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.warmOffWhite(brightness)
          : SDeckBrandColors.slateGray(brightness);

  //*************************** Secondary Colors *******************************//
  //----------------------------- Secondary -----------------------------------//
  /// Secondary - Light mode: coolGrayLightest, Dark mode: coolGrayDarkest
  static Color secondary(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayLightest(brightness)
          : SDeckBrandColors.coolGrayDarkest(brightness);

  //----------------------------- On Secondary ---------------------------------//
  /// On Secondary - Light mode: coolGrayDarkest, Dark mode: coolGrayLightest
  static Color onSecondary(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayDarkest(brightness)
          : SDeckBrandColors.coolGrayLightest(brightness);

  //----------------------------- Secondary Container -------------------------//
  /// Secondary Container - Light mode: coolGrayLightest, Dark mode: coolGrayDarkest
  static Color secondaryContainer(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayLightest(brightness)
          : SDeckBrandColors.coolGrayDarkest(brightness);

  //----------------------------- On Secondary Container ----------------------//
  /// On Secondary Container - Light mode: coolGrayDarkest, Dark mode: coolGrayLightest
  static Color onSecondaryContainer(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayDarkest(brightness)
          : SDeckBrandColors.coolGrayLightest(brightness);

  //*************************** Tertiary Colors *******************************//
  //----------------------------- Tertiary ------------------------------------//
  /// Tertiary - Light mode: coolGrayDark, Dark mode: coolGrayLight
  static Color tertiary(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayDark(brightness)
          : SDeckBrandColors.coolGrayLight(brightness);

  //----------------------------- On Tertiary ---------------------------------//
  /// On Tertiary - Light mode: warmOffWhite, Dark mode: slateGray
  static Color onTertiary(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.warmOffWhite(brightness)
          : SDeckBrandColors.slateGray(brightness);

  //----------------------------- Tertiary Container ---------------------------//
  /// Tertiary Container - Light mode: coolGrayDark, Dark mode: coolGrayLight
  static Color tertiaryContainer(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayDark(brightness)
          : SDeckBrandColors.coolGrayLight(brightness);

  //----------------------------- On Tertiary Container ------------------------//
  /// On Tertiary Container - Light mode: warmOffWhite, Dark mode: slateGray
  static Color onTertiaryContainer(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.warmOffWhite(brightness)
          : SDeckBrandColors.slateGray(brightness);

  //*************************** Error Colors ***********************************//
  //----------------------------- Error ---------------------------------------//
  /// Error - Light mode: brightCoralLightest, Dark mode: brightCoralDarkest
  static Color error(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.brightCoralLightest(brightness)
          : SDeckBrandColors.brightCoralDarkest(brightness);

  //----------------------------- On Error -------------------------------------//
  /// On Error - Light mode: brightCoral, Dark mode: brightCoral
  static Color onError(Brightness brightness) =>
      SDeckBrandColors.brightCoral(brightness);

  //----------------------------- Error Container ------------------------------//
  /// Error Container - Light mode: brightCoralLightest, Dark mode: brightCoralDarkest
  static Color errorContainer(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.brightCoralLightest(brightness)
          : SDeckBrandColors.brightCoralDarkest(brightness);

  //----------------------------- On Error Container ---------------------------//
  /// On Error Container - Light mode: brightCoral, Dark mode: brightCoral
  static Color onErrorContainer(Brightness brightness) =>
      SDeckBrandColors.brightCoral(brightness);

  //*************************** Success Colors *********************************//
  //----------------------------- Success --------------------------------------//
  /// Success - Light mode: mintGreenLightest, Dark mode: mintGreenDarkest
  static Color success(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.mintGreenLightest(brightness)
          : SDeckBrandColors.mintGreenDarkest(brightness);

  //----------------------------- On Success ----------------------------------//
  /// On Success - Light mode: mintGreen, Dark mode: mintGreen
  static Color onSuccess(Brightness brightness) =>
      SDeckBrandColors.mintGreen(brightness);

  //----------------------------- Success Container ----------------------------//
  /// Success Container - Light mode: mintGreenLightest, Dark mode: mintGreenDarkest
  static Color successContainer(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.mintGreenLightest(brightness)
          : SDeckBrandColors.mintGreenDarkest(brightness);

  //----------------------------- On Success Container ------------------------//
  /// On Success Container - Light mode: mintGreen, Dark mode: mintGreen
  static Color onSuccessContainer(Brightness brightness) =>
      SDeckBrandColors.mintGreen(brightness);

  //*************************** Outline Colors *********************************//
  //----------------------------- Outline --------------------------------------//
  /// Outline - Light mode: coolGrayDarkest, Dark mode: coolGrayLightest
  static Color outline(Brightness brightness) =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayDarkest(brightness)
          : SDeckBrandColors.coolGrayLightest(brightness);

  //----------------------------- Outline Variant ------------------------------//
  /// Outline Variant - Light mode: coolGrayLight, Dark mode: coolGrayLight
  static Color outlineVariant(Brightness brightness) =>
      SDeckBrandColors.coolGrayLight(brightness);
}
