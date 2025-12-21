/*-------------------- onboarding_profile_card_template.dart -----------------------*/
// Profile Card Onboarding Template for consistent screen structure
// Handles the common layout: header, title, card area, and bottom actions
// Different screens pass in different cards and button configurations
//
// Usage: OnboardingProfileCardTemplate(
//   title: "Profile Card",
//   profileCard: SDeckCreateProfileCard(...),
//   bottomActions: [buttons...],
// )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class OnboardingProfileCardTemplate extends StatelessWidget {
  //*************************** Core Parameters ***********************************//
  /// The main title displayed at the top ("Profile Card" vs "Adjust Photo")
  final String title;

  /// Optional subtitle text shown below the title
  /// Example: "Upload a picture to help others find and identify you."
  final String? subtitle;

  /// The profile card widget to display in the center
  /// Can be SDeckCreateProfileCard, SDeckAdjustProfileCard, or SDeckDisplayProfileCard
  final Widget profileCard;

  /// List of action buttons to show at the bottom of the screen
  /// Different screens have different button combinations
  final List<Widget> bottomActions;

  //*************************** Navigation Parameters *************************//
  /// Callback when user taps "Skip" button in header
  /// Navigates to next onboarding step
  final VoidCallback? onSkip;

  //*************************** Constructor ***********************************//
  const OnboardingProfileCardTemplate({
    super.key,
    required this.title,
    required this.profileCard,
    this.subtitle,
    this.bottomActions = const [],
    this.onSkip,
  });

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Header Navigation ------------------------//
            _buildHeader(context),

            //------------------------ Content Area ------------------------------//
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SDeckSpace.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //------------------------ Title Section ---------------------//
                    _buildTitleSection(context),

                    //------------------------ Card Area -------------------------//
                    SizedBox(height: SDeckSpace.gapM), // Space after title
                    Center(child: profileCard), // Card positioned below title
                    //------------------------ Subtitle Section ------------------//
                    _buildSubtitleSection(context),

                    //------------------------ Flexible Spacer ------------------//
                    Expanded(child: Container()), // Takes remaining space
                    //------------------------ Bottom Actions --------------------//
                    _buildBottomActions(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //*************************** Helper Methods ********************************//
  //
  /// Builds the top navigation header with logo and skip button
  //------- Navigation Bar ---------//
  Widget _buildHeader(BuildContext context) {
    return SDeckTopNavigationBar.logoWithSkip(onActionPressed: onSkip);
  }

  /// Builds the title section (only the title, no subtitle)
  //------- Title Section ---------//
  Widget _buildTitleSection(BuildContext context) {
    return Column(
      children: [Text(title, style: Theme.of(context).textTheme.h4)],
    );
  }

  /// Builds the subtitle section below the card
  //------- Subtitle Section ---------//
  Widget _buildSubtitleSection(BuildContext context) {
    if (subtitle == null) {
      return SizedBox(height: SDeckSpace.gapM); // Just spacing if no subtitle
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: SDeckSpace.gapM), // 16px space after card
        Text(subtitle!, style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Handles variable number of buttons with proper spacing
  //------- Bottom Actions ---------//
  Widget _buildBottomActions(BuildContext context) {
    // If no actions, just add bottom padding
    if (bottomActions.isEmpty) {
      return SizedBox(height: SDeckSpace.gapL);
    }

    return Column(
      children: [
        // Add each action button
        ...bottomActions
            .map(
              (action) => Padding(
                padding: EdgeInsets.only(
                  bottom: SDeckSpace.paddingXS,
                ), // 8px between buttons
                child: action,
              ),
            )
            .toList(),

        SizedBox(height: SDeckSpace.gapL), // Bottom safe area
      ],
    );
  }
}
