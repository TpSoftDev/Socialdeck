/*-------------------------- sdeck_basic_target.dart --------------------------*/
// A card that surfaces an actionable notification or invite to the user.
// The cardType controls the layout — button, dismissible, time-stamped, or empty.
// The state controls the background color tint for time-stamped cards.
//
// Usage:
//   SDeckBasicTarget(
//     title: 'Play Party',
//     description: 'Start a new session',
//     cardType: SDeckBasicTargetCardType.button,
//     buttonLabel: 'Join',
//     onButtonPressed: () {},
//   )
//
//   SDeckBasicTarget(
//     title: 'Party invite',
//     description: 'John wants to play',
//     cardType: SDeckBasicTargetCardType.time,
//     state: SDeckBasicTargetState.info,
//     timestamp: '2m',
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../helpers/index.dart';
import '../../themes/text_theme.dart';
import '../placeholders/sdeck_visual_placeholder.dart';
import 'basic_target_enums.dart';

class SDeckBasicTarget extends StatelessWidget {
  //------------------------------- Properties ---------------------------------//

  final SDeckBasicTargetCardType cardType;

  /// Only meaningful when cardType is time. Controls the background tint.
  final SDeckBasicTargetState state;

  final String? title;
  final String description;

  /// Only shown when cardType is time.
  final String? timestamp;

  /// Label on the action button. Applies to button and buttonOrNot card types.
  final String buttonLabel;

  /// Only relevant for buttonOrNot — hides the button when false, leaving just the dismiss icon.
  final bool showButton;

  /// Only relevant for time — hides the visual media placeholder when false.
  final bool showVisual;

  final VoidCallback? onTap;
  final VoidCallback? onButtonPressed;

  /// Called when the user taps the dismiss X icon. buttonOrNot card type only.
  final VoidCallback? onDismiss;

  //*************************** Constructor **********************************//
  const SDeckBasicTarget({
    super.key,
    this.cardType = SDeckBasicTargetCardType.time,
    this.state = SDeckBasicTargetState.defaultState,
    this.title,
    required this.description,
    this.timestamp,
    this.buttonLabel = 'Button',
    this.showButton = true,
    this.showVisual = true,
    this.onTap,
    this.onButtonPressed,
    this.onDismiss,
  });

