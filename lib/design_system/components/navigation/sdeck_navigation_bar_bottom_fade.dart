/*---------------------- sdeck_navigation_bar_bottom_fade.dart ----------------------*/
// **Opt-in only.** Default app headers match Figma with a flat bottom edge (no fade).
// Use this when a specific screen or spec calls for extra separation from scrolling
// content (gradient + optional low shadow).
//
// Usage:
//   Column(
//     children: [
//       SDeckTopNavigationBar(left: SDeckTopBarLeft.back, type: SDeckTopBarType.subpage, right: SDeckTopBarRight.none, title: '...'),
//       const SDeckNavigationBarBottomFade(),
//       Expanded(child: ...),
//     ],
//   )
/*-----------------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../tokens/index.dart';

/// Thin strip **below** [SDeckTopNavigationBar] — optional visual bridge to content.
///
/// Not part of the default nav spec; add only when design requires it.
class SDeckNavigationBarBottomFade extends StatelessWidget {
  const SDeckNavigationBarBottomFade({
    super.key,
    this.fadeHeight = SDeckSpace.padding16,
    this.fadeEndAlpha = 0.07,
    this.includeDropShadow = false,
  });

  /// Vertical extent of the gradient (logical pixels).
  final double fadeHeight;

  /// Max opacity of the fade at the bottom (0–1), multiplied into [semantic.shadow].
  final double fadeEndAlpha;

  /// When true, adds [SDeckBoxShadows.boxShadowLow] so the header casts slightly on content.
  final bool includeDropShadow;

  @override
  Widget build(BuildContext context) {
    final shadowColor = context.semantic.shadow;
    final surface = context.component.navigationSurface;

    Widget fade = Container(
      width: double.infinity,
      height: fadeHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            surface.withValues(alpha: 0),
            shadowColor.withValues(alpha: fadeEndAlpha.clamp(0.0, 1.0)),
          ],
        ),
        boxShadow:
            includeDropShadow ? SDeckBoxShadows.boxShadowLow(shadowColor) : null,
      ),
    );

    return IgnorePointer(child: fade);
  }
}
