/*------------------------ sdeck_image_target.dart --------------------------*/
// imageTarget (Rive) component for the SocialDeck design system.
// A horizontally-laid framed card used to present a primary call-to-action
// (e.g. "Find Friends", "Create Party") on top of a Rive/image background.
// Stateless and tappable — the parent supplies the title, description,
// optional background, and the onTap callback.
//
// Usage:
//   SDeckImageTarget(
//     title: 'Find Friends',
//     description: 'Search and request to be friends',
//     onTap: () => context.push('/find-friends'),
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../themes/text_theme.dart';
import '../../tokens/index.dart';
import '../placeholders/sdeck_visual_placeholder.dart';

//============================= SDeckImageTarget ==============================//
class SDeckImageTarget extends StatelessWidget {
  //------------------------------- Properties --------------------------------//

  /// Title shown at the top of the words column. Rendered with the H6 style.
  final String title;

  /// Supporting description shown beneath the title with the Caption style.
  final String description;

  /// Optional background widget (Rive animation, image, video, etc.) painted
  /// behind the content. Clipped to the card's rounded inner frame.
  final Widget? background;

  /// Shorthand for a plain image background. Ignored when background is set.
  final String? backgroundAssetPath;

  /// Called when the card is tapped. When null the card is non-interactive.
  final VoidCallback? onTap;

  /// Optional fixed height. When null the card hugs its content.
  final double? height;

  /// Optional drop shadow.
  final List<BoxShadow>? boxShadow;

  //------------------------------- Constructor -------------------------------//
  const SDeckImageTarget({
    super.key,
    required this.title,
    required this.description,
    this.background,
    this.backgroundAssetPath,
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
          Expanded(
            child: Column(
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
          ),
        ],
      ),
    );
  }
}
