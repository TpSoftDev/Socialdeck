import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_form_provider.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_validation_provider.dart';

class SignUpPasswordPage extends ConsumerStatefulWidget {
  const SignUpPasswordPage({super.key});

  @override
  ConsumerState<SignUpPasswordPage> createState() => _SignUpPasswordPageState();
}

class _SignUpPasswordPageState extends ConsumerState<SignUpPasswordPage> {
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _onInputChanged(String value) {
    ref.read(signUpFormProvider.notifier).updatePassword(value);
    ref.read(signUpValidationProvider.notifier).resetPasswordValidation();
  }

  Future<void> _onNextPressed() async {
    final formState = ref.read(signUpFormProvider);
    final validationNotifier = ref.read(signUpValidationProvider.notifier);

    await validationNotifier.validatePassword(formState.password);

    final validationState = ref.read(signUpValidationProvider);
    if (validationState.isPasswordValid && context.mounted) {
      context.push('/sign-up/confirm-password');
    }
  }

  void _onBackPressed() {
  ref.read(signUpValidationProvider.notifier).resetPasswordValidation();

  FocusScope.of(context).unfocus();

  Future.delayed(const Duration(milliseconds: 100), () {
    if (context.mounted) {
      context.go('/sign-up');
    }
  });
}

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(signUpFormProvider);
    final validationState = ref.watch(signUpValidationProvider);
    final validationController = ref.watch(signUpValidationProvider.notifier);

    return PopScope(
      canPop: false,
      child: OnboardingInputTemplate(
        title: 'Sign Up',
        fieldLabel: 'Password',
        placeholder: 'Enter a password',
        inputValue: formState.password,
        onInputChanged: _onInputChanged,
        onNextPressed: _onNextPressed,
        isNextEnabled: validationController.isPasswordNextEnabled,
        keyboardType: TextInputType.visiblePassword,
        isObscureText: _obscurePassword,
        showPasswordToggle: true,
        onPasswordToggle: _togglePasswordVisibility,
        showSocialLogin: false,
        fieldState: validationController.passwordFieldState,
        errorMessage: validationState.passwordErrorMessage,
        noteMessage: validationController.showPasswordNote
            ? 'Create a strong password: 8+ characters with letters, numbers & symbols.'
            : null,
        isLoading: validationState.isLoading,
        onBackPressed: _onBackPressed,
        topVisual: buildPasswordVisual(context),
      ),
    );
  }

  Widget buildPasswordVisual(BuildContext context) {
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