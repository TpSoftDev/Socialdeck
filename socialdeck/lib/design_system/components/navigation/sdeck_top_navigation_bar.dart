/*---------------------- sdeck_top_navigation_bar.dart ----------------------*/
// Top navigation bar component for the SocialDeck design system
// Provides consistent navigation patterns across onboarding and app screens
// Theme-aware component that matches Figma designs
//
// Usage: SDeckTopNavigationBar.backWithLogo() or with custom back logic
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/index.dart';
import '../../themes/text_theme.dart';
import '../../themes/icon_themes.dart';
import '../icons/sdeck_icon.dart';
import '../buttons/sdeck_solid_button.dart';

//------------------------------- Enums -------------------------------------//
/// Defines the different variants of the top navigation bar
enum SDeckTopNavVariant {
  backWithLogo, // Back arrow + Socialdeck logo (for onboarding)
  logoWithTitle, // Logo + title + action button (for main pages)
  logoWithSkip, // Logo + Skip button (for onboarding flows)
  logoWithoutBack, // Only logo on the right, nothing on the left
  backWithTitle, // Back arrow + title + save button (for main pages)
  backWithTitleAndIcon, // Back arrow + title + simple icon (for settings/options)
  // TODO: add more variants later: logoWithIndicator, backWithTitle, etc.
}

class SDeckTopNavigationBar extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  final SDeckTopNavVariant _variant;
  final VoidCallback? onBackPressed;
  final String? title;
  final VoidCallback? onActionPressed;

  //*************************** Named Constructors ***************************//
  //------------------------------- Back with Logo ------------------------//
  const SDeckTopNavigationBar.backWithLogo({super.key, this.onBackPressed})
    : _variant = SDeckTopNavVariant.backWithLogo,
      title = null,
      onActionPressed = null;

  //------------------------------- Logo with Title -----------------------//
  const SDeckTopNavigationBar.logoWithTitle({
    super.key,
    required this.title,
    this.onActionPressed,
  }) : _variant = SDeckTopNavVariant.logoWithTitle,
       onBackPressed = null;

  //------------------------------- Logo with Skip ------------------------//
  const SDeckTopNavigationBar.logoWithSkip({super.key, this.onActionPressed})
    : _variant = SDeckTopNavVariant.logoWithSkip,
      title = null,
      onBackPressed = null;

  //------------------------------- Logo Without Back ---------------------//
  const SDeckTopNavigationBar.logoWithoutBack({super.key})
    : _variant = SDeckTopNavVariant.logoWithoutBack,
      title = null,
      onBackPressed = null,
      onActionPressed = null;

  //------------------------------- Back with Title -----------------------//
  const SDeckTopNavigationBar.backWithTitle({
    super.key,
    required this.title,
    this.onActionPressed,
    this.onBackPressed,
  }) : _variant = SDeckTopNavVariant.backWithTitle;

  //------------------------------- Back with Title and Icon --------------//
  const SDeckTopNavigationBar.backWithTitleAndIcon({
    super.key,
    required this.title,
    this.onActionPressed,
    this.onBackPressed,
  }) : _variant = SDeckTopNavVariant.backWithTitleAndIcon;

  //*************************** Build Method ********************************//

  @override
  Widget build(BuildContext context) {
    return Container(
      // Exact Figma measurements: 0px left, 16px right, 16px top, 8px bottom
      padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),

      child: Row(
        // Space between left and right sections (creates the gap we see in Figma)
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Center align vertically for consistent icon/logo alignment
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [_buildLeftSection(context), _buildRightSection(context)],
      ),
    );
  }

  //*************************** Helper Methods ********************************//

  //------------------------------- Left Section ---------------------------//
  /// Builds the left section of the navigation bar based on variant
  Widget _buildLeftSection(BuildContext context) {
    switch (_variant) {
      case SDeckTopNavVariant.backWithLogo:
        return _buildBackButton(context);
      case SDeckTopNavVariant.logoWithTitle:
        return _buildLogoWithTitle(context);
      case SDeckTopNavVariant.logoWithSkip:
        return _buildLogo(context);
      case SDeckTopNavVariant.logoWithoutBack:
        return const SizedBox(width: 48); // Empty space for alignment
      case SDeckTopNavVariant.backWithTitle:
        return _buildBackWithTitle(context);
      case SDeckTopNavVariant.backWithTitleAndIcon:
        return _buildBackWithTitle(context);
    }
  }

  //------------------------------- Right Section --------------------------//
  /// Builds the right section of the navigation bar based on variant
  Widget _buildRightSection(BuildContext context) {
    switch (_variant) {
      case SDeckTopNavVariant.backWithLogo:
        return _buildLogo(context);
      case SDeckTopNavVariant.logoWithTitle:
        return _buildActionButton(context);
      case SDeckTopNavVariant.logoWithSkip:
        return _buildSkipButton(context);
      case SDeckTopNavVariant.logoWithoutBack:
        return _buildLogo(context);
      case SDeckTopNavVariant.backWithTitle:
        return _buildSaveButton(context);
      case SDeckTopNavVariant.backWithTitleAndIcon:
        return _buildActionButton(context);
    }
  }

  //------------------------------- Back with Title --------------------------//
  /// Builds the back button with title layout (matching Figma design)
  Widget _buildBackWithTitle(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          _buildBackButton(context),
          const SizedBox(width: SDeckSpace.gapXXS), // 4px gap to match Figma
          // Flexible title that takes available space but doesn't overflow
          Flexible(
            child: Text(
              title!,
              style: Theme.of(context).textTheme.h5,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  //------------------------------- Back Button ----------------------------//
  /// Builds the back button with proper touch target and ripple effect
  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      // Automatic back navigation if no custom callback provided
      onTap: onBackPressed ?? () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadiusS),
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.centerLeft,
        child: SDeckIcon.extraLarge(context.icons.leftChevron),
      ),
    );
  }

  //------------------------------- Logo -----------------------------------//
  /// Builds the Socialdeck logo
  Widget _buildLogo(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      child: SDeckIcon.extraLarge(context.icons.socialdeckLogo),
    );
  }

  //------------------------------- Logo with Title --------------------------//
  /// Builds the logo with title layout
  Widget _buildLogoWithTitle(BuildContext context) {
    return Row(
      children: [
        SDeckIcon.extraLarge(context.icons.socialdeckLogo),
        const SizedBox(width: SDeckSpace.gapXS), // Using design system token
        Text(title!, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }

  //------------------------------- Action Button ----------------------------//
  /// Builds the action button (placeholder circle from Figma)
  Widget _buildActionButton(BuildContext context) {
    return InkWell(
      onTap: onActionPressed,
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadiusS),
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        // Using placeholder icon that exists in your system
        child: SDeckIcon.extraLarge(context.icons.placeholder),
      ),
    );
  }

  //------------------------------- Save Button ------------------------------//
  /// Builds the save button for Add Cards page
  Widget _buildSaveButton(BuildContext context) {
    return SDeckSolidButton.mediumRound(
      text: "Save",
      onPressed: onActionPressed,
      enabled: onActionPressed != null,
    );
  }

  //------------------------------- Skip Button ----------------------------//
  /// Builds the skip button with right arrow (matching Figma design)
  Widget _buildSkipButton(BuildContext context) {
    return InkWell(
      onTap: onActionPressed,
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadiusS),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(
          horizontal: SDeckSpace.paddingS,
        ), // Using design system token
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Skip', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(
              width: SDeckSpace.gapXXS,
            ), // Using design system token
            SDeckIcon.small(context.icons.rightChevron),
          ],
        ),
      ),
    );
  }
}
