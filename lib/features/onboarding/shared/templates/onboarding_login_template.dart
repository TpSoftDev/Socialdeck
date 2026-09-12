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
import '../../../login/presentation/widgets/account_description_widget.dart';

class OnboardingLoginTemplate extends StatefulWidget {
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

  /// Visual state of password field (hint, focused, filled, error, disabled)
  final SDeckInputState? passwordFieldState;

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

  @override
  State<OnboardingLoginTemplate> createState() =>
      _OnboardingLoginTemplateState();
}

class _OnboardingLoginTemplateState extends State<OnboardingLoginTemplate> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// Returns the effective display state for the password field.
  /// Error and disabled always win; hint vs focused chrome comes from [SDeckInput]
  /// when a controller is wired, or from the provider state otherwise.
  SDeckInputState _effectiveState(SDeckInputState providerState) {
    if (providerState == SDeckInputState.error) return SDeckInputState.error;
    if (providerState == SDeckInputState.disabled) return SDeckInputState.disabled;
    return providerState;
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            _buildNavigation(),

            //------------------------ Scrollable Content Area ---------------//
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //------------------------ Title Section -----------------//
                    _buildTitleSection(context),

                    //------------------------ Card and Actions Area ---------//
                    SizedBox(height: SDeckSpace.gap16),
                    Center(child: _buildUserCardSection(context)),

                    //------------------------ Dynamic Content Area ----------//
                    _buildDynamicContent(context),

                    //------------------------ Actions -----------------------//
                    SizedBox(height: SDeckSpace.gap16),
                    _buildBottomActions(context),

                    //------------------------ Bottom Padding for keyboard ---//
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    ),
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

  Widget _buildNavigation() {
    return SDeckTopNavigationBar(
      left: SDeckTopBarLeft.back,
      right: SDeckTopBarRight.logo,
      onLeftPressed: widget.onBackPressed,
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(
            context,
          ).textTheme.h4.copyWith(color: context.component.textPrimary),
        ),
        SizedBox(height: SDeckSpace.gap16),
        Text(
          widget.subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: context.component.textPrimary),
        ),
      ],
    );
  }

  Widget _buildUserCardSection(BuildContext context) {
    return AccountDescriptionWidget(
      username: widget.username,
      imagePath: widget.imagePath,
      scale: widget.scale,
      panX: widget.panX,
      panY: widget.panY,
    );
  }

  Widget _buildDynamicContent(BuildContext context) {
    if (widget.showPasswordField) {
      return _buildPasswordSection(context);
    }
    return Container();
  }

  Widget _buildPasswordSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SDeckSpace.gap16),

        SDeckInput(
          size: SDeckInputSize.large,
          label: "Password",
          supportingText: widget.errorMessage,
          placeholder: "Enter a password",
          keyboardType: TextInputType.visiblePassword,
          onChanged: widget.onPasswordChanged,
          obscureText: widget.obscurePassword ?? true,
          state: _effectiveState(widget.passwordFieldState ?? SDeckInputState.hint),
          focusNode: _focusNode,
          showPasswordToggle: widget.showPasswordToggle,
          onPasswordToggle: widget.onPasswordToggle,
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Column(
      children: [
        //------------------------ Confirmation Buttons -----------------//
        if (widget.showConfirmationButtons) ...[
          SDeckSolidButton(
            text: widget.primaryButtonText ?? "Yes, that's me!",
            size: SDeckButtonSize.large,
            fullWidth: true,
            onPressed: widget.onPrimaryPressed,
          ),
          SizedBox(height: SDeckSpace.gap8),
          SDeckOutlineButton(
            text: widget.secondaryButtonText ?? "No, go back",
            size: SDeckButtonSize.large,
            fullWidth: true,
            onPressed: widget.onSecondaryPressed,
          ),
        ],

        //------------------------ Next Button (Password Mode) -----------//
        if (widget.showNextButton) ...[
          SDeckSolidButton(
            text: "Next",
            size: SDeckButtonSize.large,
            fullWidth: true,
            enabled: widget.isNextEnabled,
            onPressed: widget.onNextPressed,
          ),
        ],
      ],
    );
  }
}