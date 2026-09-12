/*------------------------------- motion.dart --------------------------------*/
// Motion tokens define animation durations and easing curves for the
// Socialdeck design system. They serve as the single source of truth for all
// animation timing, ensuring consistent motion behavior across every screen.
//
// Token names map directly to the Figma Style Guide / Motion spec,
// keeping design intent and code in sync.
//
// Usage:
//   SDeckMotionDuration.normal
//   SDeckMotionCurve.easeInOut
/*----------------------------------------------------------------------------*/

//-------------------------------- Imports ------------------------------------//
import 'package:flutter/material.dart';

//---------------------------- SDeckMotionDuration ----------------------------//
class SDeckMotionDuration {
  SDeckMotionDuration._();

  static const Duration fast    = Duration(milliseconds: 75);
  static const Duration quick   = Duration(milliseconds: 150);
  static const Duration normal  = Duration(milliseconds: 300);
  static const Duration slow    = Duration(milliseconds: 450);
  static const Duration slower  = Duration(milliseconds: 600);
  static const Duration pause   = Duration(milliseconds: 1000);
  static const Duration read    = Duration(milliseconds: 1200);
  static const Duration linger  = Duration(milliseconds: 2000);
  static const Duration wait    = Duration(milliseconds: 3500);
}

//----------------------------- SDeckMotionCurve ------------------------------//
class SDeckMotionCurve {
  SDeckMotionCurve._();

  static const Curve easeIn          = Curves.easeIn;
  static const Curve easeOut         = Curves.easeOut;
  static const Curve easeInOut       = Curves.easeInOut;
  static const Curve easeAccelerate  = Curves.easeInCubic;
  static const Curve easeDecelerate  = Curves.easeOutCubic;
  static const Curve spring          = Curves.elasticOut;
  static const Curve linear          = Curves.linear;
}