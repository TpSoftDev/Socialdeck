/*----------------------------- box_shadows.dart --------------------------------*/
// Box Shadow Tokens - Effects foundation
// Defines all box shadow tokens matching Figma exactly
// Matches Figma: Effects/Box Shadows (boxShadowLow, boxShadow, boxShadowHigh)
//
// Usage: SDeckBoxShadows.boxShadowLow(Theme.of(context).colorScheme.shadow)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

//------------------------------- SDeckBoxShadows ------------------------------//
class SDeckBoxShadows {
  SDeckBoxShadows._(); // Private constructor - prevents instantiation

  //*************************** Box Shadows **********************************//
  // Box shadow tokens match Figma Box Shadows exactly
  // All shadows use ColorScheme.shadow color with different opacity percentages

  //----------------------------- Box Shadow Low ------------------------------//
  /// Subtle elevation for small surfaces and resting elements.
  /// Matches Figma: boxShadowLow
  /// - shadow color @ 15% opacity
  /// - offset: (2, 0)
  /// - blurRadius: 4
  /// - spreadRadius: 0
  static List<BoxShadow> boxShadowLow(Color shadowColor) => [
    BoxShadow(
      offset: const Offset(2, 0), // X: 2, Y: 0 (rightward)
      blurRadius: 4, // Blur: 4px
      spreadRadius: 0, // Spread: 0px (no expansion)
      color: shadowColor.withValues(alpha: 0.15), // shadow @ 15% opacity
    ),
  ];

  //----------------------------- Box Shadow (Default) ------------------------//
  /// Balanced depth for interactive or floating components.
  /// Matches Figma: boxShadow
  /// - shadow color @ 18% opacity
  /// - offset: (4, 0)
  /// - blurRadius: 12
  /// - spreadRadius: -2
  static List<BoxShadow> boxShadow(Color shadowColor) => [
    BoxShadow(
      offset: const Offset(4, 0), // X: 4, Y: 0 (rightward)
      blurRadius: 12, // Blur: 12px
      spreadRadius: -2, // Spread: -2px (contraction)
      color: shadowColor.withValues(alpha: 0.18), // shadow @ 18% opacity
    ),
  ];

  //----------------------------- Box Shadow High -----------------------------//
  /// Strong elevation for modals, popovers, and top-layer surfaces.
  /// Matches Figma: boxShadowHigh
  /// - shadow color @ 20% opacity
  /// - offset: (8, 0)
  /// - blurRadius: 24
  /// - spreadRadius: -4
  static List<BoxShadow> boxShadowHigh(Color shadowColor) => [
    BoxShadow(
      offset: const Offset(8, 0), // X: 8, Y: 0 (rightward)
      blurRadius: 24, // Blur: 24px
      spreadRadius: -4, // Spread: -4px (contraction)
      color: shadowColor.withValues(alpha: 0.20), // shadow @ 20% opacity
    ),
  ];

  //========================== TEMPORARY: LEGACY PLAYING CARD SHADOW ==========//
  // TODO: Remove this temporary shadow after full design system refactor
  // This uses the old shadow values (offset: 0,2, black @ 25%) which differ
  // from Figma tokens. Keeping temporarily because the new Figma shadows
  // don't look good with playing cards yet. Will be replaced with proper
  // Figma token after visual design review and refactor.
  /// TEMPORARY: Legacy playing card shadow (old values)
  /// - offset: (0, 2) - downward shadow
  /// - blurRadius: 4
  /// - spreadRadius: 0
  /// - color: black @ 25% opacity
  ///
  /// NOTE: This does NOT match Figma tokens. Using temporarily until
  /// full design system refactor is complete.
  static const List<BoxShadow> playingCard = [
    BoxShadow(
      offset: Offset(0, 2), // X: 0, Y: 2 (downward)
      blurRadius: 4, // Blur: 4px
      spreadRadius: 0, // Spread: 0px (no expansion)
      color: Color.fromRGBO(0, 0, 0, 0.25), // #000000 at 25% opacity
    ),
  ];
}
