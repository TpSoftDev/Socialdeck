import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_form_provider.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_validation_provider.dart';
import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_error_type.dart';

class SignUpConfirmPasswordPage extends ConsumerStatefulWidget {
  const SignUpConfirmPasswordPage({super.key});

  @override
  ConsumerState<SignUpConfirmPasswordPage> createState() =>
      _SignUpConfirmPasswordPageState();
}

class _SignUpConfirmPasswordPageState
    extends ConsumerState<SignUpConfirmPasswordPage> {
  bool _obscureConfirmPassword = true;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final password = ref.read(signUpFormProvider).password;
    _passwordController = TextEditingController(text: password);
  }

  @override
  void didUpdateWidget(covariant SignUpConfirmPasswordPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final password = ref.read(signUpFormProvider).password;
    if (_passwordController.text != password) {
      _passwordController.text = password;
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _onConfirmPasswordChanged(String value) {
    ref.read(signUpFormProvider.notifier).updateConfirmPassword(value);
    ref
        .read(signUpValidationProvider.notifier)
        .resetConfirmPasswordValidation();
  }

  Future<void> _onNextPressed() async {
    final validationNotifier = ref.read(signUpValidationProvider.notifier);

    validationNotifier.validateConfirmPassword();
    final validationState = ref.read(signUpValidationProvider);
    if (!validationState.isConfirmPasswordValid) return;

    final formState = ref.read(signUpFormProvider);
    final success = await validationNotifier.createUser(
      formState.email,
      formState.password,
    );

    final updatedValidationState = ref.read(signUpValidationProvider);

    if (success && context.mounted) {
      context.go(AppPaths.introduceProfileCard);
      return;
    }

    if (updatedValidationState.errorType == SignUpErrorType.duplicateEmail &&
        context.mounted) {
      context.go(AppPaths.signUp);
    }
  }

  void _onBackPressed() {
  ref
      .read(signUpValidationProvider.notifier)
      .resetConfirmPasswordValidation();

  FocusScope.of(context).unfocus();

  Future.delayed(const Duration(milliseconds: 100), () {
    if (context.mounted) {
      context.go('/sign-up/password');
    }
  });
}

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(signUpFormProvider);
    final validationNotifier = ref.watch(signUpValidationProvider.notifier);

    const passwordFieldState = SDeckInputState.disabled;

    return PopScope(
      canPop: false,
      child: OnboardingInputTemplate(
        title: 'Sign Up',
        fieldLabel: 'Password',
        placeholder: 'Enter a password',
        inputValue: formState.password,
        controller: _passwordController,
        onInputChanged: (_) {},
        isObscureText: true,
        showPasswordToggle: false,
        onPasswordToggle: null,
        fieldState: passwordFieldState,
        showSocialLogin: false,
        readOnly: true,
        showSecondField: true,
        secondFieldLabel: 'Confirm Password',
        secondPlaceholder: 'Re-enter password',
        secondInputValue: formState.confirmPassword,
        onSecondInputChanged: _onConfirmPasswordChanged,
        secondFieldState: validationNotifier.confirmPasswordFieldState,
        secondFieldObscureText: _obscureConfirmPassword,
        secondShowPasswordToggle: true,
        secondOnPasswordToggle: _toggleConfirmPasswordVisibility,
        secondErrorMessage:
            ref.watch(signUpValidationProvider).confirmPasswordErrorMessage,
        secondNoteMessage:
            ref.watch(signUpValidationProvider).confirmPasswordErrorMessage ==
                    null
                ? 'Re-enter your password to confirm it matches.'
                : null,
        isNextEnabled: validationNotifier.canSubmitConfirmPassword,
        onNextPressed: _onNextPressed,
        nextButtonLabel: 'Next',
        onBackPressed: _onBackPressed,
        topVisual: buildConfirmPasswordVisual(context),
      ),
    );
  }

  Widget buildConfirmPasswordVisual(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
      child: AspectRatio(
        aspectRatio: 4 / 1,
        child: Image.asset(SDeckIcon.checkeredBackground, fit: BoxFit.cover),
      ),
    );
  }
}
