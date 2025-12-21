/*----------------------------- space.dart ---------------------------------*/
// Space tokens - Semantic spacing tokens (margin, padding, gap)
// These tokens reference Size tokens as semantic aliases.
// Matches Figma: Space tokens (marginZero, marginXXS, paddingXS, gapM, etc.)
//
// Usage:
// - Use SDeckSpace.marginM for margins
// - Use SDeckSpace.paddingM for padding
// - Use SDeckSpace.gapM for gaps
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'size.dart';

//------------------------------- SDeckSpace ------------------------------//
class SDeckSpace {
  SDeckSpace._(); // Private constructor - prevents instantiation

  //*************************** Margin **********************************//
  // Margin values reference Size tokens (semantic aliases)
  static const double marginZero = SDeckSize.sizeZero; // marginZero → sizeZero (0)
  static const double marginXXS = SDeckSize.sizeXXS; // marginXXS → sizeXXS (4)
  static const double marginXS = SDeckSize.sizeXS; // marginXS → sizeXS (8)
  static const double marginS = SDeckSize.sizeS; // marginS → sizeS (12)
  static const double marginM = SDeckSize.sizeM; // marginM → sizeM (16)
  static const double marginL = SDeckSize.sizeL; // marginL → sizeL (24)
  static const double marginXL = SDeckSize.sizeXL; // marginXL → sizeXL (32)
  static const double marginXXL = SDeckSize.sizeXXL; // marginXXL → sizeXXL (48)

  //*************************** Padding **********************************//
  // Padding values reference Size tokens (semantic aliases)
  static const double paddingZero = SDeckSize.sizeZero; // paddingZero → sizeZero (0)
  static const double paddingXXS = SDeckSize.sizeXXS; // paddingXXS → sizeXXS (4)
  static const double paddingXS = SDeckSize.sizeXS; // paddingXS → sizeXS (8)
  static const double paddingS = SDeckSize.sizeS; // paddingS → sizeS (12)
  static const double paddingM = SDeckSize.sizeM; // paddingM → sizeM (16)
  static const double paddingL = SDeckSize.sizeL; // paddingL → sizeL (24)
  static const double paddingXL = SDeckSize.sizeXL; // paddingXL → sizeXL (32)
  static const double paddingXXL = SDeckSize.sizeXXL; // paddingXXL → sizeXXL (48)

  //*************************** Gap **********************************//
  // Gap values reference Size tokens (semantic aliases)
  static const double gapZero = SDeckSize.sizeZero; // gapZero → sizeZero (0)
  static const double gapXXS = SDeckSize.sizeXXS; // gapXXS → sizeXXS (4)
  static const double gapXS = SDeckSize.sizeXS; // gapXS → sizeXS (8)
  static const double gapS = SDeckSize.sizeS; // gapS → sizeS (12)
  static const double gapM = SDeckSize.sizeM; // gapM → sizeM (16)
  static const double gapL = SDeckSize.sizeL; // gapL → sizeL (24)
  static const double gapXL = SDeckSize.sizeXL; // gapXL → sizeXL (32)
  static const double gapXXL = SDeckSize.sizeXXL; // gapXXL → sizeXXL (48)
}
