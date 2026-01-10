/*------------------------ sdeck_outline_button.dart -------------------------*/
// Outline Button component provides a bordered button style with transparent
// background for secondary actions. Unlike solid buttons, outline buttons use
// a border to define their shape while maintaining a surface background color
// that adapts to the current theme.
//
// Outline buttons support the same size, state, and icon location variations
// as solid buttons, with border colors that change based on interaction state
// to provide clear visual feedback.
//
// Usage:
//   SDeckOutlineButton(text: 'Click me')
//   SDeckOutlineButton(text: 'Save', icon: Icon(...), iconLocation: SDeckButtonIconLocation.left)
//   SDeckOutlineButton(icon: Icon(...), iconLocation: SDeckButtonIconLocation.only)
/*---------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';

import '../../tokens/colors/index.dart';
import '../../tokens/spacing/index.dart';
import '../../tokens/typography/font_sizes.dart';
import '../../tokens/typography/line_heights.dart';
import '../../tokens/typography/font_weights.dart';
import '../../tokens/effects/box_shadows.dart';
import '../icons/sdeck_icon.dart';
import 'button_enums.dart';

//============================ SDeckOutlineButton ============================//
// MAIN COMPONENT CLASS
//
// This StatefulWidget manages its own interaction states and rebuilds
// efficiently when users interact with it. A single parameterized constructor
// provides flexible configuration while maintaining consistent behavior.

class SDeckOutlineButton extends StatefulWidget {
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
  const SDeckOutlineButton({
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
  State<SDeckOutlineButton> createState() => _SDeckOutlineButtonState();
}

//========================= _SDeckOutlineButtonState ==========================//
// COMPONENT STATE MANAGEMENT
//
// This class handles the button's interactive behavior and visual feedback.
// It automatically manages state transitions and triggers rebuilds only when
// the visual appearance needs to change.

class _SDeckOutlineButtonState extends State<SDeckOutlineButton> {
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

      child: Container(
        // WIDTH BEHAVIOR
        width: widget.fullWidth ? double.infinity : null,

        // SPACING - Uses design tokens for consistency
        padding: _getPadding(),

        // APPEARANCE - Surface background with themed border
        decoration: BoxDecoration(
          color: _getBackgroundColor(context), // State-aware surface color
          border: Border.all(
            color: _getBorderColor(context), // State-aware border color
            width: SDeckSize.size4, // 4px
          ),
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          // Shadow removed for disabled state per Figma specifications
          boxShadow:
              _currentState == SDeckButtonState.disabled
                  ? null
                  : SDeckBoxShadows.boxShadowLow(context.semantic.shadow),
        ),

        // CONTENT LAYOUT
        child: Row(
          mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildButtonContent(context),
        ),
      ),
    );
  }

  //**************************** Helper Methods ******************************//
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
          horizontal: SDeckSpace.padding16, // 16px
          vertical: SDeckSpace.padding12, // 12px
        );
      case SDeckButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpace.padding24, // 24px
          vertical: SDeckSpace.padding16, // 16px
        );
      case SDeckButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpace.padding32, // 32px
          vertical: SDeckSpace.padding24, // 24px
        );
    }
  }

  /// Gets border radius based on size and shape using design tokens
  ///
  /// Radius values are carefully chosen to maintain visual consistency:
  /// • Default: Always 8px for professional look
  /// • Round: Scales with button size for proportional appearance
  double _getBorderRadius() {
    if (widget.shape == SDeckButtonShape.default_) {
      return SDeckRadius.borderRadius8; // 8px
    } else {
      switch (widget.size) {
        case SDeckButtonSize.small:
        case SDeckButtonSize.medium:
          return SDeckRadius.borderRadius24; // 24px
        case SDeckButtonSize.large:
          return SDeckRadius.borderRadius48; // 48px
      }
    }
  }

  /// Gets background color based on current state using theme-aware extensions
  ///
  /// THEME SYSTEM INTEGRATION:
  /// This method leverages the color extension system to automatically
  /// provide the correct colors for the current theme (light/dark).
  Color _getBackgroundColor(BuildContext context) {
    return context.component.outlineButtonPrimarySurface;
  }

  /// Gets border color based on current state using theme-aware extensions
  Color _getBorderColor(BuildContext context) {
    switch (_currentState) {
      case SDeckButtonState.enabled:
        return context.component.outlineButtonBorder;
      case SDeckButtonState.pressed:
        return context.component.outlineButtonBorderPressed;
      case SDeckButtonState.disabled:
        return context.component.outlineButtonBorderDisabled;
    }
  }

  /// Gets text color based on current state using theme-aware extensions
  Color _getTextColor(BuildContext context) {
    switch (_currentState) {
      case SDeckButtonState.enabled:
        return context.component.outlineButtonText;
      case SDeckButtonState.pressed:
        return context
            .component
            .outlineButtonText; // Use same as enabled for pressed
      case SDeckButtonState.disabled:
        return context.component.outlineButtonTextDisabled;
    }
  }

  /// Gets icon color based on current state using theme-aware extensions
  ///
  /// Outline buttons only change icon color for disabled state.
  /// Enabled and pressed states all use the same icon color.
  Color _getIconColor(BuildContext context) {
    switch (_currentState) {
      case SDeckButtonState.enabled:
      case SDeckButtonState.pressed:
        return context.component.outlineButtonIcon;
      case SDeckButtonState.disabled:
        return context.component.outlineButtonIconDisabled;
    }
  }

  /// Wraps icon with state-aware color if it's a monochrome SDeckIcon
  ///
  /// SMART DETECTION:
  /// • If icon is SDeckIcon with color != null → assume monochrome → wrap with state color
  /// • If icon is SDeckIcon with color == null → assume multi-colored → use as-is
  /// • If icon is not SDeckIcon → use as-is (safe fallback)
  ///
  /// This ensures monochrome icons match text colors while preserving multi-colored icons.
  Widget _wrapIconWithColor(BuildContext context, Widget icon) {
    // Check if icon is SDeckIcon instance
    if (icon is SDeckIcon) {
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
    // Not an SDeckIcon or doesn't need wrapping - return as-is
    return icon;
  }

  /// Gets text style based on button size using theme-aware text colors
  TextStyle _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = _getTextColor(context); // State-aware text color

    switch (widget.size) {
      case SDeckButtonSize.small:
        return theme.textTheme.labelLarge!.copyWith(
          fontSize: SDeckFontSizes.bodySmall, // 16px
          fontWeight: SDeckFontWeights.medium, // 500
          height:
              SDeckLineHeights.bodySmall /
              SDeckFontSizes.bodySmall, // 20px / 16px = 1.25
          color: textColor,
        );
      case SDeckButtonSize.medium:
        return theme.textTheme.labelLarge!.copyWith(
          fontSize: SDeckFontSizes.bodyMedium, // 18px
          fontWeight: SDeckFontWeights.medium, // 500
          height:
              SDeckLineHeights.bodyMedium /
              SDeckFontSizes.bodyMedium, // 22px / 18px = 1.222...
          color: textColor,
        );
      case SDeckButtonSize.large:
        return theme.textTheme.titleMedium!.copyWith(
          fontSize: SDeckFontSizes.bodyLarge, // 20px
          fontWeight: SDeckFontWeights.medium, // 500
          height:
              SDeckLineHeights.bodyLarge /
              SDeckFontSizes.bodyLarge, // 24px / 20px = 1.2
          color: textColor,
        );
    }
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
