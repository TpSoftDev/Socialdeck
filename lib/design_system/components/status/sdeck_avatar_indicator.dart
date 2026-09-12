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
// playerCardsCard and textOnly are defined in Figma but not yet visually
// differentiated — they render the same as inGame until the designer specifies.
enum SDeckAvatarIndicatorType { inGame, playerCardsCard, textOnly }

//======================== SDeckAvatarIndicator ===============================//
class SDeckAvatarIndicator extends StatelessWidget {
  final SDeckAvatarIndicatorType type;

  /// Short activity label shown next to the dot.
  final String text;

  const SDeckAvatarIndicator({
    super.key,
    this.type = SDeckAvatarIndicatorType.inGame,
    this.text = 'Text',
  });

  //*************************** Build *****************************************//
  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: Theme.of(context).textTheme.footer.copyWith(
            color: context.semantic.secondary,
          ),
    );

    // textOnly shows only the label — no dot.
    if (type == SDeckAvatarIndicatorType.textOnly) {
      return textWidget;
    }

    // inGame and playerCardsCard show a green dot + label.
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SDeckDotIndicator(color: SDeckDotIndicatorColor.green),
        const SizedBox(width: SDeckSpace.gap4),
        textWidget,
      ],
    );
  }
}
