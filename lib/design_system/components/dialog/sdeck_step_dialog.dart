/*------------------------ sdeck_step_dialog.dart ---------------------------*/
// Step dialog for the SocialDeck design system.
// Figma: Socialdeck — Design System → stepDialog (node 6275:669).
// Structure: title + optional close, square visual placeholder, progress status,
// dual actions (outline + solid) or single primary.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../themes/text_theme.dart';
import '../../tokens/index.dart';
import '../buttons/button_enums.dart';
import '../buttons/sdeck_outline_button.dart';
import '../buttons/sdeck_solid_button.dart';

//============================= SDeckStepDialog =============================//
class SDeckStepDialog extends StatelessWidget {
  const SDeckStepDialog({
    super.key,
    required this.title,
    this.currentStep = 0,
    this.totalSteps = 1,
    this.primaryButtonText = 'Button',
    this.onPrimaryPressed,
    this.secondaryButtonText = 'Button',
    this.onSecondaryPressed,
    this.onClose,
    this.showClose = true,
    this.showProgressStatus = true,
    this.showFraction = true,
    this.showVisualPlaceholder = true,
    this.content,
    this.contentHeight = 277.5,
    this.dialogWidth = 325.5,
    this.primaryAction,
    this.secondaryAction,
    this.progressStatus,
    this.progressTrack,
    this.fraction,
  }) : assert(totalSteps > 0, 'totalSteps must be greater than 0');

  final String title;
  final int currentStep;
  final int totalSteps;

  final String primaryButtonText;
  final String? secondaryButtonText;

  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final VoidCallback? onClose;
  final bool showClose;
  final bool showProgressStatus;
  final bool showFraction;

  /// When true, shows the visual block (square placeholder or [content]).
  final bool showVisualPlaceholder;

  final double dialogWidth;

  /// Optional custom content. When non-null, laid out in a fixed-height box
  /// ([contentHeight]). When null, a square checkered placeholder is shown (Figma 1:1 visual).
  final Widget? content;

  /// Height for [content] when provided. Ignored for the default square placeholder.
  final double contentHeight;

  final Widget? primaryAction;
  final Widget? secondaryAction;
  final Widget? progressStatus;
  final Widget? progressTrack;
  final Widget? fraction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int safeCurrentStep = currentStep.clamp(0, totalSteps);
    final double progressValue = safeCurrentStep / totalSteps;
    final bool hasSecondaryAction =
        secondaryAction != null ||
        ((secondaryButtonText != null && secondaryButtonText!.isNotEmpty) &&
            onSecondaryPressed != null);

    final List<Widget> children = [
      _StepDialogHeader(
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
        _StepDialogContent(
          content: content,
          contentHeight: contentHeight,
        ),
      );
    }

    if (showProgressStatus) {
      children.add(const SizedBox(height: SDeckSpace.gap16));
      children.add(
        progressStatus ??
            _ProgressStatus(
              currentStep: safeCurrentStep,
              totalSteps: totalSteps,
              progressValue: progressValue,
              showFraction: showFraction,
              progressTrack: progressTrack,
              fraction: fraction,
              fractionStyle: theme.textTheme.footer.copyWith(
                color: context.component.textSecondary,
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

//=========================== _StepDialogHeader =============================//
class _StepDialogHeader extends StatelessWidget {
  const _StepDialogHeader({
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

//=========================== _StepDialogContent ============================//
class _StepDialogContent extends StatelessWidget {
  const _StepDialogContent({
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
      child: AspectRatio(
        aspectRatio: 1,
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

//============================= _ProgressStatus =============================//
class _ProgressStatus extends StatelessWidget {
  const _ProgressStatus({
    required this.currentStep,
    required this.totalSteps,
    required this.progressValue,
    required this.showFraction,
    required this.fractionStyle,
    this.progressTrack,
    this.fraction,
  });

  final int currentStep;
  final int totalSteps;
  final double progressValue;
  final bool showFraction;
  final TextStyle fractionStyle;
  final Widget? progressTrack;
  final Widget? fraction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SDeckSize.size16,
      child: Center(
        child: _ProgressBar(
          currentStep: currentStep,
          totalSteps: totalSteps,
          progressValue: progressValue,
          showFraction: showFraction,
          progressTrack: progressTrack,
          fraction: fraction,
          fractionStyle: fractionStyle,
        ),
      ),
    );
  }
}

//============================== _ProgressBar ===============================//
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.currentStep,
    required this.totalSteps,
    required this.progressValue,
    required this.showFraction,
    required this.fractionStyle,
    this.progressTrack,
    this.fraction,
  });

  final int currentStep;
  final int totalSteps;
  final double progressValue;
  final bool showFraction;
  final TextStyle fractionStyle;
  final Widget? progressTrack;
  final Widget? fraction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: progressTrack ?? _ProgressTrack(progressValue: progressValue),
        ),
        if (showFraction) ...[
          const SizedBox(width: SDeckSpace.gap8),
          fraction ??
              Text(
                '$currentStep/$totalSteps',
                style: fractionStyle,
              ),
        ],
      ],
    );
  }
}

//============================= _ProgressTrack ==============================//
class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({required this.progressValue});

  final double progressValue;

  @override
  Widget build(BuildContext context) {
    final double safeProgress = progressValue.clamp(0, 1).toDouble();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double fillWidth = constraints.maxWidth * safeProgress;

        return Container(
          height: SDeckSize.size8,
          decoration: BoxDecoration(
            color: context.component.paginationTrack,
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius4),
          ),
          child: Stack(
            children: [
              Container(
                width: fillWidth,
                decoration: BoxDecoration(
                  color: context.component.paginationFill,
                  borderRadius: BorderRadius.circular(SDeckRadius.borderRadius4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
