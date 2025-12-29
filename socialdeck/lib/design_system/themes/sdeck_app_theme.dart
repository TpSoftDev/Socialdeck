/*----------------------------- sdeck_app_theme.dart ----------------------------*/
// Main theme assembly file
// This file combines all design tokens and themes into complete ThemeData objects
/*--------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import '../tokens/colors/index.dart';
import '../tokens/typography/index.dart';
import 'text_theme.dart';

/*----------------------------- SDeckAppTheme ------------------------------*/
class SDeckAppTheme {
  SDeckAppTheme._(); // Private constructor

  //******************************** App Themes ********************************//
  //------------------------------ Light & Dark Themes -------------------------//
  static ThemeData get light => _buildTheme(SDeckColorSchemes.light);
  static ThemeData get dark => _buildTheme(SDeckColorSchemes.dark);

  //******************************* Game Themes *********************************//
  //TODO: Add game themes here

  //*************************** Helper Method ***********************************//
  /// Builds a complete ThemeData from a ColorScheme
  /// Uses consolidated TextTheme (colors handled by components via ColorScheme)
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      textTheme:SDeckTextTheme.theme, // Single theme for both light/dark (colors handled by components)
      scaffoldBackgroundColor: colorScheme.background, // Matches Figma: --background-&-surface/background
      useMaterial3: true,
      fontFamily: SDeckFontFamily.poppins,
    );
  }
}
