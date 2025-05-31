/*------------------------ sdeck_solid_button.dart --------------------------*/
// Solid Default Button component for the SocialDeck design system
// Handles all variations: 2 radii × 4 states × 3 icon configs × 3 sizes = 72 variants
// Theme-aware component that matches Figma designs exactly
//
// Usage: SDeckSolidButton.medium() or with full customization
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../foundations/index.dart';
import '../icons/index.dart';

//------------------------------- Enums -------------------------------------//

/// Button size variations (affects padding and typography)
enum SDeckButtonSize {
  small, // 14px text, 0px 8px padding
  medium, // 16px text, 8px 16px padding
  large, // 18px text, 20px 24px padding
}

/// Button radius style
enum SDeckButtonRadius {
  squared, // 8px radius
  round, // 24px (small/medium), 32px (large)
}

/// Icon configuration
enum SDeckButtonIconConfig {
  none, // No icon
  left, // Icon on the left
  right, // Icon on the right
}

/// Button interaction state (controls colors)
enum SDeckButtonState {
  enabled, // Default state: #1F1F1F
  hover, // Hover state: #0F0F0F
  pressed, // Pressed state: #5E5E5E
  disabled, // Disabled state: #9E9E9E
}

//============================ SDeckSolidButton ============================//

class SDeckSolidButton extends StatefulWidget {
  //------------------------------- Properties -----------------------------//
  final String text;
  final VoidCallback? onPressed;
  final SDeckButtonSize size;
  final SDeckButtonRadius radius;
  final SDeckButtonIconConfig iconConfig;
  final Widget? icon;
  final bool enabled;

  //------------------------------- Private Constructor -------------------//
  const SDeckSolidButton._({
    super.key,
    required this.text,
    this.onPressed,
    required this.size,
    required this.radius,
    required this.iconConfig,
    this.icon,
    this.enabled = true,
  });

  //*************************** Named Constructors ***************************//

  //------------------------------- Small Variants ------------------------//
  /// Small squared button with no icon
  const SDeckSolidButton.small({
    super.key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.small,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
       );

  /// Small squared button with left icon
  const SDeckSolidButton.smallWithLeftIcon({
    super.key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.small,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.left,
         icon: icon,
         enabled: enabled,
       );

  /// Small squared button with right icon
  const SDeckSolidButton.smallWithRightIcon({
    super.key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.small,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.right,
         icon: icon,
         enabled: enabled,
       );

  /// Small round button with no icon
  const SDeckSolidButton.smallRound({
    super.key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.small,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
       );

  /// Small round button with left icon
  const SDeckSolidButton.smallRoundWithLeftIcon({
    super.key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.small,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.left,
         icon: icon,
         enabled: enabled,
       );

  /// Small round button with right icon
  const SDeckSolidButton.smallRoundWithRightIcon({
    super.key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.small,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.right,
         icon: icon,
         enabled: enabled,
       );

  //------------------------------- Medium Variants -----------------------//
  /// Medium squared button with no icon (most common)
  const SDeckSolidButton.medium({
    super.key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.medium,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
       );

  /// Medium squared button with left icon
  const SDeckSolidButton.mediumWithLeftIcon({
    super.key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.medium,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.left,
         icon: icon,
         enabled: enabled,
       );

  /// Medium squared button with right icon
  const SDeckSolidButton.mediumWithRightIcon({
    super.key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.medium,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.right,
         icon: icon,
         enabled: enabled,
       );

  /// Medium round button with no icon
  const SDeckSolidButton.mediumRound({
    super.key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.medium,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
       );

  /// Medium round button with left icon
  const SDeckSolidButton.mediumRoundWithLeftIcon({
    super.key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.medium,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.left,
         icon: icon,
         enabled: enabled,
       );

  /// Medium round button with right icon
  const SDeckSolidButton.mediumRoundWithRightIcon({
    super.key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.medium,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.right,
         icon: icon,
         enabled: enabled,
       );

  //------------------------------- Large Variants ------------------------//
  /// Large squared button with no icon
  const SDeckSolidButton.large({
    super.key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.large,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
       );

  /// Large squared button with left icon
  const SDeckSolidButton.largeWithLeftIcon({
    super.key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.large,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.left,
         icon: icon,
         enabled: enabled,
       );

  /// Large squared button with right icon
  const SDeckSolidButton.largeWithRightIcon({
    super.key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.large,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.right,
         icon: icon,
         enabled: enabled,
       );

  /// Large round button with no icon
  const SDeckSolidButton.largeRound({
    super.key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.large,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
       );

  /// Large round button with left icon
  const SDeckSolidButton.largeRoundWithLeftIcon({
    super.key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.large,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.left,
         icon: icon,
         enabled: enabled,
       );

  /// Large round button with right icon
  const SDeckSolidButton.largeRoundWithRightIcon({
    super.key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.large,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.right,
         icon: icon,
         enabled: enabled,
       );

  @override
  State<SDeckSolidButton> createState() => _SDeckSolidButtonState();
}
