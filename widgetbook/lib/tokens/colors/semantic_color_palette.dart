/*----------------------------- semantic_color_palette.dart --------------------------------*/
// Semantic Color Palette use cases for Widgetbook
// Displays Semantic Color Palette with light/dark mode comparisons
// Matches design system: lib/design_system/tokens/colors/colors_main_semantic.dart
// Matches Figma: Semantic Color Palette
//
// Usage: Shows Semantic Color Palette tokens organized by their purpose/meaning
/*--------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:socialdeck/design_system/tokens/colors/index.dart';
import 'semantic_color_display.dart';

/*----------------------------- SemanticColorPalette ------------------------------*/
/// Component for displaying Semantic Color Palette tokens
/// Shows all semantic colors organized by category with light/dark mode comparison
/// Matches Figma: Semantic Color Palette
class SemanticColorPalette {}

/*----------------------------- Use Cases ------------------------------*/
//*************************** Semantic Color Palette **************************//

//----------------------------- Background & Surface -------------------------------//
@widgetbook.UseCase(name: 'Background & Surface', type: SemanticColorPalette)
Widget buildBackgroundSurfaceUseCase(BuildContext context) {
  return SemanticColorDisplay.category(
    categoryName: 'Background & Surface',
    colors: [
      SemanticColorItem(
        name: 'surface',
        lightColor: SDeckSemanticColors.light.surface,
        darkColor: SDeckSemanticColors.dark.surface,
      ),
      SemanticColorItem(
        name: 'surfaceVariant',
        lightColor: SDeckSemanticColors.light.surfaceVariant,
        darkColor: SDeckSemanticColors.dark.surfaceVariant,
      ),
      SemanticColorItem(
        name: 'surfaceInverse',
        lightColor: SDeckSemanticColors.light.surfaceInverse,
        darkColor: SDeckSemanticColors.dark.surfaceInverse,
      ),
      SemanticColorItem(
        name: 'surfaceError',
        lightColor: SDeckSemanticColors.light.surfaceError,
        darkColor: SDeckSemanticColors.dark.surfaceError,
      ),
      SemanticColorItem(
        name: 'surfaceSuccess',
        lightColor: SDeckSemanticColors.light.surfaceSuccess,
        darkColor: SDeckSemanticColors.dark.surfaceSuccess,
      ),
      SemanticColorItem(
        name: 'surfaceWarning',
        lightColor: SDeckSemanticColors.light.surfaceWarning,
        darkColor: SDeckSemanticColors.dark.surfaceWarning,
      ),
      SemanticColorItem(
        name: 'surfaceInfo',
        lightColor: SDeckSemanticColors.light.surfaceInfo,
        darkColor: SDeckSemanticColors.dark.surfaceInfo,
      ),
      SemanticColorItem(
        name: 'surfaceLink',
        lightColor: SDeckSemanticColors.light.surfaceLink,
        darkColor: SDeckSemanticColors.dark.surfaceLink,
      ),
      SemanticColorItem(
        name: 'surfaceNote',
        lightColor: SDeckSemanticColors.light.surfaceNote,
        darkColor: SDeckSemanticColors.dark.surfaceNote,
      ),
    ],
  );
}

//----------------------------- Primary Colors -------------------------------//
@widgetbook.UseCase(name: 'Primary Colors', type: SemanticColorPalette)
Widget buildPrimaryColorsUseCase(BuildContext context) {
  return SemanticColorDisplay.category(
    categoryName: 'Primary Colors',
    colors: [
      SemanticColorItem(
        name: 'primary',
        lightColor: SDeckSemanticColors.light.primary,
        darkColor: SDeckSemanticColors.dark.primary,
      ),
      SemanticColorItem(
        name: 'onPrimary',
        lightColor: SDeckSemanticColors.light.onPrimary,
        darkColor: SDeckSemanticColors.dark.onPrimary,
      ),
    ],
  );
}

