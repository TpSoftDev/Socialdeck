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
extension SDeckColorScheme on ColorScheme {
  //------------------------------- Semantic Colors ------------------------//
  /// Success color
  Color get success =>
      brightness == Brightness.light
          ? SDeckColors.mintGreen[100]! // MintLighter - E0F5E9
          : SDeckColors.mintGreen[900]!; // MintDarker - 0F2E1D

  /// Text color for success backgrounds
  Color get onSuccess => SDeckColors.mintGreen[500]!; // Mint - 6FCF97

  /// Success container color
  Color get successContainer =>
      brightness == Brightness.light
          ? SDeckColors.mintGreen[100]! // MintLighter - E0F5E9
          : SDeckColors.mintGreen[900]!; // MintDarker - 0F2E1D

  /// Text color for success container backgrounds
  Color get onSuccessContainer => SDeckColors.mintGreen[500]!; // Mint - 6FCF97

  /// Warning color
  Color get warning =>
      brightness == Brightness.light
          ? SDeckColors.vibrantYellow[100]! // YellowLighter - FFF2CC
          : SDeckColors.vibrantYellow[800]!; // YellowDarker - 6B5001

  /// Text color for warning backgrounds
  Color get onWarning => SDeckColors.vibrantYellow[500]!; // Yellow - FFC008

  /// Warning container color
  Color get warningContainer =>
      brightness == Brightness.light
          ? SDeckColors.vibrantYellow[100]! // YellowLighter - FFF2CC
          : SDeckColors.vibrantYellow[800]!; // YellowDarker - 6B5001

  /// Text color for warning container backgrounds
  Color get onWarningContainer =>
      SDeckColors.vibrantYellow[500]!; // Yellow - FFC008

  /// Information color
  Color get information =>
      brightness == Brightness.light
          ? SDeckColors.skyBlue[100]! // SkyBlueLighter - DEF5FC
          : SDeckColors.skyBlue[800]!; // SkyBlueDarker - 07607B

  /// Text color for information backgrounds
  Color get onInformation => SDeckColors.skyBlue[500]!; // SkyBlue - 57CCF2

  /// Information container color
  Color get informationContainer =>
      brightness == Brightness.light
          ? SDeckColors.skyBlue[100]! // SkyBlueLighter - DEF5FC
          : SDeckColors.skyBlue[800]!; // SkyBlueDarker - 07607B

  /// Text color for information container backgrounds
  Color get onInformationContainer =>
      SDeckColors.skyBlue[500]!; // SkyBlue - 57CCF2

  /// Link color
  Color get link =>
      brightness == Brightness.light
          ? SDeckColors.lavender[100]! // LavenderLighter - F5ECFD
          : SDeckColors.lavender[800]!; // LavenderDarker - 4B0D96

  /// Text color for link backgrounds
  Color get onLink => SDeckColors.lavender[500]!; // Lavender - CBA6F7

  /// Link container color
  Color get linkContainer =>
      brightness == Brightness.light
          ? SDeckColors.lavender[100]! // LavenderLighter - F5ECFD
          : SDeckColors.lavender[800]!; // LavenderDarker - 4B0D96

  /// Text color for link container backgrounds
  Color get onLinkContainer => SDeckColors.lavender[500]!; // Lavender - CBA6F7

  //------------------------------- Text Field Colors ----------------------//

  /// Hint text color - consistent across light/dark modes
  Color get hintText => SDeckColors.coolGray[500]!; // CoolGray - 9E9E9E

  /// Text field background color
  Color get textField =>
      brightness == Brightness.light
          ? SDeckColors.warmOffWhite[300]! // WarmOffWhite (White) - FFFFFF
          : SDeckColors.slateGray[700]!; // SlateGray (Black) - 101822

  /// Text color for text field content
  Color get onTextField =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[900]! // CoolGrayDarkest - 1F1F1F
          : SDeckColors.coolGray[50]!; // CoolGrayLightest - F5F5F5

  /// Filled text field background color
  Color get filledTextField =>
      brightness == Brightness.light
          ? SDeckColors.warmOffWhite[300]! // WarmOffWhite - FDFBF5 
          : SDeckColors.slateGray[700]!; // SlateGray (Black) - 101822

  /// Text color for filled text field content
  Color get onFilledTextField =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[900]! // CoolGrayDarkest - 1F1F1F
          : SDeckColors.coolGray[50]!; // CoolGrayLightest - F5F5F5

  /// Tangerine accent color
  Color get tangerine => SDeckColors.tangerine[500]!;

  /// Text color for tangerine backgrounds
  Color get onTangerine => Colors.white;

  /// Tangerine container color - theme-aware
  Color get tangerineContainer =>
      brightness == Brightness.light
          ? SDeckColors.tangerine[50]!
          : SDeckColors.tangerine[900]!;

  //------------------------------- Button Colors ----------------------------//
  /// Primary button background - Theme-aware using exact Figma colors
  Color get buttonPrimary =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[900]! // #1F1F1F - Dark button in light mode 
          : SDeckColors.coolGray[50]!; // #F5F5F5 - Light button in dark mode 

  /// Primary button hover background - Theme-aware using exact Figma colors
  Color get buttonPrimaryHover =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[950]! // #0F0F0F - Darker on hover 
          : SDeckColors.coolGray[100]!; // #F0F0F0 - Slightly darker light in dark mode 

  /// Primary button pressed background - Theme-aware using exact Figma colors
  Color get buttonPrimaryPressed =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[800]! // #2E2E2E - Lighter when pressed 
          : SDeckColors.coolGray[200]!; // #E5E5E5 - Even darker light in dark mode 

  /// Primary button disabled background - Theme-aware using exact Figma colors
  Color get buttonPrimaryDisabled =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[400]! // #9E9E9E - Gray when disabled 
          : SDeckColors.coolGray[600]!; // #5E5E5E - Gray when disabled in dark mode 

  /// Primary button text color - Theme-aware (contrasts with background)
  Color get onButtonPrimary =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[50]! // #F5F5F5 - Light text on dark button 
          : SDeckColors.coolGray[900]!; // #1F1F1F - Dark text on light button 

  //-------------------------- Hollow Button Colors --------------------------//

  /// Hollow button border - Default state
  Color get buttonHollowBorder =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[900]! // #1F1F1F - matches Figma stroke_P72W12
          : SDeckColors.coolGray[50]!; // #F5F5F5 - Light border on dark background

  /// Hollow button border - Hover state
  Color get buttonHollowBorderHover =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[900]! // #1F1F1F - same as default 
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
          : SDeckColors.coolGray[50]!; // #F5F5F5 - Light text on dark background

  /// Hollow button text color - Hover state
  Color get onButtonHollowHover =>
      brightness == Brightness.light
          ? SDeckColors.coolGray[950]! // #0F0F0F - darker on hover 
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

  //--------------------------- Profile Card Colors --------------------------//

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
