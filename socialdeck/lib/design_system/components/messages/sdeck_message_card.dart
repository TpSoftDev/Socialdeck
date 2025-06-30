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
class SDeckMessageCard extends StatelessWidget {
  //------------------------------- Properties -----------------------------//

  /// The error message to display
  final String text;

  //------------------------------- Private Constructor -------------------//

  const SDeckMessageCard.error({super.key, required this.text});

  //*************************** Build Method *******************************//
  // Main build method that creates the message card widget tree.
  // Uses design system tokens for all styling.

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(SDeckRadius.xs), // 16px radius
      ),
      padding: const EdgeInsets.symmetric(
        vertical: SDeckSpacing.x4, // 4px top/bottom
        horizontal: SDeckSpacing.x12, // 12px left/right
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.caption.copyWith(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ), // Error text color
        textAlign: TextAlign.center, // Center text inside pill
      ),
    );
  }
}
