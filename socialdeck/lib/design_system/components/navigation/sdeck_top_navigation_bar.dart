/*---------------------- sdeck_top_navigation_bar.dart ----------------------*/
// Top navigation bar component for the SocialDeck design system
// Provides consistent navigation patterns across onboarding and app screens
// Theme-aware component that matches Figma designs
//
// Usage: SDeckTopNavigationBar.backWithLogo() or with custom back logic
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../foundations/index.dart';
import '../icons/sdeck_icon.dart';

//------------------------------- Enums -------------------------------------//
/// Defines the different variants of the top navigation bar
enum SDeckTopNavVariant {
  backWithLogo, // Back arrow + Socialdeck logo (for onboarding)
  logoWithTitle, // Logo + title + action button (for main pages)
  logoWithSkip, // Logo + Skip button (for onboarding flows)
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

  //*************************** Build Method ********************************//

  @override
  Widget build(BuildContext context) {
    return Container(
      // Exact Figma measurements: 16px horizontal, 16px top, 8px bottom
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),

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
      // Future variants will have different left sections
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
      // Future variants will have different right sections
    }
  }

  //------------------------------- Back Button ----------------------------//
  /// Builds the back button with proper touch target and ripple effect
  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      // Automatic back navigation if no custom callback provided
      onTap: onBackPressed ?? () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(SDeckRadius.s),
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: SDeckIcon.extraLarge(context.icons.leftArrow),
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
        const SizedBox(width: 8),
        Text(title!, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }

  //------------------------------- Action Button ----------------------------//
  /// Builds the action button (placeholder circle from Figma)
  Widget _buildActionButton(BuildContext context) {
    return InkWell(
      onTap: onActionPressed,
      borderRadius: BorderRadius.circular(SDeckRadius.s),
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        // Using placeholder icon that exists in your system
        child: SDeckIcon.extraLarge(context.icons.placeholder),
      ),
    );
  }

  //------------------------------- Skip Button ----------------------------//
  /// Builds the skip button with right arrow (matching Figma design)
  Widget _buildSkipButton(BuildContext context) {
    return InkWell(
      onTap: onActionPressed,
      borderRadius: BorderRadius.circular(SDeckRadius.s),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Skip', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(width: 4),
            SDeckIcon.small(context.icons.rightArrow),
          ],
        ),
      ),
    );
  }
}
