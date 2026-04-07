/*----------------------------- sdeck_toast.dart -----------------------------*/
// Inline feedback surface for short messages: variant colors from the component
// color extension, typography from shared tokens. Width caps at the design-system
// toast frame; the parent (e.g. overlay or padded column) controls alignment and
// horizontal inset on real screens.
//
// Usage:
//   SDeckToast(
//     status: SDeckToastStatus.success,
//     title: 'Saved',
//     description: 'Your changes were saved.',
//     onDismiss: () { ... },
//   )
/*----------------------------------------------------------------------------*/

//---------------------------------- Imports ---------------------------------//
import 'package:flutter/material.dart';
import 'toast_enums.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/spacing/index.dart';
import '../../tokens/effects/box_shadows.dart';
import '../../tokens/typography/font_sizes.dart';
import '../../tokens/typography/line_heights.dart';
import '../../tokens/typography/font_weights.dart';

//--------------------------------- SDeckToast -------------------------------//
/// Toast for the SocialDeck design system: title row, caption body, optional dismiss.
///
/// [onDismiss] null keeps the close glyph visible (layout parity with Figma) but
/// non-interactive; pass a callback when the host should remove the toast.
class SDeckToast extends StatelessWidget {
  //------------------------------- Properties --------------------------------//

  
  final SDeckToastStatus status;

  /// Primary line; single line with ellipsis when space is tight.
  final String title;

  /// Supporting copy below the title row.
  final String description;

  /// When set, the trailing close control is tappable and calls this. When null,
  /// the close icon is still shown but does not handle taps.
  final VoidCallback? onDismiss;

  //*************************** Constructor **********************************//
  const SDeckToast({
    super.key,
    required this.status,
    required this.title,
    required this.description,
    this.onDismiss,
  });

  //*************************** Build Method *********************************//
  @override
  Widget build(BuildContext context) {
    //------------------------ Theme & extensions -----------------------------//
    // Theme gives base TextTheme slots we tweak with token sizes/heights.
    // context.component is the design-system color extension (toast surfaces, etc.).
    final theme = Theme.of(context);
    final component = context.component;
    Color surfaceColor;
    Color borderColor;
    Color iconColor;

    //------------------------ Variant colors ---------------------------------//
    // Each status maps to three tokens: fill, outline, and close-glyph color.
    switch (status) {
      case SDeckToastStatus.error:
        surfaceColor = component.toastSurfaceError;
        borderColor = component.toastBorderError;
        iconColor = component.toastIconError;
        break;
      case SDeckToastStatus.success:
        surfaceColor = component.toastSurfaceSuccess;
        borderColor = component.toastBorderSuccess;
        iconColor = component.toastIconSuccess;
        break;
      case SDeckToastStatus.warning:
        surfaceColor = component.toastSurfaceWarning;
        borderColor = component.toastBorderWarning;
        iconColor = component.toastIconWarning;
        break;
      case SDeckToastStatus.info:
        surfaceColor = component.toastSurfaceInfo;
        borderColor = component.toastBorderInfo;
        iconColor = component.toastIconInfo;
        break;
      case SDeckToastStatus.link:
        surfaceColor = component.toastSurfaceLink;
        borderColor = component.toastBorderLink;
        iconColor = component.toastIconLink;
        break;
      case SDeckToastStatus.note:
        surfaceColor = component.toastSurfaceNote;
        borderColor = component.toastBorderNote;
        iconColor = component.toastIconNote;
        break;
    }

    //------------------------ Typography -------------------------------------//
    // Body Large (title) and Caption (description). `height` is line-height ÷ font
    // size so Flutter’s line spacing matches DS line-height tokens.
    final titleStyle = theme.textTheme.titleMedium!.copyWith(
      fontSize: SDeckFontSizes.bodyLarge,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.bodyLarge / SDeckFontSizes.bodyLarge,
      color: component.toastTitleText,
    );
    final descriptionStyle = theme.textTheme.labelLarge!.copyWith(
      fontSize: SDeckFontSizes.caption,
      fontWeight: SDeckFontWeights.medium,
      height: SDeckLineHeights.caption / SDeckFontSizes.caption,
      color: component.toastDescriptionText,
    );

    //------------------------ Close icon widget ------------------------------//
    // Built once so IconButton and the decorative-only path share the same look.
    final closeIcon = Icon(
      Icons.close,
      size: SDeckSize.size24,
      color: iconColor,
    );

    //==========================================================================//
    // WIDGET TREE (outside → inside)
    //
    // 1) ConstrainedBox — never wider than DS toast frame (SDeckSize.toastMaxWidth).
    // 2) Container      — card: padding, background, border, radius, shadow.
    // 3) Column         — vertical stack: [title row] → gap → [description].
    //==========================================================================//
    return ConstrainedBox(
      // Hard cap on width; child still needs a width when parent is wider, so…
      constraints: const BoxConstraints(maxWidth: SDeckSize.toastMaxWidth),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(SDeckSpace.padding16),
        decoration: BoxDecoration(
          // Card chrome: variant surface + matching border, rounded corners, elevation.
          color: surfaceColor,
          border: Border.all(width: SDeckSize.size4, color: borderColor),
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
          boxShadow: SDeckBoxShadows.boxShadow(context.semantic.shadow),
        ),
        child: Column(
          // Left-align all text; only as tall as the two text blocks + gap.
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //-------------------- Section: title row ---------------------------//
            // One horizontal line: title takes remaining width; close sits at end.
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title: Expanded = “use all space before the 24px close slot.”
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle,
                  ),
                ),
                // Close slot: fixed 24×24 so layout stays stable in Figma terms.
                SizedBox(
                  width: SDeckSize.size24,
                  height: SDeckSize.size24,
                  child:
                      onDismiss != null
                          // Tappable: zero padding so hit target matches visual size.
                          ? IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(
                              width: SDeckSize.size24,
                              height: SDeckSize.size24,
                            ),
                            iconSize: SDeckSize.size24,
                            onPressed: onDismiss,
                            icon: closeIcon,
                            tooltip: MaterialLocalizations.of(
                              context,
                            ).closeButtonTooltip,
                          )
                          // Not dismissible: same icon, centered, no gesture.
                          : Center(child: closeIcon),
                ),
              ],
            ),
            //-------------------- Section: description -------------------------//
            // DS vertical gap between title row and body copy.
            SizedBox(height: SDeckSpace.gap4),
            Text(description, style: descriptionStyle),
          ],
        ),
      ),
    );
  }
}
