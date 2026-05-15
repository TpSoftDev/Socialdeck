/*--------------------------- sdeck_input.dart -------------------------*/
// Input component for the SocialDeck design system
// Matches Figma's Input component with integrated Label and Supporting Text
// Uses standardized spacing tokens and foundation color extensions
//
// Usage: SDeckInput(label: "Email", placeholder: "Enter your email")
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/spacing/index.dart';
import '../../tokens/icons/index.dart';
import '../../themes/text_theme.dart';
import 'input_enums.dart';

//------------------------------- SDeckInput -----------------------------//
/// Input component for the SocialDeck design system
/// Matches Figma's Input component exactly with integrated Label and Supporting Text
/// All visual properties use foundations and tokens for consistency.
///
/// **Visual chrome (hint vs focused vs error)** when [controller] is set:
/// - [SDeckInputState.error] and [SDeckInputState.disabled] from [state] always win.
/// - Otherwise: **hint** look while the field is empty (trimmed); **focused** look
///   once the user has entered non-whitespace text. Keyboard focus alone does not
///   switch to the focused border.
///
/// Without a [controller], [state] still drives chrome, except [SDeckInputState.focused]
/// is treated like **hint** (avoids blue border on empty fields), and [filled] uses
/// the same chrome as **focused** (entered value).

class SDeckInput extends StatefulWidget {
  //------------------------------- Properties -----------------------------//

  /// Optional label text displayed above the input field
  final String? label;

  /// Optional supporting text displayed below the input field
  /// Can be used for hints, error messages, or instructions
  final String? supportingText;

  /// Size variant - affects padding and text size
  final SDeckInputSize size;

  /// Logical / provider state: use [SDeckInputState.error] when invalid,
  /// [SDeckInputState.disabled] when not interactive. Other values combine with
  /// [controller] text as described in [SDeckInput].
  final SDeckInputState state;

  /// Focus node for the text field
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

  /// Callback when user submits from the keyboard return key.
  final ValueChanged<String>? onSubmitted;

  /// Whether text should be obscured (for passwords)
  final bool obscureText;

  /// Keyboard type (email, text, password, etc.)
  final TextInputType? keyboardType;

  /// Keyboard return key action (done, next, go, etc.).
  final TextInputAction? textInputAction;

  /// Semantic label for accessibility
  final String? semanticsLabel;

  /// Whether to show password toggle icon (automatically shown when obscureText is true)
  final bool showPasswordToggle;

  /// Callback when password toggle is tapped
  final VoidCallback? onPasswordToggle;

  /// Whether the field is read-only (prevents editing)
  final bool readOnly;

  /// Optional max length (e.g. 6-digit party code). Counter is hidden.
  final int? maxLength;

  /// Optional formatters (e.g. digits-only).
  final List<TextInputFormatter>? inputFormatters;

  /// When true, the text field requests the keyboard on first layout.
  final bool autofocus;

  /// When false, disables the platform word-suggestion pipeline (often shrinks or
  /// removes the Android keyboard suggestion / accessory strip above the keys).
  final bool enableSuggestions;

  /// When false, disables autocorrect (pairs with [enableSuggestions] for IME).
  final bool autocorrect;

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
    this.onSubmitted,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.semanticsLabel,
    this.showPasswordToggle = false,
    this.onPasswordToggle,
    this.readOnly = false,
    this.maxLength,
    this.inputFormatters,
    this.autofocus = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
  });

  @override
  State<SDeckInput> createState() => _SDeckInputState();
}

class _SDeckInputState extends State<SDeckInput> {
  void _onControllerTick() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onControllerTick);
  }

  @override
  void didUpdateWidget(covariant SDeckInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerTick);
      widget.controller?.addListener(_onControllerTick);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerTick);
    super.dispose();
  }

  SDeckInputState _visualState() {
    final s = widget.state;
    if (s == SDeckInputState.disabled) return SDeckInputState.disabled;
    if (s == SDeckInputState.error) return SDeckInputState.error;

    if (widget.controller != null) {
      return widget.controller!.text.trim().isNotEmpty
          ? SDeckInputState.focused
          : SDeckInputState.hint;
    }

    if (s == SDeckInputState.filled) return SDeckInputState.focused;
    if (s == SDeckInputState.focused) return SDeckInputState.hint;
    return s;
  }

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    final visual = _visualState();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) _buildLabel(context),
        if (widget.label != null) const SizedBox(height: SDeckSpace.gap4),
        _buildInputField(context, visual),
        if (widget.supportingText != null) const SizedBox(height: SDeckSpace.gap4),
        if (widget.supportingText != null) _buildSupportingText(context, visual),
      ],
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding8),
      child: Text(
        widget.label!,
        style: Theme.of(
          context,
        ).textTheme.caption.copyWith(color: context.component.inputLabel),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, SDeckInputState visual) {
    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(context, visual),
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        border: Border.all(
          color: _getBorderColor(context, visual),
          width: SDeckSize.size4,
        ),
      ),
      padding: _getPadding(),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                if (widget.iconLeft != null) ...[
                  widget.iconLeft!,
                  const SizedBox(width: SDeckSpace.gap4),
                ],
                Expanded(
                  child: TextField(
                    autofocus: widget.autofocus,
                    focusNode: widget.focusNode,
                    controller: widget.controller,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    obscureText: widget.obscureText,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    readOnly: widget.readOnly,
                    enabled: widget.state != SDeckInputState.disabled,
                    enableSuggestions: widget.enableSuggestions,
                    autocorrect: widget.autocorrect,
                    spellCheckConfiguration: widget.enableSuggestions
                        ? null
                        : SpellCheckConfiguration.disabled(),
                    maxLength: widget.maxLength,
                    inputFormatters: widget.inputFormatters,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: _getTextColor(context, visual),
                    ),
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(color: context.component.inputTextHint),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      counterText: widget.maxLength != null ? '' : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...() {
            final rightIcon = _buildRightIcon(context, visual);
            return rightIcon != null ? [rightIcon] : <Widget>[];
          }(),
        ],
      ),
    );
  }

  Color _getBorderColor(BuildContext context, SDeckInputState visual) {
    switch (visual) {
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

  Color _getBackgroundColor(BuildContext context, SDeckInputState visual) {
    switch (visual) {
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

  Color _getTextColor(BuildContext context, SDeckInputState visual) {
    switch (visual) {
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

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case SDeckInputSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpace.padding16,
          vertical: SDeckSpace.padding12,
        );
      case SDeckInputSize.large:
        return const EdgeInsets.all(SDeckSpace.padding16);
    }
  }

  Widget _buildSupportingText(BuildContext context, SDeckInputState visual) {
    Color textColor;
    switch (visual) {
      case SDeckInputState.error:
        textColor = context.component.inputSupportingTextError;
        break;
      case SDeckInputState.disabled:
        textColor = context.component.inputSupportingTextDisabled;
        break;
      default:
        textColor = context.component.inputSupportingText;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding8),
      child: Text(
        widget.supportingText!,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: textColor),
      ),
    );
  }

  Widget? _buildRightIcon(BuildContext context, SDeckInputState visual) {
    if (widget.iconRight != null) {
      return widget.iconRight;
    }

    if (widget.showPasswordToggle) {
      return GestureDetector(
        onTap: visual != SDeckInputState.disabled ? widget.onPasswordToggle : null,
        child: SDeckIcons(
          widget.obscureText ? SDeckIcon.closedEye : SDeckIcon.eye,
          size: SDeckSize.size24,
          color: context.component.inputIcon,
          semanticsLabel: widget.obscureText ? 'Show password' : 'Hide password',
        ),
      );
    }

    return null;
  }
}
