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

  /// Text color for success container backgrounds
  Color get onSuccessContainer =>
      brightness == Brightness.light
          ? SDeckColors.mintGreen[900]!
          : SDeckColors.mintGreen[50]!;

  /// Warning color - auto-switches based on theme brightness
  Color get warning => SDeckColors.vibrantYellow[500]!;

  /// Text color for warning backgrounds
  Color get onWarning => Colors.black;

  /// Warning container color - theme-aware
  Color get warningContainer =>
      brightness == Brightness.light
          ? SDeckColors.vibrantYellow[50]!
          : SDeckColors.vibrantYellow[900]!;

  /// Text color for warning container backgrounds
  Color get onWarningContainer =>
      brightness == Brightness.light
          ? SDeckColors.vibrantYellow[900]!
          : SDeckColors.vibrantYellow[50]!;

  /// Info color - auto-switches based on theme brightness
  Color get info => SDeckColors.skyBlue[500]!;

  /// Text color for info backgrounds
  Color get onInfo => Colors.white;

  /// Info container color - theme-aware
  Color get infoContainer =>
      brightness == Brightness.light
          ? SDeckColors.skyBlue[50]!
          : SDeckColors.skyBlue[900]!;

  /// Text color for info container backgrounds
  Color get onInfoContainer =>
      brightness == Brightness.light
          ? SDeckColors.skyBlue[900]!
          : SDeckColors.skyBlue[50]!;

  /// Links color - auto-switches based on theme brightness
  Color get links => SDeckColors.lavender[500]!;

  /// Text color for link backgrounds
  Color get onLinks => Colors.white;

  /// Links container color - theme-aware
  Color get linksContainer =>
      brightness == Brightness.light
          ? SDeckColors.lavender[50]!
          : SDeckColors.lavender[900]!;

  /// Text color for links container backgrounds
  Color get onLinksContainer =>
      brightness == Brightness.light
          ? SDeckColors.lavender[900]!
          : SDeckColors.lavender[50]!;

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
              .coolGray[100]!; // #F0F0F0 - Slightly darker light in dark mode (from Figma)

  /// Primary button pressed background - Theme-aware using exact Figma colors
  Color get buttonPrimaryPressed =>
      brightness == Brightness.light
          ? SDeckColors
              .coolGray[800]! // #2E2E2E - Lighter when pressed (from palette)
          : SDeckColors
              .coolGray[200]!; // #E5E5E5 - Even darker light in dark mode (from Figma)

  /// Primary button disabled background - Theme-aware using exact Figma colors
  Color get buttonPrimaryDisabled =>
      brightness == Brightness.light
          ? SDeckColors
              .coolGray[400]! // #9E9E9E - Gray when disabled (from palette)
          : SDeckColors
              .coolGray[600]!; // #5E5E5E - Gray when disabled in dark mode (from Figma)

  /// Primary button text color - Theme-aware (contrasts with background)
  Color get onButtonPrimary =>
      brightness == Brightness.light
          ? SDeckColors
              .coolGray[50]! // #F5F5F5 - Light text on dark button (from palette)
          : SDeckColors
              .coolGray[900]!; // #1F1F1F - Dark text on light button (from Figma)

  //------------------------------- Hollow Button Colors (LIGHT & DARK MODE - Using Palette) --------------------------//

  /// Hollow button border - Default state
  Color get buttonHollowBorder =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[900]! // #1F1F1F - matches Figma stroke_P72W12
          : SDeckColors
              .coolGray[50]!; // #F5F5F5 - Light border on dark background

  /// Hollow button border - Hover state
  Color get buttonHollowBorderHover =>
      brightness == Brightness.light
          ? SDeckColors
              .coolGray[900]! // #1F1F1F - same as default (matches Figma)
          : SDeckColors.coolGray[100]!; // #F0F0F0 - Slightly dimmed on hover

  /// Hollow button border - Pressed state
  Color get buttonHollowBorderPressed =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[600]! // #5E5E5E - matches Figma stroke_VPL6EE
          : SDeckColors.coolGray[400]!; // #9E9E9E - Dimmer when pressed

  /// Hollow button border - Disabled state
  Color get buttonHollowBorderDisabled =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[400]! // #9E9E9E - matches Figma stroke_XVHG2F
          : SDeckColors.coolGray[600]!; // #5E5E5E - Darker gray when disabled

  /// Hollow button text color - Default state
  Color get onButtonHollow =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[900]! // #1F1F1F - matches Figma fill_H0QQRE
          : SDeckColors
              .coolGray[50]!; // #F5F5F5 - Light text on dark background

  /// Hollow button text color - Hover state
  Color get onButtonHollowHover =>
      brightness == Brightness.light
          ? SDeckColors
              .coolGray[950]! // #0F0F0F - darker on hover (matches Figma fill_0V232G)
          : SDeckColors.coolGray[100]!; // #F0F0F0 - Slightly dimmed on hover

  /// Hollow button text color - Pressed state
  Color get onButtonHollowPressed =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[600]! // #5E5E5E - matches Figma fill_DJOV5B
          : SDeckColors.coolGray[400]!; // #9E9E9E - Dimmer when pressed

  /// Hollow button text color - Disabled state
  Color get onButtonHollowDisabled =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[400]! // #9E9E9E - matches Figma fill_XXBOAF
          : SDeckColors.coolGray[600]!; // #5E5E5E - Darker gray when disabled

  /// Hollow button background - Always transparent
  Color get buttonHollowBackground => Colors.transparent;

  //------------------------------- Profile Card Colors (LIGHT & DARK MODE - Using Figma Specs) --------------------------//

  /// Profile card background - Theme-aware using exact Figma colors
  Color get profileCardBackground =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[100]! // #EBEBEB - Gray from Figma secondary
          : SDeckColors
              .coolGray[800]!; // #404040 - Dark gray from Figma secondary

  /// Profile card text color - Theme-aware (contrasts with background)
  Color get onProfileCard =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[900]! // #1F1F1F - Dark text from Figma
          : SDeckColors.coolGray[50]!; // Light text in dark mode
}