  //*************************** Build ****************************************//
  @override
  Widget build(BuildContext context) {
    if (state == SDeckBasicTargetState.empty &&
        cardType == SDeckBasicTargetCardType.empty) {
      return _buildEmpty(context);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: _resolveBackground(context),
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
          border: Border.all(
            color: context.component.selectionTargetBorder,
            width: SDeckSize.size4,
          ),
        ),
        child: switch (cardType) {
          SDeckBasicTargetCardType.button => _buildButton(context),
          SDeckBasicTargetCardType.buttonOrNot => _buildButtonOrNot(context),
          SDeckBasicTargetCardType.time => _buildTime(context),
          SDeckBasicTargetCardType.empty => _buildEmpty(context),
        },
      ),
    );
  }

  //*************************** Helpers **************************************//
  Color _resolveBackground(BuildContext context) {
    return switch (state) {
      SDeckBasicTargetState.note => context.component.selectionTargetSurfaceNote,
      SDeckBasicTargetState.info => context.component.selectionTargetSurfaceInfo,
      SDeckBasicTargetState.warning => context.component.selectionTargetSurfaceWarning,
      SDeckBasicTargetState.link => context.component.selectionTargetSurfaceLink,
      SDeckBasicTargetState.success => context.component.selectionTargetSurfaceSuccess,
      SDeckBasicTargetState.error => context.component.selectionTargetSurfaceError,
      _ => context.component.selectionTargetSurface,
    };
  }

  //*************************** Layout builders ******************************//
  Widget _buildEmpty(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 78,
      decoration: BoxDecoration(
        color: context.component.selectionTargetSurface,
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
      ),
      alignment: Alignment.center,
      child: Text(
        description,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: context.component.selectionTargetEmptyText,
            ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SDeckSpace.padding16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _buildTextColumn(context)),
          const SizedBox(width: SDeckSpace.gap8),
          _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildButtonOrNot(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SDeckSpace.padding16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _buildTextColumn(context)),
          const SizedBox(width: SDeckSpace.gap8),
          GestureDetector(
            onTap: onDismiss,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: SDeckIcons(
                  SDeckIcon.x,
                  size: SDeckSize.size24,
                  color: context.semantic.error,
                ),
              ),
            ),
          ),
          if (showButton) ...[
            const SizedBox(width: SDeckSpace.gap4),
            _buildOutlineButton(context),
          ],
        ],
      ),
    );
  }

  // The visual placeholder overlaps the text from the right (Stack-based layout).
  // The text takes the full card width with p-16; the visual floats on top of it,
  // anchored to the right edge and clipped by the parent Container's Clip.antiAlias.
  // The 3.85px translate lets the visual bleed just past the border (matching Figma).
  // The 48px right-padding inside the visual area preserves space near the border.
  Widget _buildTime(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        //---------------------- Text (full card width) ----------------------//
        Padding(
          padding: const EdgeInsets.all(SDeckSpace.padding16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 78),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: context.component.selectionTargetTitleText,
                            ),
                      ),
                    ),
                    if (timestamp != null) ...[
                      const SizedBox(width: SDeckSpace.gap8),
                      Text(
                        timestamp!,
                        style: Theme.of(context).textTheme.footer.copyWith(
                              color: context.component.selectionTargetTimestamp,
                            ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: SDeckSpace.gap4),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: context.component.selectionTargetDescriptionText,
                      ),
                ),
              ],
            ),
          ),
        ),

        //------------- Visual (overlaid on the right, absolutely placed) ---//
        if (showVisual)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Transform.translate(
                offset: const Offset(3.85, 0),
                child: Padding(
                  padding: const EdgeInsets.only(right: SDeckSpace.padding48),
                  child: SizedBox(
                    height: 78,
                    child: AspectRatio(
                      aspectRatio: 185 / 92,
                      child: SDeckVisualPlaceholder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTextColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.component.selectionTargetTitleText,
              ),
        ),
        const SizedBox(height: SDeckSpace.gap4),
        Text(
          description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.caption.copyWith(
                color: context.component.selectionTargetDescriptionText,
              ),
        ),
      ],
    );
  }

  // Solid button — used by the button card type (e.g. "Join").
  // Built manually so the card controls its own tap area without nested gesture conflicts.
  Widget _buildActionButton(BuildContext context) {
    return GestureDetector(
      onTap: onButtonPressed,
      child: Container(
        constraints: const BoxConstraints(minWidth: 80),
        padding: const EdgeInsets.symmetric(
          horizontal: SDeckSpace.padding16,
          vertical: SDeckSpace.padding12,
        ),
        decoration: BoxDecoration(
          color: context.component.solidButtonPrimarySurface,
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24),
          border: Border.all(
            color: context.component.solidButtonBorder,
            width: SDeckSize.size4,
          ),
        ),
        child: Text(
          buttonLabel,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.component.solidButtonText,
              ),
        ),
      ),
    );
  }

  // Outline button — used by the buttonOrNot card type (e.g. "Accept").
  // Border only, no fill background.
  Widget _buildOutlineButton(BuildContext context) {
    return GestureDetector(
      onTap: onButtonPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SDeckSpace.padding16,
          vertical: SDeckSpace.padding12,
        ),
        decoration: BoxDecoration(
          color: context.component.outlineButtonPrimarySurface,
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24),
          border: Border.all(
            color: context.component.outlineButtonBorder,
            width: SDeckSize.size4,
          ),
        ),
        child: Text(
          buttonLabel,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.component.outlineButtonText,
              ),
        ),
      ),
    );
  }
}
