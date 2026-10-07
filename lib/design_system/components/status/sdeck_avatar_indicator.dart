/*--------------------- sdeck_avatar_indicator.dart -------------------------*/
// A compact status row used inside the Profile imageTarget card.
// Renders a green dot paired with a short activity label.
//
// Usage:
//   SDeckAvatarIndicator(text: 'In Party')
//   SDeckAvatarIndicator(type: SDeckAvatarIndicatorType.playerCardsCard, text: 'Playing')
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../helpers/index.dart';
import '../../themes/text_theme.dart';
import 'sdeck_dot_indicator.dart';

//====================== SDeckAvatarIndicatorType ============================//
// Matches Figma Avatar Indicator > Type dropdown.
// playerCardsCard is not yet visually differentiated from inGame. Pass [avatar]
// for the 16px "Knows 3+" thumbnail; textOnly omits the status dot.
enum SDeckAvatarIndicatorType { inGame, playerCardsCard, textOnly }

//======================== SDeckAvatarIndicator ===============================//
class SDeckAvatarIndicator extends StatelessWidget {
  final SDeckAvatarIndicatorType type;

  /// Short activity label shown next to the dot.
  final String text;

  /// Optional 16×16 trailing thumbnail (Figma Visual Placeholder on
  /// "Knows 3+"). Clipped to [SDeckRadius.borderRadius4].
  final Widget? avatar;

  const SDeckAvatarIndicator({
    super.key,
    this.type = SDeckAvatarIndicatorType.inGame,
    this.text = 'Text',
    this.avatar,
  });

  //*************************** Build *****************************************//
  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.footer.copyWith(color: context.semantic.secondary),
    );

    // textOnly shows only the label — no dot.
    final Widget label =
        type == SDeckAvatarIndicatorType.textOnly
            ? textWidget
            : Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SDeckDotIndicator(color: SDeckDotIndicatorColor.green),
                const SizedBox(width: SDeckSpace.gap4),
                textWidget,
              ],
            );

    if (avatar == null) return label;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        label,
        const SizedBox(width: SDeckSpace.gap4),
        ClipRRect(
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius4),
          child: SizedBox(
            width: SDeckSize.size16,
            height: SDeckSize.size16,
            child: avatar,
          ),
        ),
      ],
    );
  }
}
