/*-------------------- login_card_display_page.dart -----------------------*/
// Login Card Display Page for showing user's profile card during login
// Simple test page that displays the playing card component with sample data
// Foundation for building the full "Is this your card?" login confirmation screen
//
// User Journey: Login → Enter username → See their profile card → Confirm identity
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/templates/onboarding_login_template.dart';

class LoginCardDisplayPage extends ConsumerWidget {
  const LoginCardDisplayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingLoginTemplate(
      // Core parameters matching Figma design
      title: "Log In",
      subtitle: "Is this your card?",

      // User context (existing test data)
      username: "username", // Test data - will come from user state later
      imagePath: null, // Shows placeholder for now
      scale: 1.0,
      panX: 0.0,
      panY: 0.0,

      // Confirmation mode - show the two action buttons
      showConfirmationButtons: true,
      primaryButtonText: "Yes, that's me!",
      secondaryButtonText: "No, go back",
      onPrimaryPressed: () => _handleYesPressed(context),
      onSecondaryPressed: () => _handleNoPressed(context),
    );
  }

  //*************************** Button Action Methods ************************//

  /// Handle "Yes, that's me!" button press
  /// User confirms this is their card - proceed to password entry
  void _handleYesPressed(BuildContext context) {
    print('✅ User confirmed their card - proceeding to password entry');
    context.push('/login/password'); // Navigate to password entry screen
  }

  /// Handle "No, go back" button press
  /// User says this is not their card - go back to username entry
  void _handleNoPressed(BuildContext context) {
    print('❌ User rejected card - going back to username entry');
    context.pop(); // Go back to previous screen (username entry)
  }
}
