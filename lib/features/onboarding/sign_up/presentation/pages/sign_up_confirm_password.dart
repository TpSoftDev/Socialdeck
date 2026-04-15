import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';
import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_error_type.dart';
import 'package:socialdeck/features/onboarding/sign_up/domain/sign_up_validation_state.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_form_provider.dart';
import 'package:socialdeck/features/onboarding/sign_up/providers/sign_up_validation_provider.dart';

class SignUpConfirmPasswordPage extends ConsumerStatefulWidget {
  const SignUpConfirmPasswordPage({super.key});

  @override
  ConsumerState<SignUpConfirmPasswordPage> createState() =>
      _SignUpConfirmPasswordPageState();
}

class _SignUpConfirmPasswordPageState
    extends ConsumerState<SignUpConfirmPasswordPage> {
  bool _obscurePassword = true;
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

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _onConfirmPasswordChanged(String value) {
    ref.read(signUpFormProvider.notifier).updateConfirmPassword(value);
    ref.read(signUpValidationProvider.notifier).resetConfirmPasswordValidation();
  }

  //------------------------------- _onNextPressed -----------------------------//
  /// Called when the user presses the Next button.
  /// Validates confirm password first, then creates the user account.
  Future<void> _onNextPressed() async {
    final validationNotifier = ref.read(signUpValidationProvider.notifier);

    // Validate confirm password matches before attempting account creation
    validationNotifier.validateConfirmPassword();
    final validationState = ref.read(signUpValidationProvider);
    if (!validationState.isConfirmPasswordValid) return;

    final formState = ref.read(signUpFormProvider);

    // Attempt to create the user account
    final success = await validationNotifier.createUser(
      formState.email,
      formState.password,
    );

    if (success && context.mounted) {
      context.push('/sign-up/verify-account');
    }
  }

  void _onBackPressed() {
    ref.read(signUpFormProvider.notifier).updateConfirmPassword('');
    ref.read(signUpValidationProvider.notifier).resetConfirmPasswordValidation();

    FocusScope.of(context).unfocus();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.mounted) {
        context.go('/sign-up/password');
      }
    });
  }

  // Branches on errorType — never on error message strings
  bool isEmailTakenError(SignUpValidationState validationState) =>
      validationState.errorType == SignUpErrorType.duplicateEmail;

  String mainButtonLabel(SignUpValidationState validationState) =>
      isEmailTakenError(validationState) ? 'Change Email' : 'Next';

  VoidCallback mainButtonAction(
    BuildContext context,
    SignUpValidationState validationState,
  ) {
    if (isEmailTakenError(validationState)) {
      return () {
        ref.read(signUpFormProvider.notifier).reset();
        ref.read(signUpValidationProvider.notifier).resetAll();
        FocusScope.of(context).unfocus();

        Future.delayed(const Duration(milliseconds: 100), () {
          if (context.mounted) {
            context.push('/sign-up');
          }
        });
      };
    }

    return _onNextPressed;
  }

  bool isMainButtonEnabled(
    SignUpValidationState validationState,
    SignUpValidationNotifier validationNotifier,
  ) {
    if (isEmailTakenError(validationState)) return true;
    return validationNotifier.canSubmitConfirmPassword &&
        !validationState.isLoading;
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(signUpFormProvider);
    final validationNotifier = ref.watch(signUpValidationProvider.notifier);
    final validationState = ref.watch(signUpValidationProvider);

    final passwordFieldState = formState.password.isNotEmpty
        ? SDeckInputState.filled
        : SDeckInputState.hint;

    final confirmPasswordFieldState = isEmailTakenError(validationState)
        ? SDeckInputState.hint
        : validationNotifier.confirmPasswordFieldState;

    return PopScope(
      canPop: false,
      child: OnboardingInputTemplate(
        title: "Sign Up",
        fieldLabel: "Password",
        placeholder: "Enter a password",
        inputValue: formState.password,
        controller: _passwordController,
        onInputChanged: (_) {},
        isObscureText: _obscurePassword,
        showPasswordToggle: true,
        onPasswordToggle: _togglePasswordVisibility,
        fieldState: passwordFieldState,
        showSocialLogin: false,
        readOnly: true,

        //------------------------ Second Field ------------------------//
        showSecondField: true,
        secondFieldLabel: "Confirm Password",
        secondPlaceholder: "Re-enter password",
        secondInputValue: formState.confirmPassword,
        onSecondInputChanged: _onConfirmPasswordChanged,
        secondFieldState: confirmPasswordFieldState,
        secondFieldObscureText: _obscureConfirmPassword,
        secondShowPasswordToggle: true,
        secondOnPasswordToggle: _toggleConfirmPasswordVisibility,
        secondErrorMessage: isEmailTakenError(validationState)
            ? validationState.emailErrorMessage
            : null,
        secondNoteMessage: !isEmailTakenError(validationState)
            ? "Re-enter your password"
            : null,

        //------------------------ Action Buttons ------------------------//
        secondaryActionButton: isEmailTakenError(validationState)
            ? SDeckSolidButton(
                text: 'Log In',
                size: SDeckButtonSize.large,
                fullWidth: true,
                onPressed: () {
                  context.push('/login');
                },
              )
            : null,
        isNextEnabled: isMainButtonEnabled(validationState, validationNotifier),
        onNextPressed: mainButtonAction(context, validationState),
        nextButtonLabel: mainButtonLabel(validationState),
        onBackPressed: _onBackPressed,

        //------------------------ Top Visual ------------------------//
        topVisual: buildConfirmPasswordVisual(context),
      ),
    );
  }

  //*************************** Helper Methods ********************************//

  //------------------------ Confirm Password Visual ----------------------------//
  Widget buildConfirmPasswordVisual(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
      child: AspectRatio(
        aspectRatio: 16 / 5,
        child: Image.asset(
          SDeckIcon.checkeredBackground,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}