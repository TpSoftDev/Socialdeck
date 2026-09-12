/*----------------------- sdeck_tip_bottom_sheet.dart ------------------------*/
// Tip bottom sheet component for the SocialDeck design system.
// A standalone sheet with a tip card — image slot, icon, title, and description —
// followed by a button list. Mirrors the Figma tipBottomSheet component exactly.
//
// Usage:
//   SDeckTipBottomSheet(
//     title: "Import Image",
//     tipIcon: SDeckIcon.information,
//     tipTitle: "Comedy Tip",
//     tipDescription: "This works best with head-and-shoulders photos.",
//     tipImage: Image.network(...),
//     buttons: [SDeckSolidButton(...), SDeckOutlineButton(...)],
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/spacing/index.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/icons/index.dart';
import '../../tokens/effects/box_shadows.dart';
import '../../themes/text_theme.dart';
import '../placeholders/sdeck_visual_placeholder.dart';

//------------------------------- SDeckTipBottomSheet ------------------------//
class SDeckTipBottomSheet extends StatelessWidget {
  //------------------------------- Properties -----------------------------//

  /// Sheet header title
  final String title;

  /// Icon displayed to the left of [tipTitle] inside the tip card
  final String tipIcon;

  /// Title text inside the tip card
  final String tipTitle;

  /// Body text inside the tip card
  final String tipDescription;

  /// Left-side visual in the tip card — shows a placeholder when null
  final Widget? tipImage;

  /// Toggles the X button in the header — defaults to true
  final bool showCloseButton;

  /// Called when the X button is tapped; pops the route by default
  final VoidCallback? onClosePressed;

  /// Rendered as a vertical stack with gap8 between each widget
  final List<Widget>? buttons;

  //------------------------------- Constructor ----------------------------//
  const SDeckTipBottomSheet({
    super.key,
    required this.title,
    required this.tipIcon,
    required this.tipTitle,
    required this.tipDescription,
    this.tipImage,
    this.showCloseButton = true,
    this.onClosePressed,
    this.buttons,
  });

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.component.sheetSurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(SDeckRadius.borderRadius16),
        ),
        boxShadow: SDeckBoxShadows.boxShadowHigh(context.semantic.shadow),
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            SDeckSpace.padding16,
            SDeckSpace.padding24,
            SDeckSpace.padding16,
            SDeckSpace.padding48,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //------------------------ Header ----------------------------//
              _buildHeader(context),

              const SizedBox(height: SDeckSpace.gap12),

              //------------------------ Tip Card -------------------------//
              _buildTipCard(context),

              //------------------------ Button Stack ---------------------//
              if (buttons != null && buttons!.isNotEmpty) ...[
                const SizedBox(height: SDeckSpace.gap12),
                _buildButtons(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  //*************************** Helper Methods ********************************//

  //------------------------------- Header ----------------------------------//
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.h5.copyWith(
            color: context.component.sheetTitleText,
          ),
        ),
        if (showCloseButton) _buildCloseButton(context),
      ],
    );
  }

  //------------------------------- Close Button ---------------------------//
  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: onClosePressed ?? () => Navigator.maybePop(context),
      child: SizedBox(
        width: SDeckSize.size36,
        height: SDeckSize.size36,
        child: SDeckIcons(
          SDeckIcon.x,
          size: SDeckSize.size24,
          color: context.component.sheetTitleText,
        ),
      ),
    );
  }

  //------------------------------- Tip Card --------------------------------//
  Widget _buildTipCard(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //------------------------ Image Slot ----------------------------//
        ClipRRect(
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
          child: tipImage ??
              SDeckVisualPlaceholder(
                width: SDeckSize.size96,
                height: SDeckSize.size96,
              ),
        ),

        const SizedBox(width: SDeckSpace.gap8),

        //------------------------ Written Content -----------------------//
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(SDeckSpace.padding16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //------------------ Title and Icon ---------------------//
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SDeckIcons(
                      tipIcon,
                      size: SDeckSize.size24,
                      color: context.component.textPrimary,
                    ),
                    const SizedBox(width: SDeckSpace.gap6),
                    Text(
                      tipTitle,
                      style: Theme.of(context).textTheme.bodyMediumFigma.copyWith(
                        color: context.component.textPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: SDeckSpace.gap6),

                //------------------ Description ------------------------//
                Text(
                  tipDescription,
                  style: Theme.of(context).textTheme.caption.copyWith(
                    color: context.component.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //------------------------------- Button Stack ---------------------------//
  /// Vertical list matching Figma's Button List — gap8 between each button
  Widget _buildButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < buttons!.length; i++) ...[
          buttons![i],
          if (i < buttons!.length - 1) const SizedBox(height: SDeckSpace.gap8),
        ],
      ],
    );
  }
}
