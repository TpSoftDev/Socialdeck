//------------------------------- sdeck_nav_icon.dart ------------------------//
// This file defines the SDeckNavIcon widget for navigation bars.
// It provides automatic switching between stroke and fill icon variants
// based on selection state. All icons are pulled from the design system.
// It is used to ensure consistent navigation icon rendering across the app.
//----------------------------------------------------------------------------//

//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';
import '../../tokens/spacing/index.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/icons/index.dart';

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
    this.width = SDeckSize.size24, // 24px - Medium icon size
    this.height = SDeckSize.size24, // 24px - Medium icon size
  });

  //*************************** Named Constructors ***************************//

  //------------------------------- Small Size (16px) ---------------------//
  const SDeckNavIcon.small(this.iconName, {super.key, required this.isSelected})
    : width = SDeckSize.size16, // 16px
      height = SDeckSize.size16; // 16px

  //------------------------------- Medium Size (24px) --------------------//
  const SDeckNavIcon.medium(
    this.iconName, {
    super.key,
    required this.isSelected,
  }) : width = SDeckSize.size24, // 24px
       height = SDeckSize.size24; // 24px

  //------------------------------- Large Size (48px) ---------------------//
  // TODO: Verify if this should be 36px or 48px in Figma
  const SDeckNavIcon.large(this.iconName, {super.key, required this.isSelected})
    : width = SDeckSize.size48, // 48px (hardcoded for now, verify in Figma)
      height = SDeckSize.size48; // 48px (hardcoded for now, verify in Figma)

  //------------------------------- Extra Large Size (48px) ----------------//
  const SDeckNavIcon.extraLarge(
    this.iconName, {
    super.key,
    required this.isSelected,
  }) : width = SDeckSize.size48, // 48px
       height = SDeckSize.size48; // 48px

  //*************************** Helper Methods ********************************//

  //------------------------------- Icon Path Selection -------------------//
  /// Returns icon path based on selection state
  /// Selected icons use fill variant, unselected use stroke variant
  String _getIconPath() {
    switch (iconName.toLowerCase()) {
      case 'home':
        return isSelected ? SDeckIcon.homeFill : SDeckIcon.home;
      case 'mail':
        return isSelected ? SDeckIcon.mailFill : SDeckIcon.mail;
      case 'friends':
      case 'social':
        return isSelected ? SDeckIcon.friendsFill : SDeckIcon.friends;
      case 'deck':
      case 'decks':
        // TODO: Deck stroke icon missing - using Cards as placeholder
        return isSelected ? SDeckIcon.deckFill : SDeckIcon.cards;
      case 'store':
        // TODO: Store fill icon missing - using stroke only
        return SDeckIcon.store;
      case 'profile':
        return isSelected ? SDeckIcon.settingsFill : SDeckIcon.settings;
      default:
        // Fallback to home icon if unknown name provided
        return isSelected ? SDeckIcon.homeFill : SDeckIcon.home;
    }
  }

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    // Icons are monochrome - color applied via ThemeExtension
    // ThemeExtension automatically handles light/dark mode adaptation
    return SDeckIcons(
      _getIconPath(),
      size: width, // Using width as size (width == height for icons)
      color: context.component.navigationIcon,
    );
  }
}
