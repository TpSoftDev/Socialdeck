/*--------------------------- test_navigation_bar.dart -------------------------*/
// Test screen for the SDeckTopNavigationBar component
// Demonstrates the component in action with proper theming
// Used for testing and development purposes
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'design_system/index.dart';

class TestNavigationBarScreen extends StatefulWidget {
  const TestNavigationBarScreen({super.key});

  @override
  State<TestNavigationBarScreen> createState() =>
      _TestNavigationBarScreenState();
}

class _TestNavigationBarScreenState extends State<TestNavigationBarScreen> {
  bool showBackVariant = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Test our navigation bar variants
            if (showBackVariant)
              SDeckTopNavigationBar.backWithLogo(
                onBackPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Back button pressed!')),
                  );
                },
              )
            else
              SDeckTopNavigationBar.logoWithTitle(
                title: "Home",
                onActionPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Action button pressed!')),
                  );
                },
              ),

            // Test content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      showBackVariant
                          ? 'Variant: backWithLogo\n(Back + Logo)'
                          : 'Variant: logoWithTitle\n(Logo + Title + Action)',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showBackVariant = !showBackVariant;
                        });
                      },
                      child: Text(
                        'Switch to ${showBackVariant ? "logoWithTitle" : "backWithLogo"}',
                      ),
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
}
