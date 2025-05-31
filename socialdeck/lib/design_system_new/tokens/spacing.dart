/*----------------------------- spacing.dart --------------------------------*/
// Pure spacing tokens - size values only
// These are the standardized spacing/sizing values for the design system
// Based on 4px grid system for consistency
//
// Usage: These tokens are used by components for consistent spacing
// Use these instead of hardcoded values for better maintainability
/*--------------------------------------------------------------------------*/

/// Pure spacing tokens for the SocialDeck design system
/// Based on 4px grid system for consistent layout
class SDeckSpacing {
  SDeckSpacing._(); // Private constructor

  //*************************** Core Spacing Scale ***************************//
  static const double xxs = 2.0; // 2px - Minimal spacing
  static const double xs = 4.0; // 4px - Extra small
  static const double sm = 8.0; // 8px - Small
  static const double md = 12.0; // 12px - Medium
  static const double lg = 16.0; // 16px - Large
  static const double xl = 20.0; // 20px - Extra large
  static const double xxl = 24.0; // 24px - Double extra large
  static const double xxxl = 32.0; // 32px - Triple extra large

  //*************************** Component Spacing *****************************//
  // Common spacing patterns for components

  //----------------------------- Text Field Spacing -------------------------//
  static const double textFieldPaddingSmall = 8.0;
  static const double textFieldPaddingMedium = 12.0;
  static const double textFieldPaddingLarge = 16.0;

  //----------------------------- Button Spacing ------------------------------//
  static const double buttonPaddingSmall = 8.0;
  static const double buttonPaddingMedium = 12.0;
  static const double buttonPaddingLarge = 16.0;

  //----------------------------- Border Radius -------------------------------//
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusXXLarge = 24.0;

  //----------------------------- Icon Sizes ----------------------------------//
  static const double iconXSmall = 12.0;
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0; // Updated to match nav icon default
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
  static const double iconXXLarge = 64.0;

  //----------------------------- Font Sizes ----------------------------------//
  static const double fontSizeCaption = 12.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeBodyMedium = 16.0;
  static const double fontSizeHeading = 18.0;

  //----------------------------- Elevation ------------------------------------//
  static const double elevationNone = 0.0;
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 8.0;
  static const double elevationLarge = 16.0;
}
