/*--------------------------- sdeck_dialog.dart ----------------------------*/
// Base dialog for the SocialDeck design system.
// Figma: Socialdeck — Design System → Dialog (node 5794:9058).
// Structure: title + optional close, optional visual placeholder, description,
// one or two action buttons (outline + solid when secondary is provided).
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../themes/text_theme.dart';
import '../../tokens/index.dart';
import '../buttons/button_enums.dart';
import '../buttons/sdeck_outline_button.dart';
import '../buttons/sdeck_solid_button.dart';

//=============================== SDeckDialog ===============================//
class SDeckDialog extends StatelessWidget {
  const SDeckDialog({
    super.key,
    required this.title,
    this.description,
    this.currentStep,
    this.totalSteps,
    this.primaryButtonText = 'Button',
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.onClose,
    this.showClose = true,
    this.showDescription = true,
    this.showVisualPlaceholder = true,
    this.content,
    this.contentHeight = 92.5,
    this.dialogWidth = 325.5,
    this.primaryAction,
    this.secondaryAction,
    this.descriptionWidget,
  });

  final String title;
  final String? description;

  /// Optional metadata hooks for host screens that reuse this base dialog.
  final int? currentStep;
  final int? totalSteps;

  final String primaryButtonText;
  final String? secondaryButtonText;

  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final VoidCallback? onClose;

  final bool showClose;
  final bool showDescription;

  /// When true, shows the checkered media block (Figma `visual`).
  final bool showVisualPlaceholder;

  final double contentHeight;
  final double dialogWidth;

  /// Optional custom content area. If null, checkered placeholder is shown when [showVisualPlaceholder] is true.
  final Widget? content;

  final Widget? primaryAction;
  final Widget? secondaryAction;
  final Widget? descriptionWidget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool hasSecondaryAction =
        secondaryAction != null ||
        ((secondaryButtonText?.isNotEmpty ?? false) &&
            onSecondaryPressed != null);

    final bool showDescriptionBlock =
        showDescription &&
        (descriptionWidget != null ||
            (description != null && description!.isNotEmpty));

    final List<Widget> children = [
      _DialogHeader(
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
        _DialogContent(
          content: content,
          contentHeight: contentHeight,
        ),
      );
    }

    if (showDescriptionBlock) {
      children.add(const SizedBox(height: SDeckSpace.gap16));
      children.add(
        descriptionWidget ??
            _DialogDescription(
              text: description!,
              style: theme.textTheme.bodyMediumFigma.copyWith(
                color: context.component.dialogDescriptionText,
              ),
            ),
      );
    }

    children.add(const SizedBox(height: SDeckSpace.gap16));

    if (hasSecondaryAction) {
      children.add(
        Row(
          children: [
            Expanded(
              child:
                  secondaryAction ??
                  SDeckOutlineButton(
                    text: secondaryButtonText!,
                    size: SDeckButtonSize.medium,
                    shape: SDeckButtonShape.default_,
                    onPressed: onSecondaryPressed,
                  ),
            ),
            const SizedBox(width: SDeckSpace.gap8),
            Expanded(
              child:
                  primaryAction ??
                  SDeckSolidButton(
                    text: primaryButtonText,
                    size: SDeckButtonSize.medium,
                    shape: SDeckButtonShape.default_,
                    onPressed: onPrimaryPressed,
                  ),
            ),
          ],
        ),
      );
    } else {
      children.add(
        SizedBox(
          width: double.infinity,
          child:
              primaryAction ??
              SDeckSolidButton(
                text: primaryButtonText,
                size: SDeckButtonSize.medium,
                shape: SDeckButtonShape.default_,
                onPressed: onPrimaryPressed,
                fullWidth: true,
              ),
        ),
      );
    }

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
}

//============================== _DialogHeader ==============================//
class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
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
              child: Center(
                child: SDeckIcons(
                  SDeckIcon.x,
                  size: SDeckSize.size36,
                  color: context.component.dialogIcon,
                  semanticsLabel: 'Close',
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

//============================== _DialogContent =============================//
class _DialogContent extends StatelessWidget {
  const _DialogContent({
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
        child: const DecoratedBox(
          decoration: BoxDecoration(
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

//=========================== _DialogDescription ============================//
class _DialogDescription extends StatelessWidget {
  const _DialogDescription({
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
