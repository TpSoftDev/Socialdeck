/*----------------------------- colors_component_specific.dart -----------------*/
// Component-Specific Color Palette - Component layer
// Maps component-specific names to Main Semantic Color Palette
//
// This is an extension of ColorScheme that adds component-specific color getters
// matching Figma's "Component-Specific Color Palette". When designer specifies
// component color names in Figma (e.g., "inputIcon"), developers can use the
// exact same names in code, keeping design and code in sync.
//
// Note: Only includes components that are COMPLETE in Figma
// Incomplete components remain in color_extensions.dart
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import 'colors_main_semantic.dart';
import 'colors_brand.dart';

//------------------------ SDeckComponentSpecificColors Extension ------------//
// Extension of ColorScheme that adds component-specific color getters
// Extension name matches Figma: "Component-Specific Color Palette"
extension SDeckComponentSpecificColors on ColorScheme {
  //*************************** Solid Button Component **************************//

  Color get solidButtonPrimarySurface => SDeckMainSemanticColors.primary(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get solidButtonPrimarySurfaceHover => SDeckBrandColors.coolGrayDark(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get solidButtonPrimarySurfacePressed => SDeckBrandColors.coolGrayDark(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get solidButtonSurfaceDisabled => SDeckBrandColors.coolGray(brightness);
  Color get solidButtonIcon => SDeckMainSemanticColors.onPrimary(brightness);
  Color get solidButtonText => SDeckMainSemanticColors.onPrimary(brightness);
  /// Note: Figma has typo "soild" instead of "solid"
  Color get soildButtonBorder => SDeckMainSemanticColors.outlineVariant(brightness);

  //*************************** Outline Button Component ************************//

  Color get outlineButtonPrimarySurface =>SDeckMainSemanticColors.background(brightness);
  Color get outlineButtonIcon => SDeckMainSemanticColors.primary(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get outlineButtonIconDisabled => SDeckBrandColors.coolGray(brightness);
  Color get outlineButtonText => SDeckMainSemanticColors.primary(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get outlineButtonTextDisabled => SDeckBrandColors.coolGray(brightness);
  Color get outlineButtonBorder => SDeckMainSemanticColors.outline(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get outlineButtonBorderHover => SDeckBrandColors.coolGray(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get outlineButtonBorderPressed => SDeckBrandColors.coolGray(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get outlineButtonBorderDisabled => SDeckBrandColors.coolGrayLight(brightness);

  //*************************** Text Button Component **************************//

  Color get textButtonIcon => SDeckMainSemanticColors.primary(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get textButtonIconHover => SDeckBrandColors.coolGrayDark(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get textButtonIconPressed => SDeckBrandColors.coolGrayDark(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get textButtonIconDisabled => SDeckBrandColors.coolGray(brightness);
  Color get textButtonText => SDeckMainSemanticColors.primary(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get textButtonTextHover => SDeckBrandColors.coolGrayDark(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get textButtonTextPressed => SDeckBrandColors.coolGrayDark(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get textButtonTextDisabled => SDeckBrandColors.coolGray(brightness);

  //*************************** Input Component **********************************//

  Color get inputSurface => SDeckMainSemanticColors.surface(brightness);
  Color get inputSurfaceDisabled => SDeckMainSemanticColors.surfaceVariant(brightness);
  Color get inputSurfaceError => SDeckMainSemanticColors.error(brightness);
  Color get inputIcon => SDeckMainSemanticColors.onSurface(brightness);
  Color get inputIconError => SDeckMainSemanticColors.onError(brightness);
  Color get inputIconDisabled => SDeckMainSemanticColors.onSurfaceVariant(brightness);
  Color get inputText => SDeckMainSemanticColors.onSurface(brightness);
  Color get inputTextHint => SDeckMainSemanticColors.onSurfaceVariant(brightness);
  Color get inputTextDisabled => SDeckMainSemanticColors.onSurfaceVariant(brightness);
  Color get inputLabel => SDeckMainSemanticColors.primary(brightness);
  Color get inputSupportingText => SDeckMainSemanticColors.secondary(brightness);
  Color get inputSupportingTextError => SDeckMainSemanticColors.onError(brightness);
  Color get inputSupportingTextDisabled => SDeckMainSemanticColors.onSurfaceVariant(brightness);
  Color get inputOutline => SDeckMainSemanticColors.outline(brightness);
  /// TODO: Should map to semantic color instead of brand color
  Color get inputOutlineFocused => SDeckBrandColors.skyBlue(brightness);
  Color get inputOutlineDisabled => SDeckMainSemanticColors.onSurfaceVariant(brightness);
  Color get inputOutlineError => SDeckMainSemanticColors.onError(brightness);
}
