/*----------------------------- font_weights.dart --------------------------------*/
// Font Weight Tokens - Typography foundation
// Defines all font weights used in the design system
// Matches Figma: Font weights (Bold: 700, SemiBold: 600, Medium: 500)
//
// Usage: These tokens are used by SDeckTypography to build TextTheme
// Components should use TextTheme styles, not these tokens directly
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

class SDeckFontWeights {
  SDeckFontWeights._(); // Private constructor - prevents instantiation

  //*************************** Font Weights **********************************//
  // Font weights match Figma Text Styles exactly
  // Values correspond to Poppins font weights defined in pubspec.yaml

  //----------------------------- Weight Values ------------------------------//
  // Matches Figma: Bold (700) - Used in H1, H2
  static const FontWeight bold = FontWeight.w700;

  // Matches Figma: SemiBold (600) - Used in H3, H4, H5, H6
  static const FontWeight semiBold = FontWeight.w600;

  // Matches Figma: Medium (500) - Used in Body Large, Body Medium, Body Small,
  // Caption, Label Large, Label Small
  static const FontWeight medium = FontWeight.w500;
}
