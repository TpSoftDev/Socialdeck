/*------------------------ sdeck_message_card.dart --------------------------*/
// Error Message Card component for the SocialDeck design system
// Uses only design system tokens for color, padding, and radius
// Hugs its content (not full width), matching Figma exactly
//
// Usage: SDeckMessageCard.error(text: "Error message")
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../foundations/index.dart';
import '../../tokens/index.dart';

//============================ SDeckMessageCard ============================//
// MAIN COMPONENT CLASS
//
// This StatelessWidget displays message cards using the existing design system.
// Currently supports error messages, with other types to be added.

/// A message card for displaying error messages below form fields.
/// - Hugs its content (not full width)
/// - Uses SDeck design system tokens for all styling
/// - Matches Figma error message spec exactly

//------------------------------- Enums -------------------------------------//
/// Private enum for message card type (error, note)
enum _SDeckMessageType { error, note }

class SDeckMessageCard extends StatelessWidget {
  //------------------------------- Properties -----------------------------//

  /// The message to display (error or note)
  final String text;

  /// The type of message (error or note)
  final _SDeckMessageType _type;

  //------------------------------- Constructors ---------------------------//

  /// Error message constructor (red pill)
  const SDeckMessageCard.error({Key? key, required this.text})
    : _type = _SDeckMessageType.error,
      super(key: key);

  /// Note message constructor (neutral/gray pill)
  const SDeckMessageCard.note({Key? key, required this.text})
    : _type = _SDeckMessageType.note,
      super(key: key);

  //*************************** Build Method *******************************//
  /// Builds the message card with appropriate colors for error/note.
  @override
  Widget build(BuildContext context) {
    // Pick background and text color based on type
    final backgroundColor =
        _type == _SDeckMessageType.error
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.noteContainer;
    final textColor =
        _type == _SDeckMessageType.error
            ? Theme.of(context).colorScheme.onErrorContainer
            : Theme.of(context).colorScheme.onNoteContainer;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          SDeckRadius.borderRadiusL,
        ), // 16px radius
      ),
      padding: const EdgeInsets.symmetric(
        vertical: SDeckSpace.paddingXXS, // 4px top/bottom
        horizontal: SDeckSpace.paddingS, // 12px left/right
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.caption.copyWith(
          color: textColor,
        ), // Text color based on type
        textAlign: TextAlign.center, // Center text inside pill
      ),
    );
  }
}
