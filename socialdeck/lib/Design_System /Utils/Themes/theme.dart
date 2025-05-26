//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'custom_themes/typography.dart';

//------------------------------ theme.dart ----------------------------------//
// This file combines all the individual theme components into complete themes.
// It defines both light and dark themes that can be used throughout the app.
// Each theme imports and uses the custom theme components defined separately.
// This modular approach makes it easier to maintain and update the app's appearance.
//----------------------------------------------------------------------------//

//----------------------------- SDeckAppTheme --------------------------------//
class SDeckAppTheme {
  SDeckAppTheme._(); // Private constructor to prevent instantiation

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true, // Use Material 3 design principles
    fontFamily: 'Poppins', // Set the default font family
    colorScheme: SDeckAppColors.lightTheme, // Use our custom light color scheme
    textTheme: SDeckTypography.lightTextTheme, // Use our custom typography
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true, // Use Material 3 design principles
    fontFamily: 'Poppins', // Set the default font family
    colorScheme: SDeckAppColors.darkTheme, // Use our custom dark color scheme
    textTheme: SDeckTypography.darkTextTheme, // Use our custom typography
  );
}
