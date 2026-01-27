/*------------------------------- colors/index.dart --------------------------------*/
// Colors barrel export file
// Exports all color tokens (Base, Brand, Semantic ThemeExtension, Component ThemeExtension)
// Single source of truth: ThemeExtensions only (matches Figma Collections)
/*--------------------------------------------------------------------------*/

export 'colors_base.dart';
export 'colors_brand.dart';
export 'colors_main_semantic.dart';
export 'colors_component_specific.dart';
// Re-export helpers for convenience (helper file located in design_system/helpers/)
export '../../helpers/theme_extensions_helper.dart';

// color_schemes.dart removed - using ThemeExtensions only (single source of truth)
