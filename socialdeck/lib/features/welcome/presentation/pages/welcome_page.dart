import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          // 16px horizontal padding to match your other screens
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top spacer for proper vertical positioning
              const Spacer(flex: 3),

              //------------------------ Wordmark Logo -------------------------//
              // Using wordmark instead of animation for now - positioned in center area
              Center(
                child: SDeckIcon(context.icons.wordmark, width: 64, height: 64),
              ),

              // Flexible spacer that adapts to screen size (replaces fixed 200px)
              const Spacer(flex: 2),

              //------------------------ Tagline ---------------------------//
              // "Build, Play, Share." text - positioned below wordmark
              Center(
                child: Text('Build, Play, Share.',
                  style: Theme.of(context).textTheme.h6,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: SDeckSpace.gapXS),
              //------------------------ Action Buttons --------------------//
              // Sign Up button - primary/solid style
              SDeckSolidButton.large(
                text: 'Sign Up',
                fullWidth: true,
                onPressed: () => context.push('/sign-up'),
              ),

              const SizedBox(height: SDeckSpace.gapXS),

              // Log In button - secondary/hollow style
              SDeckHollowButton.large(
                text: 'Log In',
                fullWidth: true,
                onPressed: () => context.push('/login'),
              ),

              const SizedBox(height: SDeckSpace.gapM),

              //------------------------ Terms & Privacy -------------------//
              // Legal text at bottom - matches Figma styling
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.footer,
                    children: [
                      const TextSpan(
                        text: 'By proceeding, you confirm your agreement to our ',
                      ),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onLink,
                        ),
                      ),
                      const TextSpan(
                        text: ' and acknowledge that you have reviewed our ',
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: Theme.of(context).colorScheme.onLink),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),

              // Bottom spacer
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
