/*-------------------------- color_extensions.dart --------------------------*/
// Foundation color extensions built from design tokens
// These add semantic meaning to ColorScheme with theme-aware colors
// Auto-switches between light/dark values based on current theme
//
// Usage: Theme.of(context).colorScheme.success
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../tokens/index.dart';

//*************** Theme-Aware Color Extensions (Auto Light/Dark) *************//
// Use these when you want automatic light/dark mode switching
// Example: Theme.of(context).colorScheme.success

extension SDeckColorScheme on ColorScheme {
  //------------------------------- Semantic Colors ------------------------//

  /// Success color - auto-switches based on theme brightness
  Color get success => SDeckColors.mintGreen[500]!;

  /// Text color for success backgrounds
  Color get onSuccess => Colors.white;

  /// Success container color - theme-aware
  Color get successContainer =>
      brightness == Brightness.light
          ? SDeckColors.mintGreen[50]!
          : SDeckColors.mintGreen[900]!;

  /// Warning color - auto-switches based on theme brightness
  Color get warning => SDeckColors.vibrantYellow[500]!;

  /// Text color for warning backgrounds
  Color get onWarning => Colors.black;

  /// Warning container color - theme-aware
  Color get warningContainer =>
      brightness == Brightness.light
          ? SDeckColors.vibrantYellow[50]!
          : SDeckColors.vibrantYellow[900]!;

  /// Info color - auto-switches based on theme brightness
  Color get info => SDeckColors.skyBlue[500]!;

  /// Text color for info backgrounds
  Color get onInfo => Colors.white;

  /// Info container color - theme-aware
  Color get infoContainer =>
      brightness == Brightness.light
          ? SDeckColors.skyBlue[50]!
          : SDeckColors.skyBlue[900]!;

  /// Links color - auto-switches based on theme brightness
  Color get links => SDeckColors.lavender[500]!;

  /// Text color for link backgrounds
  Color get onLinks => Colors.white;

  /// Links container color - theme-aware
  Color get linksContainer =>
      brightness == Brightness.light
          ? SDeckColors.lavender[50]!
          : SDeckColors.lavender[900]!;

  /// Tangerine accent color - auto-switches based on theme brightness
  Color get tangerine => SDeckColors.tangerine[500]!;

  /// Text color for tangerine backgrounds
  Color get onTangerine => Colors.white;

  /// Tangerine container color - theme-aware
  Color get tangerineContainer =>
      brightness == Brightness.light
          ? SDeckColors.tangerine[50]!
          : SDeckColors.tangerine[900]!;

  //------------------------------- Background Colors ---------------------//

  /// Primary background color - theme-aware
  Color get backgroundPrimary =>
      brightness == Brightness.light
          ? SDeckColors.warmOffWhite[500]!
          : SDeckColors.slateGray[500]!;

  /// Secondary background color - theme-aware
  Color get backgroundSecondary =>
      brightness == Brightness.light
          ? SDeckColors.warmOffWhite[50]!
          : SDeckColors.slateGray[800]!;

  /// Tertiary background color - theme-aware
  Color get backgroundTertiary =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[50]!
          : SDeckColors.slateGray[900]!;

  //------------------------------- Text Colors ----------------------------//

  /// Primary text color - theme-aware
  Color get textPrimary =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[700]!
          : SDeckColors.coolGray[50]!;

  /// Secondary text color - theme-aware
  Color get textSecondary =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[500]!
          : SDeckColors.coolGray[300]!;

  /// Disabled text color - theme-aware
  Color get textDisabled =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[400]!
          : SDeckColors.coolGray[600]!;

  //------------------------------- Button Colors (LIGHT & DARK MODE - Using Palette) --------------------------//

  /// Primary button background - Theme-aware using exact Figma colors
  Color get buttonPrimary =>
      brightness == Brightness.light
          ? SDeckColors
              .coolGray[900]! // #1F1F1F - Dark button in light mode (from palette)
          : SDeckColors
              .coolGray[50]!; // #F5F5F5 - Light button in dark mode (from Figma)

  /// Primary button hover background - Theme-aware using exact Figma colors
  Color get buttonPrimaryHover =>
      brightness == Brightness.light
          ? SDeckColors
              .coolGray[950]! // #0F0F0F - Darker on hover (from palette)
          : SDeckColors
              .warmOffWhite[50]!; // #FFFFFF - White on hover in dark mode (from Figma)

  /// Primary button pressed background - Theme-aware using exact Figma colors
  Color get buttonPrimaryPressed =>
      brightness == Brightness.light
          ? SDeckColors
              .coolGray[700]! // #5E5E5E - Medium gray when pressed (from palette)
          : SDeckColors
              .coolGray[200]!; // #D9D9D9 - Medium gray when pressed in dark mode (from Figma)

  /// Primary button disabled background - Theme-aware using exact Figma colors
  Color get buttonPrimaryDisabled =>
      brightness == Brightness.light
          ? SDeckColors
              .coolGray[500]! // #9E9E9E - Light gray when disabled (from palette)
          : SDeckColors
              .coolGray[400]!; // #B3B3B3 - Darker gray when disabled in dark mode (from Figma)

  /// Text color on primary buttons - Theme-aware using exact Figma colors
  Color get onButtonPrimary =>
      brightness == Brightness.light
          ? SDeckColors
              .warmOffWhite[300]! // #FDFBF5 - Light warm off-white text (from palette)
          : SDeckColors
              .slateGray[900]!; // #101822 - Dark text in dark mode (from Figma)
}
