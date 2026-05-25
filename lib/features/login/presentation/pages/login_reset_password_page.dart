import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import '../../providers/login_form_provider.dart';
import '../../providers/password_reset_oob_provider.dart';
import '../../utils/password_strength.dart';

/// First step of in-app password reset: choose a new password (after email link).
class LoginResetPasswordPage extends ConsumerStatefulWidget {
  const LoginResetPasswordPage({super.key});

  @override
  ConsumerState<LoginResetPasswordPage> createState() =>
      _LoginResetPasswordPageState();
}

class _LoginResetPasswordPageState extends ConsumerState<LoginResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  String? _errorText;

  static const String _defaultSupportingText =
      "Create a strong password: 8+ characters with letters, numbers & symbols.";

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  SDeckInputState _effectiveInputState() {
    if (_errorText != null) return SDeckInputState.error;
    if (_passwordFocusNode.hasFocus) return SDeckInputState.focused;
    if (_passwordController.text.isNotEmpty) return SDeckInputState.filled;
    return SDeckInputState.hint;
  }

  void _onPasswordChanged(String value) {
    if (_errorText != null) {
      setState(() => _errorText = null);
      return;
    }
    setState(() {});
  }

  Future<void> _onPasswordSubmitted(String _) async {
    if (_passwordController.text.trim().isEmpty) {
      FocusScope.of(context).unfocus();
      return;
    }
    _onNextPressed();
  }

  void _onNextPressed() {
    final password = _passwordController.text;
    if (!isStrongPassword(password)) {
      setState(() {
        _errorText =
            "Oops! Make it 8+ characters with letters, numbers & symbols.";
      });
      return;
    }

    context.pushNamed(
      'loginResetPasswordConfirm',
      extra: password,
    );
  }

  void _leaveResetPassword() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    final email = ref.read(loginFormProvider).usernameOrEmail;
    context.go(AppPaths.loginForgotPassword, extra: email);
  }

  @override
  Widget build(BuildContext context) {
    final oobState = ref.watch(passwordResetOobProvider);
    final hasCode = oobState.oobCode != null && oobState.oobCode!.isNotEmpty;
    final isNextEnabled = _passwordController.text.isNotEmpty && hasCode;
    final inputState = _effectiveInputState();
    final supportingText = _errorText ?? _defaultSupportingText;

    return PopScope(
      canPop: context.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || !mounted) return;
        _leaveResetPassword();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SDeckTopNavigationBar(
                left: SDeckTopBarLeft.back,
                type: SDeckTopBarType.subpage,
                right: SDeckTopBarRight.none,
                title: "Reset Password",
                onLeftPressed: _leaveResetPassword,
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
                      if (!hasCode)
                        Padding(
                          padding: const EdgeInsets.only(bottom: SDeckSpace.gap16),
                          child: Text(
                            'Open the reset link from your email first. '
                            'This screen unlocks after the app receives it.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: context.semantic.error,
                                    ),
                          ),
                        ),
                      SDeckInput(
                        size: SDeckInputSize.large,
                        label: "New Password",
                        supportingText: supportingText,
                        placeholder: "Enter a password",
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        onChanged: _onPasswordChanged,
                        onSubmitted: _onPasswordSubmitted,
                        obscureText: _obscurePassword,
                        showPasswordToggle: true,
                        onPasswordToggle: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                        state: inputState,
                      ),
                      const SizedBox(height: SDeckSpace.gap16),
                      SDeckSolidButton(
                        text: "Next",
                        size: SDeckButtonSize.large,
                        fullWidth: true,
                        enabled: isNextEnabled,
                        onPressed: isNextEnabled ? _onNextPressed : null,
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
