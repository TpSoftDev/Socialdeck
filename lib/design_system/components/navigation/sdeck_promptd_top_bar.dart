/*---------------------- sdeck_promptd_top_bar.dart -----------------------*/
// Figma promptdTopBar. A 76px bar with 16px side and top padding and
// 12px bottom padding.
//   default_  — round title (H6) over the opponent (caption), then pause
//               and a second icon
//   timer     — clock and the timer value (H4), then pause and a second icon
//   tutorial  — one icon on the left and a small round Skip button
//
// Title, timer, and icons use primary: #1F1F1F in light, #F5F5F5 in dark.
// The opponent line uses navigation supporting text: #5E5E5E in light,
// #D9D9D9 in dark. Skip uses the solid button, including its dark colors.
//
// Usage:
//   SDeckPromptdTopBar(round: 'Round 2', opposingPlayer: 'vs. Alex')
//   SDeckPromptdTopBar(type: SDeckPromptdTopBarType.timer, timerValue: '20')
//   SDeckPromptdTopBar(type: SDeckPromptdTopBarType.tutorial, skipLabel: 'Skip 1/5')
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../themes/text_theme.dart';
import '../../tokens/index.dart';
import '../buttons/button_enums.dart';
import '../buttons/sdeck_solid_button.dart';

//======================== SDeckPromptdTopBarType ============================//
enum SDeckPromptdTopBarType { default_, timer, tutorial }

//======================== SDeckPromptdTopBar ================================//
class SDeckPromptdTopBar extends StatelessWidget {
  final SDeckPromptdTopBarType type;
  final String round;
  final String opposingPlayer;
  final bool showRoundDetails;
  final String timerValue;
  final bool showPause;
  final bool showRightIcon;
  final Widget? rightIcon;
  final bool showLeftIcon;
  final Widget? leftIcon;
  final String skipLabel;
  final VoidCallback? onPausePressed;
  final VoidCallback? onRightIconPressed;
  final VoidCallback? onLeftIconPressed;
  final VoidCallback? onSkipPressed;

  const SDeckPromptdTopBar({
    super.key,
    this.type = SDeckPromptdTopBarType.default_,
    this.round = 'Round #',
    this.opposingPlayer = 'vs. Player',
    this.showRoundDetails = true,
    this.timerValue = '20',
    this.showPause = true,
    this.showRightIcon = true,
    this.rightIcon,
    this.showLeftIcon = true,
    this.leftIcon,
    this.skipLabel = 'Skip #/5',
    this.onPausePressed,
    this.onRightIconPressed,
    this.onLeftIconPressed,
    this.onSkipPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        SDeckSpace.padding16,
        SDeckSpace.padding16,
        SDeckSpace.padding16,
        SDeckSpace.padding12,
      ),
      child: SizedBox(
        height: SDeckSize.size48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildLeft(context),
              ),
            ),
            _buildRight(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLeft(BuildContext context) {
    switch (type) {
      case SDeckPromptdTopBarType.default_:
        if (!showRoundDetails) return const SizedBox.shrink();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              round,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.h6.copyWith(color: context.component.navigationText),
            ),
            Text(
              opposingPlayer,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption.copyWith(
                color: context.component.navigationSupportingText,
              ),
            ),
          ],
        );
      case SDeckPromptdTopBarType.timer:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SDeckIcons(
              SDeckIcon.clock,
              size: SDeckSize.size36,
              color: context.semantic.primary,
            ),
            const SizedBox(width: SDeckSpace.gap6),
            Text(
              timerValue,
              style: Theme.of(
                context,
              ).textTheme.h4.copyWith(color: context.semantic.primary),
            ),
          ],
        );
      case SDeckPromptdTopBarType.tutorial:
        if (!showLeftIcon) return const SizedBox.shrink();
        return _iconButton(
          onPressed: onLeftIconPressed,
          label: 'More',
          child: leftIcon ?? _placeholder(context),
        );
    }
  }

  Widget _buildRight(BuildContext context) {
    switch (type) {
      case SDeckPromptdTopBarType.default_:
      case SDeckPromptdTopBarType.timer:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showPause)
              _iconButton(
                onPressed: onPausePressed,
                label: 'Pause',
                child: _PauseIcon(color: context.semantic.primary),
              ),
            if (showPause && showRightIcon)
              const SizedBox(width: SDeckSpace.gap8),
            if (showRightIcon)
              _iconButton(
                onPressed: onRightIconPressed,
                label: 'More',
                child: rightIcon ?? _placeholder(context),
              ),
          ],
        );
      case SDeckPromptdTopBarType.tutorial:
        return SDeckSolidButton(
          text: skipLabel,
          size: SDeckButtonSize.small,
          shape: SDeckButtonShape.round,
          onPressed: onSkipPressed,
        );
    }
  }

  Widget _placeholder(BuildContext context) {
    return SDeckIcons(
      SDeckIcon.placeholder,
      size: SDeckSize.size36,
      color: context.semantic.primary,
    );
  }

  Widget _iconButton({
    required Widget child,
    required String label,
    VoidCallback? onPressed,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
        child: SizedBox(
          width: SDeckSize.size36,
          height: SDeckSize.size36,
          child: child,
        ),
      ),
    );
  }
}

/// Two 7.5×24 bars inside the 36px pause slot from the Figma icon.
class _PauseIcon extends StatelessWidget {
  final Color color;

  const _PauseIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [_bar(), const SizedBox(width: SDeckSpace.gap6), _bar()],
      ),
    );
  }

  Widget _bar() {
    return Container(
      width: 7.5,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }
}
