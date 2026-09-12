/*--------------------- sdeck_profile_bottom_sheet.dart ----------------------*/
// Profile bottom sheet — matches Figma profileBottomSheet component.
// Displays a 192×192 avatar that overflows above the sheet, an imageTarget
// (Profile type) card showing username and activity status, and a button list.
//
// Usage:
//   showSDeckProfileBottomSheet(
//     context: context,
//     title: 'Username',
//     avatar: ClipOval(
//       child: SDeckProfileCardPlaceholder(
//         photoUrl: user.photoUrl,
//         scale: user.scale,
//         panX: user.panX,
//         panY: user.panY,
//         rotation: user.rotation,
//         variant: SDeckProfileCardVariant.fixed,
//         size: 192,
//       ),
//     ),
//     avatarIndicatorType: SDeckAvatarIndicatorType.textOnly,
//     avatarIndicatorText: '14 Friends',
//     navLink: true,
//     navLinkTitle: 'View',
//     buttons: [SDeckSolidButton(text: 'Add Friend', ...)],
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../tokens/effects/box_shadows.dart';
import '../../helpers/index.dart';
import '../avatar/profile_card_enums.dart';
import '../avatar/sdeck_profile_card_placeholder.dart';
import '../selection_target/sdeck_image_target.dart';
import '../status/sdeck_avatar_indicator.dart';

//======================= SDeckProfileBottomSheet ============================//
class SDeckProfileBottomSheet extends StatelessWidget {
  //------------------------------- Properties --------------------------------//

  // 192×192 circular avatar shown overflowing above the sheet.
  // Defaults to fixed profile card placeholder when null.
  // TODO(backend): pass ClipOval + SDeckProfileCardPlaceholder with user fields.
  final Widget? avatar;

  // Matches Figma imageTarget (Rive) > Title — the profile username or name.
  final String title;

  // Matches Figma imageTarget (Rive) > Nav Link? — shows the InlineNavLink.
  final bool navLink;

  // Title passed to the InlineNavLink.
  final String navLinkTitle;

  // Callback for the InlineNavLink tap.
  final VoidCallback? onNavLinkTap;

  // Matches Figma Avatar Indicator > Type.
  final SDeckAvatarIndicatorType avatarIndicatorType;

  // Matches Figma Avatar Indicator > Text.
  final String avatarIndicatorText;

  // Rendered as a vertical stack with gap8 between each widget.
  final List<Widget>? buttons;

  //------------------------------- Constructor -------------------------------//
  const SDeckProfileBottomSheet({
    super.key,
    this.avatar,
    required this.title,
    this.navLink = false,
    this.navLinkTitle = 'Title',
    this.onNavLinkTap,
    this.avatarIndicatorType = SDeckAvatarIndicatorType.inGame,
    this.avatarIndicatorText = 'Text',
    this.buttons,
  });

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        //------------------------ Avatar (behind sheet) ---------------------//
        // Figma: avatar sits BEHIND the sheet. margin16 from left, -160px above
        // the sheet top. Rendered first so sheet paints on top of it.
        Positioned(top: -160, left: SDeckSpace.margin16, child: _buildAvatar()),

        //------------------------ Sheet Body (on top) -----------------------//
        _buildSheet(context),
      ],
    );
  }

  //*************************** Helper Methods ********************************//

  //------------------------------- Avatar ----------------------------------//
  Widget _buildAvatar() {
    return SizedBox(
      width: SDeckSize.size192,
      height: SDeckSize.size192,
      child: ClipOval(
        child:
            avatar ??
            const SDeckProfileCardPlaceholder(
              variant: SDeckProfileCardVariant.fixed,
              size: SDeckSize.size192,
            ),
      ),
    );
  }

  //------------------------------- Sheet -----------------------------------//
  Widget _buildSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.component.sheetSurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(SDeckRadius.borderRadius16),
        ),
        boxShadow: SDeckBoxShadows.boxShadowHigh(context.semantic.shadow),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          SDeckSpace.padding16,
          SDeckSpace.padding24,
          SDeckSpace.padding16,
          SDeckSpace.padding48,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //------------------ Image Target (Profile) ------------------//
            SDeckImageTarget(
              type: SDeckImageTargetType.profile,
              title: title,
              navLink: navLink,
              navLinkTitle: navLinkTitle,
              onNavLinkTap: onNavLinkTap,
              avatarIndicatorType: avatarIndicatorType,
              avatarIndicatorText: avatarIndicatorText,
            ),

            //------------------ Button Stack ----------------------------//
            if (buttons != null && buttons!.isNotEmpty) ...[
              const SizedBox(height: SDeckSpace.gap12),
              _buildButtons(),
            ],
          ],
        ),
      ),
    );
  }

  //------------------------------- Button Stack ----------------------------//
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

//========================= showSDeckProfileBottomSheet =======================//
Future<void> showSDeckProfileBottomSheet({
  required BuildContext context,
  Widget? avatar,
  required String title,
  bool navLink = false,
  String navLinkTitle = 'Title',
  VoidCallback? onNavLinkTap,
  SDeckAvatarIndicatorType avatarIndicatorType =
      SDeckAvatarIndicatorType.inGame,
  String avatarIndicatorText = 'Text',
  List<Widget>? buttons,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color.fromRGBO(31, 31, 31, 0.25),
    useRootNavigator: true,
    builder:
        (_) => SDeckProfileBottomSheet(
          avatar: avatar,
          title: title,
          navLink: navLink,
          navLinkTitle: navLinkTitle,
          onNavLinkTap: onNavLinkTap,
          avatarIndicatorType: avatarIndicatorType,
          avatarIndicatorText: avatarIndicatorText,
          buttons: buttons,
        ),
  );
}
