import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';


class OpeningScreenPage extends StatelessWidget {
  const OpeningScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //------------------------ Visual Placeholder --------------------------//
            Padding(
              padding: const EdgeInsets.all(SDeckSpace.padding16),
              child: buildVisualPlaceholder(context),
            ),

            const SizedBox(height: SDeckSpace.gap24),

            //------------------------ Socialdeck Logo -------------------------//
            Center(
              child: SDeckIcons(
                SDeckIcon.wordmark,
                size: SDeckSize.size64,
              ),
            ),

            const SizedBox(height: SDeckSpace.gap24),

            //------------------------ Button Positioning --------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SDeckSpace.padding24,
              ),
               child: SDeckSolidButton(
                text: "Sign Up",
                size: SDeckButtonSize.large,
                fullWidth: true,
                // keep your icon stuff the same...
                onPressed: () {
                context.push(AppPaths.signUp); // or context.go(AppPaths.signUp);
                },
              ),
            ),

            //------------------------ Gap between buttons --------------------------//
            const SizedBox(height: SDeckSpace.gap8),

            //------------------------ Log In Button --------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SDeckSpace.padding24,
              ),
              child: SDeckOutlineButton(
                text: "Log In",
                size: SDeckButtonSize.large,
                fullWidth: true,
                onPressed: () {
                context.push(AppPaths.login); // or context.go(AppPaths.login);
                },
              ),
            ),

            const SizedBox(height: SDeckSpace.gap16),

            //------------------------ Terms & Privacy -------------------//
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SDeckSpace.padding24,
                vertical: SDeckSpace.padding16,
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
                        style: TextStyle(
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
                        style: TextStyle(
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
          ],
        ),
      ),
    );
  }

  //*************************** Helper Methods ********************************//

  //------------------------ Visual Placeholder ----------------------------//
  Widget buildVisualPlaceholder(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
          image: const DecorationImage(
            image: AssetImage(SDeckIcon.checkeredBackground),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}