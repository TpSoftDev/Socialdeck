/*------------------------ sdeck_solid_button.dart --------------------------*/
// Solid Default Button component for the SocialDeck design system
// Handles all variations: 2 radii × 4 states × 3 icon configs × 3 sizes = 72 variants
// Theme-aware component that matches Figma designs exactly
//
// Usage: SDeckSolidButton.medium() or with full customization
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../foundations/index.dart';
import '../../tokens/index.dart';
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
  enabled, // Default state
  hover, // Hover state
  pressed, // Pressed state
  disabled, // Disabled state
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
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.small,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
       );

  /// Small squared button with left icon
  const SDeckSolidButton.smallWithLeftIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
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
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
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
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.small,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
       );

  /// Small round button with left icon
  const SDeckSolidButton.smallRoundWithLeftIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
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
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
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
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.medium,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
       );

  /// Medium squared button with left icon
  const SDeckSolidButton.mediumWithLeftIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
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
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
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
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.medium,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
       );

  /// Medium round button with left icon
  const SDeckSolidButton.mediumRoundWithLeftIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
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
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
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
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.large,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
       );

  /// Large squared button with left icon
  const SDeckSolidButton.largeWithLeftIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
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
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
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
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.large,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
       );

  /// Large round button with left icon
  const SDeckSolidButton.largeRoundWithLeftIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
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
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
  }) : this._(
         key: key,
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

//========================= _SDeckSolidButtonState ===========================//

class _SDeckSolidButtonState extends State<SDeckSolidButton> {
  SDeckButtonState _currentState = SDeckButtonState.enabled;

  //*************************** Build Method ******************************//

  @override
  Widget build(BuildContext context) {
    // Determine current state based on enabled status and user interaction
    _currentState =
        widget.enabled ? SDeckButtonState.enabled : SDeckButtonState.disabled;

    return GestureDetector(
      onTapDown:
          widget.enabled ? (_) => _updateState(SDeckButtonState.pressed) : null,
      onTapUp:
          widget.enabled ? (_) => _updateState(SDeckButtonState.enabled) : null,
      onTapCancel:
          widget.enabled ? () => _updateState(SDeckButtonState.enabled) : null,
      onTap: widget.enabled ? widget.onPressed : null,
      child: MouseRegion(
        onEnter:
            widget.enabled ? (_) => _updateState(SDeckButtonState.hover) : null,
        onExit:
            widget.enabled
                ? (_) => _updateState(SDeckButtonState.enabled)
                : null,
        child: Container(
          padding: _getPadding(),
          decoration: BoxDecoration(
            color: _getBackgroundColor(context),
            borderRadius: BorderRadius.circular(_getBorderRadius()),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildButtonContent(context),
          ),
        ),
      ),
    );
  }

  //*************************** Helper Methods *****************************//

  /// Updates the button state and triggers rebuild
  void _updateState(SDeckButtonState newState) {
    if (mounted && _currentState != newState) {
      setState(() {
        _currentState = newState;
      });
    }
  }

  /// Gets padding based on button size (using SDeckSpacing tokens)
  EdgeInsets _getPadding() {
    switch (widget.size) {
      case SDeckButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpacing.buttonPaddingSmallHorizontal,
          vertical: SDeckSpacing.buttonPaddingSmallVertical,
        );
      case SDeckButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpacing.buttonPaddingMediumHorizontal,
          vertical: SDeckSpacing.buttonPaddingMediumVertical,
        );
      case SDeckButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpacing.buttonPaddingLargeHorizontal,
          vertical: SDeckSpacing.buttonPaddingLargeVertical,
        );
    }
  }

  /// Gets border radius based on size and radius style (using SDeckSpacing tokens)
  double _getBorderRadius() {
    if (widget.radius == SDeckButtonRadius.squared) {
      return SDeckSpacing.buttonRadiusSquared;
    } else {
      // Round radius varies by size
      switch (widget.size) {
        case SDeckButtonSize.small:
        case SDeckButtonSize.medium:
          return SDeckSpacing.buttonRadiusRoundSmall;
        case SDeckButtonSize.large:
          return SDeckSpacing.buttonRadiusRoundLarge;
      }
    }
  }

  /// Gets background color based on current state (using SDeckColors tokens)
  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (_currentState) {
      case SDeckButtonState.enabled:
        return SDeckColors.coolGray[900]!;
      case SDeckButtonState.hover:
        return SDeckColors.coolGray[950]!;
      case SDeckButtonState.pressed:
        return SDeckColors.coolGray[500]!;
      case SDeckButtonState.disabled:
        return SDeckColors.coolGray[400]!;
    }
  }

  /// Gets text style based on button size (using Theme typography)
  TextStyle _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (widget.size) {
      case SDeckButtonSize.small:
        return theme.textTheme.labelLarge!.copyWith(
          color: colorScheme.onPrimary,
        );
      case SDeckButtonSize.medium:
        return theme.textTheme.labelLarge!.copyWith(
          fontSize: 16,
          color: colorScheme.onPrimary,
        );
      case SDeckButtonSize.large:
        return theme.textTheme.titleMedium!.copyWith(
          color: colorScheme.onPrimary,
        );
    }
  }

  /// Builds the button content (text and optional icon)
  List<Widget> _buildButtonContent(BuildContext context) {
    final List<Widget> children = [];

    // Add left icon if configured
    if (widget.iconConfig == SDeckButtonIconConfig.left &&
        widget.icon != null) {
      children.add(widget.icon!);
      children.add(const SizedBox(width: SDeckSpacing.buttonIconGap));
    }

    // Add text
    children.add(Text(widget.text, style: _getTextStyle(context)));

    // Add right icon if configured
    if (widget.iconConfig == SDeckButtonIconConfig.right &&
        widget.icon != null) {
      children.add(const SizedBox(width: SDeckSpacing.buttonIconGap));
      children.add(widget.icon!);
    }

    return children;
  }
}
