/*----------------------------- shadows.dart --------------------------------*/
// Shadow design tokens for the SocialDeck design system
// Used for consistent elevation and depth across components
//
// Usage: SDeckShadows.playingCard (returns List<BoxShadow>)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

//------------------------------- SDeckShadows -------------------------------//
class SDeckShadows {
  SDeckShadows._(); 

  //========================== PLAYING CARD SHADOWS ==========================//

  /// Standard playing card drop shadow
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
