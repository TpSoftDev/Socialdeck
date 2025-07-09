import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/design_system/components/messages/sdeck_message_card.dart';

class OnboardingInputTemplate extends StatelessWidget {
  //*************************** Parameters ************************************//
  // What the template needs to be told by the parent page

  final String title; // "Log In" vs "Sign Up"
  final String fieldLabel; // "Username or Email" vs "Email"
  final String
  placeholder; // "Enter username/email" vs "Enter your email address"
  final String inputValue; // Current input text
  final Function(String) onInputChanged; // Callback when user types
  final VoidCallback onNextPressed; // Callback when Next button pressed
  final bool isNextEnabled; // Whether Next button should be enabled
  final TextInputType? keyboardType; // Email vs text keyboard
  final bool isObscureText; // Whether the text is obscured
  final bool showSocialLogin; // Whether to show the social login section
  final SDeckTextFieldState fieldState; // State of the text field
  final bool
  showPasswordToggle; // Whether to show the eye icon for password fields
  final VoidCallback?
  onPasswordToggle; // Callback for toggling password visibility
  final TextEditingController?
  controller; // Controller for the first field (optional)
  final bool readOnly; // Whether the first field is read-only (default: false)

  /// Optional error message to display below the field (shows error card if not null)
  final String? errorMessage;

  /// Optional note message to display below the field (shows note card if not null and no error)
  final String? noteMessage;

  /// Whether to show a loading spinner on the Next button
  final bool isLoading;

  /// Optional callback for custom back button behavior
  /// If null, uses default Navigator.pop(context) behavior
  final VoidCallback? onBackPressed;

  /// Optional custom navigation bar widget. If provided, overrides default nav bar.
  final Widget? navigationBar;

  /// Optional label for the main action button (defaults to 'Next')
  final String? nextButtonLabel;

  //*************************** Optional Second Field Parameters **************//
  // These are for screens that need TWO input fields (like confirm password)
  // NULL SAFETY EXPLANATION:
  // - When showSecondField is FALSE: all these parameters can be null (safe)
  // - When showSecondField is TRUE: you MUST provide non-null values for required ones
  // - The ! operator is safe because we only use these inside if(showSecondField) blocks

  final bool showSecondField; // Turn second field on/off (like showSocialLogin)
  final String?
  secondFieldLabel; // "Confirm Password" - null when showSecondField is false
  final String?
  secondPlaceholder; // "Confirm your password" - null when showSecondField is false
  final String?
  secondInputValue; // Current text in second field - null when showSecondField is false
  final Function(String)?
  onSecondInputChanged; // Callback when user types in second field - null when showSecondField is false
  final SDeckTextFieldState?
  secondFieldState; // Visual state of second field - null when showSecondField is false
  final bool secondFieldObscureText; // Whether second field should hide text
  final bool
  secondShowPasswordToggle; // Whether to show the eye icon for confirm password
  final VoidCallback?
  secondOnPasswordToggle; // Callback for toggling confirm password visibility

  /// Optional error message to display below the second field (shows error card if not null)
  final String? secondErrorMessage;

  /// Optional custom widget to show below the second field (e.g., a button)
  final Widget? secondaryActionButton;

  //*************************** Constructor ***********************************//
  const OnboardingInputTemplate({
    required this.title,
    required this.fieldLabel,
    required this.placeholder,
    required this.inputValue,
    required this.onInputChanged,
    required this.onNextPressed,
    required this.isNextEnabled,
    required this.isObscureText,
    required this.showSocialLogin,
    required this.fieldState,
    this.keyboardType,
    this.controller, // New: controller for first field
    this.readOnly = false, // New: readOnly for first field
    // Optional second field parameters with safe defaults
    this.showSecondField = false, // Default: single field (like existing pages)
    this.secondFieldLabel, // Default: null (safe when showSecondField is false)
    this.secondPlaceholder, // Default: null (safe when showSecondField is false)
    this.secondInputValue, // Default: null (safe when showSecondField is false)
    this.onSecondInputChanged, // Default: null (safe when showSecondField is false)
    this.secondFieldState, // Default: null (safe when showSecondField is false)
    this.secondFieldObscureText = false, // Default: don't hide text
    this.secondShowPasswordToggle = false,
    this.secondOnPasswordToggle,
    this.errorMessage,
    this.noteMessage,
    this.isLoading = false, // Default: not loading
    this.onBackPressed,
    this.showPasswordToggle = false,
    this.onPasswordToggle,
    this.navigationBar, // New: custom navigation bar
    this.nextButtonLabel, // New: customizable main button label
    this.secondErrorMessage,
    this.secondaryActionButton,
    super.key,
  });

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation (Fixed) ---------------//
            _buildNavigation(),

