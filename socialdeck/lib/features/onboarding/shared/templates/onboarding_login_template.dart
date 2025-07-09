/*-------------------- onboarding_login_template.dart -----------------------*/
// Login Template for Social Deck onboarding flow
// Handles both confirmation screens ("Is this your card?") and password input screens
// Provides consistent layout with tilted card context throughout login flow
//
// Usage Examples:
// Confirmation: OnboardingLoginTemplate(showConfirmationButtons: true, ...)
// Password: OnboardingLoginTemplate(showPasswordField: true, ...)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/design_system/components/messages/sdeck_message_card.dart';
import '../../../login/presentation/widgets/account_description_widget.dart';

class OnboardingLoginTemplate extends StatelessWidget {
  //*************************** Core Parameters ***********************************//
  /// Main title - always "Log In" for login flow
  final String title;

  /// Screen-specific subtitle - "Is this your card?" vs "Enter your password"
  final String subtitle;

  //*************************** User Context Parameters ***********************//
  /// Username to display next to the tilted card
  final String username;

  /// Optional image path for the playing card
  /// If null, shows checkered background placeholder
  final String? imagePath;

  /// Optional transformation values for the card image
  final double scale;
  final double panX;
  final double panY;

  //*************************** Confirmation Mode Parameters ******************//
  /// Whether to show confirmation buttons ("Yes, that's me!" + "No, go back")
  final bool showConfirmationButtons;

  /// Primary confirmation button text (default: "Yes, that's me!")
  final String? primaryButtonText;

  /// Secondary confirmation button text (default: "No, go back")
  final String? secondaryButtonText;

  /// Callback for primary confirmation button
  final VoidCallback? onPrimaryPressed;

  /// Callback for secondary confirmation button
  final VoidCallback? onSecondaryPressed;

  //*************************** Password Mode Parameters **********************//
  /// Whether to show password input field
  final bool showPasswordField;

  /// Current password field value
  final String? passwordValue;

  /// Callback when password text changes
  final Function(String)? onPasswordChanged;

  /// Visual state of password field (hint, filled, error)
  final SDeckTextFieldState? passwordFieldState;

  //*************************** Next Button Parameters ************************//
  /// Whether to show Next button (for password screens)
  final bool showNextButton;

  /// Whether Next button should be enabled
  final bool isNextEnabled;

  /// Callback for Next button
  final VoidCallback? onNextPressed;

  /// Optional error message to display below the password field
  final String? errorMessage;

  //*************************** Navigation Parameters ************************//
  /// Optional callback for custom back button behavior
  /// If null, uses default Navigator.pop(context) behavior
  final VoidCallback? onBackPressed;

  //*************************** Password Toggle Parameters ********************//
  /// Whether to obscure the password field (hide text)
  final bool? obscurePassword;

  /// Whether to show the password visibility toggle (eye icon)
  final bool showPasswordToggle;

  /// Callback for toggling password visibility
  final VoidCallback? onPasswordToggle;

  //*************************** Constructor ***********************************//
  const OnboardingLoginTemplate({
    super.key,
    required this.title,
    required this.subtitle,
    required this.username,
    this.imagePath,
    this.scale = 1.0,
    this.panX = 0.0,
    this.panY = 0.0,

    // Confirmation mode parameters
    this.showConfirmationButtons = false,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,

    // Password mode parameters
    this.showPasswordField = false,
    this.passwordValue,
    this.onPasswordChanged,
    this.passwordFieldState,

    // Next button parameters
    this.showNextButton = false,
    this.isNextEnabled = false,
    this.onNextPressed,
    this.errorMessage,

    // Navigation parameters
    this.onBackPressed,

    // Password toggle parameters
    this.obscurePassword,
    this.showPasswordToggle = false,
    this.onPasswordToggle,
  });

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Allow scaffold to resize when keyboard appears
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            _buildNavigation(),

            //------------------------ Scrollable Content Area ---------------//
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: SDeckSpacing.x16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //------------------------ Title Section -----------------//
                    _buildTitleSection(context),

                    //------------------------ Card and Actions Area ---------//
                    SizedBox(height: SDeckSpacing.x16), // Space after title
                    Center(child: _buildUserCardSection(context)),

                    //------------------------ Dynamic Content Area ----------//
                    _buildDynamicContent(context),

                    //------------------------ Actions (16px below card) -----//
                    SizedBox(height: SDeckSpacing.x16), // 16px spacing
                    _buildBottomActions(context),

                    //------------------------ Bottom Padding for keyboard ---//
                    SizedBox(
                      height:
                          MediaQuery.of(context).viewInsets.bottom,
                    ), // Dynamic space for keyboard
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

  /// Builds the top navigation with back button and logo
  Widget _buildNavigation() {
    return SDeckTopNavigationBar.backWithLogo(onBackPressed: onBackPressed);
  }

  /// Builds the title and subtitle section
  Widget _buildTitleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.h4),
        SizedBox(height: SDeckSpacing.x16),
        Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  /// Builds the user card context (tilted card + username)
  /// This appears on ALL login screens for context consistency
  Widget _buildUserCardSection(BuildContext context) {
    return AccountDescriptionWidget(
      username: username,
      imagePath: imagePath,
      scale: scale,
      panX: panX,
      panY: panY,
    );
  }

  /// Builds dynamic content based on screen mode (password field or empty)
  Widget _buildDynamicContent(BuildContext context) {
    if (showPasswordField) {
      return _buildPasswordSection(context);
    }
    // For confirmation screens, no additional content needed
    return Container();
  }

  /// Builds the password input section with optional error message
  Widget _buildPasswordSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //------------------------ Spacing above password field ---------//
        SizedBox(height: SDeckSpacing.x16),

        //------------------------ Password Field Label -----------------//
        Text("Password", style: Theme.of(context).textTheme.bodySmall),
        SizedBox(height: SDeckSpacing.x8),

        //------------------------ Password Input Field -----------------//
        SDeckTextField.large(
          placeholder: "Enter a password",
          keyboardType: TextInputType.visiblePassword,
          onChanged: onPasswordChanged,
          obscureText: obscurePassword ?? true,
          state: passwordFieldState ?? SDeckTextFieldState.hint,
          showPasswordToggle: showPasswordToggle,
          onPasswordToggle: onPasswordToggle,
        ),

        // Show error message card if errorMessage is not null
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: SDeckMessageCard.error(text: errorMessage!),
            ),
          ),
      ],
    );
  }

  /// Builds action buttons based on screen mode
  Widget _buildBottomActions(BuildContext context) {
    return Column(
      children: [
        //------------------------ Confirmation Buttons -----------------//
        if (showConfirmationButtons) ...[
          SDeckSolidButton.large(
            text: primaryButtonText ?? "Yes, that's me!",
            fullWidth: true,
            onPressed: onPrimaryPressed,
          ),
          SizedBox(height: SDeckSpacing.x8),
          SDeckHollowButton.large(
            text: secondaryButtonText ?? "No, go back",
            fullWidth: true,
            onPressed: onSecondaryPressed,
          ),
        ],

        //------------------------ Next Button (Password Mode) -----------//
        if (showNextButton) ...[
          SDeckSolidButton.large(
            text: "Next",
            fullWidth: true,
            enabled: isNextEnabled,
            onPressed: onNextPressed,
          ),
        ],
      ],
    );
  }
}
