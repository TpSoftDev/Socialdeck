/*------------------ sdeck_home_tutorial_step_dialog.dart --------------------*/
// Home tutorial step dialog — short linear flow, no dismiss (X) control.
// Figma: Socialdeck — Home → Step Dialog (node 230:3693).
// Same structure as [SDeckStepDialog] (title, visual, progress, actions) but
// close is omitted so users finish or use Back/Next only.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import 'sdeck_step_dialog.dart';

//======================= SDeckHomeTutorialStepDialog =======================//
/// Tutorial step card for the home flow: title, media block, progress, and
/// [Next] (optionally [Back] + [Next] when [onSecondaryPressed] is set).
///
/// Per design spec there is **no** header close control.
class SDeckHomeTutorialStepDialog extends StatelessWidget {
  const SDeckHomeTutorialStepDialog({
    super.key,
    required this.title,
    this.currentStep = 0,
    this.totalSteps = 1,
    this.primaryButtonText = 'Next',
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
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

  final bool showProgressStatus;
  final bool showFraction;
  final bool showVisualPlaceholder;

  final double dialogWidth;
  final Widget? content;
  final double contentHeight;

  final Widget? primaryAction;
  final Widget? secondaryAction;
  final Widget? progressStatus;
  final Widget? progressTrack;
  final Widget? fraction;

  @override
  Widget build(BuildContext context) {
    return SDeckStepDialog(
      title: title,
      currentStep: currentStep,
      totalSteps: totalSteps,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: onSecondaryPressed,
      showClose: false,
      onClose: null,
      showProgressStatus: showProgressStatus,
      showFraction: showFraction,
      showVisualPlaceholder: showVisualPlaceholder,
      content: content,
      contentHeight: contentHeight,
      dialogWidth: dialogWidth,
      primaryAction: primaryAction,
      secondaryAction: secondaryAction,
      progressStatus: progressStatus,
      progressTrack: progressTrack,
      fraction: fraction,
    );
  }
}
