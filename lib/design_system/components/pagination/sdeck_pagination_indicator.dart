/*------------------- sdeck_pagination_indicator.dart ----------------------*/
// Pagination indicator component for the SocialDeck design system.
// A horizontal pill containing a row of dots that communicate which page of a
// multi-page surface (e.g. a carousel) is currently visible. The active dot is
// 8px and uses paginationFill; the inactive dots are 6px and use paginationTrack.
// The pill background uses paginationOutline.
//
// Stateless: the parent owns the current page index and rebuilds this widget
// when the index changes.
//
// Usage:
//   SDeckPaginationIndicator(
//     totalSegments: 3,
//     currentIndex: 0,
//   )
//
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/spacing/index.dart';

//============================ SDeckPaginationIndicator ======================//
/// A pill-shaped row of dots indicating the current page in a paged surface.
///
/// - The active dot is rendered at 8px using `component.paginationFill`.
/// - The other dots are rendered at 6px using `component.paginationTrack`.
/// - The pill background uses `component.paginationOutline`.
class SDeckPaginationIndicator extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  /// The total number of segments (dots) to display. Must be >= 1.
  final int totalSegments;

  /// The currently active segment, zero-indexed. Clamped to a valid range.
  final int currentIndex;

  //------------------------------- Constructor ----------------------------//
  const SDeckPaginationIndicator({
    super.key,
    required this.totalSegments,
    required this.currentIndex,
  }) : assert(totalSegments >= 1, 'totalSegments must be at least 1');

  //*************************** Build Method *******************************//
  @override
  Widget build(BuildContext context) {
    final int safeIndex = currentIndex.clamp(0, totalSegments - 1);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SDeckSpace.padding8,
        vertical: SDeckSpace.padding4,
      ),
      decoration: BoxDecoration(
        color: context.component.paginationOutline,
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List<Widget>.generate(totalSegments, (int i) {
          final bool isActive = i == safeIndex;
          return Padding(
            padding: EdgeInsets.only(
              left: i == 0 ? 0 : SDeckSpace.gap4,
            ),
            child: _PaginationDot(isActive: isActive),
          );
        }),
      ),
    );
  }
}

//============================ _PaginationDot ================================//
/// A single dot inside the pagination indicator. Sizes/colors are driven by
/// the `isActive` flag.
class _PaginationDot extends StatelessWidget {
  final bool isActive;

  const _PaginationDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final double size = isActive ? SDeckSize.size8 : 6.0;
    final Color color = isActive
        ? context.component.paginationFill
        : context.component.paginationTrack;

    return SizedBox(
      width: SDeckSize.size8,
      height: SDeckSize.size8,
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
