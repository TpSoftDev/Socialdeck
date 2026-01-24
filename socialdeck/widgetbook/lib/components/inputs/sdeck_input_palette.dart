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
import 'package:widgetbook/widgetbook.dart';
import 'package:socialdeck/design_system/components/inputs/sdeck_input.dart';
import 'package:socialdeck/design_system/components/inputs/input_enums.dart';

/*----------------------------- SDeckInput Component Class ------------------------------*/
/// Component class for Widgetbook catalog
/// This is just a marker class - Widgetbook uses it to group use cases
class SDeckInputComponent {}

/*----------------------------- Helper Functions ------------------------------*/
/// Helper to parse state string to enum
SDeckInputState _parseState(String state) {
  switch (state.toLowerCase()) {
    case 'hint':
      return SDeckInputState.hint;
    case 'focused':
      return SDeckInputState.focused;
    case 'filled':
      return SDeckInputState.filled;
    case 'disabled':
      return SDeckInputState.disabled;
    case 'error':
      return SDeckInputState.error;
    default:
      return SDeckInputState.hint;
  }
}

/// Helper to parse size string to enum
SDeckInputSize _parseSize(String size) {
  switch (size.toLowerCase()) {
    case 'medium':
      return SDeckInputSize.medium;
    case 'large':
      return SDeckInputSize.large;
    default:
      return SDeckInputSize.medium;
  }
}

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

//----------------------------- Focused State -------------------------------//
/// Shows the input in "focused" state
/// This is what users see when the keyboard is up and they're actively typing
@widgetbook.UseCase(name: 'Focused State', type: SDeckInputComponent)
Widget buildFocusedStateUseCase(BuildContext context) {
  final focusNode = FocusNode();
  final controller = TextEditingController();

  // Automatically focus the field to show focused state
  // Note: In Widgetbook, we manually set the state to show the visual appearance
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: SDeckInput(
      label: 'Email',
      placeholder: 'Enter your email',
      state: SDeckInputState.focused, // Focused state - keyboard is up
      size: SDeckInputSize.medium,
      focusNode: focusNode,
      controller: controller,
    ),
  );
}

//----------------------------- Filled State -------------------------------//
/// Shows the input in "filled" state
/// This is what users see when they've entered text and keyboard is down
@widgetbook.UseCase(name: 'Filled State', type: SDeckInputComponent)
Widget buildFilledStateUseCase(BuildContext context) {
  final focusNode = FocusNode();
  final controller = TextEditingController(
    text: 'user@example.com',
  ); // Pre-fill with text

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: SDeckInput(
      label: 'Email',
      placeholder: 'Enter your email',
      state: SDeckInputState.filled, // Filled state - has text, not focused
      size: SDeckInputSize.medium,
      focusNode: focusNode,
      controller: controller,
    ),
  );
}

//----------------------------- Disabled State -------------------------------//
/// Shows the input in "disabled" state
/// This is what users see when the field is not interactive
@widgetbook.UseCase(name: 'Disabled State', type: SDeckInputComponent)
Widget buildDisabledStateUseCase(BuildContext context) {
  final focusNode = FocusNode();
  final controller = TextEditingController();

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: SDeckInput(
      label: 'Email',
      placeholder: 'Enter your email',
      state: SDeckInputState.disabled, // Disabled state - not interactive
      size: SDeckInputSize.medium,
      focusNode: focusNode,
      controller: controller,
    ),
  );
}

//----------------------------- Error State ----------------------------------//
/// Shows the input in "error" state
/// This is what users see when there's a validation error
@widgetbook.UseCase(name: 'Error State', type: SDeckInputComponent)
Widget buildErrorStateUseCase(BuildContext context) {
  final focusNode = FocusNode();
  final controller = TextEditingController(
    text: 'invalid-email',
  ); // Invalid input

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: SDeckInput(
      label: 'Email',
      placeholder: 'Enter your email',
      supportingText: 'Please enter a valid email address', // Error message
      state: SDeckInputState.error, // Error state - validation failed
      size: SDeckInputSize.medium,
      focusNode: focusNode,
      controller: controller,
    ),
  );
}

//*************************** Galleries & Variations **************************//

