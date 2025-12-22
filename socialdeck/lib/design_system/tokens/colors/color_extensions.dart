/*-------------------------- color_extensions.dart --------------------------*/
// Color extensions built from design tokens
// These add component-specific convenience getters for colors not in Material Design 3
// Auto-switches between light/dark values based on current theme
//
// Usage: Theme.of(context).colorScheme.buttonPrimaryHover
//        Theme.of(context).colorScheme.successContainer
//        Theme.of(context).colorScheme.createProfileCardBackground
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import '../index.dart';

//------------------------------- SDeckColorScheme Extension --------------//
//*************** Theme-Aware Color Extensions (Auto Light/Dark) *************//
extension SDeckColorScheme on ColorScheme {
  //------------------------------- Semantic Colors ------------------------//
  /// Success container color - Used by text fields
  Color get successContainer =>
      brightness == Brightness.light
          ? SDeckBrandColors.mintGreenLightest(brightness)
          : SDeckBrandColors.mintGreenDarkest(brightness);

  /// Text color for success container backgrounds - Used by text fields
  Color get onSuccessContainer => SDeckBrandColors.mintGreen(brightness);

  //------------------------------- Button Colors ----------------------------//

  /// Primary button hover background - Theme-aware using exact Figma colors
  Color get buttonPrimaryHover =>
      brightness == Brightness.light
          ? SDeckBaseColors
              .coolGray[950]! // #0F0F0F - Darker on hover (no semantic mapping)
          : SDeckBaseColors
              .coolGray[100]!; // #EBEBEB - Slightly darker light in dark mode

  /// Primary button pressed background - Theme-aware using exact Figma colors
  Color get buttonPrimaryPressed =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayDarkest(
            brightness,
          ) // Uses 800 in light mode
          : SDeckBaseColors
              .coolGray[200]!; // #D9D9D9 - Even darker light in dark mode

  /// Primary button disabled background - Theme-aware using exact Figma colors
  Color get buttonPrimaryDisabled =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGray(brightness) // Uses 400 in light mode
          : SDeckBrandColors.coolGrayDark(brightness); // Uses 600 in dark mode

  //-------------------------- Hollow Button Colors --------------------------//

  /// Hollow button border - Hover state
  Color get buttonHollowBorderHover =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayDarkest(brightness)
          : SDeckBaseColors
              .coolGray[100]!; // #EBEBEB - Slightly dimmed on hover

  /// Hollow button border - Pressed state
  Color get buttonHollowBorderPressed =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayDark(brightness) // Uses 600 in light mode
          : SDeckBrandColors.coolGray(brightness); // Uses 400 in dark mode

  /// Hollow button border - Disabled state
  Color get buttonHollowBorderDisabled =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGray(brightness) // Uses 400 in light mode
          : SDeckBrandColors.coolGrayDark(brightness); // Uses 600 in dark mode

  /// Hollow button text color - Hover state
  Color get onButtonHollowHover =>
      brightness == Brightness.light
          ? SDeckBaseColors
              .coolGray[950]! // #0F0F0F - darker on hover (no semantic mapping)
          : SDeckBaseColors
              .coolGray[100]!; // #EBEBEB - Slightly dimmed on hover

  /// Hollow button text color - Pressed state
  Color get onButtonHollowPressed =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayDark(brightness) // Uses 600 in light mode
          : SDeckBrandColors.coolGray(brightness); // Uses 400 in dark mode

  /// Hollow button text color - Disabled state
  Color get onButtonHollowDisabled =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGray(brightness) // Uses 400 in light mode
          : SDeckBrandColors.coolGrayDark(brightness); // Uses 600 in dark mode

  //------------------------ Create Profile Card Colors ----------------------//

  /// Create Profile Card background - Theme-aware using exact Figma colors
  Color get createProfileCardBackground =>
      brightness == Brightness.light
          ? SDeckBaseColors.coolGray[100]! // #EBEBEB - Light gray background
          : SDeckBrandColors.coolGrayDarkest(
            brightness,
          ); // Uses 800 in dark mode

  /// Create Profile Card border - Theme-aware gray border
  Color get createProfileCardBorder =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayLight(brightness) // Uses 300 in light mode
          : SDeckBrandColors.coolGrayDark(brightness); // Uses 600 in dark mode

  //--------------------------- Playing Card Colors --------------------------//

  /// Playing Card background - Theme-aware using exact Figma colors
  /// Used for the outer container of playing cards in login, deck building, etc.
  Color get playingCardBackground =>
      brightness == Brightness.light
          ? SDeckBaseColors.coolGray[100]! // #EBEBEB - Light gray background
          : SDeckBrandColors.coolGrayDarkest(
            brightness,
          ); // Uses 800 in dark mode

  /// Note container background color (matches Figma #EBEBEB in light, #404040 in dark)
  Color get noteContainer =>
      brightness == Brightness.light
          ? SDeckBaseColors.coolGray[100]! // #EBEBEB
          : SDeckBrandColors.coolGrayDarkest(
            brightness,
          ); // Uses 800 in dark mode

  /// Note container text color (matches Figma #5E5E5E in light, #D9D9D9 in dark)
  Color get onNoteContainer =>
      brightness == Brightness.light
          ? SDeckBrandColors.coolGrayDark(brightness) // Uses 700 in light mode
          : SDeckBaseColors.coolGray[200]!; // #D9D9D9
}

