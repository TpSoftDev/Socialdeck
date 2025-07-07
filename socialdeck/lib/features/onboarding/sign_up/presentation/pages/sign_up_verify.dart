import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_info_template.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_form_provider.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_validation_provider.dart';

class SignUpVerifyPage extends ConsumerStatefulWidget {
  const SignUpVerifyPage({super.key});

  @override
  ConsumerState<SignUpVerifyPage> createState() => _SignUpVerifyPageState();
}

class _SignUpVerifyPageState extends ConsumerState<SignUpVerifyPage> {
  //*************************** Helper Methods ********************************//
  void _onSendVerification() {
    final email = ref.read(signUpFormProvider).email;
    ref.read(signUpValidationProvider.notifier).sendVerificationEmail(email);
    context.push('/sign-up/redirecting');
  }

  void _onChangeEmailAddress() {
    // Reset form and validation state, then go to email entry
    ref.read(signUpFormProvider.notifier).reset();
    ref.read(signUpValidationProvider.notifier).resetAll();
    FocusScope.of(context).unfocus();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.mounted) {
        context.go('/sign-up');
      }
    });
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(signUpFormProvider);
    final validationState = ref.watch(signUpValidationProvider);
    return PopScope(
      canPop: false,
      child: OnboardingInfoTemplate(
        navigationBar: SDeckTopNavigationBar.logoWithoutBack(),
        title: "Verify Account",
        bodyText:
            "We need to verify your account. We will send a link to the email below assigned to your new account:",
        highlightedText: formState.email,
        highlightedTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onInformation,
        ),
        primaryButtonText: "Send Verification",
        onPrimaryPressed:
            validationState.isLoading ? null : _onSendVerification,
        secondaryActionText: "Change Email Address",
        onSecondaryPressed: _onChangeEmailAddress,
        showBackButton: false,
        showLoadingIndicator: validationState.isLoading,
      ),
    );
  }
}
