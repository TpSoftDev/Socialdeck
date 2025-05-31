/*--------------------------- sdeck_text_field.dart -------------------------*/
// Text field input component for the SocialDeck design system
// Theme-aware text input that matches Figma designs exactly
// Uses standardized spacing tokens and foundation color extensions
//
// Usage: SDeckTextField() or SDeckTextField.large(placeholder: "Enter text")
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../foundations/index.dart';
import '../icons/index.dart';

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
  }) : size = SDeckTextFieldSize.large;

  //*************************** Helper Methods ********************************//

  //------------------------------- Size Configuration --------------------//
  EdgeInsets _getPadding() {
    switch (size) {
      case SDeckTextFieldSize.small:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpacing.textFieldPaddingSmallHorizontal,
          vertical: SDeckSpacing.textFieldPaddingSmallVertical,
        );
      case SDeckTextFieldSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpacing.textFieldPaddingMediumHorizontal,
          vertical: SDeckSpacing.textFieldPaddingMediumVertical,
        );
      case SDeckTextFieldSize.large:
        return const EdgeInsets.symmetric(
          horizontal: SDeckSpacing.textFieldPaddingLargeHorizontal,
          vertical: SDeckSpacing.textFieldPaddingLargeVertical,
        );
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case SDeckTextFieldSize.small:
        return SDeckSpacing.textFieldRadiusSmall;
      case SDeckTextFieldSize.medium:
        return SDeckSpacing.textFieldRadiusMedium;
      case SDeckTextFieldSize.large:
        return SDeckSpacing.textFieldRadiusLarge;
    }
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
        return Theme.of(context).colorScheme.outline;
      case SDeckTextFieldState.filled:
        return Theme.of(context).colorScheme.primary;
      case SDeckTextFieldState.error:
        return Theme.of(context).colorScheme.error;
      case SDeckTextFieldState.success:
        return Theme.of(context).colorScheme.success;
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
        return Theme.of(context).colorScheme.onSurfaceVariant;
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
        return SDeckIcon.small(context.icons.circleX);
      case SDeckTextFieldState.success:
        return SDeckIcon.small(context.icons.circleCheck);
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
    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(SDeckSpacing.radiusSmall),
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
          if (_buildStateIcon(context) != null) ...[
            Padding(
              padding: const EdgeInsets.only(right: SDeckSpacing.md),
              child: _buildStateIcon(context),
            ),
          ],
        ],
      ),
    );
  }
}
