/*------------------------ sdeck_solid_button.dart ---------------------------*/
// Solid Default Button component for the Socialdeck design system
// Handles all variations: 2 shapes × 4 states × 4 icon locations × 3 sizes = 96 variants
// Theme-aware component that matches Figma designs exactly
//
// Usage:
//   SDeckSolidButton(text: 'Click me')
//   SDeckSolidButton(text: 'Save', icon: Icon(...), iconLocation: SDeckButtonIconLocation.left)
//   SDeckSolidButton(icon: Icon(...), iconLocation: SDeckButtonIconLocation.only)
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/spacing/index.dart';
import '../../tokens/typography/font_sizes.dart';
import '../../tokens/typography/line_heights.dart';
import '../../tokens/typography/font_weights.dart';
import '../../tokens/effects/box_shadows.dart';
import '../../tokens/icons/index.dart';
import 'button_enums.dart';

//------------------------------- SDeckSolidButton ------------------------------//

class SDeckSolidButton extends StatefulWidget {
  //------------------------------- Properties -----------------------------//

  /// Button text content - required unless iconLocation is only
  final String? text;

  /// Callback function when button is tapped - null disables the button
  final VoidCallback? onPressed;

  /// Size configuration - determines padding and text size
  final SDeckButtonSize size;

  /// Button shape - controls corner rounding
  final SDeckButtonShape shape;

  /// Icon location - determines icon placement and layout
  final SDeckButtonIconLocation iconLocation;

  /// Optional icon widget - must be provided if iconLocation is left/right/only
  final Widget? icon;

  /// Whether button responds to interactions - false grays it out
  final bool enabled;

  /// Whether button stretches full width - false hugs content
  final bool fullWidth;

  //*************************** Constructor **********************************//
  const SDeckSolidButton({
    super.key,
    this.text,
    this.icon,
    this.size = SDeckButtonSize.medium,
    this.iconLocation = SDeckButtonIconLocation.none,
    this.shape = SDeckButtonShape.default_,
    this.onPressed,
    this.enabled = true,
    this.fullWidth = false,
  }) : assert(
         (iconLocation == SDeckButtonIconLocation.only && icon != null) ||
             (iconLocation != SDeckButtonIconLocation.only && text != null),
         'Icon-only buttons require icon, others require text',
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
          border: Border.all(
            width: SDeckSize.size4,
            color: context.component.solidButtonBorder,
          ),
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          // Shadow removed for disabled state
          boxShadow:
              _currentState == SDeckButtonState.disabled
                  ? null
                  : SDeckBoxShadows.boxShadowLow(context.semantic.shadow),
        ),

