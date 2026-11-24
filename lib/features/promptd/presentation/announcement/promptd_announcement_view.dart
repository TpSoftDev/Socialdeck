/*------------------- promptd_announcement_view.dart --------------------*/
// Prompt'd announcement. Stateless snapshot of one Figma frame:
// empty top bar, centered title, supporting line, then a square placeholder.
// The same bar sits above Voting Time and Final Two. Light and dark
// colors come from the theme.
/*--------------------------------------------------------------------------*/

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//---------------------------- PromptdAnnouncementView ------------------------//
class PromptdAnnouncementView extends StatelessWidget {
  const PromptdAnnouncementView({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.semantic.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SDeckPromptdTopBar(
            showRoundDetails: false,
            showPause: false,
            showRightIcon: false,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.gap16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(SDeckSpace.padding16),
                  child: Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.h4.copyWith(
                          color: context.component.textPrimary,
                        ),
                      ),
                      const SizedBox(height: SDeckSpace.gap12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.body.copyWith(
                          color: context.component.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SDeckSpace.gap16),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Figma's 4×4 placeholder is 370. On a narrower phone it
                    // shrinks with the content width and stays square.
                    final double side = math.min(constraints.maxWidth, 370);
                    return SDeckVisualPlaceholder(width: side, height: side);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
