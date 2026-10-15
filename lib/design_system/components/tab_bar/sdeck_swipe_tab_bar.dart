/*-------------------------- sdeck_swipe_tab_bar.dart -----------------------*/
// swipeTabBar is the horizontal album row on Camera Roll.
// The active tab uses the primary text color. Inactive tabs use the
// secondary-variant gray. The row scrolls when the albums do not fit.
//
// Usage:
//   SDeckSwipeTabBar(
//     tabs: const ['Recents', 'Favorites'],
//     selectedIndex: 0,
//     onTabSelected: (index) {},
//   )
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';

import '../../helpers/index.dart';
import '../../themes/text_theme.dart';
import '../../tokens/index.dart';

//------------------------------- SDeckSwipeTabBar --------------------------//
class SDeckSwipeTabBar extends StatelessWidget {
  //------------------------------- Properties --------------------------------//

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;

  //------------------------------- Constructor -------------------------------//
  const SDeckSwipeTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.onTabSelected,
  });

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMediumFigma;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(SDeckSpace.padding8),
        child: Row(
          children: [
            for (var index = 0; index < tabs.length; index++) ...[
              if (index > 0) const SizedBox(width: SDeckSpace.gap24),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTabSelected == null
                    ? null
                    : () => onTabSelected!(index),
                child: Text(
                  tabs[index],
                  style: textStyle.copyWith(
                    color: index == selectedIndex
                        ? context.semantic.primary
                        : context.semantic.secondaryVariant,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
