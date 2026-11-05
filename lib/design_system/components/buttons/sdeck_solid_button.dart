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

  /// Gap between icon and text when both are present.
  final double iconTextGap;

  /// Figma Solid Button > Type. [brightCoral] is the destructive confirm (Kick).
  final SDeckSolidButtonColor color;

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
    this.iconTextGap = 10,
    this.color = SDeckSolidButtonColor.primary,
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
  bool _hovered = false;
  bool _pressed = false;

  /// Disabled wins, then pressed, then hover, then enabled.
  SDeckButtonState get _currentState {
    if (!widget.enabled) return SDeckButtonState.disabled;
    if (_pressed) return SDeckButtonState.pressed;
    if (_hovered) return SDeckButtonState.hover;
    return SDeckButtonState.enabled;
  }

  //*************************** Build Method ******************************//
  // MAIN RENDER METHOD
  //
  // This method constructs the button's widget tree and sets up gesture
  // detection. The tree is optimized for performance with minimal nesting.

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: widget.enabled ? (_) => _setHovered(true) : null,
      onExit:
          widget.enabled
              ? (_) {
                _setHovered(false);
                _setPressed(false);
              }
              : null,
      child: GestureDetector(
        onTapDown: widget.enabled ? (_) => _setPressed(true) : null,
        onTapUp: widget.enabled ? (_) => _setPressed(false) : null,
        onTapCancel: widget.enabled ? () => _setPressed(false) : null,
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
              color: _getBorderColor(context),
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

  void _setHovered(bool value) {
    if (!mounted || _hovered == value) return;
    setState(() => _hovered = value);
  }

  void _setPressed(bool value) {
    if (!mounted || _pressed == value) return;
    setState(() => _pressed = value);
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
  /// • Default: 16px (Figma: Radius/Border Radius/borderRadius16)
  /// • Round: Scales with button size for proportional appearance
  ///
  /// @return double radius value in logical pixels
  double _getBorderRadius() {
    if (widget.shape == SDeckButtonShape.default_) {
      return SDeckRadius.borderRadius16;
    } else {
      // Match [SDeckOutlineButton] round radii (Figma pill / rounded variants).
      switch (widget.size) {
        case SDeckButtonSize.small:
        case SDeckButtonSize.medium:
          return SDeckRadius.borderRadius24;
        case SDeckButtonSize.large:
          return SDeckRadius.borderRadius48;
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
    if (widget.color == SDeckSolidButtonColor.brightCoral &&
        _currentState != SDeckButtonState.disabled) {
      final bool dark = Theme.of(context).brightness == Brightness.dark;
      // Semantic Dark keeps #FE6F61 for enabled, hover, and pressed.
      if (dark || _currentState == SDeckButtonState.enabled) {
        return SDeckBaseColors.brightCoral[500]!;
      }
      // Light hover and pressed are #FFA69E.
      return SDeckBaseColors.brightCoral[300]!;
    }
    switch (_currentState) {
      case SDeckButtonState.enabled:
        return context.component.solidButtonPrimarySurface;
      case SDeckButtonState.hover:
        return context.component.solidButtonPrimarySurfaceHover;
      case SDeckButtonState.pressed:
        return context.component.solidButtonPrimarySurfacePressed;
      case SDeckButtonState.disabled:
        return context.component.solidButtonSurfaceDisabled;
    }
  }

  Color _getBorderColor(BuildContext context) {
    if (widget.color == SDeckSolidButtonColor.brightCoral &&
        _currentState != SDeckButtonState.disabled) {
      final bool dark = Theme.of(context).brightness == Brightness.dark;
      // Light #FFA69E at 20%. Semantic Dark #D11001 at 20%.
      final Color border =
          dark
              ? SDeckBaseColors.brightCoral[700]!
              : SDeckBaseColors.brightCoral[300]!;
      return border.withValues(alpha: 0.2);
    }
    return context.component.solidButtonBorder;
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
    final textColor = _getTextColor(context);

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

  Color _getTextColor(BuildContext context) {
    if (widget.color == SDeckSolidButtonColor.brightCoral &&
        _currentState != SDeckButtonState.disabled) {
      final bool dark = Theme.of(context).brightness == Brightness.dark;
      // Light #FFE3E0. Semantic Dark #470600.
      return dark
          ? SDeckBaseColors.brightCoral[900]!
          : SDeckBaseColors.brightCoral[100]!;
    }
    return context.component.solidButtonText;
  }

  /// Gets icon color using theme-aware extensions
  ///
  /// Solid buttons use a consistent icon color across all states.
  /// Icons match the button text color for visual consistency.
  Color _getIconColor(BuildContext context) {
    if (widget.color == SDeckSolidButtonColor.brightCoral &&
        _currentState != SDeckButtonState.disabled) {
      return _getTextColor(context);
    }
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
  /// • left: Icon + gap + text, centered as a group
  /// • right: Text + gap + icon, centered as a group
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
      children.add(SizedBox(width: widget.iconTextGap));
    }

    // Add text (always present for non-icon-only buttons).
    // Do not expand the label when an icon is present — that pins the icon to
    // the far edge. Figma keeps icon + gap + text as one centered cluster.
    if (widget.text != null) {
      final Widget textWidget = Text(
        widget.text!,
        style: _getTextStyle(context),
        textAlign: TextAlign.center,
        softWrap: true,
      );
      final bool clusterWithIcon =
          widget.icon != null &&
          widget.iconLocation != SDeckButtonIconLocation.none &&
          widget.iconLocation != SDeckButtonIconLocation.only;
      if (widget.fullWidth && !clusterWithIcon) {
        children.add(Expanded(child: textWidget));
      } else if (widget.fullWidth) {
        // Loose flex keeps the approved icon/label cluster centered while
        // allowing long labels to wrap on narrow screens or larger text.
        children.add(Flexible(child: textWidget));
      } else {
        children.add(textWidget);
      }
    }

    // Add right icon if configured
    if (widget.iconLocation == SDeckButtonIconLocation.right &&
        widget.icon != null) {
      children.add(SizedBox(width: widget.iconTextGap));
      children.add(_wrapIconWithColor(context, widget.icon!));
    }

    return children;
  }
}
