/*-------------------- sdeck_friend_list_target.dart -------------------------*/
// A single row in the vertical friend list — matches Figma friendListTarget.
// Shows a 48×48 avatar, username, and an optional mutual friend indicator
// (short text + 16×16 avatar thumbnail).
//
// Usage:
//   SDeckFriendListTarget(username: 'tpsoftdev')
//   SDeckFriendListTarget(
//     username: 'tpsoftdev',
//     mutualFriendText: 'knows 2+',
//     mutualFriendAvatar: Image.network(...),
//     onTap: () {},
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
class SDeckFriendListTarget extends StatelessWidget {
  final String username;

  // Text shown in the mutual friend indicator, e.g. "knows".
  final String? mutualFriendText;

  // 16px avatar thumbnail shown next to the mutual friend text.
  // Falls back to a visual placeholder when null.
  final Widget? mutualFriendAvatar;

  final VoidCallback? onTap;

  const SDeckFriendListTarget({
    super.key,
    required this.username,
    this.mutualFriendText,
    this.mutualFriendAvatar,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: SDeckSpace.padding8),
        child: Row(
          children: [
            //----------------------- Avatar -----------------------//
            SDeckVisualPlaceholder(
              width: SDeckSize.size48,
              height: SDeckSize.size48,
              borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24),
            ),

            const SizedBox(width: SDeckSpace.gap4),

            //------------------- Username + Indicator ------------------//
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption.copyWith(
                          color: context.component.textPrimary,
                        ),
                  ),

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
