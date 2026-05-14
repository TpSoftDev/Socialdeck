/*------------------------ sdeck_input_dialog.dart --------------------------*/
// Input dialog for the SocialDeck design system.
// Figma: Socialdeck — Design System → inputDialog (node 6064:304).
// Home — Enter party code instance: node 230:3913 (title + close, visual,
// labeled field, supporting copy, Next).
// Structure: title + optional close, optional visual placeholder, description,
// input (label / field / supporting), primary CTA.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../themes/text_theme.dart';
import '../../tokens/index.dart';
import '../buttons/sdeck_solid_button.dart';
import '../buttons/button_enums.dart';
import '../inputs/input_enums.dart';
import '../inputs/sdeck_input.dart';

//============================= SDeckInputDialog ============================//
class SDeckInputDialog extends StatelessWidget {
  const SDeckInputDialog({
    super.key,
    required this.title,
    this.description = 'Description',
    this.inputLabel = 'Label',
    this.supportingText = 'Supporting Text',
    this.placeholder = 'Input',
    this.primaryButtonText = 'Button',
    this.onPrimaryPressed,
    this.onClose,
    this.showClose = true,
    this.showDescription = true,
    this.showVisualPlaceholder = true,
    this.content,
    this.contentHeight = 92.5,
    this.dialogWidth = 325.5,
    this.inputState = SDeckInputState.hint,
    this.inputSize = SDeckInputSize.medium,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.readOnly = false,
    this.iconLeft,
    this.iconRight,
    this.primaryAction,
    this.descriptionWidget,
    this.inputWidget,
    this.showInputSideIcons = true,
    this.primaryButtonEnabled = true,
    this.maxLength,
    this.inputFormatters,
  });

  final String title;
  final String description;
  final String inputLabel;
  final String supportingText;
  final String placeholder;
  final String primaryButtonText;

  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onClose;
  final bool showClose;
  final bool showDescription;

  /// When true, shows the checkered media block (Figma `visual`).
  final bool showVisualPlaceholder;

  final double contentHeight;
  final double dialogWidth;
  final Widget? content;

  final SDeckInputState inputState;
  final SDeckInputSize inputSize;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool readOnly;
  final Widget? iconLeft;
  final Widget? iconRight;

  /// Optional complete override for primary action area.
  final Widget? primaryAction;

  /// Optional complete override for description area.
  final Widget? descriptionWidget;

  /// Optional complete override for input block area.
  final Widget? inputWidget;

  /// When false, left/right input icons are omitted unless [iconLeft] /
  /// [iconRight] are set (matches Figma party-code field with no icons).
  final bool showInputSideIcons;

  /// When false, [SDeckSolidButton] is visually disabled (e.g. until code
  /// length is valid).
  final bool primaryButtonEnabled;

  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Widget> children = [
      _InputDialogHeader(
        title: title,
        onClose: onClose,
        showClose: showClose,
        titleStyle: theme.textTheme.h5.copyWith(
          color: context.component.dialogTitleText,
        ),
      ),
    ];

    if (showVisualPlaceholder) {
      children.add(const SizedBox(height: SDeckSpace.gap16));
      children.add(
        _InputDialogContent(
          content: content,
          contentHeight: contentHeight,
        ),
      );
    }

    if (showDescription) {
      children.add(const SizedBox(height: SDeckSpace.gap16));
      children.add(
        descriptionWidget ??
            _InputDialogDescription(
              text: description,
              style: theme.textTheme.bodyMediumFigma.copyWith(
                color: context.component.dialogDescriptionText,
              ),
            ),
      );
    }

    children.add(const SizedBox(height: SDeckSpace.gap16));
    children.add(
      inputWidget ??
          SDeckInput(
            label: inputLabel,
            supportingText: supportingText,
            size: inputSize,
            state: inputState,
            focusNode: focusNode,
            iconLeft: showInputSideIcons
                ? (iconLeft ?? _defaultInputIcon(context))
                : iconLeft,
            iconRight: showInputSideIcons
                ? (iconRight ?? _defaultInputIcon(context))
                : iconRight,
            placeholder: placeholder,
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            readOnly: readOnly,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
          ),
    );

    children.add(const SizedBox(height: SDeckSpace.gap16));
    children.add(
      SizedBox(
        width: double.infinity,
        child:
            primaryAction ??
            SDeckSolidButton(
              text: primaryButtonText,
              size: SDeckButtonSize.medium,
              shape: SDeckButtonShape.default_,
              enabled: primaryButtonEnabled,
              onPressed: onPrimaryPressed,
              fullWidth: true,
            ),
      ),
    );

    return Container(
      width: dialogWidth,
      padding: const EdgeInsets.all(SDeckSpace.padding24),
      decoration: BoxDecoration(
        color: context.component.dialogSurface,
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius40),
        boxShadow: SDeckBoxShadows.boxShadowHigh(context.semantic.shadow),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _defaultInputIcon(BuildContext context) {
    return Icon(
      Icons.circle_outlined,
      size: SDeckSize.size24,
      color: context.component.inputIcon,
    );
  }
}

//=========================== _InputDialogHeader ============================//
class _InputDialogHeader extends StatelessWidget {
  const _InputDialogHeader({
    required this.title,
    this.onClose,
    required this.showClose,
    required this.titleStyle,
  });

  final String title;
  final VoidCallback? onClose;
  final bool showClose;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment:
          showClose ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle,
          ),
        ),
        if (showClose) ...[
          const SizedBox(width: SDeckSpace.gap8),
          SizedBox(
            width: SDeckSize.size36,
            height: SDeckSize.size36,
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
              child: SDeckIcons(
                SDeckIcon.x,
                size: SDeckSize.size36,
                color: context.component.dialogIcon,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

//=========================== _InputDialogContent ===========================//
class _InputDialogContent extends StatelessWidget {
  const _InputDialogContent({
    required this.content,
    required this.contentHeight,
  });

  final Widget? content;
  final double contentHeight;

  @override
  Widget build(BuildContext context) {
    if (content != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        child: SizedBox(
          height: contentHeight,
          width: double.infinity,
          child: content,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
      child: SizedBox(
        width: double.infinity,
        height: contentHeight,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xFFD3D3D3),
            image: DecorationImage(
              image: AssetImage(SDeckIcon.checkeredBackground),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

//========================= _InputDialogDescription =========================//
class _InputDialogDescription extends StatelessWidget {
  const _InputDialogDescription({
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style);
  }
}
