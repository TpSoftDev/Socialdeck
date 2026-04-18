/*--------------------------- fade_swap.dart ----------------------------*/
// Profile feature utility — fade in/out wrapper.
//
// Wraps AnimatedOpacity with IgnorePointer so hidden content
// cannot receive taps. Uses motion tokens from the design system.
/*----------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

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
