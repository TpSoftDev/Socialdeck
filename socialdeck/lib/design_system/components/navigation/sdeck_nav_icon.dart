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
import '../../tokens/icons/icons.dart';
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
    this.width = SDeckSize.sizeL, // 24px - Medium icon size
    this.height = SDeckSize.sizeL, // 24px - Medium icon size
  });

  //*************************** Named Constructors ***************************//

  //------------------------------- Small Size (16px) ---------------------//
  const SDeckNavIcon.small(this.iconName, {super.key, required this.isSelected})
    : width = SDeckSize.sizeM, // 16px
      height = SDeckSize.sizeM; // 16px

  //------------------------------- Medium Size (24px) --------------------//
  const SDeckNavIcon.medium(
    this.iconName, {
    super.key,
    required this.isSelected,
  }) : width = SDeckSize.sizeL, // 24px
       height = SDeckSize.sizeL; // 24px

  //------------------------------- Large Size (48px) ---------------------//
  // TODO: Verify if this should be 36px or 48px in Figma
  const SDeckNavIcon.large(this.iconName, {super.key, required this.isSelected})
    : width = SDeckSize.sizeXXL, // 48px (hardcoded for now, verify in Figma)
      height = SDeckSize.sizeXXL; // 48px (hardcoded for now, verify in Figma)

  //------------------------------- Extra Large Size (48px) ----------------//
  const SDeckNavIcon.extraLarge(
    this.iconName, {
    super.key,
    required this.isSelected,
  }) : width = SDeckSize.sizeXXL, // 48px
       height = SDeckSize.sizeXXL; // 48px

  //*************************** Helper Methods ********************************//

  //------------------------------- Icon Path Selection -------------------//
  /// Returns icon path based on selection state
  /// Selected icons use fill variant, unselected use stroke variant
  String _getIconPath() {
    switch (iconName.toLowerCase()) {
      case 'home':
        return isSelected ? SDeckIcons.homeFill : SDeckIcons.home;
      case 'mail':
        return isSelected ? SDeckIcons.mailFill : SDeckIcons.mail;
      case 'friends':
      case 'social':
        // TODO: Friends stroke icon missing - using placeholder
        return isSelected ? SDeckIcons.friendsFill : SDeckIcons.placeholder;
      case 'deck':
      case 'decks':
        // TODO: Deck stroke icon missing - using placeholder
        return isSelected ? SDeckIcons.deckFill : SDeckIcons.placeholder;
      case 'store':
        // TODO: Store fill icon missing - using stroke only
        return SDeckIcons.store;
      case 'profile':
        return isSelected ? SDeckIcons.profileFill : SDeckIcons.profile;
      default:
        // Fallback to home icon if unknown name provided
        return isSelected ? SDeckIcons.homeFill : SDeckIcons.home;
    }
  }

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    // Icons are monochrome - color applied via ThemeExtension
    // ThemeExtension automatically handles light/dark mode adaptation
    return SDeckIcon(
      _getIconPath(),
      width: width,
      height: height,
      color: context.component.navigationIcon,
    );
  }
}
