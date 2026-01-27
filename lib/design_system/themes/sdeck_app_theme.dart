/*----------------------------- sdeck_app_theme.dart -----------------------------*/
// Main theme assembly file that combines design tokens into complete ThemeData
// objects. Uses ThemeExtensions as the single source of truth for colors, ensuring
// consistent theming across light and dark modes.
//
// Usage:
//   ThemeData theme = SDeckAppTheme.light
//   ThemeData theme = SDeckAppTheme.dark
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';
import '../tokens/colors/index.dart';
import '../tokens/typography/index.dart';
import 'text_theme.dart';

//------------------------------- SDeckAppTheme ------------------------------//
class SDeckAppTheme {
  SDeckAppTheme._();

  //*************************** App Themes **********************************//
  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  //*************************** Game Themes **********************************//
  // TODO: Add game themes here

  //*************************** Helper Method **********************************//
  /// Builds ThemeData using ThemeExtensions as single source of truth.
  static ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    SDeckSemanticColors semanticColors;
    if (isLight) {
      semanticColors = SDeckSemanticColors.light;
    } else {
      semanticColors = SDeckSemanticColors.dark;
    }

    SDeckComponentColors componentColors;
    if (isLight) {
      componentColors = SDeckComponentColors.light(semanticColors);
    } else {
      componentColors = SDeckComponentColors.dark(semanticColors);
    }

    return ThemeData(
      textTheme: SDeckTextTheme.theme,
      scaffoldBackgroundColor: semanticColors.surface,
      useMaterial3: true,
      fontFamily: SDeckFontFamily.poppins,
      extensions: <ThemeExtension<dynamic>>[semanticColors, componentColors],
    );
  }
}
