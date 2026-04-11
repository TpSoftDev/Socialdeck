/*-------------------- login_password_page.dart ---------------------------*/
// Login password step: large checkered visual, password field, Next, Forget Password.
// Typically reached after confirm profile ("That's me!").
//
// User Journey: Login -> Username -> Password Entry -> Success
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/login/providers/login_form_provider.dart';
import 'package:socialdeck/features/login/providers/login_validation_provider.dart';

class LoginPasswordPage extends ConsumerStatefulWidget {
  const LoginPasswordPage({super.key});

  @override
  ConsumerState<LoginPasswordPage> createState() => _LoginPasswordPageState();
}

class _LoginPasswordPageState extends ConsumerState<LoginPasswordPage> {
  static const String _profileCardHeroTag = 'login_profile_card_hero';

  /// Figma stack gap (e.g. between Next and “Forget Password?”) when keyboard is open.
  static const double _keyboardSectionGap = 10;
  static const double _navToContentFadeHeight = 28;

  // Local state for password visibility
  bool _obscurePassword = true;
  final FocusNode _passwordFocusNode = FocusNode();
  final GlobalKey _forgotPasswordKey = GlobalKey();
  final ScrollController _keyboardScrollController = ScrollController();
  bool _isPasswordFocused = false;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      if (!mounted) return;
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });

    // Reset validation; re-apply password so [isNextEnabled] matches this step.
    // (After email, [isNextEnabled] is still true from the username field — avoid
    // a black Next button before the user types a password.)
    Future.microtask(() {
      if (!mounted) return;
      ref.read(loginValidationProvider.notifier).resetPasswordValidation();
      final password = ref.read(loginFormProvider).password;
      ref.read(loginFormProvider.notifier).updatePassword(password);
    });
  }

  @override
  void dispose() {
    _keyboardScrollController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
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
  /// Returns to the email entry screen. Clears password-only state first.
  void _onBackPressed() {
    ref.read(loginFormProvider.notifier).updatePassword('');
    ref.read(loginValidationProvider.notifier).resetPasswordValidation();
    FocusScope.of(context).unfocus();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!context.mounted) return;
      // Always go to email entry per login flow requirement.
      context.go(AppPaths.login);
    });
  }

  void _onForgotPasswordPressed() {
    if (!context.mounted) return;
    final email = ref.read(loginFormProvider).usernameOrEmail;
    context.push(AppPaths.loginForgotPassword, extra: email);
  }

  /// Handles keyboard return key behavior from Figma edge cases:
  /// - Empty password: close keyboard only.
  /// - Typed password: same action as tapping Next.
  Future<void> _onPasswordSubmitted(String _) async {
    final formState = ref.read(loginFormProvider);
    if (!formState.isNextEnabled) {
      FocusScope.of(context).unfocus();
      return;
    }
    await _onNextPressed(context);
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
      // Password is correct - show load transition before home
      print('Login successful - navigating to load transition');
      if (context.mounted) {
        context.go('/login/load-into-main-menu');
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
  SDeckInputState _effectivePasswordState(SDeckInputState providerState) {
    if (providerState == SDeckInputState.error) return SDeckInputState.error;
    if (providerState == SDeckInputState.disabled) {
      return SDeckInputState.disabled;
    }
    if (_isPasswordFocused) return SDeckInputState.focused;
    return providerState;
  }

  @override
  Widget build(BuildContext context) {
    final viewInsetsBottom = MediaQuery.viewInsetsOf(context).bottom;
    final keyboardOpen = viewInsetsBottom > 0;
    final formState = ref.watch(loginFormProvider);
    final validationState = ref.watch(loginValidationProvider);
    final photoUrl = validationState.userProfileData?['photoUrl'] as String?;
    final effectivePasswordState = _effectivePasswordState(
      validationState.passwordFieldState,
    );
    final supportingText =
        validationState.errorMessage ??
        "Enter the email address you used to sign up.";
    final navSurface = context.component.navigationSurface;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) _onBackPressed();
      },
      child: Scaffold(
        // Shrink the scroll viewport with [Padding] below instead; avoids Android
        // cases where resize + viewInsets double-count or leave the viewport under the IME.
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SDeckTopNavigationBar.backWithTitleOnly(
                title: "Log In",
                onBackPressed: _onBackPressed,
              ),
              Expanded(
                child: SDeckKeyboardAnchorListener(
                  anchorKey: _forgotPasswordKey,
                  focusNode: _passwordFocusNode,
                  padChildWithViewInsetBottom: true,
                  scrollToEndController: _keyboardScrollController,
                  revealAlignment: 0.78,
                  afterRevealExtraOverlap: SDeckSpace.padding24,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      SingleChildScrollView(
                        controller: _keyboardScrollController,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        // Match [LoginConfirmProfilePage] / reset flow: 16px horizontal;
                        // bottom inset when IME open matches [SDeckKeyboardAnchorListener] pad.
                        padding: EdgeInsets.fromLTRB(
                          SDeckSpace.padding16,
                          0,
                          SDeckSpace.padding16,
                          keyboardOpen
                              ? SDeckSpace.padding16
                              : SDeckSpace.gap16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final width = constraints.maxWidth;
                                final ImageProvider profileCardImageProvider =
                                    (photoUrl != null &&
                                            photoUrl.trim().isNotEmpty)
                                        ? NetworkImage(photoUrl)
                                        : const AssetImage(
                                          SDeckIcon.checkeredBackground,
                                        );
                                return Hero(
                                  tag: _profileCardHeroTag,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      SDeckRadius.borderRadius16,
                                    ),
                                    child: SizedBox(
                                      width: width,
                                      height: width,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: profileCardImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: keyboardOpen
                                  ? _keyboardSectionGap
                                  : SDeckSpace.gap16,
                            ),
                            SDeckInput(
                              size: SDeckInputSize.large,
                              label: "Password",
                              supportingText: supportingText,
                              placeholder: "Enter password",
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              onChanged: _onPasswordChanged,
                              onSubmitted: _onPasswordSubmitted,
                              obscureText: _obscurePassword,
                              state: effectivePasswordState,
                              focusNode: _passwordFocusNode,
                              showPasswordToggle: true,
                              onPasswordToggle: _togglePasswordVisibility,
                            ),
                            const SizedBox(height: SDeckSpace.gap16),
                            SDeckSolidButton(
                              text: "Next",
                              size: SDeckButtonSize.large,
                              fullWidth: true,
                              enabled: formState.isNextEnabled,
                              onPressed: () => _onNextPressed(context),
                            ),
                            SizedBox(
                              height: keyboardOpen
                                  ? _keyboardSectionGap
                                  : SDeckSpace.gap16,
                            ),
                            KeyedSubtree(
                              key: _forgotPasswordKey,
                              child: Center(
                                child: SDeckTextButton(
                                  text: "Forget Password?",
                                  size: SDeckButtonSize.medium,
                                  onPressed: _onForgotPasswordPressed,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (keyboardOpen)
                        Positioned(
                          top: 0,
                          left: SDeckSpace.padding16,
                          right: SDeckSpace.padding16,
                          height: _navToContentFadeHeight,
                          child: IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    navSurface,
                                    navSurface.withValues(alpha: 0),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
