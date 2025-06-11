import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_info_template.dart';

class SignUpVerifyPage extends ConsumerStatefulWidget {
  const SignUpVerifyPage({super.key});

  @override
  ConsumerState<SignUpVerifyPage> createState() => _SignUpVerifyPageState();
}

class _SignUpVerifyPageState extends ConsumerState<SignUpVerifyPage> {
  //*************************** Helper Methods ********************************//
  void _onSendVerification() {
    // TODO: Implement actual email verification logic
    print('Sending verification email to: real@email.com');

    // For now, navigate to redirecting screen
    context.push('/sign-up/redirecting');
  }

  void _onChangeEmailAddress() {
    // TODO: Navigate back to email entry or show email change dialog
    print('User wants to change email address');

    // For now, go back to email entry
    context.push('/sign-up');
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return OnboardingInfoTemplate(
      title: "Verify Account",
      bodyText:
          "We need to verify your account. Send a link to the email below assigned to your new account:",
      highlightedText: "real@email.com",
      highlightedTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.info,
      ),
      primaryButtonText: "Send Verification",
      onPrimaryPressed: _onSendVerification,
      secondaryActionText: "Change Email Address",
      onSecondaryPressed: _onChangeEmailAddress,
      showBackButton: true,
      showLoadingIndicator: false,
    );
  }
}
