/*----------------------------- control.dart ------------------------------*/
// Control size tokens - For control-specific sizing contexts.
// These tokens reference Size tokens with a 1:1 mapping.
// Matches Figma: Control tokens (controlXXS, controlXS, etc.)
// Usage: Use these for control-specific sizing needs.
/*--------------------------------------------------------------------------*/
//-------------------------------- Imports --------------------------------//
import 'size.dart';

//------------------------------- SDeckControl ------------------------------//
class SDeckControl {
  SDeckControl._(); // Private constructor - prevents instantiation

  //*************************** Control Scale *******************************//
  // Control sizes reference Size tokens with 1:1 mapping
  static const double controlXXS =
      SDeckSize.sizeXXXS; // controlXXS → sizeXXXS (2.0)
  static const double controlXS =
      SDeckSize.sizeXXS; // controlXS → sizeXXS (4.0)
  static const double controlS = SDeckSize.sizeXS; // controlS → sizeXS (8.0)
  static const double controlM = SDeckSize.sizeM; // controlM → sizeM (16.0)
  static const double controlL = SDeckSize.sizeL; // controlL → sizeL (24.0)
  static const double controlXL = SDeckSize.sizeXL; // controlXL → sizeXL (32.0)
  static const double controlXXL =
      SDeckSize.sizeXXL; // controlXXL → sizeXXL (48.0)
}
