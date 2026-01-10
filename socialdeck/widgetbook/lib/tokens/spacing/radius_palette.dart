/*----------------------------- radius_palette.dart --------------------------------*/
// Widgetbook use cases for Radius tokens
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'radius_display.dart';

/*----------------------------- Use Cases ------------------------------*/
@widgetbook.UseCase(name: 'Radius', type: RadiusDisplay)
Widget buildRadiusUseCase(BuildContext context) {
  return const RadiusDisplay();
}
