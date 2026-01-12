/*----------------------------- sdeck_input_palette.dart --------------------------------*/
// Widgetbook use cases for SDeckInput component
// Shows all states, sizes, and variations of the input component
// Matches design system: lib/design_system/components/inputs/sdeck_input.dart
//
// Usage: Run build_runner to generate catalog, then view in Widgetbook
/*--------------------------------------------------------------------------*/

/*----------------------------- Imports -------------------------------------*/
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:socialdeck/design_system/components/inputs/sdeck_input.dart';
import 'package:socialdeck/design_system/components/inputs/input_enums.dart';

/*----------------------------- SDeckInput Component Class ------------------------------*/
/// Component class for Widgetbook catalog
/// This is just a marker class - Widgetbook uses it to group use cases
class SDeckInputComponent {}

/*----------------------------- Use Cases ------------------------------*/
//*************************** Basic States **************************//

//----------------------------- Hint State (Default) -------------------------------//
/// Shows the input in its default "hint" state
/// This is what users see when the field is empty and not focused
@widgetbook.UseCase(name: 'Hint State', type: SDeckInputComponent)
Widget buildHintStateUseCase(BuildContext context) {
  // Create a FocusNode for the input (required by SDeckInput)
  final focusNode = FocusNode();

  // Create a TextEditingController to manage the text
  final controller = TextEditingController();

  return Padding(
    padding: const EdgeInsets.all(24.0), // Add padding so we can see it clearly
    child: SDeckInput(
      label: 'Email',
      placeholder: 'Enter your email',
      state: SDeckInputState.hint, // This is the "hint" state
      size: SDeckInputSize.medium,
      focusNode: focusNode,
      controller: controller,
    ),
  );
}
