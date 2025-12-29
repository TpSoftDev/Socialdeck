/*--------------------------- sdeck_text_field.dart -------------------------*/
// Text field input component for the SocialDeck design system
// Uses standardized spacing tokens and foundation color extensions
//
// Usage: SDeckTextField() or SDeckTextField.large(placeholder: "Enter text")
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/index.dart';
import '../../tokens/icons/icons.dart';
import '../icons/sdeck_icon.dart';

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

  //------------------------------- Size Configuration --------------------//
  EdgeInsets _getPadding() {
    switch (size) {
      case SDeckTextFieldSize.small:
        return const EdgeInsets.symmetric(
          horizontal:
              SDeckSpaceComponentSpecific.textFieldPaddingSmallHorizontal,
          vertical: SDeckSpaceComponentSpecific.textFieldPaddingSmallVertical,
        );
      case SDeckTextFieldSize.medium:
        return const EdgeInsets.symmetric(
          horizontal:
              SDeckSpaceComponentSpecific.textFieldPaddingMediumHorizontal,
          vertical: SDeckSpaceComponentSpecific.textFieldPaddingMediumVertical,
        );
      case SDeckTextFieldSize.large:
        return const EdgeInsets.symmetric(
          horizontal:
              SDeckSpaceComponentSpecific.textFieldPaddingLargeHorizontal,
          vertical: SDeckSpaceComponentSpecific.textFieldPaddingLargeVertical,
        );
    }
  }

  double _getBorderRadius() {
    // All text field sizes use the same radius per Figma: Radius/XXS (8px)
    return SDeckRadius.borderRadiusXXS;
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
        return Theme.of(context).colorScheme.primary;
      case SDeckTextFieldState.filled:
        return Theme.of(context).colorScheme.primary;
      case SDeckTextFieldState.error:
        return Theme.of(context).colorScheme.onErrorContainer;
      case SDeckTextFieldState.success:
        return Theme.of(context).colorScheme.onSuccessContainer;
    }
  }

  Color? _getBackgroundColor(BuildContext context) {
    switch (state) {
      case SDeckTextFieldState.error:
        return Theme.of(context).colorScheme.errorContainer;
      case SDeckTextFieldState.success:
        return Theme.of(context).colorScheme.successContainer;
      default:
        return Theme.of(context).colorScheme.surface;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (state) {
      case SDeckTextFieldState.hint:
        return Theme.of(context).colorScheme.onSurface;
      default:
        return Theme.of(context).colorScheme.onSurface;
    }
  }

  TextStyle _getHintStyle(BuildContext context) {
    return _getTextStyle(
      context,
    ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
  }

  //------------------------------- State Icons ----------------------------//
  Widget? _buildStateIcon(BuildContext context) {
    switch (state) {
      case SDeckTextFieldState.error:
        return SDeckIcon.medium(
          SDeckIcons.delete, // Using delete icon for error state
          color: Theme.of(context).colorScheme.inputIconError,
        );
      case SDeckTextFieldState.success:
        return SDeckIcon.medium(
          SDeckIcons
              .placeholder, // TODO: circleCheck missing - using placeholder
          color: Theme.of(context).colorScheme.inputIcon,
        );
      default:
        return null;
    }
  }

  //------------------------------- Inner Background Color ----------------//
  Color _getInnerBackgroundColor(BuildContext context) {
    switch (state) {
      case SDeckTextFieldState.error:
        return Theme.of(context).colorScheme.errorContainer;
      case SDeckTextFieldState.success:
        return Theme.of(context).colorScheme.successContainer;
      default:
        return Theme.of(context).colorScheme.surface;
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
            color: Theme.of(context).colorScheme.onSurface,
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
          padding: const EdgeInsets.only(right: SDeckSpace.paddingM),
          child: stateIcon,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadiusXXS),
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
