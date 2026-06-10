/*----------------------- sdeck_friend_block_target.dart ---------------------*/
// A compact friend card used in 3-column grids across the social screens.
// Shows a circular avatar, username, and one of two optional indicator rows.
//
// Use indicatorText for the activity status on the social page.
// Use mutualFriendText for the mutual friend count on the find friends page.
// Only one indicator should be set at a time. Both null hides the indicator row.
//
// Usage:
//   SDeckFriendBlockTarget(username: 'tpsoftdev')
//   SDeckFriendBlockTarget(username: 'tpsoftdev', indicatorText: 'In Party')
//   SDeckFriendBlockTarget(username: 'Username', mutualFriendText: 'knows 3+')
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

  /// Activity status indicator shown as a green dot with text. Used on the social page.
  /// Mutually exclusive with mutualFriendText.
  final String? indicatorText;

  /// Mutual friend indicator: text + 16px avatar thumbnail. Used on the
  /// find friends page. Mutually exclusive with indicatorText.
  final String? mutualFriendText;

  /// The mutual friend's profile avatar shown in the indicator row.
  /// Falls back to SDeckVisualPlaceholder when null.
  /// Pass a real profile image widget here when wiring real data.
  final Widget? mutualFriendAvatar;

  final SDeckFriendBlockTargetState state;

  final VoidCallback? onTap;

  //*************************** Constructor **********************************//
  const SDeckFriendBlockTarget({
    super.key,
    required this.username,
    this.indicatorText,
    this.mutualFriendText,
    this.mutualFriendAvatar,
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
                  //--- activity indicator: green dot + text ---//
                  if (indicatorText != null)
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

                  //--- mutual friend indicator: text + 16px avatar ---//
                  if (mutualFriendText != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          mutualFriendText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.footer.copyWith(
                                color: context.semantic.secondary,
                              ),
                        ),
                        const SizedBox(width: SDeckSpace.gap4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            SDeckRadius.borderRadius4,
                          ),
                          child: SizedBox(
                            width: SDeckSize.size16,
                            height: SDeckSize.size16,
                            child: mutualFriendAvatar ??
                                SDeckVisualPlaceholder(
                                  borderRadius: BorderRadius.circular(
                                    SDeckRadius.borderRadius4,
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
