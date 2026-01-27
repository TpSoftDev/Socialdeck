/*----------------------------- size_palette.dart --------------------------------*/
// Widgetbook use cases for Size tokens
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'size_display.dart';

/*----------------------------- Use Cases ------------------------------*/
@widgetbook.UseCase(
  name: 'Size',
  type: SizeDisplay,
)
Widget buildSizeUseCase(BuildContext context) {
  return const SizeDisplay();
}

