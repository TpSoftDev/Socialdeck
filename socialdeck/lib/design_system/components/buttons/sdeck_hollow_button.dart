/*------------------------ sdeck_hollow_button.dart --------------------------*/
// Hollow Default Button component for the SocialDeck design system
// Handles all variations: 2 radii × 4 states × 3 icon configs × 3 sizes = 72 variants
// Theme-aware component that matches Figma designs exactly
//
// Usage: SDeckHollowButton.medium() or with full customization
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../foundations/index.dart';
import 'button_enums.dart';

//============================ SDeckHollowButton ============================//
// MAIN COMPONENT CLASS
//
// This StatefulWidget manages its own interaction states and rebuilds
// efficiently when users interact with it. The private constructor pattern
// ensures all variants use the same core logic while providing a clean API.

class SDeckHollowButton extends StatefulWidget {
  //------------------------------- Properties -----------------------------//
  // These properties configure the button's content and behavior.
  // Most are passed through from the named constructors.

  /// Button text content - always required
  final String text;

  /// Callback function when button is tapped - null disables the button
  final VoidCallback? onPressed;

  /// Size configuration - determines padding and text size
  final SDeckButtonSize size;

  /// Corner style - squared or round appearance
  final SDeckButtonRadius radius;

  /// Icon placement - none, left, or right of text
  final SDeckButtonIconConfig iconConfig;

  /// Optional icon widget - must be provided if iconConfig is left/right
  final Widget? icon;

  /// Whether button responds to interactions - false grays it out
  final bool enabled;

  /// Whether button stretches full width - false hugs content
  final bool fullWidth;

  //------------------------------- Private Constructor -------------------//
  // Private constructor ensures all button variants use the same core logic.
  // Named constructors (below) provide the public API and pass values here.

  const SDeckHollowButton._({
    super.key,
    required this.text,
    this.onPressed,
    required this.size,
    required this.radius,
    required this.iconConfig,
    this.icon,
    this.enabled = true,
    this.fullWidth = false,
  });

  //*************************** Named Constructors ***************************//
  // PUBLIC API - These constructors provide a clean, semantic way to create
  // hollow buttons without needing to understand the internal configuration.
  //
  // NAMING PATTERN: [size][radius][iconConfig]
  // • Size: small, medium, large
  // • Radius: (none = squared), Round
  // • Icon: (none), WithLeftIcon, WithRightIcon
  //
  // ALL constructors support these optional parameters:
  // • enabled: true/false (default: true)
  // • fullWidth: true/false (default: false)

