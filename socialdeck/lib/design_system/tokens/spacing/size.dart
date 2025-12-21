/*----------------------------- size.dart ---------------------------------*/
// Size tokens - Foundation layer for all design system tokens.
// These are the base numeric values that all other tokens reference.
// Matches Figma: Size tokens (sizeZero, sizeXXXS, sizeXXS, etc.)
// Usage: Other token classes (Space, Radius, Control) reference these values.
// Components should typically use semantic tokens (SDeckSpace.marginM)
// rather than these base Size tokens directly.

class SDeckSize {
  SDeckSize._(); // Private constructor - prevents instantiation

  //*************************** Size Scale **********************************//
  // Base foundation values - single source of truth for all numeric values
  static const double sizeZero = 0.0;
  static const double sizeXXXS = 2.0;
  static const double sizeXXS = 4.0;
  static const double sizeXS = 8.0;
  static const double sizeS = 12.0;
  static const double sizeM = 16.0;
  static const double sizeL = 24.0;
  static const double sizeXL = 32.0;
  static const double sizeXXL = 48.0;
  static const double sizeXXXL = 64.0;
}
