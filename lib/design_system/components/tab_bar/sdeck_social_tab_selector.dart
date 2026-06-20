/*-------------------- sdeck_social_tab_selector.dart ------------------------*/
// Horizontal tab selector with two labelled tabs and optional dot indicators.
// Active tab renders in the primary navigation color, inactive in secondary.
// Each tab independently controls whether its dot is shown and what color it is.
//
// Usage:
//   SDeckSocialTabSelector(
//     selectedIndex: 0,
//     tabs: const [
//       SDeckSocialTabItem(label: 'People', showUnreadDot: true, dotColor: SDeckDotIndicatorColor.blue),
//       SDeckSocialTabItem(label: 'News', showUnreadDot: true, dotColor: SDeckDotIndicatorColor.red),
//     ],
//     onTabSelected: (index) {},
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//========================= SDeckSocialTabItem ================================//
class SDeckSocialTabItem {
  final String label;

  /// When true a dot indicator is shown to the right of the label.
  final bool showUnreadDot;

  /// Color of the dot indicator. Only relevant when showUnreadDot is true.
  final SDeckDotIndicatorColor dotColor;

  const SDeckSocialTabItem({
    required this.label,
    this.showUnreadDot = false,
    this.dotColor = SDeckDotIndicatorColor.blue,
  });
}

//========================= SDeckSocialTabSelector ============================//
class SDeckSocialTabSelector extends StatelessWidget {
  //------------------------------- Properties --------------------------------//

  final List<SDeckSocialTabItem> tabs;

  final int selectedIndex;

  final ValueChanged<int> onTabSelected;

  //------------------------------- Constructor -------------------------------//
  const SDeckSocialTabSelector({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SDeckSpace.padding8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          final isSelected = selectedIndex == index;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTabSelected(index),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tab.label,
                  style: Theme.of(context).textTheme.h6.copyWith(
                        color: isSelected
                            ? context.component.navigationText
                            : context.component.textSecondary,
                      ),
                ),
                if (tab.showUnreadDot) ...[
                  const SizedBox(width: SDeckSpace.gap8),
                  SDeckDotIndicator(color: tab.dotColor),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}
