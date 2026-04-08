import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

/// Forgot password confirmation: shows where the reset link will be sent.
/// [emailForDisplay] is supplied via [GoRouterState.extra] when navigating from login.
class LoginForgotPasswordPage extends StatelessWidget {
  const LoginForgotPasswordPage({super.key, required this.emailForDisplay});

  final String emailForDisplay;

  @override
  Widget build(BuildContext context) {
    final trimmed = emailForDisplay.trim();
    final emailText = trimmed.isEmpty ? 'your email' : trimmed;
    final prompt = 'Send a password reset link to\n$emailText?';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.backWithTitleOnly(
              title: "Forgot Password",
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
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        return Container(
                          width: width,
                          height: 92,
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
                    Text(
                      prompt,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.component.textSecondary,
                      ),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: "Send Link",
                      size: SDeckButtonSize.large,
                      fullWidth: true,
                      onPressed: () {
                        // TODO: Call reset-password email API here.
                        context.push('/login/reset-password');
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
