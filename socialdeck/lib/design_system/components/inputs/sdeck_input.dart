/*--------------------------- sdeck_input.dart -------------------------*/
// Input component for the SocialDeck design system
// Matches Figma's Input component with integrated Label and Supporting Text
// Uses standardized spacing tokens and foundation color extensions
//
// Usage: SDeckInput(label: "Email", placeholder: "Enter your email")
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/spacing/index.dart';
import '../../tokens/icons/index.dart';
import '../../themes/text_theme.dart';
import 'input_enums.dart';

//------------------------------- SDeckInput -----------------------------//
/// Input component for the SocialDeck design system
/// Matches Figma's Input component exactly with integrated Label and Supporting Text
/// Component is "blind" - receives state from provider (single source of truth)
/// All visual properties use foundations and tokens for consistency

class SDeckInput extends StatelessWidget {
  //------------------------------- Properties -----------------------------//

  /// Optional label text displayed above the input field
  final String? label;

  /// Optional supporting text displayed below the input field
  /// Can be used for hints, error messages, or instructions
  final String? supportingText;

  /// Size variant - affects padding and text size
  final SDeckInputSize size;

  /// Visual state - provider always provides this (hint, focused, filled, error, disabled)
  final SDeckInputState state;

  /// Focus node for detecting keyboard focus - provided by provider
  final FocusNode? focusNode;

  /// Optional left icon widget
  final Widget? iconLeft;

  /// Optional right icon widget (password toggle handled automatically)
  final Widget? iconRight;

  /// Placeholder text shown when field is empty
  final String? placeholder;

  /// Controller for the text field
  final TextEditingController? controller;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Whether text should be obscured (for passwords)
  final bool obscureText;

  /// Keyboard type (email, text, password, etc.)
  final TextInputType? keyboardType;

  /// Semantic label for accessibility
  final String? semanticsLabel;

  /// Whether to show password toggle icon (automatically shown when obscureText is true)
  final bool showPasswordToggle;

  /// Callback when password toggle is tapped
  final VoidCallback? onPasswordToggle;

  /// Whether the field is read-only (prevents editing)
  final bool readOnly;

  //------------------------------- Constructor ----------------------------//
  const SDeckInput({
    super.key,
    this.label,
    this.supportingText,
    required this.state,
    this.size = SDeckInputSize.medium,
    this.focusNode,
    this.iconLeft,
    this.iconRight,
    this.placeholder,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.semanticsLabel,
    this.showPasswordToggle = false,
    this.onPasswordToggle,
    this.readOnly = false,
  });

  //*************************** Build Method ********************************//
  /// Builds the complete input component structure
  /// Matches Figma: Column layout with 4px gaps between all elements
  /// Structure: [Label] → 4px gap → [Input] → 4px gap → [Supporting Text]
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label (optional) - Figma: 14px Caption, 8px horizontal padding
        if (label != null) _buildLabel(context),

        // 4px gap between label and input (matches Figma gap-4)
        if (label != null) const SizedBox(height: SDeckSpace.gap4),

        // Input field - Figma: Single container with Row layout
        _buildInputField(context, state),

        // 4px gap between input and supporting text (matches Figma gap-4)
        if (supportingText != null) const SizedBox(height: SDeckSpace.gap4),

