/*------------------------- theme_extensions_helper.dart -----------------------*/
// Helper extensions for easy ThemeExtension access
// Provides convenient getters on BuildContext for semantic and component colors
//
// Usage: context.semantic.surfaceError
//        context.component.inputIcon
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';
import '../tokens/colors/colors_main_semantic.dart';
import '../tokens/colors/colors_component_specific.dart';

//------------------------------- SDeckThemeExtension ------------------------//
extension SDeckThemeExtension on BuildContext {
  //*************************** Semantic Colors ******************************//
  /// Semantic colors - Matches Figma Collection: "Color - Semantic"
  /// Use for: surface, primary, error, success, warning, info, link, note, etc.
  ///
  /// Example: context.semantic.surfaceError
  ///          context.semantic.primary
  SDeckSemanticColors get semantic =>
      Theme.of(this).extension<SDeckSemanticColors>()!;

  //*************************** Component Colors *****************************//
  /// Component-specific colors - Matches Figma Collection: "Color - Component-Specific"
  /// Use for: inputIcon, solidButtonPrimarySurface, toastSurfaceError, etc.
  ///
  /// Example: context.component.inputIcon
  ///          context.component.solidButtonPrimarySurface
  SDeckComponentColors get component =>
      Theme.of(this).extension<SDeckComponentColors>()!;
}

