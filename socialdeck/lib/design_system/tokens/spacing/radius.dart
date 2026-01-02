/*----------------------------- radius.dart ---------------------------------*/
// Radius tokens define the curvature of component corners, creating consistent
// rounding across elements and supporting the overall visual style and brand
// personality.
//
// These tokens reference Size tokens directly, providing semantic naming
// for border radius values.
//
// Usage: BorderRadius.circular(SDeckRadius.borderRadius8)
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'size.dart';

//------------------------------- SDeckRadius ------------------------------//
class SDeckRadius {
  SDeckRadius._();

  //*************************** Radius Scale **********************************//
  static const double borderRadiusZero = SDeckSize.sizeZero;
  static const double borderRadius2 = SDeckSize.size2;
  static const double borderRadius4 = SDeckSize.size4;
  static const double borderRadius8 = SDeckSize.size8;
  static const double borderRadius12 = SDeckSize.size12;
  static const double borderRadius16 = SDeckSize.size16;
  static const double borderRadius24 = SDeckSize.size24;
  static const double borderRadius32 = SDeckSize.size32;
  static const double borderRadius48 = SDeckSize.size48;
}
