/*----------------------------- spacing.dart --------------------------------*/
// Spacing tokens for the SocialDeck design system
// Used for padding, margins, gaps, and layout spacing
//
// Usage: padding: EdgeInsets.all(SDeckSpacing.x16)
/*--------------------------------------------------------------------------*/

class SDeckSpacing {
  SDeckSpacing._(); // Private constructor

  //*************************** Spacing Scale *********************************//
  static const double x0 = 0.0; 
  static const double x4 = 4.0; 
  static const double x8 = 8.0; 
  static const double x6 = 6.0; 
  static const double x12 = 12.0; 
  static const double x16 = 16.0; 
  static const double x20 = 20.0; 
  static const double x24 = 24.0; 
  static const double x32 = 32.0; 
  static const double x40 = 40.0; 
  static const double x48 = 48.0; 
  static const double x56 = 56.0; 
  static const double x64 = 64.0; 
  static const double x72 = 72.0; 
  static const double x80 = 80.0; 
  static const double x88 = 88.0; 
  static const double x96 = 96.0; 

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
