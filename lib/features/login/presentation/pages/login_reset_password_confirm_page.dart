import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import '../../providers/login_repository_provider.dart';
import '../../providers/password_reset_oob_provider.dart';
import '../../utils/password_strength.dart';

/// Confirms new password and calls [LoginRepository.confirmPasswordReset].
class LoginResetPasswordConfirmPage extends ConsumerStatefulWidget {
  const LoginResetPasswordConfirmPage({super.key, required this.newPassword});

  final String newPassword;

  @override
  ConsumerState<LoginResetPasswordConfirmPage> createState() =>
      _LoginResetPasswordConfirmPageState();
}

class _LoginResetPasswordConfirmPageState
    extends ConsumerState<LoginResetPasswordConfirmPage> {
  final TextEditingController _confirmController = TextEditingController();
  final FocusNode _confirmFocusNode = FocusNode();
  bool _obscureConfirm = true;
  String? _errorText;
  bool _submitting = false;

  static const String _defaultSupportingText =
      'Re-enter your new password to confirm it matches.';

  @override
  void initState() {
    super.initState();
    _confirmFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _confirmController.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  SDeckInputState _confirmFieldState() {
    if (_errorText != null) return SDeckInputState.error;
    if (_confirmFocusNode.hasFocus) return SDeckInputState.focused;
    if (_confirmController.text.isNotEmpty) return SDeckInputState.filled;
    return SDeckInputState.hint;
  }

  void _onConfirmChanged(String value) {
    if (_errorText != null) {
      setState(() => _errorText = null);
      return;
    }
    setState(() {});
  }

  Future<void> _onConfirmSubmitted(String _) async {
    if (_confirmController.text.trim().isEmpty) {
      FocusScope.of(context).unfocus();
      return;
    }
    await _onNextPressed();
  }

  String _mapConfirmError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return "Oops! Make it 8+ characters with letters, numbers & symbols.";
      case 'invalid-action-code':
      case 'expired-action-code':
        return 'This reset link is invalid or expired. Request a new one.';
      default:
        return "This action isn't available right now. Try again shortly.";
    }
  }

  Future<void> _onNextPressed() async {
    final primary = widget.newPassword;
    if (!isStrongPassword(primary)) {
      if (!mounted) return;
      context.pop();
      return;
    }

    final confirm = _confirmController.text;
    if (confirm != primary) {
      setState(() {
        _errorText = _defaultSupportingText;
      });
      return;
    }

    final oob = ref.read(passwordResetOobProvider).oobCode;
    if (oob == null || oob.isEmpty) {
      setState(() {
        _errorText =
            "This action isn't available right now. Try again shortly.";
      });
      return;
    }

    setState(() {
      _submitting = true;
      _errorText = null;
    });

    try {
      await ref.read(loginRepositoryProvider).confirmPasswordReset(
            oobCode: oob,
            newPassword: primary,
          );
      ref.read(passwordResetOobProvider.notifier).clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated. Sign in with your new password.'),
        ),
      );
      context.go(AppPaths.login);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _errorText = _mapConfirmError(e);
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _errorText =
              "This action isn't available right now. Try again shortly.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit =
        _confirmController.text.isNotEmpty && !_submitting;
    final supportingText = _errorText ?? _defaultSupportingText;

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
                      supportingText: supportingText,
                      placeholder: "Re-enter password",
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      controller: _confirmController,
                      focusNode: _confirmFocusNode,
                      onChanged: _onConfirmChanged,
                      onSubmitted: _onConfirmSubmitted,
                      obscureText: _obscureConfirm,
                      showPasswordToggle: true,
                      onPasswordToggle: () {
                        setState(() => _obscureConfirm = !_obscureConfirm);
                      },
                      state: _confirmFieldState(),
                    ),
                    const SizedBox(height: SDeckSpace.gap16),
                    SDeckSolidButton(
                      text: "Next",
                      size: SDeckButtonSize.large,
                      fullWidth: true,
                      enabled: canSubmit,
                      onPressed: canSubmit ? () => _onNextPressed() : null,
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
