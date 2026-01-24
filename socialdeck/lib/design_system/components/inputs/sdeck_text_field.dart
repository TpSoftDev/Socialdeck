/*--------------------------- sdeck_text_field.dart -------------------------*/
// Text field input component for the SocialDeck design system
// Uses standardized spacing tokens and foundation color extensions
//
// Usage: SDeckTextField() or SDeckTextField.large(placeholder: "Enter text")
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/spacing/index.dart';
import '../../tokens/icons/index.dart';

//------------------------------- Enums -------------------------------------//
/// Defines the visual state of the text field
enum SDeckTextFieldState {
  hint, // Default placeholder state
  filled, // User has entered text
  error, // Validation error
  success, // Validation success
}

/// Defines the size variants of the text field
enum SDeckTextFieldSize {
  small, // 14px text, compact padding
  medium, // 16px text, medium padding
  large, // 18px text, large padding
}

//------------------------------- SDeckTextField -----------------------------//
/// Text field input component for the SocialDeck design system
/// All visual properties use foundations and tokens for consistency
/// Supports multiple states and sizes with theme-aware styling

class SDeckTextField extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  final String? placeholder;
  final SDeckTextFieldSize size;
  final SDeckTextFieldState state;
  final String? errorMessage;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? semanticsLabel;
  final bool
  showPasswordToggle; // Whether to show the eye icon for password fields
  final VoidCallback? onPasswordToggle; // Callback when eye icon is tapped
  final bool readOnly; // Whether the field is read-only (prevents editing)

  //------------------------------- Constructor ----------------------------//
  const SDeckTextField({
    super.key,
    this.placeholder,
    this.size = SDeckTextFieldSize.medium,
    this.state = SDeckTextFieldState.hint,
    this.errorMessage,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.semanticsLabel,
    this.showPasswordToggle = false, // Default: don't show eye icon
    this.onPasswordToggle,
    this.readOnly = false, // Default: not read-only
  });

  //*************************** Named Constructors ***************************//

  //------------------------------- Small Size -----------------------------//
  const SDeckTextField.small({
    super.key,
    this.placeholder,
    this.state = SDeckTextFieldState.hint,
    this.errorMessage,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.semanticsLabel,
    this.showPasswordToggle = false,
    this.onPasswordToggle,
    this.readOnly = false,
  }) : size = SDeckTextFieldSize.small;

  //------------------------------- Medium Size ----------------------------//
  const SDeckTextField.medium({
    super.key,
    this.placeholder,
    this.state = SDeckTextFieldState.hint,
    this.errorMessage,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.semanticsLabel,
    this.showPasswordToggle = false,
    this.onPasswordToggle,
    this.readOnly = false,
  }) : size = SDeckTextFieldSize.medium;

  //------------------------------- Large Size -----------------------------//
  const SDeckTextField.large({
    super.key,
    this.placeholder,
    this.state = SDeckTextFieldState.hint,
    this.errorMessage,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.semanticsLabel,
    this.showPasswordToggle = false,
    this.onPasswordToggle,
    this.readOnly = false,
  }) : size = SDeckTextFieldSize.large;

  //*************************** Helper Methods ********************************//

  //------------------------------- Size Configuration -----------------------//
  EdgeInsets _getPadding() {
    switch (size) {
      case SDeckTextFieldSize.small:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpace.padding12, // 12px
          vertical: SDeckSpace.padding8, // 8px
        );
      case SDeckTextFieldSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpace.padding12, // 12px
          vertical: SDeckSpace.padding12, // 12px
        );
      case SDeckTextFieldSize.large:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpace.padding16, // 16px
          vertical: SDeckSpace.padding16, // 16px
        );
    }
  }

  double _getBorderRadius() {
    // All text field sizes use the same radius per Figma: Radius/XXS (8px)
    return SDeckRadius.borderRadius2;
  }

  TextStyle _getTextStyle(BuildContext context) {
    switch (size) {
      case SDeckTextFieldSize.small:
        return Theme.of(context).textTheme.bodySmall!;
      case SDeckTextFieldSize.medium:
        return Theme.of(context).textTheme.bodyMedium!;
      case SDeckTextFieldSize.large:
        return Theme.of(context).textTheme.bodyLarge!;
    }
  }

  //------------------------------- State Colors ---------------------------//
  Color _getBorderColor(BuildContext context) {
    switch (state) {
      case SDeckTextFieldState.hint:
        return context.semantic.primary;
      case SDeckTextFieldState.filled:
        return context.semantic.primary;
      case SDeckTextFieldState.error:
        return context.component.inputBorderError;
      case SDeckTextFieldState.success:
        return context.semantic.success;
    }
  }

  Color? _getBackgroundColor(BuildContext context) {
    switch (state) {
      case SDeckTextFieldState.error:
        return context.semantic.surfaceError;
      case SDeckTextFieldState.success:
        return context.semantic.surfaceSuccess;
      default:
        return context.semantic.surface;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (state) {
      case SDeckTextFieldState.hint:
        return context.component.inputText;
      default:
        return context.component.inputText;
    }
  }

  TextStyle _getHintStyle(BuildContext context) {
    return _getTextStyle(
      context,
    ).copyWith(color: context.component.inputTextHint);
  }

  //------------------------------- State Icons ----------------------------//
  Widget? _buildStateIcon(BuildContext context) {
    switch (state) {
      case SDeckTextFieldState.error:
        return SDeckIcons(
          SDeckIcon.delete, // Using delete icon for error state
          size: SDeckSize.size24,
          color: context.component.inputIconError,
        );
      case SDeckTextFieldState.success:
        return SDeckIcons(
          SDeckIcon
              .placeholder, // TODO: circleCheck missing - using placeholder
          size: SDeckSize.size24,
          color: context.component.inputIcon,
        );
      default:
        return null;
    }
  }

  //------------------------------- Inner Background Color ----------------//
  Color _getInnerBackgroundColor(BuildContext context) {
    switch (state) {
      case SDeckTextFieldState.error:
        return context.semantic.surfaceError;
      case SDeckTextFieldState.success:
        return context.semantic.surfaceSuccess;
      default:
        return context.semantic.surface;
    }
  }

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    List<Widget> rightIcons = [];
    // Add password toggle (eye) icon if enabled
    if (showPasswordToggle) {
      rightIcons.add(
        IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: context.component.inputText,
          ),
          onPressed: onPasswordToggle,
          tooltip: obscureText ? 'Show password' : 'Hide password',
        ),
      );
    }
    // Add state icon (error/success) if present
    final stateIcon = _buildStateIcon(context);
    if (stateIcon != null) {
      rightIcons.add(
        Padding(
          padding: const EdgeInsets.only(right: SDeckSpace.padding16),
          child: stateIcon,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius2),
        border: Border.all(
          color: _getBorderColor(context),
          width: 3.0, // Border weight from Figma specs
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _getInnerBackgroundColor(context),
                borderRadius: BorderRadius.circular(_getBorderRadius()),
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                obscureText: obscureText,
                keyboardType: keyboardType,
                style: _getTextStyle(
                  context,
                ).copyWith(color: _getTextColor(context)),
                readOnly: readOnly,
                decoration: InputDecoration(
                  hintText: placeholder,
                  hintStyle: _getHintStyle(context),
                  border: InputBorder.none, // No border - handled by Container
                  contentPadding: _getPadding(),
                  semanticCounterText: semanticsLabel,
                ),
              ),
            ),
          ),
          // Show all right-side icons (eye, error, success)
          ...rightIcons,
        ],
      ),
    );
  }
}
