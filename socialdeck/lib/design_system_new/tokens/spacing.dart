/*----------------------------- spacing.dart --------------------------------*/
// Essential spacing values for the SocialDeck design system
// Contains only Figma-exact measurements and commonly used values
// Keeps things simple while maintaining consistency
//
// Usage: Only use these for values that are repeated across components
/*--------------------------------------------------------------------------*/

/// Essential spacing tokens for the SocialDeck design system
/// Only contains values that are actually needed and used multiple times
class SDeckSpacing {
  SDeckSpacing._(); // Private constructor

  //*************************** Text Field Values (From Figma) ***************//
  // Exact measurements from your Figma text field component

  //----------------------------- Text Field Padding -------------------------//
  static const double textFieldPaddingSmallVertical = 8.0;
  static const double textFieldPaddingSmallHorizontal = 12.0;
  static const double textFieldPaddingMediumVertical = 12.0;
  static const double textFieldPaddingMediumHorizontal = 16.0;
  static const double textFieldPaddingLargeVertical = 16.0;
  static const double textFieldPaddingLargeHorizontal = 20.0;

  //----------------------------- Text Field Border Radius -------------------//
  static const double textFieldRadiusSmall = 20.0; // Small inner frame
  static const double textFieldRadiusMedium = 24.0; // Medium inner frame
  static const double textFieldRadiusLarge = 28.0; // Large inner frame

  //*************************** Icon Sizes (From Old System) *****************//
  // Your established icon sizes - kept for consistency
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;

  //*************************** Common Values *********************************//
  // Only the most frequently used values across components
  static const double radiusSmall = 8.0; // Used for outer text field border
  static const double md = 12.0; // Used for icon padding in text fields
}
