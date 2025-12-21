/*------------------------ sdeck_solid_button.dart --------------------------*/
// Solid Default Button component for the SocialDeck design system
// Handles all variations: 2 radii × 4 states × 3 icon configs × 3 sizes = 72 variants
// Theme-aware component that matches Figma designs exactly
//
// Usage: SDeckSolidButton.medium() or with full customization
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../foundations/index.dart';
import 'button_enums.dart';

//============================ SDeckSolidButton ============================//
// MAIN COMPONENT CLASS
//
// This StatefulWidget manages its own interaction states and rebuilds
// efficiently when users interact with it. The private constructor pattern
// ensures all variants use the same core logic while providing a clean API.

class SDeckSolidButton extends StatefulWidget {
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

  const SDeckSolidButton._({
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
  // buttons without needing to understand the internal configuration.
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
  const SDeckSolidButton.small({
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

  const SDeckSolidButton.smallWithLeftIcon({
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

  const SDeckSolidButton.smallWithRightIcon({
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

  const SDeckSolidButton.smallRound({
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

  const SDeckSolidButton.smallRoundWithLeftIcon({
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

  const SDeckSolidButton.smallRoundWithRightIcon({
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

  //------------------------------- Medium Variants -----------------------//
  const SDeckSolidButton.medium({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false, // Set to true for full-width primary actions
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

  const SDeckSolidButton.mediumWithLeftIcon({
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

  const SDeckSolidButton.mediumWithRightIcon({
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

  const SDeckSolidButton.mediumRound({
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

  const SDeckSolidButton.mediumRoundWithLeftIcon({
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

  const SDeckSolidButton.mediumRoundWithRightIcon({
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
  const SDeckSolidButton.large({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool enabled = true,
    bool fullWidth = false, // Often true for primary actions
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

  const SDeckSolidButton.largeWithLeftIcon({
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

  const SDeckSolidButton.largeWithRightIcon({
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

  const SDeckSolidButton.largeRound({
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

  const SDeckSolidButton.largeRoundWithLeftIcon({
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

  const SDeckSolidButton.largeRoundWithRightIcon({
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
  State<SDeckSolidButton> createState() => _SDeckSolidButtonState();
}

//========================= _SDeckSolidButtonState ===========================//
// COMPONENT STATE MANAGEMENT
//
// This class handles the button's interactive behavior and visual feedback.
// It automatically manages state transitions and triggers rebuilds only when
// the visual appearance needs to change.
//
// STATE FLOW:
// User interaction → State change → Color calculation → Rebuild
//
// PERFORMANCE:
// • Only rebuilds when state actually changes
// • Uses efficient gesture detection
// • Minimal widget tree depth

class _SDeckSolidButtonState extends State<SDeckSolidButton> {
  /// Current interaction state - drives visual appearance
  ///
  /// This state is automatically managed by gesture handlers below.
  /// It determines which colors to use from the theme-aware color system.
  SDeckButtonState _currentState = SDeckButtonState.enabled;

  //*************************** Build Method ******************************//
  // MAIN RENDER METHOD
  //
  // This method constructs the button's widget tree and sets up gesture
  // detection. The tree is optimized for performance with minimal nesting.

  @override
  Widget build(BuildContext context) {
    // Determine initial state based on enabled property
    // This ensures disabled buttons are immediately grayed out
    _currentState =
        widget.enabled ? SDeckButtonState.enabled : SDeckButtonState.disabled;

    return GestureDetector(
      // TOUCH INTERACTION HANDLERS
      // These provide immediate visual feedback for user interactions
      onTapDown:
          widget.enabled ? (_) => _updateState(SDeckButtonState.pressed) : null,
      onTapUp:
          widget.enabled ? (_) => _updateState(SDeckButtonState.enabled) : null,
      onTapCancel:
          widget.enabled ? () => _updateState(SDeckButtonState.enabled) : null,
      onTap: widget.enabled ? widget.onPressed : null,

      child: MouseRegion(
        // HOVER INTERACTION HANDLERS
        // Provides desktop hover feedback for better UX
        onEnter:
            widget.enabled ? (_) => _updateState(SDeckButtonState.hover) : null,
        onExit:
            widget.enabled
                ? (_) => _updateState(SDeckButtonState.enabled)
                : null,

        child: Container(
          // WIDTH BEHAVIOR
          // fullWidth buttons stretch to fill available space
          // Regular buttons hug their content
          width: widget.fullWidth ? double.infinity : null,

          // SPACING - Uses design tokens for consistency
          padding: _getPadding(),

          // APPEARANCE - Colors come from theme-aware system
          decoration: BoxDecoration(
            color: _getBackgroundColor(context),
            borderRadius: BorderRadius.circular(_getBorderRadius()),
          ),

          // CONTENT LAYOUT
          child: Row(
            // Layout behavior depends on fullWidth setting
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
  // These methods encapsulate the button's appearance logic and ensure
  // consistency across all variants. They use design tokens and theme
  // extensions to maintain design system compliance.

  /// Updates the button state and triggers a rebuild if necessary
  ///
  /// PERFORMANCE NOTE: Only rebuilds if the state actually changes.
  /// This prevents unnecessary widget tree reconstructions.
  ///
  /// @param newState The state to transition to
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
        // Minimal padding for compact interfaces
        return const EdgeInsets.symmetric(
          horizontal:
              SDeckSpaceComponentSpecific.buttonPaddingSmallHorizontal, // 8px
          vertical:
              SDeckSpaceComponentSpecific.buttonPaddingSmallVertical, // 0px
        );
      case SDeckButtonSize.medium:
        // Standard padding for most use cases
        return const EdgeInsets.symmetric(
          horizontal:
              SDeckSpaceComponentSpecific.buttonPaddingMediumHorizontal, // 16px
          vertical:
              SDeckSpaceComponentSpecific.buttonPaddingMediumVertical, // 8px
        );
      case SDeckButtonSize.large:
        // Generous padding for prominent actions
        return const EdgeInsets.symmetric(
          horizontal:
              SDeckSpaceComponentSpecific.buttonPaddingLargeHorizontal, // 24px
          vertical:
              SDeckSpaceComponentSpecific.buttonPaddingLargeVertical, // 20px
        );
    }
  }

  /// Gets border radius based on size and radius style using design tokens
  ///
  /// Radius values are carefully chosen to maintain visual consistency:
  /// • Squared: Always 8px for professional look
  /// • Round: Scales with button size for proportional appearance
  ///
  /// @return double radius value in logical pixels
  double _getBorderRadius() {
    if (widget.radius == SDeckButtonRadius.squared) {
      // Consistent radius for all squared buttons
      return SDeckRadius.borderRadiusXXS; // 8px
    } else {
      // Scale round radius with button size
      switch (widget.size) {
        case SDeckButtonSize.small:
        case SDeckButtonSize.medium:
          return SDeckRadius.borderRadiusS; // 24px
        case SDeckButtonSize.large:
          return SDeckRadius.borderRadiusM; // 32px
      }
    }
  }

  /// Gets background color based on current state using theme-aware extensions
  ///
  /// THEME SYSTEM INTEGRATION:
  /// This method leverages the color extension system to automatically
  /// provide the correct colors for the current theme (light/dark).
  ///
  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (_currentState) {
      case SDeckButtonState.enabled:
        // Base button color - dark in light mode, light in dark mode
        return colorScheme.buttonPrimary;
      case SDeckButtonState.hover:
        // Slightly lighter for hover feedback
        return colorScheme.buttonPrimaryHover;
      case SDeckButtonState.pressed:
        // Lightest for immediate press feedback
        return colorScheme.buttonPrimaryPressed;
      case SDeckButtonState.disabled:
        // Grayed out to indicate non-interactive state
        return colorScheme.buttonPrimaryDisabled;
    }
  }

  /// Gets text style based on button size using theme-aware text colors
  ///
  /// TEXT SYSTEM INTEGRATION:
  /// Combines Flutter's theme typography with our custom color system.
  /// Text size scales with button size, and colors automatically adapt
  /// to ensure proper contrast in both light and dark themes.
  ///
  /// @param context BuildContext to access theme
  /// @return TextStyle with appropriate size and color
  TextStyle _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    // Use theme-aware button text color for proper contrast
    // Light mode: Light text on dark buttons
    // Dark mode: Dark text on light buttons
    final textColor = colorScheme.onButtonPrimary;

    switch (widget.size) {
      case SDeckButtonSize.small:
        // Compact text for small buttons
        return theme.textTheme.labelLarge!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        );
      case SDeckButtonSize.medium:
        // Standard text size for most buttons
        return theme.textTheme.labelLarge!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        );
      case SDeckButtonSize.large:
        // Prominent text for large buttons
        return theme.textTheme.titleMedium!.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        );
    }
  }

  /// Builds the button content (text and optional icon) with proper spacing
  ///
  /// LAYOUT LOGIC:
  /// This method constructs the button's content based on icon configuration:
  /// • none: Just centered text
  /// • left: Icon + gap + text (left-aligned)
  /// • right: Text + gap + icon (right-aligned but content centered)
  ///
  List<Widget> _buildButtonContent(BuildContext context) {
    final List<Widget> children = [];

    // Add left icon if configured
    if (widget.iconConfig == SDeckButtonIconConfig.left &&
        widget.icon != null) {
      children.add(widget.icon!);
      children.add(
        const SizedBox(width: SDeckSpaceComponentSpecific.buttonIconGap),
      ); // 4px
    }

    // Add text (always present)
    children.add(Text(widget.text, style: _getTextStyle(context)));

    // Add right icon if configured
    if (widget.iconConfig == SDeckButtonIconConfig.right &&
        widget.icon != null) {
      children.add(
        const SizedBox(width: SDeckSpaceComponentSpecific.buttonIconGap),
      ); // 4px
      children.add(widget.icon!);
    }

    return children;
  }
}
