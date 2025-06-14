/*----------------------------- sdeck_theme.dart ----------------------------*/
// Main theme assembly file
// This file combines all design foundations into complete ThemeData objects
// Import this file to get complete themes ready for MaterialApp
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../foundations/index.dart';

/// Main theme class that assembles all design system foundations
/// into complete Material Design themes
class SDeckTheme {
  SDeckTheme._(); // Private constructor

//******************************** App Themes ********************************//
//------------------------------ In-House Theme ------------------------------//
  static ThemeData get inHouseLight =>_buildTheme(SDeckColorSchemes.inHouseLight);
  static ThemeData get inHouseDark => _buildTheme(SDeckColorSchemes.inHouseDark);


//******************************* Game Themes **********************************//
//TODO



//*************************** Helper Method ***********************************//
  /// Builds a complete ThemeData from a ColorScheme
  /// Automatically selects appropriate typography and icons based on brightness
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      // Use the provided color scheme
      colorScheme: colorScheme,

      // Auto-select typography based on brightness
      textTheme:
          colorScheme.brightness == Brightness.light
              ? SDeckTypography.light
              : SDeckTypography.dark,

      // Auto-select icon theme based on brightness
      extensions: [
        colorScheme.brightness == Brightness.light
            ? SDeckIconThemes.light
            : SDeckIconThemes.dark,
      ],

      // Set background color from the color scheme
      scaffoldBackgroundColor: colorScheme.surface,

      // Material Design 3
      useMaterial3: true,

      // Set the default font family
      fontFamily: 'Poppins',
    );
  }
}


