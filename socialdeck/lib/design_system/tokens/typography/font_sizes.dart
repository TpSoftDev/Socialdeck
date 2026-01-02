/*----------------------------- font_sizes.dart ---------------------------------*/
// Font size tokens define the scale of text across the design system, creating
// visual hierarchy and consistent typography. Values are in pixels (Flutter
// converts to logical pixels automatically).
//
// Usage: These tokens are used by SDeckTypography to build TextTheme. Components
// should use TextTheme styles, not these tokens directly.
/*--------------------------------------------------------------------------*/

//------------------------------- SDeckFontSizes ------------------------------//
class SDeckFontSizes {
  SDeckFontSizes._();

  //*************************** Font Sizes **********************************//

  //----------------------------- Headings -----------------------------------//
  static const double h1 = 64.0;
  static const double h2 = 48.0;
  static const double h3 = 40.0;
  static const double h4 = 32.0;
  static const double h5 = 28.0;
  static const double h6 = 24.0;

  //----------------------------- Body Text -----------------------------------//
  static const double bodyLarge = 20.0;
  static const double bodyMedium = 18.0;
  static const double bodySmall = 16.0;

  //----------------------------- Labels & Captions -------------------------//
  static const double caption = 14.0;
  static const double labelLarge = 14.0;
  static const double labelSmall = 12.0;
}
