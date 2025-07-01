import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';
import '../../providers/login_form_provider.dart'; // Import the form provider
import '../../providers/login_validation_provider.dart'; // Import the validation provider

// Use ConsumerStatefulWidget to access Riverpod's ref
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // Track if we've started validation to avoid calling handler multiple times
  bool _hasStartedValidation = false;

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
  /// Now validates the username before navigating to the next screen.
  void _onNextPressed() {
    // Get the current username from the form state
    final currentUsername = ref.read(loginFormProvider).usernameOrEmail;

    // Call the validation provider to check if username exists
    // This will show loading state and then update with result
    ref
        .read(loginValidationProvider.notifier)
        .validateUsername(currentUsername);

    // Mark that we've started validation so we can handle the result
    _hasStartedValidation = true;

    print('Validating username: $currentUsername');
  }

  /// Called when validation state changes.
  /// Navigates to next screen if validation is successful.
  void _handleValidationResult() {
    // Get the current validation state
    final validationState = ref.read(loginValidationProvider);

    // Only navigate if validation is successful (username exists)
    if (validationState.isValidationSuccessful) {
      print('Username validation successful - navigating to card display');
      context.push('/login/card-display');
    } else if (!validationState.isLoading &&
        validationState.errorMessage != null) {
      // Validation failed - error message will be shown by template
      print('Username validation failed: ${validationState.errorMessage}');
    }
  }

  //==================== Build Method ====================//
  @override
  Widget build(BuildContext context) {
    // Watch the form provider for the latest form state.
    // Use loginFormProvider (the provider variable), not LoginFormProvider (the class)
    final formState = ref.watch(loginFormProvider);

    // Watch the validation provider for validation state (loading, error, success)
    // This tells us if username validation is in progress or completed
    final validationState = ref.watch(loginValidationProvider);

    // Handle validation result when validation completes
    // Only call handler if we've started validation and it's no longer loading
    if (_hasStartedValidation && !validationState.isLoading) {
      // Reset flag and handle result
      _hasStartedValidation = false;
      _handleValidationResult();
    }

    // Use the provider's state for all UI fields.
    return OnboardingInputTemplate(
      title: "Log In",
      fieldLabel: "Username or email",
      placeholder: "Enter username/email",
      inputValue: formState.usernameOrEmail, // From provider
      onInputChanged: _onInputChanged, // Calls provider method
      onNextPressed: _onNextPressed,
      isNextEnabled: formState.isNextEnabled, // From provider
      keyboardType: TextInputType.emailAddress,
      isObscureText: false,
      showSocialLogin: true,
      fieldState:
          validationState
              .usernameFieldState, // Use validation provider's field state
      errorMessage:
          validationState.errorMessage, // Pass error message from validation
      isLoading: validationState.isLoading, // Pass loading state to template
    );
  }
}
