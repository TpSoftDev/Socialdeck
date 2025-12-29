//--------------------------- sdeck_bottom_nav_bar.dart ----------------------//
// This file defines the SDeckBottomNavBar widget for the app.
// It provides a customized BottomNavigationBar that matches Figma designs exactly.
// Uses Flutter's built-in navigation handling with custom theming and icons.
// It is used to ensure consistent navigation experience across the app.
//----------------------------------------------------------------------------//

//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import 'sdeck_nav_icon.dart';

//------------------------------- Navigation Item Model ---------------------//
/// Data model for navigation bar items
class SDeckNavItem {
  final String iconName;
  final String label;

  const SDeckNavItem({required this.iconName, required this.label});
}

//------------------------------- SDeckBottomNavBar -------------------------//
/// A theme-aware bottom navigation bar that matches Figma designs exactly.
/// Uses Flutter's BottomNavigationBar with heavy customization for colors,
/// typography, and icon behavior. Integrates with SDeckNavIcon for state switching.

class SDeckBottomNavBar extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final List<SDeckNavItem> items;

  //------------------------------- Constructor ----------------------------//
  const SDeckBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  //*************************** Default Items *******************************//

  /// Default navigation items matching Figma desig
  static const List<SDeckNavItem> defaultItems = [
    SDeckNavItem(iconName: 'home', label: 'Home'),
    SDeckNavItem(iconName: 'mail', label: 'Social'),
    SDeckNavItem(iconName: 'deck', label: 'Decks'),
    SDeckNavItem(iconName: 'store', label: 'Store'),
    SDeckNavItem(iconName: 'profile', label: 'Profile'),
  ];

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory, // Remove ripple effects
      ),
      child: BottomNavigationBar(
        items:
            items
                .map(
                  (item) => BottomNavigationBarItem(
                    icon: SDeckNavIcon.large(item.iconName, isSelected: false),
                    activeIcon: SDeckNavIcon.large(
                      item.iconName,
                      isSelected: true,
                    ),
                    label: item.label,
                    tooltip: item.label,
                  ),
                )
                .toList(),
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        iconSize:
            SDeckSpaceComponentSpecific
                .iconLarge, // Large size from our SDeckNavIcon
        showSelectedLabels: false, // Hide labels to match Figma
        showUnselectedLabels: false, // Hide labels to match Figma
        elevation: 0.0,
      ),
    );
  }
}
