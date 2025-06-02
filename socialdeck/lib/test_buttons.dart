/*------------------------------ test_buttons.dart ------------------------------*/
// Sign Up screen recreation using SocialDeck design system components
// Matches Figma layout structure and spacing exactly
// Demonstrates proper usage of typography, buttons, and text fields
//
// Purpose: Testing design system components in real-world layout scenarios
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'design_system/index.dart';

//============================ TestButtonsScreen ============================//
/// Sign Up screen that recreates the Figma design exactly
/// Uses SocialDeck design system components with proper spacing
/// Demonstrates theme-aware components and responsive layout

class TestButtonsScreen extends StatefulWidget {
  const TestButtonsScreen({super.key});

  @override
  State<TestButtonsScreen> createState() => _TestButtonsScreenState();
}

class _TestButtonsScreenState extends State<TestButtonsScreen> {
  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: SDeckTheme.light,
      darkTheme: SDeckTheme.dark,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //------------------------------- Screen Layout ----------------------//
        // Main layout structure matches Figma Frame hierarchy:
        // Column -> SafeArea (nav) -> Padding (content with 16px horizontal)
        body: Column(
          children: [
            //------------------------------- Top Navigation ------------------//
            // Navigation bar in SafeArea for proper status bar spacing
            SafeArea(child: SDeckTopNavigationBar.backWithLogo()),

            //------------------------------- Main Content --------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //------------------------------- Page Heading ----------------//
                  // H4 typography (32px, Semi Bold)
                  Text('Sign Up', style: Theme.of(context).textTheme.h4),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      SDeckTextField.large(
                        placeholder: 'Enter your email address',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => print('Email: $value'),
                      ),
                      const SizedBox(height: 8),
                      SDeckSolidButton.large(
                        text: 'Next',
                        fullWidth: true,
                        enabled: false,
                        onPressed: () => print('Next pressed'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16), // 16px gap to divider section
                  //------------------------------- Divider Section -------------//
                  // "or" text centered between form and social login options
                  Center(
                    child: Text(
                      'or',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.textPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  //------------------ Social Login Section ------------------//
                  // Uses hollow buttons with brand icons
                  Column(
                    children: [
                      // Google sign-in with brand icon
                      SDeckHollowButton.largeWithLeftIcon(
                        text: 'Continue with Google',
                        icon: SDeckIcon.medium(context.icons.google),
                        fullWidth: true,
                        onPressed: () => print('Google login pressed'),
                      ),

                      const SizedBox(height: 8),
                      // Apple sign-in with brand icon
                      SDeckHollowButton.largeWithLeftIcon(
                        text: 'Continue with Apple',
                        icon: SDeckIcon.medium(context.icons.apple),
                        fullWidth: true,
                        onPressed: () => print('Apple login pressed'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
