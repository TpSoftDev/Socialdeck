/*----------------------------- sdeck_theme.dart ----------------------------*/
// Main theme assembly file
// This file combines all design foundations into complete ThemeData objects
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../foundations/index.dart';

class SDeckTheme {
  SDeckTheme._(); // Private constructor

//******************************** App Themes ********************************//
//------------------------------ In-House Theme ------------------------------//
  static ThemeData get inHouseLight =>_buildTheme(SDeckColorSchemes.inHouseLight);
  static ThemeData get inHouseDark => _buildTheme(SDeckColorSchemes.inHouseDark);


//******************************* Game Themes **********************************//
//TODO: Add game themes here



//*************************** Helper Method ***********************************//
  /// Builds a complete ThemeData from a ColorScheme
  /// Automatically selects appropriate typography and icons based on brightness
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      textTheme:
          colorScheme.brightness == Brightness.light
              ? SDeckTypography.light
              : SDeckTypography.dark,
      extensions: [
        colorScheme.brightness == Brightness.light
            ? SDeckIconThemes.light
            : SDeckIconThemes.dark,
      ],
      scaffoldBackgroundColor: colorScheme.surface,
      useMaterial3: true,
      fontFamily: 'Poppins',
    );
  }
}


