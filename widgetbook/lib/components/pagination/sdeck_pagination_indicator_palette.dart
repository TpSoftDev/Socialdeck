/*------------------ sdeck_pagination_indicator_palette.dart ----------------*/
// Widgetbook use cases for SDeckPaginationIndicator.
// Showcases dot-pill in different segment counts and active indices.
//
// Matches design system:
// lib/design_system/components/pagination/sdeck_pagination_indicator.dart
/*---------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:socialdeck/design_system/components/pagination/sdeck_pagination_indicator.dart';

/*----------------- SDeckPaginationIndicator Component Class ----------------*/
/// Marker class used by Widgetbook to group SDeckPaginationIndicator use cases.
class SDeckPaginationIndicatorComponent {}

/*----------------------------- Use Cases ----------------------------------*/

//----------------------------- Default (3 segments) -------------------------//
@widgetbook.UseCase(
  name: 'Default (3 segments, index 0)',
  type: SDeckPaginationIndicatorComponent,
)
Widget buildPaginationDefaultUseCase(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Center(
      child: SDeckPaginationIndicator(
        totalSegments: 3,
        currentIndex: 0,
      ),
    ),
  );
}

//----------------------------- Middle Segment Active ------------------------//
@widgetbook.UseCase(
  name: '3 segments, index 1',
  type: SDeckPaginationIndicatorComponent,
)
Widget buildPaginationMiddleUseCase(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Center(
      child: SDeckPaginationIndicator(
        totalSegments: 3,
        currentIndex: 1,
      ),
    ),
  );
}

//----------------------------- Last Segment Active --------------------------//
@widgetbook.UseCase(
  name: '5 segments, index 4',
  type: SDeckPaginationIndicatorComponent,
)
Widget buildPaginationLastUseCase(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24.0),
    child: Center(
      child: SDeckPaginationIndicator(
        totalSegments: 5,
        currentIndex: 4,
      ),
    ),
  );
}

//----------------------------- Interactive Knobs -------------------------//
@widgetbook.UseCase(
  name: 'Interactive Controls',
  type: SDeckPaginationIndicatorComponent,
)
Widget buildPaginationInteractiveUseCase(BuildContext context) {
  final int totalSegments = context.knobs
      .double
      .slider(
        label: 'Total segments',
        initialValue: 3,
        min: 1,
        max: 8,
        divisions: 7,
      )
      .round();

  final int currentIndex = context.knobs
      .double
      .slider(
        label: 'Current index',
        initialValue: 0,
        min: 0,
        max: 7,
        divisions: 7,
      )
      .round()
      .clamp(0, totalSegments - 1);

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Center(
      child: SDeckPaginationIndicator(
        totalSegments: totalSegments,
        currentIndex: currentIndex,
      ),
    ),
  );
}
