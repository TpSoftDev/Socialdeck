import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

/// First step of reset password.
/// Stateless for now; routing stays wired.
class LoginResetPasswordPage extends StatelessWidget {
  const LoginResetPasswordPage({super.key});

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
                      supportingText:
                          "Create a strong password: 8+ characters with letters, numbers & symbols.",
                      placeholder: "Enter a password",
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      showPasswordToggle: true,
                      state: SDeckInputState.hint,
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: "Next",
                      size: SDeckButtonSize.large,
                      fullWidth: true,
                      onPressed: () {
                        context.pushNamed(
                          'loginResetPasswordConfirm',
                          extra: '',
                        );
                      },
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