//----------------------------- Secondary Colors -------------------------------//
@widgetbook.UseCase(name: 'Secondary Colors', type: SemanticColorPalette)
Widget buildSecondaryColorsUseCase(BuildContext context) {
  return SemanticColorDisplay.category(
    categoryName: 'Secondary Colors',
    colors: [
      SemanticColorItem(
        name: 'secondary',
        lightColor: SDeckSemanticColors.light.secondary,
        darkColor: SDeckSemanticColors.dark.secondary,
      ),
      SemanticColorItem(
        name: 'secondaryVariant',
        lightColor: SDeckSemanticColors.light.secondaryVariant,
        darkColor: SDeckSemanticColors.dark.secondaryVariant,
      ),
    ],
  );
}

//----------------------------- Tertiary Colors -------------------------------//
@widgetbook.UseCase(name: 'Tertiary Colors', type: SemanticColorPalette)
Widget buildTertiaryColorsUseCase(BuildContext context) {
  return SemanticColorDisplay.category(
    categoryName: 'Tertiary Colors',
    colors: [
      SemanticColorItem(
        name: 'tertiary',
        lightColor: SDeckSemanticColors.light.tertiary,
        darkColor: SDeckSemanticColors.dark.tertiary,
      ),
      SemanticColorItem(
        name: 'tertiaryVariant',
        lightColor: SDeckSemanticColors.light.tertiaryVariant,
        darkColor: SDeckSemanticColors.dark.tertiaryVariant,
      ),
    ],
  );
}

//----------------------------- Outline & Misc -------------------------------//
@widgetbook.UseCase(name: 'Outline & Misc', type: SemanticColorPalette)
Widget buildOutlineMiscUseCase(BuildContext context) {
  return SemanticColorDisplay.category(
    categoryName: 'Outline & Misc',
    colors: [
      SemanticColorItem(
        name: 'outline',
        lightColor: SDeckSemanticColors.light.outline,
        darkColor: SDeckSemanticColors.dark.outline,
      ),
      SemanticColorItem(
        name: 'outlineVariant',
        lightColor: SDeckSemanticColors.light.outlineVariant,
        darkColor: SDeckSemanticColors.dark.outlineVariant,
      ),
      SemanticColorItem(
        name: 'shadow',
        lightColor: SDeckSemanticColors.light.shadow,
        darkColor: SDeckSemanticColors.dark.shadow,
      ),
      SemanticColorItem(
        name: 'scrim',
        lightColor: SDeckSemanticColors.light.scrim,
        darkColor: SDeckSemanticColors.dark.scrim,
      ),
    ],
  );
}

//----------------------------- Status Colors -------------------------------//
@widgetbook.UseCase(name: 'Status Colors', type: SemanticColorPalette)
Widget buildStatusColorsUseCase(BuildContext context) {
  return SemanticColorDisplay.category(
    categoryName: 'Status Colors',
    colors: [
      SemanticColorItem(
        name: 'error',
        lightColor: SDeckSemanticColors.light.error,
        darkColor: SDeckSemanticColors.dark.error,
      ),
      SemanticColorItem(
        name: 'success',
        lightColor: SDeckSemanticColors.light.success,
        darkColor: SDeckSemanticColors.dark.success,
      ),
      SemanticColorItem(
        name: 'warning',
        lightColor: SDeckSemanticColors.light.warning,
        darkColor: SDeckSemanticColors.dark.warning,
      ),
      SemanticColorItem(
        name: 'info',
        lightColor: SDeckSemanticColors.light.info,
        darkColor: SDeckSemanticColors.dark.info,
      ),
      SemanticColorItem(
        name: 'link',
        lightColor: SDeckSemanticColors.light.link,
        darkColor: SDeckSemanticColors.dark.link,
      ),
      SemanticColorItem(
        name: 'note',
        lightColor: SDeckSemanticColors.light.note,
        darkColor: SDeckSemanticColors.dark.note,
      ),
    ],
  );
}

