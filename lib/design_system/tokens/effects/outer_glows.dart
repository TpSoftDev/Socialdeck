/*----------------------------- outer_glows.dart --------------------------------*/
// Outer glows create luminance and focus by radiating color outward from a
// surface edge. Used for emphasis states like Selected and Move on cards.
//
// Usage:
//   SDeckOuterGlows.outerGlowLowSkyBlue(context.semantic.info)
//   SDeckOuterGlows.outerGlowHighVibrantYellow(context.semantic.warning)
//
// Pass the full-opacity brand or semantic color. Each helper applies 25% alpha.
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';

//------------------------------- SDeckOuterGlows ------------------------------//
class SDeckOuterGlows {
  SDeckOuterGlows._();

  //*************************** Sky Blue **********************************//

  //----------------------------- Low ---------------------------------------//
  // Subtle glow for emphasis. offset (0, 0), blur 0, spread 4.
  static List<BoxShadow> outerGlowLowSkyBlue(Color color) => [
    BoxShadow(
      offset: Offset.zero,
      blurRadius: 0,
      spreadRadius: 4,
      color: color.withValues(alpha: 0.25),
    ),
  ];

  //----------------------------- Default -----------------------------------//
  // Balanced glow for emphasis. offset (0, 0), blur 0, spread 6.
  static List<BoxShadow> outerGlowSkyBlue(Color color) => [
    BoxShadow(
      offset: Offset.zero,
      blurRadius: 0,
      spreadRadius: 6,
      color: color.withValues(alpha: 0.25),
    ),
  ];

  //----------------------------- High --------------------------------------//
  // Raised glow for emphasis. offset (0, 0), blur 0, spread 8.
  static List<BoxShadow> outerGlowHighSkyBlue(Color color) => [
    BoxShadow(
      offset: Offset.zero,
      blurRadius: 0,
      spreadRadius: 8,
      color: color.withValues(alpha: 0.25),
    ),
  ];

  //*************************** Vibrant Yellow ******************************//

  //----------------------------- Low ---------------------------------------//
  // Subtle glow for emphasis. offset (0, 0), blur 0, spread 4.
  static List<BoxShadow> outerGlowLowVibrantYellow(Color color) => [
    BoxShadow(
      offset: Offset.zero,
      blurRadius: 0,
      spreadRadius: 4,
      color: color.withValues(alpha: 0.25),
    ),
  ];

  //----------------------------- Default -----------------------------------//
  // Balanced glow for emphasis. offset (0, 0), blur 0, spread 6.
  static List<BoxShadow> outerGlowVibrantYellow(Color color) => [
    BoxShadow(
      offset: Offset.zero,
      blurRadius: 0,
      spreadRadius: 6,
      color: color.withValues(alpha: 0.25),
    ),
  ];

  //----------------------------- High --------------------------------------//
  // Raised glow for emphasis. offset (0, 0), blur 0, spread 8.
  // Named High to mirror the SkyBlue set.
  static List<BoxShadow> outerGlowHighVibrantYellow(Color color) => [
    BoxShadow(
      offset: Offset.zero,
      blurRadius: 0,
      spreadRadius: 8,
      color: color.withValues(alpha: 0.25),
    ),
  ];
}
