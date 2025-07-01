import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';
import '../../providers/login_form_provider.dart'; // Import the form provider
import '../../providers/login_validation_provider.dart'; // Import the validation provider
import 'package:socialdeck/features/onboarding/shared/providers/onboarding_navigation_provider.dart';
import 'package:socialdeck/features/onboarding/login/domain/login_validation_state.dart';
import 'package:go_router/go_router.dart'; // Add GoRouter for imperative navigation

// Use ConsumerStatefulWidget to access Riverpod's ref
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  /// Called whenever the user types in the username/email field.
  /// Instead of setState, we update the provider's state.
  void _onInputChanged(String value) {
    // 1. Update the form provider with the new input value
    ref.read(loginFormProvider.notifier).updateUsernameOrEmail(value);

    // 2. Reset the validation provider so error state and message disappear
    ref.read(loginValidationProvider.notifier).resetUsernameValidation();

    // 3. (Optional) Debug print to confirm this runs
    print('User typed: $value, validation reset.');
  }

  /// Called when the user presses the Next button.
  /// Validates the username and navigates to the card display page if successful.
  Future<void> _onNextPressed(BuildContext context) async {
    final currentUsername = ref.read(loginFormProvider).usernameOrEmail;
    // Call the validation provider to check if username exists (async)
    await ref
        .read(loginValidationProvider.notifier)
        .validateUsername(currentUsername);
    // After validation, check the provider state for success
    final validationState = ref.read(loginValidationProvider);
    if (validationState.isValidationSuccessful) {
      // Imperative navigation: push to card display page
      if (context.mounted) {
        context.push('/login/card-display');
      }
    }
  }

  //==================== Build Method ====================//
  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(loginFormProvider);
    final validationState = ref.watch(loginValidationProvider);

    return OnboardingInputTemplate(
      title: "Log In",
      fieldLabel: "Username or email",
      placeholder: "Enter username/email",
      inputValue: formState.usernameOrEmail,
      onInputChanged: _onInputChanged,
      onNextPressed: () => _onNextPressed(context),
      isNextEnabled: formState.isNextEnabled,
      keyboardType: TextInputType.emailAddress,
      isObscureText: false,
      showSocialLogin: true,
      fieldState: validationState.usernameFieldState,
      errorMessage: validationState.errorMessage,
      isLoading: validationState.isLoading,
    );
  }
}
