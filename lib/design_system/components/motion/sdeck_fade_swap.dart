/*------------------------ sdeck_fade_swap.dart -------------------------*/
// Socialdeck Design System Fade Swap Component
//
// Purpose:
// - Reusable wrapper for fading content in and out
// - Keeps fade duration and curve consistent across the app
//
// Good use cases:
// - onboarding text
// - title sections
// - button groups
// - lower content that changes while top content stays fixed
/*-----------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/tokens/motion/sdeck_motion.dart';

class SDeckFadeSwap extends StatelessWidget {
  const SDeckFadeSwap({
    super.key,
    required this.visible,
    required this.child,
    this.duration,
    this.curve,
    this.alwaysMaintainLayout = false,
  });

  /// Whether the child should be visible.
  final bool visible;

  /// The widget being faded in/out.
  final Widget child;

  /// Optional override. Defaults to DS fade duration.
  final Duration? duration;

  /// Optional override. Defaults to DS standard motion curve.
  final Curve? curve;

  /// If true, the widget keeps occupying layout space even when invisible.
  ///
  /// Useful when:
  /// - you want to preserve spacing
  /// - you want hidden UI to not jump the layout
  ///
  /// If false, the widget fades and then stops taking interaction through
  /// IgnorePointer, but still remains in layout because AnimatedOpacity
  /// itself keeps size. This flag is mostly here for clarity and future use.
  final bool alwaysMaintainLayout;

  @override
  Widget build(BuildContext context) {
    final resolvedDuration = duration ?? SDeckMotionDuration.fade;
    final resolvedCurve = curve ?? SDeckMotionCurve.standard;

    final content = IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: resolvedDuration,
        curve: resolvedCurve,
        child: child,
      ),
    );

    return content;
  }
}
