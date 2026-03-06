import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/features/sprint2_training/opening_screen/providers/opening_screen_provider.dart';

class OpeningScreenPage extends ConsumerStatefulWidget {
  const OpeningScreenPage({super.key});

  //------------------------------- Constructor -----------------------------//
  @override
  ConsumerState<OpeningScreenPage> createState() => _OpeningScreenPageState();
}

class _OpeningScreenPageState extends ConsumerState<OpeningScreenPage> {
  //------------------------------- Init State -----------------------------//
  @override
  void initState() {
    super.initState();
    // Run right after initState so provider updates don't fire too early.
    Future.microtask(() {
      ref.read(openingScreenProvider.notifier).checkAuthStatus();
    });
  }
































  //------------------------------- Build -----------------------------//
  @override
  Widget build(BuildContext context) {
    // Watch provider state so this widget rebuilds when loading/auth changes.
    final state = ref.watch(openingScreenProvider);

    ref.listen(openingScreenProvider, (previous, next) {
      if (previous?.isAuthenticated != true && next.isAuthenticated) {
        Future.microtask(() => context.go(AppPaths.home));
      }
    });

    // Show backend at work: spinner while we "check auth" (3s from test repo).
    if (state.isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: SDeckSpace.gap16),
              Text(
                state.statusMessage,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: context.component.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    //Frontend Code
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                  onPressed: () {
                    context.go(AppPaths.signUpPassword);
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
                    ref.read(openingScreenProvider.notifier).simulateLogin();
                  },
                ),
              ),

              const SizedBox(height: SDeckSpace.gap16),

              Center(
                child: Text(
                  state.statusMessage,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.component.textSecondary,
                      ),
                ),
              ),

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