//----------------------------- Gallery: All States -------------------------------//
/// Shows all five states side by side for quick visual comparison
@widgetbook.UseCase(name: 'Gallery - All States', type: SDeckInputComponent)
Widget buildAllStatesGalleryUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SDeckInput(
          label: 'Email',
          placeholder: 'Enter your email',
          state: SDeckInputState.hint,
          size: SDeckInputSize.medium,
        ),
        const SizedBox(height: 16),
        SDeckInput(
          label: 'Email',
          placeholder: 'Enter your email',
          state: SDeckInputState.focused,
          size: SDeckInputSize.medium,
        ),
        const SizedBox(height: 16),
        SDeckInput(
          label: 'Email',
          placeholder: 'Enter your email',
          state: SDeckInputState.filled,
          size: SDeckInputSize.medium,
          controller: TextEditingController(text: 'user@example.com'),
        ),
        const SizedBox(height: 16),
        SDeckInput(
          label: 'Email',
          placeholder: 'Enter your email',
          state: SDeckInputState.disabled,
          size: SDeckInputSize.medium,
        ),
        const SizedBox(height: 16),
        SDeckInput(
          label: 'Email',
          placeholder: 'Enter your email',
          supportingText: 'Please enter a valid email address',
          state: SDeckInputState.error,
          size: SDeckInputSize.medium,
          controller: TextEditingController(text: 'invalid-email'),
        ),
      ],
    ),
  );
}

//----------------------------- Size Variations -------------------------------//
/// Shows medium vs large size for quick comparison
@widgetbook.UseCase(name: 'Sizes - Medium vs Large', type: SDeckInputComponent)
Widget buildSizeVariationsUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Medium'),
        const SizedBox(height: 8),
        SDeckInput(
          label: 'Email',
          placeholder: 'Enter your email',
          state: SDeckInputState.hint,
          size: SDeckInputSize.medium,
        ),
        const SizedBox(height: 24),
        const Text('Large'),
        const SizedBox(height: 8),
        SDeckInput(
          label: 'Email',
          placeholder: 'Enter your email',
          state: SDeckInputState.hint,
          size: SDeckInputSize.large,
        ),
      ],
    ),
  );
}

//----------------------------- ReadOnly maps to Disabled -------------------------------//
/// Shows readOnly=true mapping to disabled visual state
@widgetbook.UseCase(
  name: 'ReadOnly (Disabled Visual)',
  type: SDeckInputComponent,
)
Widget buildReadOnlyUseCase(BuildContext context) {
  final controller = TextEditingController(text: 'Read-only value');

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: SDeckInput(
      label: 'Email',
      placeholder: 'Enter your email',
      state: SDeckInputState.disabled,
      size: SDeckInputSize.medium,
      controller: controller,
      readOnly: true,
    ),
  );
}

//----------------------------- Interactive Knobs -------------------------------//
/// Interactive controls to tweak state, size, labels, and supporting text
@widgetbook.UseCase(name: 'Interactive Controls', type: SDeckInputComponent)
Widget buildInteractiveUseCase(BuildContext context) {
  // State dropdown - using string knob with manual conversion
  final stateString = context.knobs.string(
    label: 'State',
    initialValue: 'hint',
  );
  final state = _parseState(stateString);

  // Size dropdown - using string knob with manual conversion
  final sizeString = context.knobs.string(
    label: 'Size',
    initialValue: 'medium',
  );
  final size = _parseSize(sizeString);

  final showLabel = context.knobs.boolean(
    label: 'Show label',
    initialValue: true,
  );
  final labelText = context.knobs.string(
    label: 'Label text',
    initialValue: 'Email',
  );

  final showSupporting = context.knobs.boolean(
    label: 'Show supporting text',
    initialValue: true,
  );
  final supportingText = context.knobs.string(
    label: 'Supporting text',
    initialValue: state == SDeckInputState.error
        ? 'Please enter a valid email address'
        : 'We will never share your email.',
  );

  final placeholder = context.knobs.string(
    label: 'Placeholder',
    initialValue: 'Enter your email',
  );

  final readOnly = context.knobs.boolean(
    label: 'Read-only (maps to disabled visual)',
    initialValue: false,
  );

  // When readOnly is true, force disabled visual to match component behavior
  final effectiveState = readOnly ? SDeckInputState.disabled : state;

  final controller = TextEditingController(
    text: effectiveState == SDeckInputState.filled ? 'user@example.com' : '',
  );

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SDeckInput(
          label: showLabel ? labelText : null,
          placeholder: placeholder,
          supportingText: showSupporting ? supportingText : null,
          state: effectiveState,
          size: size,
          controller: controller,
          readOnly: readOnly,
        ),
      ],
    ),
  );
}