  //------------------------------- Small Variants ------------------------//
  /// Small squared hollow button with no icon
  ///
  /// Use for: Secondary actions, compact interfaces
  /// Example: SDeckHollowButton.small(text: 'Cancel', onPressed: () => pop())
  const SDeckHollowButton.small({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false, // Optional: makes button stretch full width
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.small,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Small squared hollow button with left icon
  ///
  /// Use for: Icon-labeled secondary actions, visual context
  /// Example: SDeckHollowButton.smallWithLeftIcon(
  ///   text: 'Back',
  ///   icon: SDeckIcon.small(context.icons.leftArrow),
  ///   onPressed: () => Navigator.pop(context)
  /// )
  const SDeckHollowButton.smallWithLeftIcon({
    Key? key,
    required String text,
    required Widget icon, // Icon displayed before text
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.small,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.left,
         icon: icon,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Small squared hollow button with right icon
  ///
  /// Use for: Navigation actions, directional flow
  /// Example: SDeckHollowButton.smallWithRightIcon(
  ///   text: 'Next',
  ///   icon: SDeckIcon.small(context.icons.rightArrow)
  /// )
  const SDeckHollowButton.smallWithRightIcon({
    Key? key,
    required String text,
    required Widget icon, // Icon displayed after text
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.small,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.right,
         icon: icon,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Small round hollow button with no icon
  ///
  /// Use for: Friendly, approachable secondary actions
  /// Example: SDeckHollowButton.smallRound(text: 'Maybe Later')
  const SDeckHollowButton.smallRound({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.small,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Small round hollow button with left icon
  ///
  /// Use for: Soft, friendly actions with visual context
  /// Example: SDeckHollowButton.smallRoundWithLeftIcon(
  ///   text: 'Share',
  ///   icon: SDeckIcon.small(context.icons.socialdeckLogo)
  /// )
  const SDeckHollowButton.smallRoundWithLeftIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.small,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.left,
         icon: icon,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Small round hollow button with right icon
  ///
  /// Use for: Soft navigation, gentle directional flow
  const SDeckHollowButton.smallRoundWithRightIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.small,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.right,
         icon: icon,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  //------------------------------- Medium Variants ------------------------//
  // Medium buttons are the workhorse of the design system:
  // • Most common size for standard secondary actions
  // • Good balance of prominence and space efficiency
  // • Default choice for hollow buttons in forms, dialogs, and general UI

  /// Medium squared hollow button with no icon (MOST COMMON)
  ///
  /// Use for: Standard secondary actions, form submissions, dialogs
  /// Example: SDeckHollowButton.medium(text: 'Cancel', onPressed: _cancel)
  const SDeckHollowButton.medium({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false, // Set to true for full-width secondary actions
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.medium,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Medium squared hollow button with left icon
  ///
  /// Use for: Secondary actions that benefit from visual context
  /// Example: SDeckHollowButton.mediumWithLeftIcon(
  ///   text: 'Learn More',
  ///   icon: SDeckIcon.medium(context.icons.info),
  /// )
  const SDeckHollowButton.mediumWithLeftIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.medium,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.left,
         icon: icon,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Medium squared hollow button with right icon
  ///
  /// Use for: Secondary navigation, alternative steps
  /// Example: SDeckHollowButton.mediumWithRightIcon(
  ///   text: 'Skip',
  ///   icon: SDeckIcon.medium(context.icons.rightArrow)
  /// )
  const SDeckHollowButton.mediumWithRightIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.medium,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.right,
         icon: icon,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Medium round hollow button with no icon
  ///
  /// Use for: Friendly standard secondary actions, softer appearance
  /// Example: SDeckHollowButton.mediumRound(text: 'Maybe Later')
  const SDeckHollowButton.mediumRound({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.medium,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Medium round hollow button with left icon
  ///
  /// Use for: Social secondary actions, community features
  /// Example: SDeckHollowButton.mediumRoundWithLeftIcon(
  ///   text: 'View Profile',
  ///   icon: SDeckIcon.medium(context.icons.profile)
  /// )
  const SDeckHollowButton.mediumRoundWithLeftIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.medium,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.left,
         icon: icon,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Medium round hollow button with right icon
  ///
  /// Use for: Soft secondary navigation, gentle progression
  const SDeckHollowButton.mediumRoundWithRightIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.medium,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.right,
         icon: icon,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  //------------------------------- Large Variants ------------------------//
  // Large hollow buttons are perfect for:
  // • Secondary actions that need more prominence
  // • Alternative CTAs in onboarding flows
  // • Full-width secondary form actions
  // • Cancel/alternative actions on landing screens

  /// Large squared hollow button with no icon
  ///
  /// Use for: Prominent secondary actions, important alternatives
  /// Example: SDeckHollowButton.large(
  ///   text: 'Skip for Now',
  ///   fullWidth: true,
  ///   onPressed: _skipOnboarding
  /// )
  const SDeckHollowButton.large({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false, // Often true for secondary actions
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.large,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Large squared hollow button with left icon
  ///
  /// Use for: Prominent alternative actions with context
  /// Example: SDeckHollowButton.largeWithLeftIcon(
  ///   text: 'Sign in with Email',
  ///   icon: SDeckIcon.medium(context.icons.info),
  ///   fullWidth: true // Typical for onboarding alternatives
  /// )
  const SDeckHollowButton.largeWithLeftIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.large,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.left,
         icon: icon,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Large squared hollow button with right icon
  ///
  /// Use for: Secondary navigation, alternative next steps
  /// Example: SDeckHollowButton.largeWithRightIcon(
  ///   text: 'Skip Setup',
  ///   icon: SDeckIcon.medium(context.icons.rightArrow)
  /// )
  const SDeckHollowButton.largeWithRightIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.large,
         radius: SDeckButtonRadius.squared,
         iconConfig: SDeckButtonIconConfig.right,
         icon: icon,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Large round hollow button with no icon
  ///
  /// Use for: Friendly secondary actions, approachable alternatives
  /// Example: SDeckHollowButton.largeRound(text: 'Explore First')
  const SDeckHollowButton.largeRound({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.large,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.none,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Large round hollow button with left icon
  ///
  /// Use for: Major alternative social actions, secondary community engagement
  /// Example: SDeckHollowButton.largeRoundWithLeftIcon(
  ///   text: 'Watch Tutorial',
  ///   icon: SDeckIcon.medium(context.icons.playHollow)
  /// )
  const SDeckHollowButton.largeRoundWithLeftIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.large,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.left,
         icon: icon,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  /// Large round hollow button with right icon
  ///
  /// Use for: Major friendly alternatives, inviting secondary progression
  const SDeckHollowButton.largeRoundWithRightIcon({
    Key? key,
    required String text,
    required Widget icon,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         size: SDeckButtonSize.large,
         radius: SDeckButtonRadius.round,
         iconConfig: SDeckButtonIconConfig.right,
         icon: icon,
         enabled: enabled,
         fullWidth: fullWidth,
       );

  @override
  State<SDeckHollowButton> createState() => _SDeckHollowButtonState();
}

//========================= _SDeckHollowButtonState ===========================//
// COMPONENT STATE MANAGEMENT
//
// This class handles the button's interactive behavior and visual feedback.
// It automatically manages state transitions and triggers rebuilds only when
// the visual appearance needs to change.

class _SDeckHollowButtonState extends State<SDeckHollowButton> {
  /// Current interaction state - drives visual appearance
  SDeckButtonState _currentState = SDeckButtonState.enabled;

  //*************************** Build Method ******************************//
  @override
  Widget build(BuildContext context) {
    // Determine initial state based on enabled property
    _currentState =
        widget.enabled ? SDeckButtonState.enabled : SDeckButtonState.disabled;

    return GestureDetector(
      // TOUCH INTERACTION HANDLERS
      onTapDown:
          widget.enabled ? (_) => _updateState(SDeckButtonState.pressed) : null,
      onTapUp:
          widget.enabled ? (_) => _updateState(SDeckButtonState.enabled) : null,
      onTapCancel:
          widget.enabled ? () => _updateState(SDeckButtonState.enabled) : null,
      onTap: widget.enabled ? widget.onPressed : null,

      child: MouseRegion(
        // HOVER INTERACTION HANDLERS
        onEnter:
            widget.enabled ? (_) => _updateState(SDeckButtonState.hover) : null,
        onExit:
            widget.enabled
                ? (_) => _updateState(SDeckButtonState.enabled)
                : null,

        child: Container(
          // WIDTH BEHAVIOR
          width: widget.fullWidth ? double.infinity : null,

          // SPACING - Uses design tokens for consistency
          padding: _getPadding(),

          // APPEARANCE - Transparent background with themed border
          decoration: BoxDecoration(
            color: _getBackgroundColor(context), // Always transparent
            border: Border.all(
              color: _getBorderColor(context), // State-aware border color
              width: 3, // 3px border width from Figma
            ),
            borderRadius: BorderRadius.circular(_getBorderRadius()),
          ),

          // CONTENT LAYOUT
          child: Row(
            mainAxisSize:
                widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildButtonContent(context),
          ),
        ),
      ),
    );
  }

  //*************************** Helper Methods *****************************//

  /// Updates the button state and triggers a rebuild if necessary
  void _updateState(SDeckButtonState newState) {
    if (mounted && _currentState != newState) {
      setState(() {
        _currentState = newState;
      });
    }
  }

  /// Gets padding based on button size using design tokens
  EdgeInsets _getPadding() {
    switch (widget.size) {
      case SDeckButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpacing.buttonPaddingSmallHorizontal, // 8px
          vertical: SDeckSpacing.buttonPaddingSmallVertical, // 0px
        );
      case SDeckButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpacing.buttonPaddingMediumHorizontal, // 16px
          vertical: SDeckSpacing.buttonPaddingMediumVertical, // 8px
        );
      case SDeckButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpacing.buttonPaddingLargeHorizontal, // 24px
          vertical: SDeckSpacing.buttonPaddingLargeVertical, // 20px
        );
    }
  }

  /// Gets border radius based on size and radius style using design tokens
  double _getBorderRadius() {
    if (widget.radius == SDeckButtonRadius.squared) {
      return SDeckSpacing.buttonRadiusSquared; // 8px
    } else {
      switch (widget.size) {
        case SDeckButtonSize.small:
        case SDeckButtonSize.medium:
          return SDeckSpacing.buttonRadiusRoundSmall; // 24px
        case SDeckButtonSize.large:
          return SDeckSpacing.buttonRadiusRoundLarge; // 32px
      }
    }
  }

  /// Gets background color - always transparent for hollow buttons
  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return colorScheme.buttonHollowBackground; // Always transparent
  }

  /// Gets border color based on current state using theme-aware extensions
  Color _getBorderColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (_currentState) {
      case SDeckButtonState.enabled:
        return colorScheme.buttonHollowBorder; // #1F1F1F in light mode
      case SDeckButtonState.hover:
        return colorScheme.buttonHollowBorderHover; // #1F1F1F in light mode
      case SDeckButtonState.pressed:
        return colorScheme.buttonHollowBorderPressed; // #5E5E5E in light mode
      case SDeckButtonState.disabled:
        return colorScheme.buttonHollowBorderDisabled; // #9E9E9E in light mode
    }
  }

  /// Gets text color based on current state using theme-aware extensions
  Color _getTextColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (_currentState) {
      case SDeckButtonState.enabled:
        return colorScheme.onButtonHollow; // #1F1F1F in light mode
      case SDeckButtonState.hover:
        return colorScheme.onButtonHollowHover; // #0F0F0F in light mode
      case SDeckButtonState.pressed:
        return colorScheme.onButtonHollowPressed; // #5E5E5E in light mode
      case SDeckButtonState.disabled:
        return colorScheme.onButtonHollowDisabled; // #9E9E9E in light mode
    }
  }

  /// Gets text style based on button size using theme-aware text colors
  TextStyle _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = _getTextColor(context); // State-aware text color

    switch (widget.size) {
      case SDeckButtonSize.small:
        return theme.textTheme.labelLarge!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        );
      case SDeckButtonSize.medium:
        return theme.textTheme.labelLarge!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        );
      case SDeckButtonSize.large:
        return theme.textTheme.titleMedium!.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        );
    }
  }

  /// Builds the button content (text and optional icon) with proper spacing
  List<Widget> _buildButtonContent(BuildContext context) {
    final List<Widget> children = [];

    // Add left icon if configured
    if (widget.iconConfig == SDeckButtonIconConfig.left &&
        widget.icon != null) {
      children.add(widget.icon!);
      children.add(const SizedBox(width: SDeckSpacing.buttonIconGap)); // 4px
    }

    // Add text (always present)
    children.add(Text(widget.text, style: _getTextStyle(context)));

    // Add right icon if configured
    if (widget.iconConfig == SDeckButtonIconConfig.right &&
        widget.icon != null) {
      children.add(const SizedBox(width: SDeckSpacing.buttonIconGap)); // 4px
      children.add(widget.icon!);
    }

    return children;
  }
}
