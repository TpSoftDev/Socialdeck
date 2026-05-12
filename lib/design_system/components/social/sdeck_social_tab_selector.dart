import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class SDeckSocialTabItem {
  final String label;
  final bool showUnreadDot;

  const SDeckSocialTabItem({
    required this.label,
    this.showUnreadDot = false,
  });
}

class SDeckSocialTabSelector extends StatelessWidget {
  final List<SDeckSocialTabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const SDeckSocialTabSelector({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabs.length, (index) {
        final tab = tabs[index];
        final isSelected = selectedIndex == index;

        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTabSelected(index),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tab.label,
                    style: Theme.of(context).textTheme.bodySmallFigma.copyWith(
                          color: isSelected
                              ? context.component.textPrimary
                              : context.component.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                  ),
                  if (tab.showUnreadDot) ...[
                    const SizedBox(width: SDeckSpace.gap8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: context.semantic.info,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}