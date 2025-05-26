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


  // App Basic Colors


  // Text Colors


  // Background Colors
  static final Color backgroundLight = SDeckColorPalette.warmOffWhite[500]!;
  static final Color backgroundDark = SDeckColorPalette.slateGray[500]!;

  // Container Colors

  // Button Colors

  // Border Colors


  // Status Colors


  // Neutral Shades - Light Theme


  // Theme-specific colors
  static final Color lightThemePrimary = SDeckColorPalette.warmOffWhite[500]!;
  static final Color darkThemePrimary = SDeckColorPalette.slateGray[500]!;


}
