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
}
