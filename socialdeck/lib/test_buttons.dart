/*------------------------------ test_buttons.dart ------------------------------*/
// Simple example showing how to use SDeck buttons with proper icons
// Clean demonstration of the most common button patterns
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'design_system/index.dart';

class TestButtonsScreen extends StatelessWidget {
  const TestButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'How to Use SDeck Buttons',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 40),

            // Simple button with no icon
            SDeckSolidButton.mediumRoundWithLeftIcon(
              icon: SDeckIcon.medium(context.icons.google),
              text: 'Continue',
              onPressed: () {
                print('✅ Button pressed!');
              },
            ),

            const SizedBox(height: 20),

            // Button with left icon using your design system
            SDeckSolidButton.mediumWithLeftIcon(
              text: 'Go Back',
              icon: SDeckIcon.medium(context.icons.leftArrow),
              onPressed: () {
                print('⬅️ Going back!');
              },
            ),

            const SizedBox(height: 20),

            // Button with right icon using your design system
            SDeckSolidButton.largeWithRightIcon(
              text: 'Next Step',
              icon: SDeckIcon.medium(context.icons.rightArrow),
              onPressed: () {
                print('➡️ Going to next step!');
              },
            ),

            const SizedBox(height: 20),

            // Round button example
            SDeckSolidButton.mediumRound(
              text: 'Save',
              onPressed: () {
                print('💾 Saving!');
              },
            ),

            const SizedBox(height: 20),

            // Disabled button example
            SDeckSolidButton.medium(text: 'Loading...', enabled: false),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
