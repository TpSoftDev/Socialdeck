/*-------------------- login_password_page.dart ---------------------------*/
// Login password step: large checkered visual, password field, Next, Forget Password.
// Typically reached after confirm profile ("That's me!").
//
// User Journey: Login -> Username -> Password Entry -> Success
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/login/providers/login_form_provider.dart';
import 'package:socialdeck/features/login/providers/login_validation_provider.dart';

class LoginPasswordPage extends ConsumerStatefulWidget {
  const LoginPasswordPage({super.key});

  @override
  ConsumerState<LoginPasswordPage> createState() => _LoginPasswordPageState();
}

class _LoginPasswordPageState extends ConsumerState<LoginPasswordPage> {
  // Local state for password visibility
  bool _obscurePassword = true;
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordFocused = false;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      if (!mounted) return;
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });

    // Reset password validation state when arriving on this page
    Future.microtask(() {
      if (mounted) {
        ref.read(loginValidationProvider.notifier).resetPasswordValidation();
      }
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  //*************************** Helper Methods ********************************//
  /// Called when the user types in the password field.
  /// Updates the provider's state and resets any previous validation errors.
  void _onPasswordChanged(String value) {
    // 1. Update the form provider with the new password value
    ref.read(loginFormProvider.notifier).updatePassword(value);

    // 2. Reset any previous validation errors so the field returns to normal state
    // (This mirrors the pattern from login_page.dart)
    ref.read(loginValidationProvider.notifier).resetPasswordValidation();

    // 3. Debug output to confirm this runs
    print('Password: $value, validation reset.');
  }

  //------------------------------- _onBackPressed -----------------------------//
  /// Returns to the email entry screen. Clears password-only state first.
  void _onBackPressed() {
    ref.read(loginFormProvider.notifier).updatePassword('');
    ref.read(loginValidationProvider.notifier).resetPasswordValidation();
    FocusScope.of(context).unfocus();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!context.mounted) return;
      // Always go to email entry per login flow requirement.
      context.go(AppPaths.login);
    });
  }

  void _onForgotPasswordPressed() {
    if (!context.mounted) return;
    final email = ref.read(loginFormProvider).usernameOrEmail;
    context.push('/login/forgot-password', extra: email);
  }

  /// Handles keyboard return key behavior from Figma edge cases:
  /// - Empty password: close keyboard only.
  /// - Typed password: same action as tapping Next.
  Future<void> _onPasswordSubmitted(String _) async {
    final formState = ref.read(loginFormProvider);
    if (!formState.isNextEnabled) {
      FocusScope.of(context).unfocus();
      return;
    }
    await _onNextPressed(context);
  }

  //------------------------------- _onNextPressed -----------------------------//
  /// Called when the user presses the Next button.
  /// Validates the password and navigates to home if successful.
  Future<void> _onNextPressed(BuildContext context) async {
    // Get the current form state (username and password)
    final currentFormState = ref.read(loginFormProvider);

    // Call the validation provider to check if password is correct (async)
    await ref
        .read(loginValidationProvider.notifier)
        .validatePassword(
          currentFormState.usernameOrEmail,
          currentFormState.password,
        );

    // After validation, check the provider state for success
    final validationState = ref.read(loginValidationProvider);

    if (validationState.isValidationSuccessful) {
      // Password is correct - show load transition before home
      print('Login successful - navigating to load transition');
      if (context.mounted) {
        context.go('/login/load-into-main-menu');
      }
    } else {
      // Password is wrong - error message will be shown automatically by UI
      print('Login failed - incorrect password');
    }
  }

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  //*************************** Build Method **********************************//
  SDeckInputState _effectivePasswordState(SDeckInputState providerState) {
    if (providerState == SDeckInputState.error) return SDeckInputState.error;
    if (providerState == SDeckInputState.disabled) return SDeckInputState.disabled;
    if (_isPasswordFocused) return SDeckInputState.focused;
    return providerState;
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(loginFormProvider);
    final validationState = ref.watch(loginValidationProvider);
    final effectivePasswordState = _effectivePasswordState(
      validationState.passwordFieldState,
    );
    final supportingText =
        validationState.errorMessage ?? "Enter the email address you used to sign up.";

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) _onBackPressed();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              SDeckTopNavigationBar.backWithTitleOnly(
                title: "Log In",
                onBackPressed: _onBackPressed,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SDeckSpace.padding16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: SDeckSpace.gap16),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final size = constraints.maxWidth;
                          return Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                SDeckRadius.borderRadius16,
                              ),
                              image: const DecorationImage(
                                image: AssetImage(SDeckIcon.checkeredBackground),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: SDeckSpace.gap16),
                      SDeckInput(
                        size: SDeckInputSize.large,
                        label: "Password",
                        supportingText: supportingText,
                        placeholder: "Enter password",
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        onChanged: _onPasswordChanged,
                        onSubmitted: _onPasswordSubmitted,
                        obscureText: _obscurePassword,
                        state: effectivePasswordState,
                        focusNode: _passwordFocusNode,
                        showPasswordToggle: true,
                        onPasswordToggle: _togglePasswordVisibility,
                      ),
                      const SizedBox(height: SDeckSpace.gap8),
                      SDeckSolidButton(
                        text: "Next",
                        size: SDeckButtonSize.large,
                        fullWidth: true,
                        enabled: formState.isNextEnabled,
                        onPressed: () => _onNextPressed(context),
                      ),
                      const SizedBox(height: SDeckSpace.gap16),
                      Center(
                        child: SDeckTextButton(
                          text: "Forget Password?",
                          size: SDeckButtonSize.medium,
                          onPressed: _onForgotPasswordPressed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}