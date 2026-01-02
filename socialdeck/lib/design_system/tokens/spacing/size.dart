/*----------------------------- size.dart ---------------------------------*/
// Size tokens - Foundation layer for all design system tokens.
// These are the base numeric values that all other tokens reference.
// Matches Figma: Size tokens (sizeZero, size1, size2, size4, etc.)
// Usage: Other token classes (Space, Radius) reference these values.
// Components should typically use semantic tokens (SDeckSpace.margin16)
// rather than these base Size tokens directly.

class SDeckSize {
  SDeckSize._(); // Private constructor - prevents instantiation

  //*************************** Size Scale **********************************//
  // Base foundation values - single source of truth for all numeric values
  // Matches Figma: Size tokens exactly
  static const double sizeZero = 0.0; // 0 px
  static const double size1 = 1.0; // 1 px
  static const double size2 = 2.0; // 2 px
  static const double size3 = 3.0; // 3 px
  static const double size4 = 4.0; // 4 px
  static const double size8 = 8.0; // 8 px
  static const double size12 = 12.0; // 12 px
  static const double size16 = 16.0; // 16 px
  static const double size24 = 24.0; // 24 px
  static const double size32 = 32.0; // 32 px
  static const double size48 = 48.0; // 48 px
  static const double size64 = 64.0; // 64 px
  static const double size80 = 80.0; // 80 px
  static const double size96 = 96.0; // 96 px
  static const double size108 = 108.0; // 108 px
  static const double size120 = 120.0; // 120 px
}
