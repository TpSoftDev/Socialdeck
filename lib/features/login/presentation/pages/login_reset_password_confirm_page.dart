import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

/// Second step of reset password: confirm new password matches.
/// Stateless for now; routing stays wired.
class LoginResetPasswordConfirmPage extends StatelessWidget {
  const LoginResetPasswordConfirmPage({super.key, required this.newPassword});

  final String newPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.backWithTitleOnly(
              title: "Reset Password",
              onBackPressed: () => context.pop(),
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
                    const SDeckVisualPlaceholder(height: 92),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckInput(
                      size: SDeckInputSize.large,
                      label: "New Password",
                      placeholder: "**********",
                      obscureText: true,
                      showPasswordToggle: false,
                      readOnly: true,
                      state: SDeckInputState.disabled,
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckInput(
                      size: SDeckInputSize.large,
                      label: "Confirm New Password",
                      supportingText:
                          "Re-enter your new password to confirm it matches.",
                      placeholder: "Re-enter password",
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      showPasswordToggle: true,
                      state: SDeckInputState.hint,
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: "Next",
                      size: SDeckButtonSize.large,
                      fullWidth: true,
                      onPressed: () => context.go('/login/password'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
