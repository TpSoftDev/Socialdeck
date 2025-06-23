import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class OnboardingInfoTemplate extends StatelessWidget {
  //*************************** Core Parameters ***********************************//
  // What every info screen needs to display

  final String title; // "Verify Account" vs "Redirecting..."

  //*************************** Optional Content Parameters *******************//
  // For screens that need explanatory text and highlighted information
  // When these are null, the screen shows minimal content (like redirecting)

  final String? bodyText; // Main explanation text - null for minimal screens
  final String?
  highlightedText; // Text to show in accent color (like email) - null if not needed
  final TextStyle?
  highlightedTextStyle; // Custom style for highlighted text - defaults to theme

  //*************************** Optional Action Parameters ********************//
  // For screens that need user actions (buttons)
  // When these are null, no action buttons are shown (like redirecting)

  final String?
  primaryButtonText; // "Send Verification" - null if no primary action
  final VoidCallback?
  onPrimaryPressed; // Callback for primary button - null if no primary action
  final String?
  secondaryActionText; // "Change Email Address" - null if no secondary action
  final VoidCallback?
  onSecondaryPressed; // Callback for secondary action - null if no secondary action

  //*************************** Navigation Parameters *************************//
  // Control the top navigation behavior

  final bool showBackButton; // Whether to show back arrow

  //*************************** Loading State Parameters **********************//
  // For screens that show loading/processing state

  final bool
  showLoadingIndicator; // Show spinner/loading state - true for redirecting

  //*************************** Constructor ***********************************//
  const OnboardingInfoTemplate({
    required this.title,
    // Optional content (for verify account type screens)
    this.bodyText,
    this.highlightedText,
    this.highlightedTextStyle,

    // Optional actions (for interactive screens)
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryActionText,
    this.onSecondaryPressed,

    // Navigation control
    this.showBackButton = false, // Default: no back button
    // Loading state
    this.showLoadingIndicator = false, // Default: no loading indicator
    super.key,
  });

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //------------------------ Top Navigation ------------------------//
              _buildNavigation(context),

              //------------------------ Main Content --------------------------//
              _buildMainContent(context),
            ],
          ),
        ),
      ),
    );
  }

  //**************************** Helper Methods ********************************//
  Widget _buildNavigation(BuildContext context) {
    // Navigation based on showBackButton parameter
    // Info screens (verify, redirecting) don't have back buttons per Figma
    if (showBackButton) {
      return SDeckTopNavigationBar.backWithLogo();
    } else {
      // Just logo, no back button (matches verify account and redirecting screens)
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SDeckIcon(context.icons.socialdeckLogo, width: 48, height: 48),
          ],
        ),
      );
    }
  }

  //**************************** Main Content ********************************//
  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //------------------------ Title ----------------------------------//
          Text(title, style: Theme.of(context).textTheme.h4),
          SizedBox(height: 16.0),

          //------------------------ Optional Body Content -------------------//
          // Only show if bodyText is provided (verify account has this, redirecting doesn't)
          if (bodyText != null) ...[
            Text(bodyText!, style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 16.0),
          ],

          //------------------------ Optional Highlighted Text ----------------//
          // For displaying email addresses or other emphasized information
          if (highlightedText != null) ...[
            Text(highlightedText!, style: highlightedTextStyle),
            SizedBox(height: 16.0), // Extra spacing before buttons
          ],

          //----------------------- Spacer for Button Positioning -------------//
          // Push buttons toward bottom of screen, with optional centered loading indicator
          if (showLoadingIndicator)
            // For loading screens - center the spinner in the middle area
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          else
            // For regular screens - use flexible spacing that accommodates secondary button
            SizedBox(height: MediaQuery.of(context).size.height * 0.4),

          //------------------------ Optional Primary Action ----------------//
          // Main action button (like "Send Verification")
          if (primaryButtonText != null && onPrimaryPressed != null) ...[
            SDeckSolidButton.large(
              text: primaryButtonText!,
              fullWidth: true,
              enabled: true,
              onPressed: onPrimaryPressed!,
            ),
            SizedBox(height: 8.0),
          ],

          //------------------------ Optional Secondary Action ---------------//
          // Secondary action (like "Change Email Address")
          if (secondaryActionText != null && onSecondaryPressed != null) ...[
            Center(
              child: TextButton(
                onPressed: onSecondaryPressed!,
                child: Text(
                  secondaryActionText!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
