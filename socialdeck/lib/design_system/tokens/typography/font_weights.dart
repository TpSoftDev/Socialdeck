/*----------------------------- font_weights.dart ---------------------------------*/
// Font weight tokens define the thickness and emphasis of text across the design
// system. These weights correspond to Poppins font variants and are used to build
// the TextTheme hierarchy.
//
// Usage: These tokens are used by SDeckTypography to build TextTheme. Components
// should use TextTheme styles, not these tokens directly.
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';

//------------------------------- SDeckFontWeights ------------------------------//
class SDeckFontWeights {
  SDeckFontWeights._();

  //*************************** Font Weights **********************************//
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight medium = FontWeight.w500;
}
