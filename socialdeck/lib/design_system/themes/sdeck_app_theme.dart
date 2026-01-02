/*----------------------------- sdeck_app_theme.dart ----------------------------*/
// Main theme assembly file
// Combines design tokens into complete ThemeData objects using ThemeExtensions
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';
import '../tokens/colors/index.dart';
import '../tokens/typography/index.dart';
import 'text_theme.dart';

//------------------------------- SDeckAppTheme ------------------------------//
class SDeckAppTheme {
  SDeckAppTheme._(); // Private constructor

  //******************************** App Themes ********************************//
  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  //******************************* Game Themes *********************************//
  //TODO: Add game themes here

  //*************************** Helper Method ***********************************//
  /// Builds ThemeData using ThemeExtensions as single source of truth
  static ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final semanticColors = isLight ? SDeckSemanticColors.light : SDeckSemanticColors.dark;
    final componentColors = isLight ? SDeckComponentColors.light(semanticColors) : SDeckComponentColors.dark(semanticColors);

    return ThemeData(
      textTheme: SDeckTextTheme.theme,
      scaffoldBackgroundColor: semanticColors.surface,
      useMaterial3: true,
      fontFamily: SDeckFontFamily.poppins,
      extensions: <ThemeExtension<dynamic>>[semanticColors, componentColors],
    );
  }
}
