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

  //*************************** Light Theme ***********************************//
  static ThemeData get light {
    return ThemeData(
      // Use our foundation color schemes
      colorScheme: SDeckColorSchemes.light,

      // Use our foundation text styles
      textTheme: SDeckTypography.light,

      // Add our foundation icon themes as extensions
      extensions: [SDeckIconThemes.light],

      // Set default background color for all screens
      scaffoldBackgroundColor: SDeckColorSchemes.light.surface,

      // Material Design 3
      useMaterial3: true,

      // Set the default font family
      fontFamily: 'Poppins',
    );
  }

  //*************************** Dark Theme ************************************//
  static ThemeData get dark {
    return ThemeData(
      // Use our foundation color schemes
      colorScheme: SDeckColorSchemes.dark,

      // Use our foundation text styles
      textTheme: SDeckTypography.dark,

      // Add our foundation icon themes as extensions
      extensions: [SDeckIconThemes.dark],

      // Set default background color for all screens
      scaffoldBackgroundColor: SDeckColorSchemes.dark.surface,

      // Material Design 3
      useMaterial3: true,

      // Set the default font family
      fontFamily: 'Poppins',
    );
  }
}
