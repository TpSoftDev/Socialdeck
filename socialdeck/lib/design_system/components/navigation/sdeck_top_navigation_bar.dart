/*---------------------- sdeck_top_navigation_bar.dart ----------------------*/
// Top navigation bar component for the SocialDeck design system
// Provides consistent navigation patterns across onboarding and app screens
// Theme-aware component that matches Figma designs exactly
//
// Usage: SDeckTopNavigationBar.backWithLogo() or with custom back logic
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../foundations/index.dart';
import '../icons/index.dart';

//------------------------------- Enums -------------------------------------//
/// Defines the different variants of the top navigation bar
enum SDeckTopNavVariant {
  backWithLogo, // Back arrow + Socialdeck logo (for onboarding)
  logoWithTitle, // Logo + title + action button (for main pages)
  // TODO: add more variants later: logoWithIndicator, backWithTitle, etc.
}

//------------------------- SDeckTopNavigationBar ---------------------------//
/// Top navigation bar component for the SocialDeck design system
/// Provides consistent navigation patterns with exact Figma measurements
/// All visual properties use foundations and tokens for theme consistency

class SDeckTopNavigationBar extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  final SDeckTopNavVariant _variant;
  final VoidCallback? onBackPressed;
  final String? title; 
  final VoidCallback? onActionPressed; 

  //------------------------------- Private Constructor -------------------//
  const SDeckTopNavigationBar._({
    super.key,
    required SDeckTopNavVariant variant,
    this.onBackPressed,
    this.title,
    this.onActionPressed,
  }) : _variant = variant;

  //*************************** Named Constructors ***************************//

  //------------------------------- Back with Logo ------------------------//
  /// Creates a navigation bar with back arrow and logo
  /// Perfect for onboarding flows and simple navigation
  const SDeckTopNavigationBar.backWithLogo({super.key, this.onBackPressed})
    : _variant = SDeckTopNavVariant.backWithLogo,
      title = null,
      onActionPressed = null;

  //------------------------------- Logo with Title -----------------------//
  /// Creates a navigation bar with logo, title, and action button
  /// Perfect for main app pages with page titles
  const SDeckTopNavigationBar.logoWithTitle({
    super.key,
    required this.title,
    this.onActionPressed,
  }) : _variant = SDeckTopNavVariant.logoWithTitle,
       onBackPressed = null;

  //*************************** Build Method ******************************//

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
      // Future variants will have different right sections
    }
  }

  //------------------------------- Back Button ----------------------------//
  /// Builds the back button with proper touch target and ripple effect
  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      // Automatic back navigation if no custom callback provided
      onTap: onBackPressed ?? () => Navigator.pop(context),
      // Rounded ripple effect that matches icon bounds
      borderRadius: BorderRadius.circular(24),
      child: Container(
        // 48px touch target (from Figma icon sizing)
        width: 48,
        height: 48,
        alignment: Alignment.center,
        // Much cleaner icon access!
        child: SDeckIcon.extraLarge(context.icons.leftArrow),
      ),
    );
  }

  //------------------------------- Logo -----------------------------------//
  /// Builds the Socialdeck logo
  Widget _buildLogo(BuildContext context) {
    return Container(
      // 48px sizing to match back button
      width: 48,
      height: 48,
      alignment: Alignment.center,
      // Much cleaner icon access!
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
        Text(
          title!,
          style:
              Theme.of(
                context,
              ).textTheme.headlineSmall, // H6 = headlineSmall in Flutter
        ),
      ],
    );
  }

  //------------------------------- Action Button ----------------------------//
  /// Builds the action button (placeholder circle from Figma)
  Widget _buildActionButton(BuildContext context) {
    return InkWell(
      onTap: onActionPressed,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        // Using placeholder icon that exists in your system
        child: SDeckIcon.extraLarge(context.icons.placeholder),
      ),
    );
  }
}