        // Supporting text (optional) - Figma: 12px Label Small, 8px horizontal padding
        if (supportingText != null) _buildSupportingText(context, state),
      ],
    );
  }

  //*************************** Build Helper Methods ********************************//

  /// Builds the label above the input
  /// Matches Figma: 14px Caption, 18px line height, 8px horizontal padding
  Widget _buildLabel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding8),
      child: Text(
        label!,
        style: Theme.of(
          context,
        ).textTheme.caption.copyWith(color: context.component.inputLabel),
      ),
    );
  }

  /// Builds the main input field
  /// Matches Figma exactly:
  /// - Single container (not nested) with border-4 (4px), borderradius8 (8px)
  /// - Row layout: [iconLeft + 4px gap + text] | [iconRight]
  /// - Padding: Medium = 16px horizontal / 12px vertical, Large = 16px all
  /// - Typography: 20px Body Large (24px line height)
  /// - Colors: State-based (hint/focused/filled/error/disabled)
  Widget _buildInputField(BuildContext context, SDeckInputState state) {
    return Container(
      decoration: BoxDecoration(
        // Background color based on state (matches Figma inputSurface variants)
        color: _getBackgroundColor(context),
        // Border radius: 8px (matches Figma borderradius8)
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
        border: Border.all(
          // Border color based on state (matches Figma inputBorder variants)
          color: _getBorderColor(context),
          // Border width: 4px (matches Figma border-4)
          width: SDeckSize.size4,
        ),
      ),
      // Padding based on size (matches Figma padding tokens)
      padding: _getPadding(),
      child: Row(
        // Matches Figma: flex items-center justify-between
        children: [
          // Left side: iconLeft + 4px gap + text (matches Figma gap-4)
          Expanded(
            child: Row(
              children: [
                if (iconLeft != null) ...[
                  iconLeft!, // Icon size: 24px (from Figma)
                  const SizedBox(
                    width: SDeckSpace.gap4,
                  ), // 4px gap (matches Figma gap-4)
                ],
                Expanded(
                  child: TextField(
                    // Provider's FocusNode - enables focus detection at provider level
                    focusNode: focusNode,
                    controller: controller,
                    onChanged: onChanged,
                    obscureText: obscureText,
                    keyboardType: keyboardType,
                    readOnly: readOnly,
                    enabled: state != SDeckInputState.disabled,
                    // Typography: 20px Body Large, 24px line height (matches Figma)
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      // Text color based on state (matches Figma inputText variants)
                      color: _getTextColor(context),
                    ),
                    decoration: InputDecoration(
                      hintText: placeholder,
                      // Hint color: inputTextHint (matches Figma)
                      hintStyle: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(color: context.component.inputTextHint),
                      border:
                          InputBorder.none, // No border - handled by Container
                      contentPadding:
                          EdgeInsets.zero, // Padding handled by container
                      isDense: true, // Reduces default TextField padding
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Right side: iconRight or password toggle (matches Figma layout)
          // Build right icon (iconRight takes priority, then password toggle if enabled)
          ...() {
            final rightIcon = _buildRightIcon(context);
            return rightIcon != null ? [rightIcon] : <Widget>[];
          }(),
        ],
      ),
    );
  }

  /// Gets border color based on state
  /// Matches Figma color tokens exactly:
  /// - Focused: inputBorderFocused (#57ccf2)
  /// - Error: inputBorderError (#fe6f61)
  /// - Disabled: inputBorderDisabled (#9e9e9e)
  /// - Hint/Filled: inputBorder (rgba(31,31,31,0.2))
  Color _getBorderColor(BuildContext context) {
    switch (state) {
      case SDeckInputState.focused:
        return context.component.inputBorderFocused;
      case SDeckInputState.error:
        return context.component.inputBorderError;
      case SDeckInputState.disabled:
        return context.component.inputBorderDisabled;
      case SDeckInputState.hint:
      case SDeckInputState.filled:
        return context.component.inputBorder;
    }
  }

  /// Gets background color based on state
  /// Matches Figma color tokens exactly:
  /// - Error: inputSurfaceError (#ffe3e0)
  /// - Disabled: inputSurfaceDisabled (#ebebeb)
  /// - Hint/Focused/Filled: inputSurface (#fdfbf5)
  Color _getBackgroundColor(BuildContext context) {
    switch (state) {
      case SDeckInputState.error:
        return context.component.inputSurfaceError;
      case SDeckInputState.disabled:
        return context.component.inputSurfaceDisabled;
      case SDeckInputState.hint:
      case SDeckInputState.focused:
      case SDeckInputState.filled:
        return context.component.inputSurface;
    }
  }

  /// Gets text color based on state
  /// Matches Figma color tokens exactly:
  /// - Disabled: inputTextDisabled (#9e9e9e)
  /// - Hint: inputTextHint (#9e9e9e)
  /// - Focused/Filled/Error: inputText (#1f1f1f)
  Color _getTextColor(BuildContext context) {
    switch (state) {
      case SDeckInputState.disabled:
        return context.component.inputTextDisabled;
      case SDeckInputState.hint:
        return context.component.inputTextHint;
      case SDeckInputState.focused:
      case SDeckInputState.filled:
      case SDeckInputState.error:
        return context.component.inputText;
    }
  }

  /// Gets padding based on size
  /// Matches Figma padding tokens exactly:
  /// - Medium: 16px horizontal, 12px vertical (px-padding16, py-padding12)
  /// - Large: 16px all around (p-padding16)
  EdgeInsets _getPadding() {
    switch (size) {
      case SDeckInputSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpace.padding16, // 16px horizontal (matches Figma
          vertical: SDeckSpace.padding12, // 12px vertical (matches Figma)
        );
      case SDeckInputSize.large:
        return const EdgeInsets.all(
          SDeckSpace.padding16,
        ); // 16px all around (matches Figma)
    }
  }

  /// Builds the supporting text below the input
  /// Matches Figma exactly:
  /// - Typography: 12px Label Small (font-size/label-small), 16px line height (line-height/footer)
  /// - Padding: 8px horizontal (px-padding8)
  /// - Colors: inputSupportingText (#5e5e5e) / inputSupportingTextError (#fe6f61) / inputSupportingTextDisabled (#9e9e9e)
  Widget _buildSupportingText(BuildContext context, SDeckInputState state) {
    Color textColor;
    switch (state) {
      case SDeckInputState.error:
        // Error state: inputSupportingTextError (#fe6f61) - matches Figma
        textColor = context.component.inputSupportingTextError;
        break;
      case SDeckInputState.disabled:
        // Disabled state: inputSupportingTextDisabled (#9e9e9e) - matches Figma
        textColor = context.component.inputSupportingTextDisabled;
        break;
      default:
        // Normal state: inputSupportingText (#5e5e5e) - matches Figma
        textColor = context.component.inputSupportingText;
    }

    return Padding(
      // Padding: 8px horizontal (matches Figma px-padding8)
      padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding8),
      child: Text(
        supportingText!,
        // Typography: labelMedium uses labelSmall font size (12px) and line height (16px)
        // This matches Figma's font-size/label-small and line-height/footer
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: textColor),
      ),
    );
  }

  /// Builds the right icon (iconRight or password toggle)
  /// Matches Figma exactly:
  /// - Icon size: 24px (SDeckIcon.medium uses SDeckSize.size24 token)
  /// - Icon color: inputIcon (from component color tokens)
  /// - Icons: SDeckIcon.eye (when password visible) / SDeckIcon.closedEye (when password hidden)
  /// Priority: iconRight (if provided) > password toggle (if showPasswordToggle is true)
  ///
  /// NOTE: Using SDeckIcon for now (consistent with rest of codebase)
  /// TODO: Refactor to use tokens directly when SDeckIcon is phased out
  Widget? _buildRightIcon(BuildContext context) {
    // Priority 1: If explicit iconRight is provided, use that (caller controls styling)
    if (iconRight != null) {
      return iconRight;
    }

    // Priority 2: If password toggle is enabled, show eye/closedEye icon
    if (showPasswordToggle) {
      return GestureDetector(
        // Disable tap when input is disabled
        onTap: state != SDeckInputState.disabled ? onPasswordToggle : null,
        child: SDeckIcons(
          // Icon selection based on password visibility:
          // - obscureText = true → closedEye (password is hidden, show "eye" to reveal)
          // - obscureText = false → eye (password is visible, show "closedEye" to hide)
          obscureText ? SDeckIcon.closedEye : SDeckIcon.eye,
          size: SDeckSize.size24,
          // Icon color: inputIcon (matches Figma color token)
          color: context.component.inputIcon,
          semanticsLabel: obscureText ? 'Show password' : 'Hide password',
        ),
      );
    }

    // No icon to show
    return null;
  }
}