        // CONTENT LAYOUT
        child: Row(
          // Layout behavior depends on fullWidth setting
          mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildButtonContent(context),
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
          horizontal: SDeckSpace.padding16,
          vertical: SDeckSpace.padding12,
        );
      case SDeckButtonSize.medium:
        // Standard padding for most use cases
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpace.padding24,
          vertical: SDeckSpace.padding16,
        );
      case SDeckButtonSize.large:
        // Generous padding for prominent actions
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpace.padding32,
          vertical: SDeckSpace.padding24,
        );
    }
  }

  /// Gets border radius based on size and shape using design tokens
  ///
  /// Radius values are carefully chosen to maintain visual consistency:
  /// • Default: Always 8px for professional look
  /// • Round: Scales with button size for proportional appearance
  ///
  /// @return double radius value in logical pixels
  double _getBorderRadius() {
    if (widget.shape == SDeckButtonShape.default_) {
      // Consistent radius for all default shape buttons
      return SDeckRadius.borderRadius8;
    } else {
      // Scale round radius with button size
      switch (widget.size) {
        case SDeckButtonSize.small:
        case SDeckButtonSize.medium:
          return SDeckRadius.borderRadius8; // 24px
        case SDeckButtonSize.large:
          return SDeckRadius.borderRadius12; // 32px
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
    switch (_currentState) {
      case SDeckButtonState.enabled:
        // Base button color - dark in light mode, light in dark mode
        return context.component.solidButtonPrimarySurface;
      case SDeckButtonState.pressed:
        // Lightest for immediate press feedback
        return context.component.solidButtonPrimarySurfacePressed;
      case SDeckButtonState.disabled:
        // Grayed out to indicate non-interactive state
        return context.component.solidButtonSurfaceDisabled;
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

    // Use theme-aware button text color for proper contrast
    // Light mode: Light text on dark buttons
    // Dark mode: Dark text on light buttons
    final textColor = context.component.solidButtonText;

    switch (widget.size) {
      case SDeckButtonSize.small:
        // Compact text for small buttons - matches Figma Body Small
        return theme.textTheme.labelLarge!.copyWith(
          fontSize: SDeckFontSizes.bodySmall, // 16px
          fontWeight: SDeckFontWeights.medium, // 500 - matches Figma
          height:
              SDeckLineHeights.bodySmall /
              SDeckFontSizes.bodySmall, // 20px / 16px = 1.25
          color: textColor,
        );
      case SDeckButtonSize.medium:
        // Standard text size for most buttons - matches Figma Body Medium
        return theme.textTheme.labelLarge!.copyWith(
          fontSize: SDeckFontSizes.bodyMedium, // 18px
          fontWeight: SDeckFontWeights.medium, // 500 - matches Figma
          height:
              SDeckLineHeights.bodyMedium /
              SDeckFontSizes.bodyMedium, // 22px / 18px = 1.222...
          color: textColor,
        );
      case SDeckButtonSize.large:
        // Prominent text for large buttons - matches Figma Body Large
        return theme.textTheme.titleMedium!.copyWith(
          fontSize: SDeckFontSizes.bodyLarge, // 20px
          fontWeight: SDeckFontWeights.medium, // 500 - matches Figma
          height:
              SDeckLineHeights.bodyLarge /
              SDeckFontSizes.bodyLarge, // 24px / 20px = 1.2
          color: textColor,
        );
    }
  }

  /// Gets icon color using theme-aware extensions
  ///
  /// Solid buttons use a consistent icon color across all states.
  /// Icons match the button text color for visual consistency.
  Color _getIconColor(BuildContext context) {
    return context.component.solidButtonIcon;
  }

  /// Wraps icon with state-aware color if it's a monochrome SDeckIcon
  ///
  /// SMART DETECTION:
  /// • If icon is SDeckIcons with color != null → assume monochrome → wrap with state color
  /// • If icon is SDeckIcons with color == null → assume multi-colored → use as-is
  /// • If icon is not SDeckIcons → use as-is (safe fallback)
  ///
  /// This ensures monochrome icons match text colors while preserving multi-colored icons.
  Widget _wrapIconWithColor(BuildContext context, Widget icon) {
    // Check if icon is SDeckIcons instance
    if (icon is SDeckIcons) {
      // If icon has a color set, assume it's monochrome and wrap with state-aware color
      if (icon.color != null) {
        return ColorFiltered(
          colorFilter: ColorFilter.mode(
            _getIconColor(context),
            BlendMode.srcIn,
          ),
          child: icon,
        );
      }
      // If color is null, assume multi-colored (like Google logo) - use as-is
    }
    // Not an SDeckIcons or doesn't need wrapping - return as-is
    return icon;
  }

  /// Builds the button content (text and optional icon) with proper spacing
  ///
  /// LAYOUT LOGIC:
  /// This method constructs the button's content based on icon location:
  /// • none: Just centered text
  /// • left: Icon + gap + text (left-aligned)
  /// • right: Text + gap + icon (right-aligned but content centered)
  /// • only: Icon only, no text (square/circular button)
  ///
  List<Widget> _buildButtonContent(BuildContext context) {
    final List<Widget> children = [];

    // Handle icon-only case
    if (widget.iconLocation == SDeckButtonIconLocation.only) {
      return widget.icon != null
          ? [_wrapIconWithColor(context, widget.icon!)]
          : [];
    }

    // Add left icon if configured
    if (widget.iconLocation == SDeckButtonIconLocation.left &&
        widget.icon != null) {
      children.add(_wrapIconWithColor(context, widget.icon!));
      children.add(const SizedBox(width: SDeckSpace.gap4)); // 4px
    }

    // Add text (always present for non-icon-only buttons)
    if (widget.text != null) {
      children.add(Text(widget.text!, style: _getTextStyle(context)));
    }

    // Add right icon if configured
    if (widget.iconLocation == SDeckButtonIconLocation.right &&
        widget.icon != null) {
      children.add(const SizedBox(width: SDeckSpace.gap4)); // 4px
      children.add(_wrapIconWithColor(context, widget.icon!));
    }

    return children;
  }
}
