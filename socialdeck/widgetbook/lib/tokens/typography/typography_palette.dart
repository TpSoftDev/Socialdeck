/*----------------------------- typography_palette.dart --------------------------------*/
// Typography use cases for Widgetbook
// Displays Typography tokens (Text Styles) with properties and examples
// Matches design system: lib/design_system/tokens/typography/
// Matches Figma: Text Styles
//
// Usage: Shows all typography text styles organized by type
/*--------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'typography_display.dart';

/*----------------------------- TypographyPalette ------------------------------*/
/// Component for displaying Typography tokens
/// Shows all text styles with their properties and visual examples
/// Matches Figma: Text Styles
class TypographyPalette {}

/*----------------------------- Use Cases ------------------------------*/
//*************************** Typography **************************//

@widgetbook.UseCase(name: 'All Text Styles', type: TypographyPalette)
Widget buildTypographyUseCase(BuildContext context) {
  return const TypographyDisplay();
}
