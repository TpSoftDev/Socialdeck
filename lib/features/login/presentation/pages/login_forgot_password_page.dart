import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import '../../providers/password_reset_send_provider.dart';

/// Forgot password confirmation: shows where the reset link will be sent.
/// [emailForDisplay] is supplied via [GoRouterState.extra] when navigating from login.
///
/// After a successful send, the user must open the email link; the app navigates
/// to reset-password via [SocialdeckAppLinksScope] when the link is ingested.
class LoginForgotPasswordPage extends ConsumerStatefulWidget {
  const LoginForgotPasswordPage({super.key, required this.emailForDisplay});

  final String emailForDisplay;

  @override
  ConsumerState<LoginForgotPasswordPage> createState() =>
      _LoginForgotPasswordPageState();
}

class _LoginForgotPasswordPageState
    extends ConsumerState<LoginForgotPasswordPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(passwordResetSendProvider.notifier).reset();
    });
  }

  Future<void> _onSendLinkPressed() async {
    final notifier = ref.read(passwordResetSendProvider.notifier);
    final ok = await notifier.sendResetEmail(widget.emailForDisplay);
    if (!mounted || !ok) return;
    context.pushReplacementNamed('loginResetPassword');
  }

  @override
  Widget build(BuildContext context) {
    final sendState = ref.watch(passwordResetSendProvider);
    final trimmed = widget.emailForDisplay.trim();
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
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: context.component.textSecondary,
                      ),
                    ),
                    if (sendState.errorMessage != null) ...[
                      const SizedBox(height: SDeckSpace.gap8),
                      Text(
                        sendState.errorMessage!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.semantic.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: 'Send Link',
                      size: SDeckButtonSize.large,
                      shape: SDeckButtonShape.round,
                      fullWidth: true,
                      enabled: !sendState.isLoading,
                      onPressed:
                          sendState.isLoading ? null : _onSendLinkPressed,
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
