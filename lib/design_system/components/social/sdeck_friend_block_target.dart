/*----------------------- sdeck_friend_block_target.dart ---------------------*/
// A compact friend card used in the 3-column friends grid on the social screen.
// Shows the friend's avatar, username, and an optional activity indicator.
//
// The selected state adds a surfaceInfo background — used when the card is
// actively chosen or highlighted.
//
// Usage:
//   SDeckFriendBlockTarget(username: 'tpsoftdev')
//   SDeckFriendBlockTarget(
//     username: 'tpsoftdev',
//     indicatorText: 'In Party',
//     state: SDeckFriendBlockTargetState.selected,
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../helpers/index.dart';
import '../../themes/text_theme.dart';
import '../placeholders/sdeck_visual_placeholder.dart';
import '../status/sdeck_dot_indicator.dart';
import 'friend_block_target_enums.dart';

class SDeckFriendBlockTarget extends StatelessWidget {
  //------------------------------- Properties ---------------------------------//

  final String username;

  /// When provided, shows a green dot and this text below the username.
  /// When null, the indicator row is hidden.
  final String? indicatorText;

  final SDeckFriendBlockTargetState state;

  final VoidCallback? onTap;

  //*************************** Constructor **********************************//
  const SDeckFriendBlockTarget({
    super.key,
    required this.username,
    this.indicatorText,
    this.state = SDeckFriendBlockTargetState.enabled,
    this.onTap,
  });

  //*************************** Build ****************************************//
  @override
  Widget build(BuildContext context) {
    final bool isSelected = state == SDeckFriendBlockTargetState.selected;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: context.semantic.surfaceInfo,
                borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //------------------- Avatar -------------------//
            // Expanded fills the remaining cell height after the text block.
            // Center + AspectRatio(1) ensures the avatar is always a perfect square
            // regardless of how much vertical space Expanded provides.
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: SDeckVisualPlaceholder(
                    borderRadius: BorderRadius.circular(
                      SDeckRadius.borderRadius999,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: SDeckSpace.gap4),

            //------------------- Text block ---------------//
            Padding(
              padding: const EdgeInsets.only(bottom: SDeckSpace.padding4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption.copyWith(
                          color: context.component.selectionTargetTitleText,
                        ),
                  ),
                  if (indicatorText != null) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SDeckDotIndicator(
                          color: SDeckDotIndicatorColor.green,
                        ),
                        const SizedBox(width: SDeckSpace.gap4),
                        Text(
                          indicatorText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.footer.copyWith(
                                color: context.semantic.secondary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
