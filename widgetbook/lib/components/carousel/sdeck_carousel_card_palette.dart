/*--------------------- sdeck_carousel_card_palette.dart -------------------*/
// Widgetbook use cases for SDeckCarouselCard.
// Showcases the carousel framed card with title, description, pagination dots,
// and prev/next chevrons. Includes both empty (placeholder) and image-backed
// variants, plus an interactive playground driven by knobs.
//
// Matches design system:
// lib/design_system/components/carousel/sdeck_carousel_card.dart
/*---------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:socialdeck/design_system/components/carousel/sdeck_carousel_card.dart';
import 'package:socialdeck/design_system/tokens/icons/icon_paths.dart';

/*----------------- SDeckCarouselCard Component Class ----------------------*/
/// Marker class used by Widgetbook to group SDeckCarouselCard use cases.
class SDeckCarouselCardComponent {}

/*----------------------------- Use Cases ----------------------------------*/

//----------------------------- Default ("What's New?") ----------------------//
@widgetbook.UseCase(
  name: "Default - What's New?",
  type: SDeckCarouselCardComponent,
)
Widget buildCarouselDefaultUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      height: 370,
      child: SDeckCarouselCard(
        title: "What's New?",
        description: "Here's an update on what's going on...",
        totalSegments: 3,
        currentIndex: 0,
        backgroundAssetPath: SDeckIcon.checkeredBackground,
        onPrevious: () {},
        onNext: () {},
      ),
    ),
  );
}

//----------------------------- Empty Background ----------------------------//
/// No background image - shows just the surface color, useful for verifying
/// the empty/placeholder state of the carousel.
@widgetbook.UseCase(
  name: 'Empty background',
  type: SDeckCarouselCardComponent,
)
Widget buildCarouselEmptyUseCase(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SizedBox(
      height: 370,
      child: SDeckCarouselCard(
        title: 'Loading content',
        description: 'A title and description placeholder.',
        totalSegments: 3,
        currentIndex: 1,
      ),
    ),
  );
}

//----------------------------- Interactive Knobs -------------------------//
@widgetbook.UseCase(
  name: 'Interactive Controls',
  type: SDeckCarouselCardComponent,
)
Widget buildCarouselInteractiveUseCase(BuildContext context) {
  final String title = context.knobs.string(
    label: 'Title',
    initialValue: "What's New?",
  );
  final String description = context.knobs.string(
    label: 'Description',
    initialValue: "Here's an update on what's going on...",
  );

  final int totalSegments = context.knobs
      .double
      .slider(
        label: 'Total segments',
        initialValue: 3,
        min: 1,
        max: 6,
        divisions: 5,
      )
      .round();

  final int currentIndex = context.knobs
      .double
      .slider(
        label: 'Current index',
        initialValue: 0,
        min: 0,
        max: 5,
        divisions: 5,
      )
      .round()
      .clamp(0, totalSegments - 1);

  final double height = context.knobs.double.slider(
    label: 'Height',
    initialValue: 370,
    min: 200,
    max: 600,
  );

  final bool showBackground = context.knobs.boolean(
    label: 'Show placeholder background',
    initialValue: true,
  );

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SDeckCarouselCard(
      title: title,
      description: description,
      totalSegments: totalSegments,
      currentIndex: currentIndex,
      height: height,
      backgroundAssetPath:
          showBackground ? SDeckIcon.checkeredBackground : null,
      onPrevious: () {},
      onNext: () {},
    ),
  );
}
