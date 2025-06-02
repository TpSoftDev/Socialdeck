/*------------------------------ test_buttons.dart ------------------------------*/
// Simple button test - just 3 essential examples
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'design_system/index.dart';

class TestButtonsScreen extends StatefulWidget {
  const TestButtonsScreen({super.key});

  @override
  State<TestButtonsScreen> createState() => _TestButtonsScreenState();
}

class _TestButtonsScreenState extends State<TestButtonsScreen> {
  int _selectedIndex = 0; // Track which nav item is selected

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: SDeckTheme.light,
      darkTheme: SDeckTheme.dark,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            SafeArea(
              child: Column(
                children: [
                  SDeckTopNavigationBar.backWithLogo(),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Selected Tab: $_selectedIndex',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: SDeckSpacing.md),

   
                    const SizedBox(height: 20),

                  SDeckSolidButton.largeWithLeftIcon(
                      text: 'Continue with Apple',
                      icon: SDeckIcon.medium(context.icons.apple),
                      fullWidth: true,
                      onPressed: () => print('Continue with Google pressed'),
                    ),
                    const SizedBox(height: 20),

                    // 4. Small Full Width Button
                    SDeckSolidButton.largeWithLeftIcon(
                      text: 'Continue with Google',
                      icon: SDeckIcon.medium(context.icons.google),
                      fullWidth: true,
                      onPressed: () => print('Continue with Google pressed'),
                    ),

                    const SizedBox(height: 20),

                  ],
                ),
              ),
            ),
          ],
        ),

        // Bottom nav bar - now with working state!
        bottomNavigationBar: SDeckBottomNavBar(
          currentIndex: _selectedIndex, // Use the state variable
          onTap: (index) {
            setState(() {
              _selectedIndex = index; // Update the state when tapped
            });
          },
          items: SDeckBottomNavBar.defaultItems,
        ),
      ),
    );
  }
}
