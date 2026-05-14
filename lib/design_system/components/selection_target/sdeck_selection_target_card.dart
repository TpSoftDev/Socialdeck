/*-------------------- sdeck_selection_target_card.dart --------------------*/
// Selection target card component for the SocialDeck design system.
// A horizontally-laid framed card used to present a primary call-to-action
// (e.g. "Create Party", "Join a Party") on top of a Rive/image background.
// Stateless and tappable — the parent supplies the title, description,
// optional background, and the onTap callback.
//
// Usage:
//   SDeckSelectionTargetCard(
//     title: 'Create Party',
//     description: 'Start a new game',
//     onTap: () => context.push('/parties/new'),
//   )
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';
import '../../themes/text_theme.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/spacing/index.dart';

//============================ SDeckSelectionTargetCard ======================//
/// A framed horizontal card with a title, description and optional background
/// widget (Rive animation, image, video, etc.). Used for primary action tiles
/// such as "Create Party" / "Join a Party" on the home screen.
class SDeckSelectionTargetCard extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  /// Title shown at the top of the words column. Rendered with the H6 style.
  final String title;

  /// Supporting description shown beneath the title with the Caption style.
  final String description;

  /// Optional background widget (image, Rive animation, video, etc.) painted
  /// behind the content. Clipped to the card's rounded inner frame.
  final Widget? background;

  /// Convenience: image asset path used when [background] is null. Painted
  /// with `BoxFit.cover`.
  final String? backgroundAssetPath;

  /// Called when the card is tapped. When null the card is non-interactive.
  final VoidCallback? onTap;

  /// Optional fixed height. When null the card hugs its content.
  final double? height;

  //------------------------------- Constructor ----------------------------//
  const SDeckSelectionTargetCard({
    super.key,
    required this.title,
    required this.description,
    this.background,
    this.backgroundAssetPath,
    this.onTap,
    this.height,
  });

  //*************************** Build Method *******************************//
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

  //*************************** Helper Methods *****************************//

  //----------------------------- Background ------------------------------//
  /// Paints the card background. Prefers an explicit [background] widget;
  /// falls back to [backgroundAssetPath]; otherwise renders nothing so the
  /// card surface shows through.
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
      child = const SizedBox.expand();
    }
    return Positioned.fill(child: IgnorePointer(child: child));
  }

  //----------------------------- Content ---------------------------------//
  /// Title + description column, centered vertically inside 16px padding.
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
