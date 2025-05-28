//------------------------------- sdeck_text_field.dart ----------------------//
// This file defines the SDeckTextField widget for the app.
// It provides a theme-aware text input field that matches Figma designs exactly.
// All colors, typography, and icons are pulled from the existing design system.
// It is used to ensure consistent text field rendering across the app.
//----------------------------------------------------------------------------//

//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';
import '../themes/custom_themes/icons.dart';
import '../constants/app_colors.dart';
import 'sdeck_icon.dart';

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
/// A theme-aware text field widget that matches Figma designs exactly.
/// All visual properties are pulled from the existing design system including
/// colors, typography, and icons. Supports multiple states and sizes.

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
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case SDeckTextFieldSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case SDeckTextFieldSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case SDeckTextFieldSize.small:
        return 20;
      case SDeckTextFieldSize.medium:
        return 24;
      case SDeckTextFieldSize.large:
        return 28;
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
        return Theme.of(context).colorScheme.outline; // coolGray[300]
      case SDeckTextFieldState.filled:
        return Theme.of(context).colorScheme.primary; // coolGray[700]
      case SDeckTextFieldState.error:
        return Theme.of(context).colorScheme.error; // brightCoral[500]
      case SDeckTextFieldState.success:
        return Theme.of(context).colorScheme.success; // mintGreen[500]
    }
  }

  Color? _getBackgroundColor(BuildContext context) {
    switch (state) {
      case SDeckTextFieldState.error:
        return Theme.of(context).colorScheme.errorContainer; // brightCoral[50]
      case SDeckTextFieldState.success:
        return Theme.of(context).colorScheme.successContainer; // mintGreen[50]
      default:
        return Theme.of(context).colorScheme.surface; // Default background
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (state) {
      case SDeckTextFieldState.hint:
        return Theme.of(context).colorScheme.onSurfaceVariant; // Gray hint text
      default:
        return Theme.of(context).colorScheme.onSurface; // Primary text color
    }
  }

  TextStyle _getHintStyle(BuildContext context) {
    return _getTextStyle(context).copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant, // Gray hint color
    );
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
    // This provides the main text field background that changes based on state:
    // - Error: Light red background
    // - Success: Light green background
    // - Normal: White (light mode) / Dark surface (dark mode)
    switch (state) {
      case SDeckTextFieldState.error:
        return Theme.of(
          context,
        ).colorScheme.errorContainer; // Light red background
      case SDeckTextFieldState.success:
        return Theme.of(
          context,
        ).colorScheme.successContainer; // Light green background
      default:
        return Theme.of(context).colorScheme.surface; // Normal background
    }
  }

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(
          8,
        ), // Outer container radius from Figma
        border: Border.all(
          color: _getBorderColor(context),
          width: 3, // Border weight from Figma specs
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _getInnerBackgroundColor(
                  context,
                ), // Theme-aware background
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
              padding: const EdgeInsets.only(right: 12),
              child: _buildStateIcon(context),
            ),
          ],
        ],
      ),
    );
  }
}
