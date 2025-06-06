//------------------------------- sdeck_nav_icon.dart ------------------------//
// This file defines the SDeckNavIcon widget for navigation bars.
// It provides automatic switching between stroke and fill icon variants
// based on selection state. All icons are pulled from the design system.
// It is used to ensure consistent navigation icon rendering across the app.
//----------------------------------------------------------------------------//

//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';
import '../../foundations/index.dart';
import '../icons/sdeck_icon.dart';

//------------------------------- SDeckNavIcon -------------------------------//
/// A theme-aware navigation icon widget that automatically switches between
/// stroke and fill variants based on selection state. Integrates seamlessly
/// with the existing SDeckIcon system and design system colors.

class SDeckNavIcon extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  final String iconName;
  final bool isSelected;
  final double width;
  final double height;

  //------------------------------- Constructor ----------------------------//
  const SDeckNavIcon(
    this.iconName, {
    super.key,
    required this.isSelected,
    this.width = SDeckSpacing.iconMedium,
    this.height = SDeckSpacing.iconMedium,
  });

  //*************************** Named Constructors ***************************//

  //------------------------------- Small Size (16px) ---------------------//
  const SDeckNavIcon.small(this.iconName, {super.key, required this.isSelected})
    : width = SDeckSpacing.iconSmall,
      height = SDeckSpacing.iconSmall;

  //------------------------------- Medium Size (24px) --------------------//
  const SDeckNavIcon.medium(
    this.iconName, {
    super.key,
    required this.isSelected,
  }) : width = SDeckSpacing.iconMedium,
       height = SDeckSpacing.iconMedium;

  //------------------------------- Large Size (32px) ---------------------//
  const SDeckNavIcon.large(this.iconName, {super.key, required this.isSelected})
    : width = SDeckSpacing.iconLarge,
      height = SDeckSpacing.iconLarge;

  //------------------------------- Extra Large Size (48px) ----------------//
  const SDeckNavIcon.extraLarge(this.iconName, {super.key, required this.isSelected})
    : width = SDeckSpacing.iconXLarge,
      height = SDeckSpacing.iconXLarge;

  //*************************** Helper Methods ********************************//

  //------------------------------- Icon Path Selection -------------------//
  String _getIconPath(BuildContext context) {
    // Maps icon names to the appropriate stroke/fill variant
    // Uses the navigation helper methods from SDeckNavIconsExtension
    switch (iconName.toLowerCase()) {
      case 'home':
        return context.icons.homeNav(isSelected);
      case 'friends':
      case 'social':
        return context.icons.friendsNav(isSelected);
      case 'deck':
      case 'decks':
        return context.icons.deckNav(isSelected);
      case 'store':
        return context.icons.storeNav(isSelected);
      case 'profile':
        return context.icons.profileNav(isSelected);
      default:
        // Fallback to home icon if unknown name provided
        return context.icons.homeNav(isSelected);
    }
  }

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    // Uses the existing SDeckIcon system with the selected icon path
    // This ensures consistent sizing, theming, and behavior
    return SDeckIcon(_getIconPath(context), width: width, height: height);
  }
}
