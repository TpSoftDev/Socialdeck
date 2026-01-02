/*----------------------------- box_shadows.dart --------------------------------*/
// Box shadows create a sense of depth and hierarchy by visually separating
// surfaces from their backgrounds. They communicate elevation, help define
// interaction states, and reinforce the spatial system across both light and
// dark themes.
//
// Usage:
//   SDeckBoxShadows.boxShadowLow(context.semantic.shadow)
//   SDeckBoxShadows.boxShadow(context.semantic.shadow)
//   SDeckBoxShadows.boxShadowHigh(context.semantic.shadow)
//
// Each method takes a shadow color parameter and creates a shadow with
// different visual properties (offset, blur, spread, and opacity).
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';

//------------------------------- SDeckBoxShadows ------------------------------//
class SDeckBoxShadows {
  SDeckBoxShadows._();

  //*************************** Box Shadows **********************************//

  //----------------------------- Box Shadow Low ------------------------------//
  /// Subtle elevation for small surfaces and resting elements.
  static List<BoxShadow> boxShadowLow(Color shadowColor) => [
    BoxShadow(
      offset: const Offset(2, 0),
      blurRadius: 4,
      spreadRadius: 0,
      color: shadowColor.withValues(alpha: 0.15),
    ),
  ];

  //----------------------------- Box Shadow (Default) ------------------------//
  /// Balanced depth for interactive or floating components.
  static List<BoxShadow> boxShadow(Color shadowColor) => [
    BoxShadow(
      offset: const Offset(4, 0),
      blurRadius: 12,
      spreadRadius: -2,
      color: shadowColor.withValues(alpha: 0.18),
    ),
  ];

  //----------------------------- Box Shadow High -----------------------------//
  /// Strong elevation for modals, popovers, and top-layer surfaces.
  static List<BoxShadow> boxShadowHigh(Color shadowColor) => [
    BoxShadow(
      offset: const Offset(8, 0),
      blurRadius: 24,
      spreadRadius: -4,
      color: shadowColor.withValues(alpha: 0.20),
    ),
  ];
}
