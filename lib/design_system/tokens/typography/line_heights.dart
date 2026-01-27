/*----------------------------- line_heights.dart ---------------------------------*/
// Line height tokens define the vertical spacing between lines of text, ensuring
// comfortable reading and visual consistency. Values are in pixels (Flutter
// converts to logical pixels automatically).
//
// Usage: These tokens are used by SDeckTypography to build TextTheme. Components
// should use TextTheme styles, not these tokens directly.
/*--------------------------------------------------------------------------*/

//------------------------------- SDeckLineHeights ------------------------------//
class SDeckLineHeights {
  SDeckLineHeights._();

  //*************************** Line Heights **********************************//

  //----------------------------- Headings -----------------------------------//
  static const double h1 = 80.0;
  static const double h2 = 60.0;
  static const double h3 = 48.0;
  static const double h4 = 40.0;
  static const double h5 = 36.0;
  static const double h6 = 30.0;

  //----------------------------- Body Text -----------------------------------//
  static const double bodyLarge = 24.0;
  static const double bodyMedium = 22.0;
  static const double bodySmall = 20.0;

  //----------------------------- Labels & Captions -------------------------//
  static const double caption = 18.0;
  static const double labelLarge = 18.0;
  static const double labelSmall = 16.0;
}
