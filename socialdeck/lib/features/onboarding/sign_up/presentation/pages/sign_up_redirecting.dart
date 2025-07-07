import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_info_template.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/components/navigation/sdeck_top_navigation_bar.dart';

class SignUpRedirectingPage extends ConsumerStatefulWidget {
  const SignUpRedirectingPage({super.key});

  @override
  ConsumerState<SignUpRedirectingPage> createState() =>
      _SignUpRedirectingPageState();
}

class _SignUpRedirectingPageState extends ConsumerState<SignUpRedirectingPage> {
  @override
  void initState() {
    super.initState();
    // Simulate waiting for email verification, then navigate to profile/username
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        context.go('/profile/username');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingInfoTemplate(
      navigationBar: SDeckTopNavigationBar.logoWithoutBack(),
      title: "Redirecting...",
      showBackButton: false,
      showLoadingIndicator: true,
    );
  }
}
