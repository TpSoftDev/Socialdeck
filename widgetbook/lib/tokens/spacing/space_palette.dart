/*----------------------------- space_palette.dart --------------------------------*/
// Widgetbook use cases for Space tokens
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'space_display.dart';

/*----------------------------- Use Cases ------------------------------*/
@widgetbook.UseCase(
  name: 'Space',
  type: SpaceDisplay,
)
Widget buildSpaceUseCase(BuildContext context) {
  return const SpaceDisplay();
}

