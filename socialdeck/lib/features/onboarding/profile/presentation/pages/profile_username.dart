import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_input_template.dart';
import '../../providers/profile_form_provider.dart';
import '../../providers/profile_validation_provider.dart';

// -----------------------------------------------------------------------------
// ProfileUsernamePage
// -----------------------------------------------------------------------------
// Onboarding page for entering and validating a username.
// Uses ProfileFormProvider for value and ProfileValidationProvider for validation.
// Matches login/sign-up page structure and style.
// -----------------------------------------------------------------------------

class ProfileUsernamePage extends ConsumerStatefulWidget {
  const ProfileUsernamePage({super.key});

  @override
  ConsumerState<ProfileUsernamePage> createState() =>
      _ProfileUsernamePageState();
}

class _ProfileUsernamePageState extends ConsumerState<ProfileUsernamePage> {


  //*************************** Input Change Handler **************************//
  void _onInputChanged(String value) {
    // Update the username in the form provider
    ref.read(profileFormProvider.notifier).setUsername(value);
    // Reset validation state when typing
    ref.read(profileValidationProvider.notifier).resetUsernameValidation();
  }

  //*************************** Next Button Handler ***************************//
  Future<void> _onNextPressed() async {
    final username = ref.read(profileFormProvider).username;
    // Trigger validation
    await ref
        .read(profileValidationProvider.notifier)
        .validateUsername(username);
    // If valid, navigate to add profile card page
    if (ref.read(profileValidationProvider).isUsernameValid) {
      if (mounted) {
        context.push('/profile/add-card');
      }
    }
  }
    //*************************** Build Method **********************************//
    @override
  Widget build(BuildContext context) {
    final formState = ref.watch(profileFormProvider);
    final validationState = ref.watch(profileValidationProvider);
    final username = formState.username;
    final isNextEnabled = username.isNotEmpty && !validationState.isLoading;

    return OnboardingInputTemplate(
      navigationBar: SDeckTopNavigationBar.logoWithoutBack(),
      title: "Profile",
      fieldLabel: "Create Username",
      placeholder: "Enter a username",
      inputValue: username,
      onInputChanged: _onInputChanged,
      onNextPressed: _onNextPressed,
      isNextEnabled: isNextEnabled,
      isObscureText: false,
      showSocialLogin: false,
      fieldState: validationState.usernameFieldState,
      errorMessage: validationState.errorMessage,
      noteMessage: validationState.noteMessage,
      isLoading: validationState.isLoading,
    );
  }
}
