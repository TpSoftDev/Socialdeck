/*----------------------------- space.dart ---------------------------------*/
// Space tokens - Semantic spacing tokens (margin, padding, gap)
// These tokens reference Size tokens as semantic aliases.
// Matches Figma: Space tokens (marginZero, margin4, padding8, gap16, etc.)
//
// Usage:
// - Use SDeckSpace.margin16 for margins
// - Use SDeckSpace.padding16 for padding
// - Use SDeckSpace.gap16 for gaps
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'size.dart';

//------------------------------- SDeckSpace ------------------------------//
class SDeckSpace {
  SDeckSpace._(); // Private constructor - prevents instantiation

  //*************************** Margin **********************************//
  // Margin values reference Size tokens (semantic aliases)
  // Matches Figma: Margin tokens exactly
  static const double marginZero = SDeckSize.sizeZero; // marginZero → sizeZero (0)
  static const double margin4 = SDeckSize.size4; // margin4 → size4 (4)
  static const double margin8 = SDeckSize.size8; // margin8 → size8 (8)
  static const double margin12 = SDeckSize.size12; // margin12 → size12 (12)
  static const double margin16 = SDeckSize.size16; // margin16 → size16 (16)
  static const double margin24 = SDeckSize.size24; // margin24 → size24 (24)
  static const double margin32 = SDeckSize.size32; // margin32 → size32 (32)
  static const double margin48 = SDeckSize.size48; // margin48 → size48 (48)

  //*************************** Padding **********************************//
  // Padding values reference Size tokens (semantic aliases)
  // Matches Figma: Padding tokens exactly
  static const double paddingZero = SDeckSize.sizeZero; // paddingZero → sizeZero (0)
  static const double padding4 = SDeckSize.size4; // padding4 → size4 (4)
  static const double padding8 = SDeckSize.size8; // padding8 → size8 (8)
  static const double padding12 = SDeckSize.size12; // padding12 → size12 (12)
  static const double padding16 = SDeckSize.size16; // padding16 → size16 (16)
  static const double padding24 = SDeckSize.size24; // padding24 → size24 (24)
  static const double padding32 = SDeckSize.size32; // padding32 → size32 (32)
  static const double padding48 = SDeckSize.size48; // padding48 → size48 (48)

  //*************************** Gap **********************************//
  // Gap values reference Size tokens (semantic aliases)
  // Matches Figma: Gap tokens exactly
  static const double gapZero = SDeckSize.sizeZero; // gapZero → sizeZero (0)
  static const double gap4 = SDeckSize.size4; // gap4 → size4 (4)
  static const double gap8 = SDeckSize.size8; // gap8 → size8 (8)
  static const double gap12 = SDeckSize.size12; // gap12 → size12 (12)
  static const double gap16 = SDeckSize.size16; // gap16 → size16 (16)
  static const double gap24 = SDeckSize.size24; // gap24 → size24 (24)
  static const double gap32 = SDeckSize.size32; // gap32 → size32 (32)
  static const double gap48 = SDeckSize.size48; // gap48 → size48 (48)
}
