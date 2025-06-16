/*------------------------- sdeck_create_profile_card.dart ----------------------*/
// Create Profile Card component for the SocialDeck design system
// Theme-aware card container that matches Figma designs
// Basic rectangular container with exact dimensions and colors
//
// Usage: SDeckCreateProfileCard()
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../foundations/index.dart';
import '../icons/sdeck_icon.dart';

//--------------------------- CreateProfileCardState -------------------------//
/// Defines the visual state of the CreateProfileCard component
enum SDeckCreateProfileCardState {
  /// Default state with gray border (State 1 from Figma)
  defaultState,

  /// Blink state with blue border (State 2 from Figma)
  blink,

  /// Selected state with gray border (State 3 from Figma)
  selected,
}

class SDeckCreateProfileCard extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  final SDeckCreateProfileCardState state;
  final VoidCallback? onTap;

  //------------------------------- Constructor ----------------------------//
  const SDeckCreateProfileCard({
    super.key,
    this.state = SDeckCreateProfileCardState.defaultState,
    this.onTap,
  });

  //*************************** Named Constructors ***************************//

  /// Creates a CreateProfileCard in default state
  const SDeckCreateProfileCard.defaultState({super.key, this.onTap})
    : state = SDeckCreateProfileCardState.defaultState;

  /// Creates a CreateProfileCard in blink state
  const SDeckCreateProfileCard.blink({super.key, this.onTap})
    : state = SDeckCreateProfileCardState.blink;

  /// Creates a CreateProfileCard in selected state
  const SDeckCreateProfileCard.selected({super.key, this.onTap})
    : state = SDeckCreateProfileCardState.selected;

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 192,
        height: 288,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        child: DottedBorder(
          color: _getBorderColor(context),
          strokeWidth: 5,
          dashPattern: [25, 10],
          borderType: BorderType.RRect,
          radius: Radius.circular(SDeckRadius.xs), // 16px
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SDeckRadius.xs),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add Profile Card Icon
                  SDeckIcon(
                    context.icons.addProfileCard,
                    width: 42, // Figma width 42px
                    height: 36, // Figma height 36px
                  ),

                  // Spacing between icon and text
                  SizedBox(height: SDeckSpacing.x8), // 8px gap
                  // "Add Card" Text
                  Text('Add Card', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //*************************** Helper Methods *****************************//
  // These methods encapsulate the card's appearance logic and ensure
  // consistency with the design system. They use theme extensions for
  // automatic light/dark mode switching.

  /// Gets background color using theme-aware extensions
  Color _getBackgroundColor(BuildContext context) {
    return Theme.of(context).colorScheme.createProfileCardBackground;
  }

  /// Gets border radius using design tokens
  double _getBorderRadius() {
    return SDeckRadius.xs; // 16px
  }

  /// Gets border color based on the state
  Color _getBorderColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (state) {
      case SDeckCreateProfileCardState.defaultState:
        return colorScheme.createProfileCardBorderDefault;
      case SDeckCreateProfileCardState.blink:
        return colorScheme.createProfileCardBorderBlink;
      case SDeckCreateProfileCardState.selected:
        return colorScheme.createProfileCardBorderSelected;
    }
  }
}
