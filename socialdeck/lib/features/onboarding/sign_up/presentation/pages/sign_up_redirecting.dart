import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_info_template.dart';

class SignUpRedirectingPage extends ConsumerStatefulWidget {
  const SignUpRedirectingPage({super.key});

  @override
  ConsumerState<SignUpRedirectingPage> createState() => _SignUpRedirectingPageState();
  
  
}

class _SignUpRedirectingPageState extends ConsumerState<SignUpRedirectingPage> {
  @override
  Widget build(BuildContext context) {
    return OnboardingInfoTemplate(
      title: "Redirecting...",
      showBackButton: true,
      showLoadingIndicator: true,
    );
  }
}