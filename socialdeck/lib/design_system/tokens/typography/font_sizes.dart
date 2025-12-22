/*----------------------------- font_sizes.dart --------------------------------*/
// Font Size Tokens - Typography foundation
// Defines all font sizes used in the design system
// Matches Figma: Text Styles/Font Size/* variables
//
// Usage: These tokens are used by SDeckTypography to build TextTheme
// Components should use TextTheme styles, not these tokens directly
/*--------------------------------------------------------------------------*/

class SDeckFontSizes {
  SDeckFontSizes._(); // Private constructor 

  //*************************** Font Sizes **********************************//
  // Font sizes match Figma Text Styles exactly
  // Values are in pixels (Flutter converts to logical pixels automatically)

  //----------------------------- Headings -----------------------------------//
  // Matches Figma: Text Styles/Font Size/H1
  static const double h1 = 64.0;

  // Matches Figma: Text Styles/Font Size/H2
  static const double h2 = 48.0;

  // Matches Figma: Text Styles/Font Size/H3
  static const double h3 = 40.0;

  // Matches Figma: Text Styles/Font Size/H4
  static const double h4 = 32.0;

  // Matches Figma: Text Styles/Font Size/H5
  static const double h5 = 28.0;

  // Matches Figma: Text Styles/Font Size/H6
  static const double h6 = 24.0;

  //----------------------------- Body Text -----------------------------------//
  // Matches Figma: Text Styles/Font Size/Body Large
  static const double bodyLarge = 20.0;

  // Matches Figma: Text Styles/Font Size/Body Medium
  static const double bodyMedium = 18.0;

  // Matches Figma: Text Styles/Font Size/Body Small
  static const double bodySmall = 16.0;

  //----------------------------- Labels & Captions -------------------------//
  // Matches Figma: Text Styles/Font Size/Caption
  static const double caption = 14.0;

  // Matches Figma: Text Styles/Font Size/Label Large
  static const double labelLarge = 14.0;

  // Matches Figma: Text Styles/Font Size/Label Small
  static const double labelSmall = 12.0;
}
