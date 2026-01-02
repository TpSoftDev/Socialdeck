/*----------------------------- theme_extensions_helper.dart -------------------------*/
// Helper extensions provide convenient access to ThemeExtensions via BuildContext,
// eliminating the need for verbose Theme.of(context).extension<>() calls throughout
// the codebase. These extensions enable clean, readable access to semantic and
// component-specific colors.
//
// Usage:
//   context.semantic.surfaceError
//   context.component.inputIcon
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';
import '../tokens/colors/colors_main_semantic.dart';
import '../tokens/colors/colors_component_specific.dart';

//------------------------------- SDeckThemeExtension ------------------------//
extension SDeckThemeExtension on BuildContext {
  //*************************** Semantic Colors ******************************//
  /// Provides access to semantic color tokens.
  /// Use for: surface, primary, error, success, warning, info, link, note, etc.
  ///
  /// Example: context.semantic.surfaceError
  ///          context.semantic.primary
  SDeckSemanticColors get semantic =>
      Theme.of(this).extension<SDeckSemanticColors>()!;

  //*************************** Component Colors *****************************//
  /// Provides access to component-specific color tokens.
  /// Use for: inputIcon, solidButtonPrimarySurface, toastSurfaceError, etc.
  ///
  /// Example: context.component.inputIcon
  ///          context.component.solidButtonPrimarySurface
  SDeckComponentColors get component =>
      Theme.of(this).extension<SDeckComponentColors>()!;
}
