/*----------------------------- box_shadows.dart --------------------------------*/
// Box shadows create depth and hierarchy by separating surfaces from their
// backgrounds. They communicate elevation and reinforce the spatial system
// across light and dark themes.
//
// Usage:
//   SDeckBoxShadows.boxShadowLow(context.semantic.shadow)
//   SDeckBoxShadows.boxShadow(context.semantic.shadow)
//   SDeckBoxShadows.boxShadowHigh(context.semantic.shadow)
//
// Pass the shadow color token as-is. Alpha is already baked into that token.
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';

//------------------------------- SDeckBoxShadows ------------------------------//
class SDeckBoxShadows {
  SDeckBoxShadows._();

  //*************************** Box Shadows **********************************//

  //----------------------------- No Shadow ------------------------------//
  // Used for flat surfaces.
  static List<BoxShadow> noShadow() => [];

  //----------------------------- Box Shadow Low ------------------------------//
  // Subtle elevation for small surfaces and resting elements.
  // offset (2, 2), blur 0, spread 0.
  static List<BoxShadow> boxShadowLow(Color shadowColor) => [
    BoxShadow(
      offset: const Offset(2, 2),
      blurRadius: 0,
      spreadRadius: 0,
      color: shadowColor,
    ),
  ];

  //----------------------------- Box Shadow (Default) ------------------------//
  // Balanced depth for interactive or floating components.
  // offset (4, 4), blur 0, spread 0.
  static List<BoxShadow> boxShadow(Color shadowColor) => [
    BoxShadow(
      offset: const Offset(4, 4),
      blurRadius: 0,
      spreadRadius: 0,
      color: shadowColor,
    ),
  ];

  //----------------------------- Box Shadow High -----------------------------//
  // Strong elevation for modals, popovers, and top-layer surfaces.
  // offset (8, 8), blur 0, spread 0.
  static List<BoxShadow> boxShadowHigh(Color shadowColor) => [
    BoxShadow(
      offset: const Offset(8, 8),
      blurRadius: 0,
      spreadRadius: 0,
      color: shadowColor,
    ),
  ];
}
