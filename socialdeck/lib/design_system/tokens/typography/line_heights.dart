/*----------------------------- line_heights.dart --------------------------------*/
// Line Height Tokens - Typography foundation
// Defines all line heights used in the design system
// Matches Figma: Text Styles/Line Height/* variables
//
// Usage: These tokens are used by SDeckTypography to build TextTheme
// Components should use TextTheme styles, not these tokens directly
/*--------------------------------------------------------------------------*/

class SDeckLineHeights {
  SDeckLineHeights._(); // Private constructor 

  //*************************** Line Heights **********************************//
  // Line heights match Figma Text Styles exactly
  // Values are in pixels (Flutter converts to logical pixels automatically)
  // Line-height ratio multiplier: ~1.25

  //----------------------------- Headings -----------------------------------//
  // Matches Figma: Text Styles/Line Height/H1
  static const double h1 = 80.0;

  // Matches Figma: Text Styles/Line Height/H2
  static const double h2 = 60.0;

  // Matches Figma: Text Styles/Line Height/H3
  static const double h3 = 48.0;

  // Matches Figma: Text Styles/Line Height/H4
  static const double h4 = 40.0;

  // Matches Figma: Text Styles/Line Height/H5
  static const double h5 = 36.0;

  // Matches Figma: Text Styles/Line Height/H6
  static const double h6 = 30.0;

  //----------------------------- Body Text -----------------------------------//
  // Matches Figma: Text Styles/Line Height/Body Large
  static const double bodyLarge = 24.0;

  // Matches Figma: Text Styles/Line Height/Body Medium
  static const double bodyMedium = 22.0;

  // Matches Figma: Text Styles/Line Height/Body Small
  static const double bodySmall = 20.0;

  //----------------------------- Labels & Captions -------------------------//
  // Matches Figma: Text Styles/Line Height/Caption
  static const double caption = 18.0;

  // Matches Figma: Text Styles/Line Height/Footer (used for Label Small)
  static const double labelSmall = 16.0;

  // Note: Label Large uses the same line height as Caption (18px)
  // Matches Figma: Text Styles/Line Height/Caption
  static const double labelLarge = 18.0;
}
