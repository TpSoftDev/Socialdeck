/*----------------------------- radius.dart ---------------------------------*/
// Radius tokens - Border radius values for components
// These tokens reference Size tokens directly.
// Matches Figma: Radius tokens (borderRadiusZero, borderRadius2, borderRadius4, etc.)
// Usage: BorderRadius.circular(SDeckRadius.borderRadius8)
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'size.dart';

//------------------------------- SDeckRadius ------------------------------//
class SDeckRadius {
  SDeckRadius._(); // Private constructor - prevents instantiation

  //*************************** Radius Scale **********************************//
  // Radius values reference Size tokens directly
  // Matches Figma: Border Radius tokens exactly
  static const double borderRadiusZero =
      SDeckSize.sizeZero; // borderRadiusZero → sizeZero (0)
  static const double borderRadius2 =
      SDeckSize.size2; // borderRadius2 → size2 (2)
  static const double borderRadius4 =
      SDeckSize.size4; // borderRadius4 → size4 (4)
  static const double borderRadius8 =
      SDeckSize.size8; // borderRadius8 → size8 (8)
  static const double borderRadius12 =
      SDeckSize.size12; // borderRadius12 → size12 (12)
  static const double borderRadius16 =
      SDeckSize.size16; // borderRadius16 → size16 (16)
  static const double borderRadius24 =
      SDeckSize.size24; // borderRadius24 → size24 (24)
  static const double borderRadius32 =
      SDeckSize.size32; // borderRadius32 → size32 (32)
  static const double borderRadius48 =
      SDeckSize.size48; // borderRadius48 → size48 (48)
}