            //------------------------ Scrollable Content --------------------//
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //------------------------ Main Content --------------------------//
                    _buildMainContent(context),

                    //------------------------ Optional Social Login Section ---------//
                    if (showSocialLogin) ...[
                      _buildDivider(context),
                      _buildSocialSection(context),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //**************************** Helper Methods ********************************//
  Widget _buildNavigation() {
    if (navigationBar != null) return navigationBar!;
    return SDeckTopNavigationBar.backWithLogo(onBackPressed: onBackPressed);
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //------------------------ Title -------------------------------//
          Text(title, style: Theme.of(context).textTheme.h4),
          SizedBox(height: 16.0),

          //------------------------ First Field -------------------------//
          Text(fieldLabel, style: Theme.of(context).textTheme.bodySmall),
          SDeckTextField.large(
            placeholder: placeholder,
            keyboardType: keyboardType ?? TextInputType.text,
            onChanged: onInputChanged,
            obscureText: isObscureText,
            state: fieldState,
            showPasswordToggle: showPasswordToggle,
            onPasswordToggle: onPasswordToggle,
            controller: controller, // Forward controller
            readOnly: readOnly, // Forward readOnly
          ),
          // Show error message card if errorMessage is not null
          // Otherwise, show note message card if noteMessage is not null
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: SDeckMessageCard.error(text: errorMessage!),
              ),
            )
          else if (noteMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: SDeckMessageCard.note(text: noteMessage!),
              ),
            ),
          SizedBox(height: 8.0),

          //------------------------ Second Field (Optional) -------------//
          // NULL SAFETY EXPLANATION:
          // The ! operators below are SAFE because:
          // 1. They only run when showSecondField is TRUE
          // 2. When you set showSecondField: true, you MUST provide these parameters
          // 3. It's like a contract: "If you turn on second field, give me the data"
          if (showSecondField) ...[
            Text(
              secondFieldLabel!,
              style: Theme.of(context).textTheme.bodySmall,
            ), // ! is safe here
            SDeckTextField.large(
              placeholder: secondPlaceholder!, // ! is safe here
              keyboardType:
                  TextInputType
                      .visiblePassword, // Usually password confirmation
              onChanged: onSecondInputChanged!, // ! is safe here
              obscureText:
                  secondFieldObscureText, // This has a default value, so no ! needed
              state: secondFieldState!, // ! is safe here
              showPasswordToggle: secondShowPasswordToggle,
              onPasswordToggle: secondOnPasswordToggle,
            ),
            // Show error message card if secondErrorMessage is not null
            if (secondErrorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SDeckMessageCard.error(text: secondErrorMessage!),
                ),
              ),
            // Show custom secondary action button if provided
            if (secondaryActionButton != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: secondaryActionButton!,
              ),
            SizedBox(height: 8.0),
          ],

          //================ Next Button (with loading spinner) ================//
          SDeckSolidButton.large(
            text: nextButtonLabel ?? "Next",
            fullWidth: true,
            enabled: isNextEnabled,
            onPressed: onNextPressed,
          ),
        ],
      ),
    );
  }

  //---------------------------------- Divider Widget ------------------------//
  Widget _buildDivider(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.0),
        Center(child: Text('or', style: Theme.of(context).textTheme.bodyLarge)),
        SizedBox(height: 16.0),
      ],
    );
  }

  //----------------------------- Social Login Widget ------------------------//
  Widget _buildSocialSection(BuildContext context) {
    return Column(
      children: [
        //------------------------ Google Button ------------------------------//
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SDeckHollowButton.largeWithLeftIcon(
            text: "Continue with Google",
            icon: SDeckIcon.medium(context.icons.google),
            fullWidth: true,
            onPressed: () => print('Continue with Google'),
          ),
        ),
        SizedBox(height: 8.0),
        //------------------------- Apple Button ---------------------------//
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SDeckHollowButton.largeWithLeftIcon(
            text: "Continue with Apple",
            icon: SDeckIcon.medium(context.icons.apple),
            fullWidth: true,
            onPressed: () => print('Continue with Apple'),
          ),
        ),
      ],
    );
  }
}
