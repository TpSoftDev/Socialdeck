/*---------------------- sdeck_card_selection_shelf.dart ---------------------*/
// cardSelectionShelf stacks the Camera Roll album tabs over the card list.
// The page owns which album is active and which photos are selected.
// This widget only lays those two pieces out the way Figma does.
//
// Usage:
//   SDeckCardSelectionShelf(
//     tabs: const ['Recents', 'Favorites'],
//     selectedTabIndex: 0,
//     onTabSelected: (index) {},
//     items: const [],
//   )
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';

import '../../helpers/index.dart';
import '../../tokens/index.dart';
import '../tab_bar/sdeck_swipe_tab_bar.dart';
import 'sdeck_card_list.dart';

//------------------------------- SDeckCardSelectionShelf -------------------//
class SDeckCardSelectionShelf extends StatelessWidget {
  //------------------------------- Properties --------------------------------//

  final List<String> tabs;
  final int selectedTabIndex;
  final ValueChanged<int>? onTabSelected;
  final List<SDeckCardListItem> items;

  //------------------------------- Constructor -------------------------------//
  const SDeckCardSelectionShelf({
    super.key,
    required this.tabs,
    required this.selectedTabIndex,
    this.onTabSelected,
    this.items = const [],
  });

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.semantic.surface,
      child: Padding(
        // Figma's 48px bottom pad includes the home indicator. This page
        // already sits in a SafeArea, so 16px is the gap above that inset.
        padding: const EdgeInsets.fromLTRB(
          SDeckSpace.padding16,
          SDeckSpace.padding16,
          SDeckSpace.padding16,
          SDeckSpace.padding16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SDeckSwipeTabBar(
              tabs: tabs,
              selectedIndex: selectedTabIndex,
              onTabSelected: onTabSelected,
            ),
            const SizedBox(height: SDeckSpace.gap12),
            SDeckCardList(items: items),
          ],
        ),
      ),
    );
  }
}
