/*----------------------------- sdeck_dialog.dart -------------------------*/
// Reusable dialog component for the SocialDeck design system.
// Matches the same design-system philosophy as the input components:
// - token-based spacing
// - theme-aware colors
// - reusable structure
//
// Usage:
//   SDeckDialog(
//     title: 'Wait!',
//     description: 'Are you sure you want to skip decorating your profile card?',
//     preview: Container(...),
//     secondaryButtonText: 'Back',
//     primaryButtonText: 'Skip',
//     onSecondaryPressed: () => Navigator.of(context).pop(false),
//     onPrimaryPressed: () => Navigator.of(context).pop(true),
//   )
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

import 'dialog_enums.dart';

//------------------------------- SDeckDialog -----------------------------//
class SDeckDialog extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  /// Dialog variation
  final SDeckDialogVariant variant;

  /// Main dialog title
  final String title;

  /// Optional short description text
  final String? description;

  /// Optional preview widget displayed below the title
  final Widget? preview;

  /// Optional custom content widget displayed below description
  /// Useful for future input/step variants.
  final Widget? content;

  /// Optional widget displayed between preview/content and actions
  /// Example: progress bar + step counter
  final Widget? footer;

  /// Optional primary button text
  final String? primaryButtonText;

  /// Optional secondary button text
  final String? secondaryButtonText;

  /// Callback for primary action
  final VoidCallback? onPrimaryPressed;

  /// Callback for secondary action
  final VoidCallback? onSecondaryPressed;

  /// Optional close callback for the top-right X icon
  final VoidCallback? onClose;

  /// Whether tapping outside dismisses the dialog.
  /// Controlled by showDialog, but exposed here for semantics/future use.
  final bool barrierDismissible;

  /// Whether to show the close icon
  final bool showCloseButton;

  /// Optional semantic label
  final String? semanticsLabel;

  /// Horizontal inset padding used by Dialog
  final double horizontalInset;

  /// Preview size hint (used only when preview is provided)
  final SDeckDialogPreviewSize previewSize;

  //------------------------------- Constructor ----------------------------//
  const SDeckDialog({
    super.key,
    required this.title,
    this.description,
    this.preview,
    this.content,
    this.footer,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.onClose,
    this.variant = SDeckDialogVariant.standard,
    this.barrierDismissible = true,
    this.showCloseButton = true,
    this.semanticsLabel,
    this.horizontalInset = 32,
    this.previewSize = SDeckDialogPreviewSize.banner,
  });

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      container: true,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: horizontalInset),
        child: Container(
          padding: const EdgeInsets.all(SDeckSpace.padding24),
          decoration: BoxDecoration(
            color: context.semantic.surface,
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //------------------------ Header ------------------------//
              _buildHeader(context),

              //------------------------ Preview -----------------------//
              if (preview != null) ...[
                const SizedBox(height: SDeckSpace.gap16),
                _buildPreviewWrapper(preview!),
              ],

              //------------------------ Description -------------------//
              if (description != null) ...[
                const SizedBox(height: SDeckSpace.gap16),
                _buildDescription(context),
              ],

              //------------------------ Content -----------------------//
              if (content != null) ...[
                const SizedBox(height: SDeckSpace.gap16),
                content!,
              ],

              //------------------------ Footer ------------------------//
              if (footer != null) ...[
                const SizedBox(height: SDeckSpace.gap16),
                footer!,
              ],

              //------------------------ Actions -----------------------//
              if (_hasActions) ...[
                const SizedBox(height: SDeckSpace.gap16),
                _buildActions(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  //*************************** Helpers *************************************//
  bool get _hasActions =>
      primaryButtonText != null || secondaryButtonText != null;

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: context.component.textPrimary,
                ),
          ),
        ),
        if (showCloseButton)
          InkWell(
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
            onTap: onClose ?? () => Navigator.of(context).maybePop(),
            child: Padding(
              padding: const EdgeInsets.all(SDeckSpace.padding4),
              child: Icon(
                Icons.close,
                size: 24,
                color: context.component.iconPrimary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      description!,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.component.textSecondary,
          ),
    );
  }

  Widget _buildPreviewWrapper(Widget child) {
    return SizedBox(
      width: double.infinity,
      child: child,
    );
  }

  Widget _buildActions(BuildContext context) {
    final List<Widget> actions = [];

    if (secondaryButtonText != null) {
      actions.add(
        Expanded(
          child: SDeckOutlineButton(
            text: secondaryButtonText!,
            size: SDeckButtonSize.medium,
            fullWidth: true,
            onPressed: onSecondaryPressed,
          ),
        ),
      );
    }

    if (secondaryButtonText != null && primaryButtonText != null) {
      actions.add(const SizedBox(width: SDeckSpace.gap8));
    }

    if (primaryButtonText != null) {
      actions.add(
        Expanded(
          child: SDeckSolidButton(
            text: primaryButtonText!,
            size: SDeckButtonSize.medium,
            fullWidth: true,
            onPressed: onPrimaryPressed,
          ),
        ),
      );
    }

    return Row(children: actions);
  }
}