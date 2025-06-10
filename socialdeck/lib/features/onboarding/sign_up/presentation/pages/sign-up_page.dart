import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //------------------------------- Screen Layout ----------------------//
      // SingleChildScrollView -> Column -> SafeArea (nav) -> Padding (content with 16px horizontal)
      body: SingleChildScrollView(
        child: Column(
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
                  const SizedBox(height: 24.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8.0),
                      SDeckTextField.large(
                        placeholder: 'Enter your email address',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => print('Email: $value'),
                      ),

                      const SizedBox(height: 8.0),
                      SDeckSolidButton.large(
                        text: 'Next',
                        fullWidth: true,
                        enabled: false,
                        onPressed: () => print('Next pressed'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0), 
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


                  const SizedBox(height: 16.0),
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

                      const SizedBox(height: 8.0),
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
