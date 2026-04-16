import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

// LLD: Frontend Layout is clean and uses button navigation and routing

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SDeckSpace.padding16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //------------------------ Top Space ------------------------//
                    const SizedBox(height: SDeckSpace.padding24),

                    //------------------------ Visual Placeholder --------------------------//
                    buildVisualPlaceholder(context),

                    const SizedBox(height: SDeckSpace.gap24),

                    //------------------------ Socialdeck Logo -------------------------//
                    Center(
                      child: SDeckIcons(
                        SDeckIcon.wordmark,
                        size: SDeckSize.size64,
                      ),
                    ),

                    const SizedBox(height: SDeckSpace.gap24),

                    //------------------------ Action Buttons --------------------//
                    SDeckSolidButton(
                      text: 'Sign Up',
                      size: SDeckButtonSize.large,
                      fullWidth: true,
                      onPressed: () => context.push('/sign-up'),
                    ),

                    const SizedBox(height: SDeckSpace.gap8),

                    SDeckOutlineButton(
                      text: 'Log In',
                      size: SDeckButtonSize.large,
                      fullWidth: true,
                      onPressed: () => context.push('/login'),
                    ),

                    const Spacer(),

                    //------------------------ Terms & Privacy -------------------//
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SDeckSpace.padding8,
                      ),
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context).textTheme.footer.copyWith(
                              color: context.component.textSecondary,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                    'By proceeding, you confirm your agreement to our\n',
                              ),
                              TextSpan(
                                text: 'Terms of Service',
                                style:
                                    Theme.of(context).textTheme.footer.copyWith(
                                  color: SDeckBrandColors.lavender(
                                    Theme.of(context).brightness,
                                  ),
                                ),
                              ),
                              const TextSpan(
                                text:
                                    ' and acknowledge that you have\nreviewed our ',
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style:
                                    Theme.of(context).textTheme.footer.copyWith(
                                  color: SDeckBrandColors.lavender(
                                    Theme.of(context).brightness,
                                  ),
                                ),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //------------------------ Bottom Space ------------------------//
                    const SizedBox(height: SDeckSpace.padding24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //*************************** Helper Methods ********************************//

  //------------------------ Visual Placeholder ----------------------------//
  Widget buildVisualPlaceholder(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.asset(
          SDeckIcon.checkeredBackground,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}