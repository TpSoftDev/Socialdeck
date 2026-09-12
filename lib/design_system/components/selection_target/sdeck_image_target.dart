/*------------------------ sdeck_image_target.dart --------------------------*/
// imageTarget (Rive) component — matches Figma imageTarget (Rive).
// Supports two types:
//   default_ — title + description, used as a full-width entry card.
//   profile  — title + AvatarIndicator + optional InlineNavLink, used inside
//              the profileBottomSheet.
//
// Usage:
//   SDeckImageTarget(
//     title: 'Find Friends',
//     description: 'Search and request to be friends',
//     onTap: () => context.go('/find-friends'),
//   )
//
//   SDeckImageTarget(
//     type: SDeckImageTargetType.profile,
//     title: 'Username',
//     avatarIndicatorText: 'In Party',
//     navLink: true,
//     navLinkTitle: 'View Profile',
//     onNavLinkTap: () {},
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../themes/text_theme.dart';
import '../../tokens/index.dart';
import '../placeholders/sdeck_visual_placeholder.dart';
import '../navigation/sdeck_inline_nav_link.dart';
import '../status/sdeck_avatar_indicator.dart';

//========================= SDeckImageTargetType ==============================//
// Matches Figma imageTarget (Rive) > Type dropdown.
enum SDeckImageTargetType { default_, profile }

//============================= SDeckImageTarget ==============================//
class SDeckImageTarget extends StatelessWidget {
  //------------------------------- Properties --------------------------------//

  /// Matches Figma imageTarget (Rive) > Type.
  final SDeckImageTargetType type;

  /// Title shown in the words column. Rendered with H6 style.
  final String title;

  /// Description shown beneath the title. Only rendered for the default type.
  final String description;

  /// Optional background widget (Rive, image, etc.) painted behind the card.
  final Widget? background;

  /// Shorthand for a plain image background. Ignored when background is set.
  final String? backgroundAssetPath;

  /// Matches Figma imageTarget (Rive) > Nav Link? — shows the InlineNavLink
  /// on the right side. Only applies to the profile type.
  final bool navLink;

  /// Title passed to the InlineNavLink. Only used when navLink is true.
  final String navLinkTitle;

  /// Callback for the InlineNavLink tap.
  final VoidCallback? onNavLinkTap;

  /// Matches Figma Avatar Indicator > Type. Only used for the profile type.
  final SDeckAvatarIndicatorType avatarIndicatorType;

  /// Matches Figma Avatar Indicator > Text. Only used for the profile type.
  final String avatarIndicatorText;

  /// Called when the card is tapped. When null the card is non-interactive.
  final VoidCallback? onTap;

  /// Optional fixed height. When null the card hugs its content.
  final double? height;

  /// Optional drop shadow.
  final List<BoxShadow>? boxShadow;

  //------------------------------- Constructor -------------------------------//
  const SDeckImageTarget({
    super.key,
    this.type = SDeckImageTargetType.default_,
    required this.title,
    this.description = '',
    this.background,
    this.backgroundAssetPath,
    this.navLink = false,
    this.navLinkTitle = 'Title',
    this.onNavLinkTap,
    this.avatarIndicatorType = SDeckAvatarIndicatorType.inGame,
    this.avatarIndicatorText = 'Text',
    this.onTap,
    this.height,
    this.boxShadow,
  });

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    final BorderRadius outerRadius = BorderRadius.circular(
      SDeckRadius.borderRadius16,
    );
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      type: MaterialType.transparency,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: outerRadius,
        splashFactory: NoSplash.splashFactory,
        overlayColor: const WidgetStatePropertyAll<Color?>(Colors.transparent),
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: context.semantic.surface,
            borderRadius: outerRadius,
            border: Border.all(
              color: context.component.selectionTargetBorder,
              width: SDeckSize.size4,
            ),
            boxShadow: boxShadow,
          ),
          child: ClipRRect(
            borderRadius: outerRadius,
            child: Stack(
              children: <Widget>[
                _buildBackground(),
                _buildContent(context, textTheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //*************************** Helper Methods ********************************//

  Widget _buildBackground() {
    Widget child;
    if (background != null) {
      child = background!;
    } else if (backgroundAssetPath != null) {
      child = Image.asset(
        backgroundAssetPath!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      child = const SDeckVisualPlaceholder(
        height: double.infinity,
        borderRadius: BorderRadius.zero,
      );
    }
    return Positioned.fill(child: IgnorePointer(child: child));
  }

  Widget _buildContent(BuildContext context, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(SDeckSpace.padding16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: _buildWords(context, textTheme)),
          if (type == SDeckImageTargetType.profile && navLink) ...[
            const SizedBox(width: SDeckSpace.gap4),
            SDeckInlineNavLink(
              title: navLinkTitle,
              onTap: onNavLinkTap,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWords(BuildContext context, TextTheme textTheme) {
    return switch (type) {
      SDeckImageTargetType.default_ => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: textTheme.h6.copyWith(
                color: context.component.selectionTargetTitleText,
              ),
            ),
            const SizedBox(height: SDeckSpace.gap4),
            Text(
              description,
              style: textTheme.caption.copyWith(
                color: context.component.selectionTargetDescriptionText,
              ),
            ),
          ],
        ),
      SDeckImageTargetType.profile => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: textTheme.h6.copyWith(
                color: context.component.selectionTargetTitleText,
              ),
            ),
            const SizedBox(height: SDeckSpace.gap4),
            SDeckAvatarIndicator(
              type: avatarIndicatorType,
              text: avatarIndicatorText,
            ),
          ],
        ),
    };
  }
}
