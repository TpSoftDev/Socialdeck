/*----------------------------- app_colors.dart -----------------------------*/
// A collection of color constants used throughout the application.
// These colors are derived from the Figma design system and provide
// consistent theming across the app.
/*----------------------------------------------------------------------------*/

//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';
import 'color_palette.dart';

class SDeckAppColors {
  SDeckAppColors._(); // Private constructor to prevent instantiation

  //*************************** Light Theme Colors ***************************//
  static const lightTheme = ColorScheme(
    brightness: Brightness.light,

    //------------------------------- Primary Colors -------------------------//
    primary: Color(0xFF56CCF2),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFEBF9FE),
    onPrimaryContainer: Color(0xFF01161C),

    //------------------------------- Secondary Colors -----------------------//
    secondary: Color(0xFF6FCF97),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFF0FAF4),
    onSecondaryContainer: Color(0xFF08170E),

    //------------------------------- Error Colors ---------------------------//
    error: Color(0xFFFF6F61),
    onError: Colors.white,
    errorContainer: Color(0xFFFFF0F0),
    onErrorContainer: Color(0xFF240300),

    //------------------------------- Background Colors ---------------------//
    surface: Color(0xFFFDF9F3),
    onSurface: Color(0xFF5E5E5E),
    surfaceContainerHighest: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFF9E9E9E),

    //------------------------------- Outline Colors ------------------------//
    outline: Color(0xFFC4C4C4),
    outlineVariant: Color(0xFFEBEBEB),
  );






  //*************************** Dark Theme Colors ****************************//
  static const darkTheme = ColorScheme(
    brightness: Brightness.dark,

    //------------------------------- Primary Colors -------------------------//
    primary: Color(0xFF56CCF2),
    onPrimary: Color(0xFF01161C),
    primaryContainer: Color(0xFF062F3F),
    onPrimaryContainer: Color(0xFFEBF9FE),

    //------------------------------- Secondary Colors -----------------------//
    secondary: Color(0xFF6FCF97),
    onSecondary: Color(0xFF08170E),
    secondaryContainer: Color(0xFF0F2E1D),
    onSecondaryContainer: Color(0xFFF0FAF4),

    //------------------------------- Error Colors ---------------------------//
    error: Color(0xFFFF6F61),
    onError: Color(0xFF240300),
    errorContainer: Color(0xFF470600),
    onErrorContainer: Color(0xFFFFF0F0),

    //------------------------------- Background Colors ---------------------//
    surface: Color(0xFF1C2838),
    onSurface: Color(0xFFF5F5F5),
    surfaceContainerHighest: Color(0xFF0C1118),
    onSurfaceVariant: Color(0xFF9E9E9E),

    //------------------------------- Outline Colors ------------------------//
    outline: Color(0xFF5E5E5E),
    outlineVariant: Color(0xFF404040),
  );





//*************************** Semantic Color Helpers *************************//

  //------------------------------- Success Colors -------------------------//
  static const success = Color(0xFF6FCF97);
  static const successLight = Color(0xFFF0FAF4);
  static const successDark = Color(0xFF0F2E1D);

  //------------------------------- Warning Colors -------------------------//
  static const warning = Color(0xFFFFC107);
  static const warningLight = Color(0xFFFFF9E5);
  static const warningDark = Color(0xFF191300);

  //------------------------------- Info Colors -----------------------------//
  static const info = Color(0xFF56CCF2);
  static const infoLight = Color(0xFFEBF9FE);
  static const infoDark = Color(0xFF01161C);

  //------------------------------- Accent Colors ---------------------------//
  static const accent = Color(0xFFCBA6F7);
  static const accentLight = Color(0xFFF8F6FE);
  static const accentDark = Color(0xFF130325);
}




//************************ Theme-Aware Color Extension ***********************//
extension SDeckColorScheme on ColorScheme {
  //------------------------------- Success Colors -------------------------//
  Color get success =>
      brightness == Brightness.light
          ? SDeckAppColors.success
          : SDeckAppColors.success;

  Color get onSuccess =>
      brightness == Brightness.light ? Colors.white : Colors.white;

  Color get successContainer =>
      brightness == Brightness.light
          ? SDeckAppColors.successLight
          : SDeckAppColors.successDark;

  //------------------------------- Warning Colors -------------------------//
  Color get warning =>
      brightness == Brightness.light
          ? SDeckAppColors.warning
          : SDeckAppColors.warning;

  Color get onWarning =>
      brightness == Brightness.light ? Colors.black : Colors.black;

  Color get warningContainer =>
      brightness == Brightness.light
          ? SDeckAppColors.warningLight
          : SDeckAppColors.warningDark;

  //------------------------------- Info Colors -----------------------------//
  Color get info =>
      brightness == Brightness.light
          ? SDeckAppColors.info
          : SDeckAppColors.info;

  Color get onInfo =>
      brightness == Brightness.light ? Colors.white : Colors.white;

  Color get infoContainer =>
      brightness == Brightness.light
          ? SDeckAppColors.infoLight
          : SDeckAppColors.infoDark;

  //------------------------------- Accent Colors ---------------------------//
  Color get accent =>
      brightness == Brightness.light
          ? SDeckAppColors.accent
          : SDeckAppColors.accent;

  Color get onAccent =>
      brightness == Brightness.light ? Colors.white : Colors.white;

  Color get accentContainer =>
      brightness == Brightness.light
          ? SDeckAppColors.accentLight
          : SDeckAppColors.accentDark;
}
