/*-------------------- login_page.dart -----------------------*/
// Login Page for the onboarding flow
// Simple test page that displays the input template with sample data
// Foundation for building the full login page
//
// User Journey: Login → Email → Reveal profile card → Password → Success
/*--------------------------------------------------------------------------*/

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';
import '../../providers/login_form_provider.dart';
import '../../providers/login_validation_provider.dart';
import 'package:go_router/go_router.dart';

//------------------------------- LoginPage -----------------------------//
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  /// Fades out fields + CTAs while keeping the nav bar, then holds for Rive placeholder.
  double _scrollableSectionOpacity = 1;

  /// Prevents duplicate Next handling during email → confirm-profile bridge.
  bool _isEmailToConfirmProfileBridge = false;

  //------------------------------- _onInputChanged -----------------------------//
  void _onInputChanged(String value) {
    // 1. Update the form provider with the new input value
    ref.read(loginFormProvider.notifier).updateUsernameOrEmail(value);

    // 2. Reset the validation provider so error state and message disappear
    ref.read(loginValidationProvider.notifier).resetUsernameValidation();
  }

  //------------------------------- _onNextPressed -----------------------------//
  /// Called when the user presses Next. Loads profile data for the reveal step if the email exists.
  Future<void> _onNextPressed(BuildContext context) async {
    if (_isEmailToConfirmProfileBridge) return;

    final email = ref.read(loginFormProvider).usernameOrEmail;
    await ref
        .read(loginValidationProvider.notifier)
        .loadRevealProfileForEmail(email);
    // After validation, check the provider state for success
    final validationState = ref.read(loginValidationProvider);
    if (!validationState.isValidationSuccessful || !context.mounted) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isEmailToConfirmProfileBridge = true;
      _scrollableSectionOpacity = 0;
    });

    await Future.delayed(SDeckMotion.fade);
    await Future.delayed(SDeckMotion.riveAnimationPlaceholder);
    if (!context.mounted) return;

    await context.push('/login/confirm-profile');
    if (!mounted) return;

    setState(() {
      _isEmailToConfirmProfileBridge = false;
      _scrollableSectionOpacity = 1;
    });
  }

  //==================== Build Method ====================//
  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(loginFormProvider);
    final validationState = ref.watch(loginValidationProvider);
    final effectiveFieldState =
        validationState.errorMessage != null
            ? validationState.usernameFieldState
            : formState.usernameFieldState;

    // Custom back button callback: always go to welcome page
    void _onBackPressed() {
      // Reset the login form and validation state so errors and input are cleared on return
      ref.read(loginFormProvider.notifier).reset();
      ref.read(loginValidationProvider.notifier).resetUsernameValidation();
      // Dismiss the keyboard
      FocusScope.of(context).unfocus();
      // Wait for the keyboard to collapse, then navigate
      Future.delayed(const Duration(milliseconds: 100), () {
        if (context.mounted) {
          context.go('/welcome');
        }
      });
    }

    return PopScope(
      canPop:false, // Block all native back navigation (swipe-back, device back button)
      child: OnboardingInputTemplate(
        title: "Log In",
        fieldLabel: "Email",
        placeholder: "yourname@email.com",
        inputValue: formState.usernameOrEmail,
        onInputChanged: _onInputChanged,
        onNextPressed: () => _onNextPressed(context),
        isNextEnabled: formState.isNextEnabled && !_isEmailToConfirmProfileBridge,
        scrollableSectionOpacity: _scrollableSectionOpacity,
        keyboardType: TextInputType.emailAddress,
        isObscureText: false,
        showSocialLogin: true,
        fieldState: effectiveFieldState,
        errorMessage: validationState.errorMessage,
        isLoading: validationState.isLoading,
        noteMessage: "Enter the email address you used to sign up.",
        showTopVisualPlaceholder: true,
        // Pass custom back button callback
        onBackPressed: _onBackPressed,
      ),
    );
  }
}
