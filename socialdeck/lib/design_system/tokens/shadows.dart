/*----------------------------- shadows.dart --------------------------------*/
// Shadow design tokens for the SocialDeck design system
// These are the shadow specifications extracted from Figma designs
// Used for consistent elevation and depth across components
//
// Usage: SDeckShadows.playingCard (returns List<BoxShadow>)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

//------------------------------- SDeckShadows -------------------------------//
/// Static class containing all shadow design tokens
/// Each shadow returns a List<BoxShadow> ready to use in BoxDecoration
class SDeckShadows {
  SDeckShadows._(); // Private constructor to prevent instantiation

  //========================== PLAYING CARD SHADOWS ==========================//

  /// Standard playing card drop shadow
  /// Specifications from Figma: X:0, Y:2, Blur:4, Spread:0, Color:#000000-25%
  /// Used for medium, small, and smaller playing cards
  static const List<BoxShadow> playingCard = [
    BoxShadow(
      offset: Offset(0, 2), // X: 0, Y: 2 (downward)
      blurRadius: 4, // Blur: 4px
      spreadRadius: 0, // Spread: 0px (no expansion)
      color: Color.fromRGBO(0, 0, 0, 0.25), // #000000 at 25% opacity
    ),
  ];

  //========================== FUTURE SHADOW TOKENS ===========================//
  // Add more shadow variations here as needed:
  // static const List<BoxShadow> buttonShadow = [...];
  // static const List<BoxShadow> cardShadow = [...];
  // static const List<BoxShadow> modalShadow = [...];
}
