//--------------------------- sdeck_bottom_nav_bar.dart ----------------------//
// This file defines the SDeckBottomNavBar widget for the app.
// It provides a customized BottomNavigationBar that matches Figma designs exactly.
// Uses Flutter's built-in navigation handling with custom theming and icons.
// It is used to ensure consistent navigation experience across the app.
//----------------------------------------------------------------------------//

//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';
import '../../foundations/index.dart';
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

  /// Default navigation items matching Figma design
  static const List<SDeckNavItem> defaultItems = [
    SDeckNavItem(iconName: 'home', label: 'Home'),
    SDeckNavItem(iconName: 'friends', label: 'Social'),
    SDeckNavItem(iconName: 'deck', label: 'Decks'),
    SDeckNavItem(iconName: 'store', label: 'Store'),
    SDeckNavItem(iconName: 'profile', label: 'Profile'),
  ];

  //*************************** Helper Methods ********************************//

  //------------------------------- Build Nav Items -----------------------//
  List<BottomNavigationBarItem> _buildNavItems(BuildContext context) {
    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = index == currentIndex;

      return BottomNavigationBarItem(
        // Use stroke icons for unselected, fill icons for selected
        // SDeckNavIcon now handles color overrides to fix SVG fill issues
        icon: SDeckNavIcon.medium(item.iconName, isSelected: isSelected),
        label: item.label,
        tooltip: item.label,
      );
    }).toList();
  }

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      //------------------------------- Core Properties --------------------//
      currentIndex: currentIndex,
      onTap: onTap,
      items: _buildNavItems(context),
      type: BottomNavigationBarType.fixed, // Ensures all items show
      //------------------------------- Figma Color Matching ---------------//
      backgroundColor: theme.colorScheme.surface,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),

      //------------------------------- Typography -------------------------//
      selectedLabelStyle: theme.textTheme.caption.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: SDeckSpacing.fontSizeCaption,
      ),
      unselectedLabelStyle: theme.textTheme.caption.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: SDeckSpacing.fontSizeCaption,
      ),

      //------------------------------- Behavior ---------------------------//
      showSelectedLabels: true,
      showUnselectedLabels: true,
      enableFeedback: true,

      //------------------------------- Figma Spacing ----------------------//
      iconSize: SDeckSpacing.iconMedium, // Medium size from our SDeckNavIcon
      selectedFontSize: SDeckSpacing.fontSizeCaption,
      unselectedFontSize: SDeckSpacing.fontSizeCaption,

      //------------------------------- Visual Polish ----------------------//
      elevation: SDeckSpacing.elevationMedium, // Subtle shadow like in Figma
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
    );
  }
}
