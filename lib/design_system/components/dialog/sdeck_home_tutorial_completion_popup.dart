/*--------------- sdeck_home_tutorial_completion_popup.dart ------------------*/
// Tutorial completion visual — Figma Socialdeck — Home, visualPopup (230:3805).
// Square 1:1 media area (Rive / celebration animation slot).
/*--------------------------------------------------------------------------*/

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../tokens/index.dart';
import '../placeholders/sdeck_visual_placeholder.dart';

//===================== SDeckHomeTutorialCompletionPopup ======================//
/// Centered square (max [maxWidth]) with 16px corners — placeholder or [visual]
/// for Rive / confetti. Copy (“Tutorial Completed”) can live inside [visual].
class SDeckHomeTutorialCompletionPopup extends StatelessWidget {
  const SDeckHomeTutorialCompletionPopup({
    super.key,
    this.visual,
    this.maxWidth = 370,
  });

  /// Replaces the default checkered placeholder (e.g. Rive celebration).
  final Widget? visual;

  /// Caps the square side length (Figma reference frame 370).
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = math.min(constraints.maxWidth, maxWidth);

        return SizedBox(
          width: side,
          height: side,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
            child: visual ??
                SDeckVisualPlaceholder(
                  width: side,
                  height: side,
                  borderRadius: BorderRadius.circular(
                    SDeckRadius.borderRadius16,
                  ),
                ),
          ),
        );
      },
    );
  }
}
