/*----------------------------- spacing.dart --------------------------------*/
// Spacing tokens for the SocialDeck design system
// These values match the Figma spacing collection exactly
// Used for padding, margins, gaps, and layout spacing
//
// Usage: padding: EdgeInsets.all(SDeckSpacing.x16)
/*--------------------------------------------------------------------------*/

/// Spacing tokens for the SocialDeck design system
/// These represent the spacing scale from Figma
class SDeckSpacing {
  SDeckSpacing._(); // Private constructor

  //*************************** Spacing Scale *********************************//
  static const double x0 = 0.0; // Number/0
  static const double x4 = 4.0; // Number/50 (4)
  static const double x8 = 8.0; // Number/100 (8)
  static const double x12 = 12.0; // Number/150 (12)
  static const double x16 = 16.0; // Number/200 (16)
  static const double x20 = 20.0; // Number/250 (20)
  static const double x24 = 24.0; // Number/300 (24)
  static const double x32 = 32.0; // Number/400 (32)
  static const double x40 = 40.0; // Number/500 (40)
  static const double x48 = 48.0; // Number/600 (48)
  static const double x56 = 56.0; // Number/700 (56)
  static const double x64 = 64.0; // Number/800 (64)
  static const double x72 = 72.0; // Number/900 (72)
  static const double x80 = 80.0; // Number/1000 (80)
  static const double x88 = 88.0; // Number/1100 (88)
  static const double x96 = 96.0; // Number/1200 (96)

  //*************************** Component-Specific Values ********************//
  //----------------------------- Text Field Values (From Figma) -------------//
  static const double textFieldPaddingSmallVertical = 8.0;
  static const double textFieldPaddingSmallHorizontal = 12.0;
  static const double textFieldPaddingMediumVertical = 12.0;
  static const double textFieldPaddingMediumHorizontal = 16.0;
  static const double textFieldPaddingLargeVertical = 16.0;
  static const double textFieldPaddingLargeHorizontal = 20.0;

  //----------------------------- Button Values (From Figma) -----------------//
  static const double buttonPaddingSmallVertical = 0.0;
  static const double buttonPaddingSmallHorizontal = 8.0;
  static const double buttonPaddingMediumVertical = 8.0;
  static const double buttonPaddingMediumHorizontal = 16.0;
  static const double buttonPaddingLargeVertical = 20.0;
  static const double buttonPaddingLargeHorizontal = 24.0;

  //----------------------------- Button Icon Gap ----------------------------//
  static const double buttonIconGap = 4.0;

  //*************************** Icon Sizes ***********************************//
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 36.0;
  static const double iconXLarge = 48.0;
}
