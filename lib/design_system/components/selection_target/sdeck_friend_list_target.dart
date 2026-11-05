/*-------------------- sdeck_friend_list_target.dart -------------------------*/
// Figma listTarget. One row, four types:
//   friend  — 48×48 profile card, username, optional AvatarIndicator
//   toggle  — title, description, switch on the right
//   button  — title, description, solid button on the right
//   stepper — title, description, chevron stepper on the right
//
// Title and stepper text follow selectionTargetTitleText. The description
// uses indicatorText, which is #5E5E5E in light and #C4C4C4 in Semantic Dark.
//
// Usage:
//   SDeckFriendListTarget(username: 'tpsoftdev')
//   SDeckFriendListTarget(
//     username: 'tpsoftdev',
//     indicatorText: 'In Party',
//     onTap: () {},
//   )
//   SDeckFriendListTarget(
//     type: SDeckListTargetType.toggle,
//     username: 'Mix Cards',
//     description: "Shuffle everyone's cards and distribute.",
//     toggleValue: true,
//     onToggleChanged: (value) {},
//   )
//   SDeckFriendListTarget(
//     type: SDeckListTargetType.button,
//     username: 'Title/Username',
//     description: 'Description',
//     buttonLabel: 'Button',
//     onButtonPressed: () {},
//   )
//   SDeckFriendListTarget(
//     type: SDeckListTargetType.stepper,
//     username: 'Rounds',
//     description: 'Play up to 5 rounds in a single game.',
//     stepperText: '3',
//     onStepperDecrease: () {},
//     onStepperIncrease: () {},
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//========================== SDeckListTargetType ==============================//
// Matches Figma listTarget > Type.
enum SDeckListTargetType { friend, toggle, button, stepper }

//========================= SDeckFriendListTarget =============================//
class SDeckFriendListTarget extends StatelessWidget {
  // Figma listTarget width is 370; the row hugs its parent and stays at least
  // 64 tall, which is the symbol height of every type.
  static const double _minHeight = 64;

  final SDeckListTargetType type;

  final String username;

  // Shown under the title for toggle, button, and stepper.
  final String description;

  // Figma profileCard for the friend row. Defaults to the 48×48 fixed placeholder.
  final Widget profile;

  // AvatarIndicator label. Null hides the indicator.
  final String? indicatorText;

  final SDeckAvatarIndicatorType indicatorType;

  // Optional 16×16 thumbnail on the AvatarIndicator ("Knows 3+").
  final Widget? indicatorAvatar;

  final bool toggleValue;

  final ValueChanged<bool>? onToggleChanged;

  final String buttonLabel;

  final VoidCallback? onButtonPressed;

  final String stepperText;

  final VoidCallback? onStepperDecrease;

  final VoidCallback? onStepperIncrease;

  final VoidCallback? onTap;

  const SDeckFriendListTarget({
    super.key,
    this.type = SDeckListTargetType.friend,
    required this.username,
    this.description = 'Description',
    this.profile = const SDeckProfileCardPlaceholder(
      variant: SDeckProfileCardVariant.fixed,
      size: SDeckSize.size48,
    ),
    this.indicatorText,
    this.indicatorType = SDeckAvatarIndicatorType.inGame,
    this.indicatorAvatar,
    this.toggleValue = false,
    this.onToggleChanged,
    this.buttonLabel = 'Button',
    this.onButtonPressed,
    this.stepperText = 'Text',
    this.onStepperDecrease,
    this.onStepperIncrease,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _minHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: SDeckSpace.padding8),
          child: Row(
            children: switch (type) {
              SDeckListTargetType.friend => _friendChildren(context),
              SDeckListTargetType.toggle => [
                _titleBlock(context),
                SDeckToggleSwitch(
                  value: toggleValue,
                  onChanged: onToggleChanged,
                ),
              ],
              SDeckListTargetType.button => [
                _titleBlock(context),
                _button(),
              ],
              SDeckListTargetType.stepper => [
                _titleBlock(context),
                _stepper(context),
              ],
            },
          ),
        ),
      ),
    );
  }

  //----------------------------- Friend --------------------------------------//
  List<Widget> _friendChildren(BuildContext context) {
    return [
      profile,
      const SizedBox(width: SDeckSpace.gap4),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _username(
              context,
              style: Theme.of(context).textTheme.caption,
            ),
            if (indicatorText != null)
              SDeckAvatarIndicator(
                type: indicatorType,
                text: indicatorText!,
                avatar: indicatorAvatar,
              ),
          ],
        ),
      ),
    ];
  }

  //------------------------ Title + description ------------------------------//
  Widget _titleBlock(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: SDeckSpace.gap12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _username(
              context,
              style: Theme.of(context).textTheme.bodySmallFigma,
            ),
            const SizedBox(height: SDeckSpace.gap4),
            Text(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.footer.copyWith(
                color: _indicatorTextColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _username(BuildContext context, {required TextStyle style}) {
    return Text(
      username,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style.copyWith(color: context.component.selectionTargetTitleText),
    );
  }

  //------------------------------ Button -------------------------------------//
  Widget _button() {
    return SDeckSolidButton(
      text: buttonLabel,
      size: SDeckButtonSize.small,
      shape: SDeckButtonShape.round,
      onPressed: onButtonPressed,
    );
  }

  //------------------------------ Stepper ------------------------------------//
  Widget _stepper(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _chevron(
          context,
          icon: SDeckIcon.leftChevron,
          onTap: onStepperDecrease,
        ),
        const SizedBox(width: SDeckSpace.gap12),
        Text(
          stepperText,
          style: Theme.of(context).textTheme.h6.copyWith(
            color: context.component.selectionTargetTitleText,
          ),
        ),
        const SizedBox(width: SDeckSpace.gap12),
        _chevron(
          context,
          icon: SDeckIcon.rightChevron,
          onTap: onStepperIncrease,
        ),
      ],
    );
  }

  Widget _chevron(
    BuildContext context, {
    required String icon,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SDeckIcons(
        icon,
        size: SDeckSize.size36,
        color: onTap == null
            ? context.component.iconDisabled
            : context.component.iconPrimary,
      ),
    );
  }

  // Status Indicators/indicatorText. semantic.secondary is #D9D9D9 in dark.
  Color _indicatorTextColor(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return dark ? SDeckBaseColors.coolGray[300]! : SDeckBaseColors.coolGray[700]!;
  }
}
