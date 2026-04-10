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

  //------------------------------- _onInputChanged -----------------------------//
  void _onInputChanged(String value) {
    ref.read(signUpFormProvider.notifier).updateEmail(value);
    ref.read(signUpValidationProvider.notifier).resetEmailValidation();
  }

  //------------------------------- _onNextPressed -----------------------------//
  Future<void> _onNextPressed() async {
    final formState = ref.read(signUpFormProvider);
    final validationNotifier = ref.read(signUpValidationProvider.notifier);

    await validationNotifier.validateEmail(formState.email);
    final validationState = ref.read(signUpValidationProvider);

    if (validationState.isEmailValid && mounted) {
      context.push('/sign-up/password');
    }
  }

  //------------------------------- _onBackPressed -----------------------------//
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

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(signUpFormProvider);
    final validationState = ref.watch(signUpValidationProvider);
    final validationNotifier = ref.watch(signUpValidationProvider.notifier);

    return PopScope(
      canPop: false,
      child: OnboardingInputTemplate(
        title: "Sign Up",
        fieldLabel: "Email",
        placeholder: "yourname@email.com",
        inputValue: formState.email,
        onInputChanged: _onInputChanged,
        onNextPressed: _onNextPressed,
        isNextEnabled: formState.isNextEnabled,
        keyboardType: TextInputType.emailAddress,
        isObscureText: false,
        showSocialLogin: true,

        // ── Backend-owned field states ────────────────────────────────────────
        // 1. idle/hint — no error yet, emailFieldState returns SDeckInputState.hint
        // 2. focused   — template handles locally via FocusNode, NOT backend
        // 3. error     — provider sets errorType → emailFieldState returns SDeckInputState.error
        // 4. filled    — provider sets isEmailValid → emailFieldState returns SDeckInputState.filled
        fieldState: validationNotifier.emailFieldState,

        // Error message — set by provider on validation failure, null on idle/success
        errorMessage: validationState.emailErrorMessage,

        // Note message — shown on idle when no error is present
        // Cleared automatically when errorMessage takes over
        noteMessage: validationState.emailErrorMessage == null
            ? 'Enter a valid email to get started.'
            : null,

        isLoading: validationState.isLoading,
        onBackPressed: _onBackPressed,

        //------------------------ Temporary top visual ------------------------//
        showTopVisualPlaceholder: true,
      ),
    );
  }

  //*************************** Helper Methods ********************************//
  Widget _buildEmailVisual(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        image: const DecorationImage(
          image: AssetImage(SDeckIcon.checkeredBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 5,
        child: Container(),
      ),
    );
  }
}