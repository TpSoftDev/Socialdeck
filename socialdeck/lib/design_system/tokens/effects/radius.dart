/*----------------------------- radius.dart ---------------------------------*/
// Radius tokens - Border radius values for components
// These tokens reference Size tokens with offset mapping (one step smaller).
// Matches Figma: Radius tokens (borderRadiusZero, borderRadiusXXS, etc.)
// Usage: BorderRadius.circular(SDeckRadius.s)
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import '../spacing/size.dart';

//------------------------------- SDeckRadius ------------------------------//
class SDeckRadius {
  SDeckRadius._(); // Private constructor - prevents instantiation

  //*************************** Radius Scale **********************************//
  // Radius values reference Size tokens with OFFSET mapping (one step smaller)
  static const double borderRadiusZero = SDeckSize.sizeZero; // borderRadiusZero → sizeZero (0)
  static const double borderRadiusXXS =  SDeckSize.sizeXXXS; // borderRadiusXXS → sizeXXXS (2)
  static const double borderRadiusXS = SDeckSize.sizeXXS; // borderRadiusXS → sizeXXS (4)
  static const double borderRadiusS = SDeckSize.sizeXS; // borderRadiusS → sizeXS (8)
  static const double borderRadiusM = SDeckSize.sizeS; // borderRadiusM → sizeS (12)
  static const double borderRadiusL = SDeckSize.sizeM; // borderRadiusL → sizeM (16)
  static const double borderRadiusXL = SDeckSize.sizeL; // borderRadiusXL → sizeL (24)
  static const double borderRadiusXXL = SDeckSize.sizeXL; // borderRadiusXXL → sizeXL (32)
  static const double borderRadiusXXXL = SDeckSize.sizeXXL; // borderRadiusXXXL → sizeXXL (48)
}
