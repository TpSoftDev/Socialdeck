import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //------------------------ Top Navigation ---------------------------//
          //Top Navbar
          SafeArea(child: SDeckTopNavigationBar.backWithLogo()),

          //------------------------ Main Content -----------------------------//
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //------------------------ Title -------------------------------//
                Text('Log In', style: Theme.of(context).textTheme.h4),
                SizedBox(height: SDeckSpacing.md),
                Text(
                  'Username or Email',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
               
                //------------------------ Email Input -------------------------//
                SDeckTextField.large(
                  placeholder: 'Enter username/email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => print('Email: $value'),
                ),
                SizedBox(height: SDeckSpacing.sm),
                //------------------------ Next Button -------------------------//
                SDeckSolidButton.large(
                  text: "Next",
                  fullWidth: true,
                  enabled: false,
                  onPressed: () => print('Next'),
                ),
              ],
            ),
          ),

          SizedBox(height: SDeckSpacing.md),
          //------------------------ Divider ------------------------------//
          Center(
            child: Text('or', style: Theme.of(context).textTheme.bodyLarge),
          ),
          SizedBox(height: SDeckSpacing.md),
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
          SizedBox(height: SDeckSpacing.sm),
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
      ),
    );
  }
}
