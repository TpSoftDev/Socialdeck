import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_form_provider.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_validation_provider.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(signUpValidationProvider.notifier).resetAll();
    });
  }

  void _onInputChanged(String value) {
    ref.read(signUpFormProvider.notifier).updateEmail(value);
    ref.read(signUpValidationProvider.notifier).resetEmailValidation();
  }

  Future<void> _onNextPressed() async {
    final formState = ref.read(signUpFormProvider);
    final validationNotifier = ref.read(signUpValidationProvider.notifier);

    await validationNotifier.validateEmail(formState.email);
    final validationState = ref.read(signUpValidationProvider);

    if (validationState.isEmailValid && mounted) {
      context.push('/sign-up/password');
    }
  }

  void _onBackPressed() {
    ref.read(signUpFormProvider.notifier).reset();
    ref.read(signUpValidationProvider.notifier).resetEmailValidation();
    FocusScope.of(context).unfocus();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.mounted) {
        context.go('/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(signUpFormProvider);
    final validationState = ref.watch(signUpValidationProvider);
    final validationNotifier = ref.watch(signUpValidationProvider.notifier);

    return PopScope(
      canPop: false,
      child: OnboardingInputTemplate(
        title: 'Sign Up',
        fieldLabel: 'Email',
        placeholder: 'yourname@email.com',
        inputValue: formState.email,
        onInputChanged: _onInputChanged,
        onNextPressed: _onNextPressed,
        isNextEnabled: formState.email.trim().isNotEmpty,
        keyboardType: TextInputType.emailAddress,
        isObscureText: false,
        showSocialLogin: true,
        fieldState: validationNotifier.emailFieldState,
        errorMessage: validationState.emailErrorMessage,
        noteMessage: validationState.emailErrorMessage == null
            ? 'Enter a valid email to get started.'
            : null,
        isLoading: validationState.isLoading,
        onBackPressed: _onBackPressed,
        topVisual: _buildEmailVisual(context),
      ),
    );
  }

  Widget _buildEmailVisual(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
      child: AspectRatio(
        aspectRatio: 4 / 1,
        child: Image.asset(
          SDeckIcon.checkeredBackground,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}