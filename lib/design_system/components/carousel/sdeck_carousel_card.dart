/*------------------------ sdeck_carousel_card.dart ------------------------*/
// Carousel card component for the SocialDeck design system.
// A framed card that displays paged content (image, Rive animation, video,
// etc.) with a title, description, pagination indicator, and prev/next arrow
// controls. Stateless: the parent owns the current page and supplies the
// content to render and navigation callbacks.
//
// Usage:
//   SDeckCarouselCard(
//     title: "What's New?",
//     description: "Here's an update on what's going on...",
//     totalSegments: 3,
//     currentIndex: 0,
//     background: Image.asset('assets/...'),
//     onPrevious: () { ... },
//     onNext: () { ... },
//   )
//
// Matches Figma: node 314:2816 (carousel (Rive))
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../themes/text_theme.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/icons/index.dart';
import '../../tokens/spacing/index.dart';
import '../pagination/sdeck_pagination_indicator.dart';

//============================ SDeckCarouselCard =============================//
/// A framed carousel card displaying a single page of paged content with a
/// title, description, pagination indicator, and previous/next chevron
/// controls.
class SDeckCarouselCard extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  /// Title shown over the bottom-left of the card. Rendered with the H6 style.
  final String title;

  /// Supporting description shown beneath the title using the Caption style.
  final String description;

  /// Total number of carousel pages. Must be >= 1.
  final int totalSegments;

  /// Currently visible page, zero-indexed. Clamped to a valid range.
  final int currentIndex;

  /// Optional background widget (image, Rive animation, video, etc.) painted
  /// behind the content. The card clips it to its rounded inner frame.
  final Widget? background;

  /// Convenience: image asset path used when [background] is null. Painted
  /// with `BoxFit.cover`.
  final String? backgroundAssetPath;

  /// Optional fixed height. If null the card fills the parent's height.
  final double? height;

  /// Called when the user taps the left chevron.
  final VoidCallback? onPrevious;

  /// Called when the user taps the right chevron.
  final VoidCallback? onNext;

  //------------------------------- Constructor ----------------------------//
  const SDeckCarouselCard({
    super.key,
    required this.title,
    required this.description,
    required this.totalSegments,
    required this.currentIndex,
    this.background,
    this.backgroundAssetPath,
    this.height,
    this.onPrevious,
    this.onNext,
  }) : assert(totalSegments >= 1, 'totalSegments must be at least 1');

  //*************************** Build Method *******************************//
  @override
  Widget build(BuildContext context) {
    final double outerR = SDeckRadius.borderRadius16;
    final double stroke = SDeckSize.size4;
    final double innerR = outerR - stroke;
    final BorderRadius outerRadius = BorderRadius.circular(outerR);
    final BorderRadius innerRadius = BorderRadius.circular(innerR);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: context.semantic.surface,
          borderRadius: outerRadius,
          border: Border.all(
            color: context.component.carouselBorder,
            width: stroke,
          ),
        ),
        padding: EdgeInsets.all(stroke),
        child: ClipRRect(
          borderRadius: innerRadius,
          child: Stack(
            children: <Widget>[
              _buildBackground(context),
              _buildContent(context),
              _buildArrows(context),
            ],
          ),
        ),
      ),
    );
  }

  //*************************** Helper Methods *****************************//

  //----------------------------- Background ------------------------------//
  /// Paints the carousel background. Prefers an explicit [background] widget;
  /// falls back to [backgroundAssetPath]; otherwise paints a transparent
  /// placeholder so the surface color shows through.
  Widget _buildBackground(BuildContext context) {
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
  /// Title, description, and pagination indicator pinned to the bottom of
  /// the card with 16px padding on all sides.
  Widget _buildContent(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(SDeckSpace.padding16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: Text(
                  title,
                  style: textTheme.h6.copyWith(
                    color: context.component.carouselTitleText,
                  ),
                ),
              ),
              const SizedBox(height: SDeckSpace.gap4),
              SizedBox(
                width: double.infinity,
                child: Text(
                  description,
                  style: textTheme.caption.copyWith(
                    color: context.component.carouselDescriptionText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SDeckSpace.gap12),
          SDeckPaginationIndicator(
            totalSegments: totalSegments,
            currentIndex: currentIndex,
          ),
        ],
      ),
    );
  }

  //----------------------------- Arrows ----------------------------------//
  /// Left + right chevron arrows pinned to the vertical center of the card,
  /// aligned to the left/right edges. Each chevron has a 20×48 visual frame
  /// inside a 48×48 tap target.
  Widget _buildArrows(BuildContext context) {
    return Positioned.fill(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _CarouselChevron(
            iconAsset: SDeckIcon.leftChevron,
            color: context.component.carouselIconArrow,
            onTap: onPrevious,
            semanticsLabel: 'Previous slide',
            isLeading: true,
          ),
          _CarouselChevron(
            iconAsset: SDeckIcon.rightChevron,
            color: context.component.carouselIconArrow,
            onTap: onNext,
            semanticsLabel: 'Next slide',
            isLeading: false,
          ),
        ],
      ),
    );
  }
}

//============================ _CarouselChevron ==============================//
/// Figma carousel chevron: **20×48** artwork inside a **48×48** min tap target
/// (node 314:2816). Uses [carouselIconArrow] for a light stroke, not a full
/// 48px icon tile.
class _CarouselChevron extends StatelessWidget {
  final String iconAsset;
  final Color color;
  final VoidCallback? onTap;
  final String semanticsLabel;
  final bool isLeading;

  const _CarouselChevron({
    required this.iconAsset,
    required this.color,
    required this.semanticsLabel,
    required this.isLeading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double chevronFrameWidth = 20.0;
    const double tapSize = SDeckSize.size48;
    final double overshoot = (tapSize - chevronFrameWidth) / 2;

    return SizedBox(
      width: chevronFrameWidth,
      height: tapSize,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            left: isLeading ? -overshoot : null,
            right: isLeading ? null : -overshoot,
            child: Semantics(
              button: true,
              label: semanticsLabel,
              child: Material(
                type: MaterialType.transparency,
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor:
                      const WidgetStatePropertyAll<Color?>(Colors.transparent),
                  borderRadius:
                      BorderRadius.circular(SDeckRadius.borderRadius8),
                  child: SizedBox(
                    width: tapSize,
                    height: tapSize,
                    child: Align(
                      alignment: isLeading
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: isLeading ? overshoot : 0,
                          right: isLeading ? 0 : overshoot,
                        ),
                        child: SvgPicture.asset(
                          iconAsset,
                          width: chevronFrameWidth,
                          height: tapSize,
                          fit: BoxFit.contain,
                          alignment: isLeading
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
