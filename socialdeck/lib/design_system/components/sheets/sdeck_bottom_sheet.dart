/*--------------------------- sdeck_bottom_sheet.dart --------------------------*/
// Bottom sheet component for the SocialDeck design system
// Generic container that can hold any child content with consistent header styling
// Theme-aware component that matches Figma designs exactly
//
// Usage: SDeckBottomSheet(title: "Insert Photo", child: YourContent())
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/spacing/index.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/icons/icons.dart';
import '../icons/sdeck_icon.dart';

//------------------------------- SDeckBottomSheet ---------------------------//
/// Generic bottom sheet component with consistent header styling
/// Accepts any child widget as content for maximum flexibility
/// All visual properties use foundations and tokens for consistency
class SDeckBottomSheet extends StatelessWidget {
  //------------------------------- Properties -----------------------------//

  /// The title text displayed in the header
  final String title;

  /// Callback when the close (X) button is pressed
  final VoidCallback? onClosePressed;

  /// The content widget to display in the sheet body
  /// Can be any widget - buttons, forms, lists, etc.
  final Widget child;

  /// Whether to show the custom home indicator at bottom
  /// Set to false on iOS devices to avoid conflict with system home indicator
  final bool showHomeIndicator;

  //------------------------------- Constructor ----------------------------//
  const SDeckBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.onClosePressed,
    this.showHomeIndicator =
        false, // Default false to avoid iOS system conflict
  });

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    return Container(
      // Match Figma background color exactly
      decoration: BoxDecoration(
        color: context.semantic.surface, // #fdfbf5
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SDeckRadius.borderRadius16), // 16px
          topRight: Radius.circular(SDeckRadius.borderRadius16), // 16px
        ),
        // Figma shadow: 0px 0px 4px 0px #1f1f1f
        boxShadow: [
          BoxShadow(
            color: context.semantic.primary.withValues(alpha: 0.25),
            blurRadius: 4.0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: SafeArea(
        // Only apply SafeArea to bottom to avoid iOS home indicator clash
        top: false, // Don't affect top (status bar handled by parent)
        bottom: true, // Prevent clash with home indicator
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //------------------------ Header Section -------------------------//
            _buildHeader(context),

            //------------------------ Content Section ------------------------//
            _buildContent(),

            //------------------------ Optional Home Indicator ---------------//
            if (showHomeIndicator) _buildHomeIndicator(context),
          ],
        ),
      ),
    );
  }

  //*************************** Helper Methods ********************************//

  //------------------------------- Header ----------------------------------//
  /// Builds the header with title and close button matching Figma exactly
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        SDeckSpace.padding16, // 16px left
        SDeckSpace.padding16, // 16px top
        SDeckSpace.padding16, // 16px right
        SDeckSpace
            .paddingZero, // 0px bottom (content will have its own padding)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //------------------------ Title Text ---------------------------//
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontSize: 24, // H6 from Figma: 24px
              fontWeight: FontWeight.w600,
              height: 36 / 24, // Line height 36px / font size 24px
              color: context.component.dialogTitleText,
            ),
          ),

          //------------------------ Close Button -------------------------//
          _buildCloseButton(context),
        ],
      ),
    );
  }

  //------------------------------- Close Button ---------------------------//
  /// Builds the X close button with proper touch target
  Widget _buildCloseButton(BuildContext context) {
    return InkWell(
      onTap: onClosePressed ?? () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24), // 24px
      child: Container(
        width: SDeckSize.size48, // 48px touch target (hardcoded for now, verify in Figma)
        height: SDeckSize.size48, // 48px touch target (hardcoded for now, verify in Figma)
        alignment: Alignment.center,
        child: SDeckIcon.small(
          SDeckIcons.x, // X close icon
          color: context.component.dialogIcon,
        ),
      ),
    );
  }

  //------------------------------- Content ---------------------------------//
  /// Builds the content area with proper padding
  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        SDeckSpace.padding16, // 16px left
        SDeckSpace.padding16, // 16px top (gap from header)
        SDeckSpace.padding16, // 16px right
        SDeckSpace.padding16, // 16px bottom (before home indicator)
      ),
      child: child,
    );
  }

  //------------------------------- Home Indicator -------------------------//
  /// Builds the iOS-style home indicator at bottom
  Widget _buildHomeIndicator(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SDeckSpace.padding8), // 8px from bottom
      child: Center(
        child: Container(
          width: 144, // 36 * 4 = 144px (Figma shows w-36 which is 144px)
          height: 5,
          decoration: BoxDecoration(
            color: context.semantic.primary, // #1f1f1f
            borderRadius: BorderRadius.circular(100), // Fully rounded
          ),
        ),
      ),
    );
  }
}
