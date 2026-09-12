/*------------------ sdeck_selection_target_card_palette.dart ----------------*/
// Widgetbook use cases for SDeckSelectionTargetCard.
// Demonstrates the "Create Party" / "Join a Party" home action cards in their
// default and interactive forms.
//
// Matches design system:
// lib/design_system/components/selection_target/sdeck_selection_target_card.dart
/*-----------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:socialdeck/design_system/components/selection_target/sdeck_selection_target_card.dart';
import 'package:socialdeck/design_system/tokens/icons/icon_paths.dart';

/*----------------- SDeckSelectionTargetCard Component Class ----------------*/
class SDeckSelectionTargetCardComponent {}

/*----------------------------- Use Cases ----------------------------------*/

//----------------------------- Create Party --------------------------------//
@widgetbook.UseCase(
  name: 'Create Party',
  type: SDeckSelectionTargetCardComponent,
)
Widget buildSelectionTargetCreateUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SDeckSelectionTargetCard(
      title: 'Create Party',
      description: 'Start a new game',
      backgroundAssetPath: SDeckIcon.checkeredBackground,
      onTap: () {},
    ),
  );
}

//----------------------------- Join a Party --------------------------------//
@widgetbook.UseCase(
  name: 'Join a Party',
  type: SDeckSelectionTargetCardComponent,
)
Widget buildSelectionTargetJoinUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SDeckSelectionTargetCard(
      title: 'Join a Party',
      description: 'Insert a game code',
      backgroundAssetPath: SDeckIcon.checkeredBackground,
      onTap: () {},
    ),
  );
}

//----------------------------- Empty Background ----------------------------//
@widgetbook.UseCase(
  name: 'Empty background',
  type: SDeckSelectionTargetCardComponent,
)
Widget buildSelectionTargetEmptyUseCase(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16.0),
    child: SDeckSelectionTargetCard(
      title: 'Section title',
      description: 'Supporting description text',
    ),
  );
}

//----------------------------- Interactive Knobs ---------------------------//
@widgetbook.UseCase(
  name: 'Interactive Controls',
  type: SDeckSelectionTargetCardComponent,
)
Widget buildSelectionTargetInteractiveUseCase(BuildContext context) {
  final String title = context.knobs.string(
    label: 'Title',
    initialValue: 'Create Party',
  );
  final String description = context.knobs.string(
    label: 'Description',
    initialValue: 'Start a new game',
  );
  final bool showBackground = context.knobs.boolean(
    label: 'Show placeholder background',
    initialValue: true,
  );

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SDeckSelectionTargetCard(
      title: title,
      description: description,
      backgroundAssetPath:
          showBackground ? SDeckIcon.checkeredBackground : null,
      onTap: () {},
    ),
  );
}
