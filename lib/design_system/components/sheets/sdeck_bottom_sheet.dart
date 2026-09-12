/*--------------------------- sdeck_bottom_sheet.dart --------------------------*/
// Base bottom sheet shell for the SocialDeck design system.
// Handles surface, shadow, padding, header, optional description, and button stack.
// Specialized sheet components (tip, profile, etc.) compose this as their shell.
//
// Usage:
//   showSDeckBottomSheet(
//     context: context,
//     title: "Sheet Title",
//     description: "Optional description",
//     buttons: [SDeckSolidButton(...), SDeckOutlineButton(...)],
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/spacing/index.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/icons/index.dart';
import '../../tokens/effects/index.dart';
import '../../themes/text_theme.dart';

//------------------------------- SDeckBottomSheet ---------------------------//
class SDeckBottomSheet extends StatelessWidget {
  //------------------------------- Properties -------------------------------//
  final String title;

  /// When null the description row is not rendered
  final String? description;

  /// Toggles the X button in the header — defaults to true
  final bool showCloseButton;

  /// Called when the X button is tapped; pops the route by default
  final VoidCallback? onClosePressed;

  /// Rendered as a vertical stack with gap8 between each widget
  final List<Widget>? buttons;

  //------------------------------- Constructor ------------------------------//
  const SDeckBottomSheet({
    super.key,
    required this.title,
    this.description,
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
        top: false, // status bar is handled by the parent scaffold
        bottom: true, // keeps content above the iOS home indicator
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

              //------------------------ Description -----------------------//
              if (description != null) ...[
                const SizedBox(height: SDeckSpace.gap16),
                _buildDescription(context),
              ],

              //------------------------ Button Stack ----------------------//
              if (buttons != null && buttons!.isNotEmpty) ...[
                const SizedBox(height: SDeckSpace.gap16),
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

  //------------------------------- Description ----------------------------//
  Widget _buildDescription(BuildContext context) {
    return Text(
      description!,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: context.component.sheetDescriptionText,
      ),
    );
  }

  //------------------------------- Button Stack ---------------------------//
  /// Renders buttons as a vertical list — gap8 between each, matching Figma's Vert List
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

//========================= showSDeckBottomSheet ==============================//
Future<void> showSDeckBottomSheet({
  required BuildContext context,
  required String title,
  String? description,
  bool showCloseButton = true,
  VoidCallback? onClosePressed,
  List<Widget>? buttons,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color.fromRGBO(31, 31, 31, 0.25),
    useRootNavigator: true,
    builder: (_) => SDeckBottomSheet(
      title: title,
      description: description,
      showCloseButton: showCloseButton,
      onClosePressed: onClosePressed,
      buttons: buttons,
    ),
  );
}
