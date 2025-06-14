/*------------------------------- profile_card.dart ----------------------------*/
// Profile card component for the SocialDeck design system
// Theme-aware card container that matches Figma designs exactly
// Basic rectangular container with exact dimensions and colors
//
// Usage: ProfileCard()
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../foundations/index.dart';
import '../../tokens/index.dart';

//------------------------------- ProfileCard -------------------------------//
/// Profile card component for the SocialDeck design system
/// Provides consistent card container with exact Figma measurements
/// All visual properties use foundations and tokens for theme consistency

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 192,
      height: 288,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(_getBorderRadius()),
      ),
      child: DottedBorder(
        color: SDeckColors.coolGray[300]!, // #C4C4C4
        strokeWidth: 5,
        dashPattern: [22, 12],
        borderType: BorderType.RRect,
        radius: Radius.circular(16),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
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
    return Theme.of(context).colorScheme.profileCardBackground;
  }

  /// Gets border radius using design tokens
  double _getBorderRadius() {
    return 16.0;
  }
}
