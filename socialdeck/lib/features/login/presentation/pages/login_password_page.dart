/*-------------------- login_password_page.dart ---------------------------*/
// Login Password Page for entering password after username validation
// Uses OnboardingLoginTemplate in password mode to maintain card context
// Shows the same tilted card + username while user enters their password
//
// User Journey: Login → Username → Password Entry → Success
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/login/providers/login_form_provider.dart';
import 'package:socialdeck/features/login/providers/login_validation_provider.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import '../../../onboarding/shared/templates/onboarding_login_template.dart';

class LoginPasswordPage extends ConsumerStatefulWidget {
  const LoginPasswordPage({super.key});

  @override
  ConsumerState<LoginPasswordPage> createState() => _LoginPasswordPageState();
}

class _LoginPasswordPageState extends ConsumerState<LoginPasswordPage> {
  // Local state for password visibility
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Reset password validation state when arriving on this page
    Future.microtask(() {
      if (mounted) {
        ref.read(loginValidationProvider.notifier).resetPasswordValidation();
      }
    });
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
  /// Called when the user presses the custom back button.
  /// Provides controlled navigation back to the login page.
  void _onBackPressed() {
    // Reset the login form and validation state so errors and input are cleared on return
    ref.read(loginFormProvider.notifier).reset();
    ref.read(loginValidationProvider.notifier).resetUsernameValidation();
    // Dismiss the keyboard
    FocusScope.of(context).unfocus();
    // Wait for the keyboard to collapse, then navigate
    Future.delayed(const Duration(milliseconds: 100), () {
      if (context.mounted) {
        context.go('/login');
      }
    });
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
      // Password is correct - navigate to home and clear entire navigation stack
      print('Login successful - navigating to home');
      if (context.mounted) {
        context.go('/home');
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
  @override
  Widget build(BuildContext context) {
    // Watch both providers for the latest state
    final formState = ref.watch(loginFormProvider);
    final validationState = ref.watch(loginValidationProvider);

    // Extract user profile data for display
    final profileData = validationState.userProfileData;
    final displayUsername =
        profileData?['username'] ??
        (formState.usernameOrEmail.contains('@')
            ? formState.usernameOrEmail.split('@')[0]
            : formState.usernameOrEmail);
    final profileImageUrl = profileData?['photoUrl'] as String?;

    // Debug: Log image path (temp paths won't work after app restart)
    if (profileImageUrl != null) {
      print('🖼️ Profile image path: $profileImageUrl');
      if (profileImageUrl.contains('/tmp/')) {
        print(
          '⚠️ This is a temporary file path - image upload to Firebase Storage needed',
        );
      }
    }

    // Calculate proportional transforms from adjustment card to login card
    // Adjustment card: 192x288 with 16px padding = 160x256 image area
    // Login card: 68x96 with 6px padding = 56x84 image area
    final adjustmentImageWidth = 192.0 - (16.0 * 2); // 160px image area
    final adjustmentImageHeight = 288.0 - (16.0 * 2); // 256px image area
    final loginImageWidth = 68.0 - (6.0 * 2); // 56px image area
    final loginImageHeight = 96.0 - (6.0 * 2); // 84px image area

    final widthRatio = loginImageWidth / adjustmentImageWidth; // 56/160 = 0.35
    final heightRatio =
        loginImageHeight / adjustmentImageHeight; // 84/256 = 0.328

    final originalScale = (profileData?['scale'] as num?)?.toDouble() ?? 1.0;
    final originalPanX = (profileData?['panX'] as num?)?.toDouble() ?? 0.0;
    final originalPanY = (profileData?['panY'] as num?)?.toDouble() ?? 0.0;

    // Scale keeps the same (2.0x zoom should still be 2.0x zoom)
    // Pan values scale proportionally to the image area
    final imageScale = originalScale;
    final imagePanX =
        originalPanX * widthRatio; // Scale pan based on width ratio
    final imagePanY =
        originalPanY * heightRatio; // Scale pan based on height ratio

    return PopScope(
      canPop:
          false, // Block all native back navigation (swipe-back, device back button)
      child: OnboardingLoginTemplate(
        title: "Log In",
        subtitle: "Enter your password",

        // User context (real data from Firebase)
        username: displayUsername,
        imagePath: profileImageUrl, // Real profile photo from Firestore
        scale: imageScale,
        panX: imagePanX,
        panY: imagePanY,

        // Password mode - show password field and Next button
        showPasswordField: true,
        passwordValue: formState.password,
        onPasswordChanged: _onPasswordChanged,
        passwordFieldState: validationState.passwordFieldState,
        errorMessage: validationState.errorMessage,

        // Pass password visibility state and toggle to the template
        obscurePassword: _obscurePassword,
        showPasswordToggle: true,
        onPasswordToggle: _togglePasswordVisibility,

        // Next button configuration
        showNextButton: true,
        isNextEnabled: formState.isNextEnabled, // Use form provider's state
        onNextPressed: () => _onNextPressed(context),

        // Custom back button callback
        onBackPressed: _onBackPressed,
      ),
    );
  }
}
