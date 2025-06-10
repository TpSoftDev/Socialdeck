import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class OnboardingTemplate extends StatelessWidget {
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

  //*************************** Constructor ***********************************//
  const OnboardingTemplate({
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
    super.key,
  });

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //------------------------ Top Navigation ---------------------------//
            _buildNavigation(),

            //------------------------ Main Content -----------------------------//
            _buildMainContent(context),

            //------------------------ Optional Social Login Section -----------//
            if (showSocialLogin) ...[
              _buildDivider(context),
              _buildSocialSection(context),
            ],
          ],
        ),
      ),
    );
  }

  //**************************** Helper Methods ********************************//
  Widget _buildNavigation() {
    return SafeArea(child: SDeckTopNavigationBar.backWithLogo());
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
          Text(fieldLabel, style: Theme.of(context).textTheme.bodySmall),

          //------------------------ Input Field -------------------------//
          SDeckTextField.large(
            placeholder: placeholder,
            keyboardType: keyboardType ?? TextInputType.text,
            onChanged: onInputChanged,
            obscureText: isObscureText,
            state: fieldState,
          ),
          SizedBox(height: 8.0),

          //------------------------ Next Button -------------------------//
          SDeckSolidButton.large(
            text: "Next",
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
