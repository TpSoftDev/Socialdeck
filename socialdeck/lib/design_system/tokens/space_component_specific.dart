/*----------------------------- space_component_specific.dart -----------------*/
// Component-specific space values - Temporary file
// These values are kept temporarily to avoid breaking existing components.
// TODO: These will be refactored later when we update components to use
// semantic tokens (SDeckSpace.marginM, paddingM, etc.)
/*--------------------------------------------------------------------------*/
//-------------------------------- Imports --------------------------------//
import 'size.dart';

//------------------------------- SDeckSpaceComponentSpecific --------------//
class SDeckSpaceComponentSpecific {
  SDeckSpaceComponentSpecific._(); // Private constructor - prevents instantiation

  //*************************** Component-Specific Values ********************//
  // TODO: These will be refactored later when we update components
  // Keeping them temporarily to avoid breaking components
  //----------------------------- Text Field Values -------------------------//
  static const double textFieldPaddingSmallVertical = SDeckSize.sizeXS; // 8.0
  static const double textFieldPaddingSmallHorizontal = SDeckSize.sizeS; // 12.0
  static const double textFieldPaddingMediumVertical = SDeckSize.sizeS; // 12.0
  static const double textFieldPaddingMediumHorizontal =
      SDeckSize.sizeS; // 12.0 (FIX: was 16.0, need to verify in Figma)
  static const double textFieldPaddingLargeVertical = SDeckSize.sizeM; // 16.0
  static const double textFieldPaddingLargeHorizontal =
      SDeckSize.sizeM; // 16.0 (FIX: was 20.0, need to verify in Figma)

  //----------------------------- Button Values -----------------------------//
  static const double buttonPaddingSmallVertical = SDeckSize.sizeZero; // 0.0
  static const double buttonPaddingSmallHorizontal = SDeckSize.sizeXS; // 8.0
  static const double buttonPaddingMediumVertical = SDeckSize.sizeXS; // 8.0
  static const double buttonPaddingMediumHorizontal = SDeckSize.sizeM; // 16.0
  static const double buttonPaddingLargeVertical =
      SDeckSize.sizeM; // 16.0 (FIX: was 20.0, need to verify in Figma)
  static const double buttonPaddingLargeHorizontal = SDeckSize.sizeL; // 24.0

  //----------------------------- Button Icon Gap ---------------------------//
  static const double buttonIconGap = SDeckSize.sizeXXS; // 4.0

  //*************************** Icon Sizes ***********************************//
  static const double iconSmall = SDeckSize.sizeM; // 16.0
  static const double iconMedium = SDeckSize.sizeL; // 24.0
  static const double iconLarge =
      SDeckSize.sizeXXL; // 48.0 (FIX: was 36.0, need to verify in Figma)
  static const double iconXLarge = SDeckSize.sizeXXL; // 48.0
}
