/*--------------------------- fade_swap.dart ----------------------------*/
// Profile feature utility that wraps AnimatedOpacity with IgnorePointer,
// fading a child widget in and out while blocking taps when hidden.
// Not a design system component — it has no Figma equivalent.
//
// Usage:
//   FadeSwap(visible: _visible, child: myWidget)
/*----------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//-------------------------------- FadeSwap --------------------------------//
class FadeSwap extends StatelessWidget {
  const FadeSwap({
    super.key,
    required this.visible,
    required this.child,
    this.duration,
    this.curve,
  });

  // Whether the child should be visible.
  final bool visible;

  // The widget being faded in/out.
  final Widget child;

  // Optional override. Defaults to normal duration.
  final Duration? duration;

  // Optional override. Defaults to easeInOut curve.
  final Curve? curve;

  @override
  Widget build(BuildContext context) {
    final resolvedDuration = duration ?? SDeckMotionDuration.normal;
    final resolvedCurve = curve ?? SDeckMotionCurve.easeInOut;

    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: resolvedDuration,
        curve: resolvedCurve,
        child: child,
      ),
    );
  }
}
