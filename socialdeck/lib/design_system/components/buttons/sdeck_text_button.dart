/*------------------------ sdeck_text_button.dart ---------------------------*/
// Text Button component for the SocialDeck design system
// Handles all variations: 1 shape × 4 states × 4 icon locations × 3 sizes = 48 variants
// Note: Text buttons only support Default shape (Round has no visual effect since there's no background/border)
//
// Usage:
//   SDeckTextButton(text: 'Click me')
//   SDeckTextButton(text: 'Save', icon: Icon(...), iconLocation: SDeckButtonIconLocation.left)
//   SDeckTextButton(icon: Icon(...), iconLocation: SDeckButtonIconLocation.only)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../helpers/theme_extensions_helper.dart';
import '../../tokens/spacing/index.dart';
import '../../tokens/typography/font_sizes.dart';
import '../../tokens/typography/line_heights.dart';
import '../../tokens/typography/font_weights.dart';
import '../../tokens/icons/index.dart';
import 'button_enums.dart';

//============================ SDeckTextButton ============================//
// MAIN COMPONENT CLASS
//
// This StatefulWidget manages its own interaction states and rebuilds
// efficiently when users interact with it. A single parameterized constructor
// provides flexible configuration while maintaining consistent behavior.

class SDeckTextButton extends StatefulWidget {
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
  const SDeckTextButton({
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
  State<SDeckTextButton> createState() => _SDeckTextButtonState();
}

//========================= _SDeckTextButtonState ===========================//
// COMPONENT STATE MANAGEMENT
//
// This class handles the button's interactive behavior and visual feedback.
// It automatically manages state transitions and triggers rebuilds only when
// the visual appearance needs to change.

class _SDeckTextButtonState extends State<SDeckTextButton> {
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

        // APPEARANCE - Transparent background, no border
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(_getBorderRadius()),
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
          horizontal: SDeckSpace.padding16, // 16px - matches Figma
          vertical:
              SDeckSpace.padding12, // 12px (44px height - 20px line height) / 2
        );
      case SDeckButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpace.padding16, // 16px
          vertical:
              SDeckSpace.padding16, // 16px (54px height - 22px line height) / 2
        );
      case SDeckButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpace.padding24, // 24px
          vertical:
              SDeckSpace.padding24, // 24px (72px height - 24px line height) / 2
        );
    }
  }

  /// Gets border radius using design tokens
  ///
  /// Text buttons always use the same border radius regardless of shape,
  /// since they have no visible background or border. The radius is kept
  /// for consistency with other button types and potential future use.
  ///
  /// @return double radius value in logical pixels
  double _getBorderRadius() {
    // Text buttons always use default radius (Round shape has no visual effect)
    return SDeckRadius.borderRadius8; // 8px - matches Figma
  }

  /// Gets text color based on current state using theme-aware extensions
  Color _getTextColor(BuildContext context) {
    switch (_currentState) {
      case SDeckButtonState.enabled:
        return context.component.textButtonText;
      case SDeckButtonState.pressed:
        return context.component.textButtonTextPressed;
      case SDeckButtonState.disabled:
        return context.component.textButtonTextDisabled;
    }
  }

  /// Gets icon color based on current state using theme-aware extensions
  ///
  /// Mirrors `_getTextColor()` to ensure icons match text colors in all states.
  /// This ensures visual consistency between text and icons per Figma design.
  Color _getIconColor(BuildContext context) {
    switch (_currentState) {
      case SDeckButtonState.enabled:
        return context.component.textButtonIcon;
      case SDeckButtonState.pressed:
        return context.component.textButtonIconPressed;
      case SDeckButtonState.disabled:
        return context.component.textButtonIconDisabled;
    }
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
    final textColor = _getTextColor(context); // State-aware text color

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

  /// Builds the button content (text and optional icon) with proper spacing
  ///
  /// LAYOUT LOGIC:
  /// This method constructs the button's content based on icon location:
  /// • none: Just centered text
  /// • left: Icon + gap + text (left-aligned).
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
