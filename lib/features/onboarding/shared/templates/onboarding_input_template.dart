import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import '../services/google_auth_service.dart';

class _NoStretchScrollBehavior extends ScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class OnboardingInputTemplate extends ConsumerStatefulWidget {
  //*************************** Parameters ************************************//
  // What the template needs to be told by the parent page

  final String title;
  final String fieldLabel;
  final String placeholder;
  final String inputValue;
  final Function(String) onInputChanged;
  final VoidCallback onNextPressed;
  final bool isNextEnabled;
  final TextInputType? keyboardType;
  final bool isObscureText;
  final bool showSocialLogin;
  final SDeckInputState fieldState;
  final bool showPasswordToggle;
  final VoidCallback? onPasswordToggle;
  final TextEditingController? controller;
  final bool readOnly;

  /// Optional visual widget shown below the title
  final Widget? topVisual;

  /// Optional error message for the first field
  final String? errorMessage;

  /// Optional note message for the first field
  final String? noteMessage;

  /// Whether to show loading behavior on the main button
  final bool isLoading;

  /// Optional custom back button behavior
  final VoidCallback? onBackPressed;

  /// Optional custom navigation bar
  final Widget? navigationBar;

  /// Optional label for the main button
  final String? nextButtonLabel;

  //*************************** Optional Second Field Parameters **************//
  final bool showSecondField;
  final String? secondFieldLabel;
  final String? secondPlaceholder;
  final String? secondInputValue;
  final Function(String)? onSecondInputChanged;
  final SDeckInputState? secondFieldState;
  final bool secondFieldObscureText;
  final bool secondShowPasswordToggle;
  final VoidCallback? secondOnPasswordToggle;

  /// Optional error message for the second field
  final String? secondErrorMessage;

  /// Optional note message for the second field
  final String? secondNoteMessage;

  /// Optional custom widget below the second field
  final Widget? secondaryActionButton;

  /// Figma visual placeholder under the title (e.g. Log In banner). Off by default
  /// so sign-up and other flows using this template stay unchanged.
  final bool showTopVisualPlaceholder;

  /// Opacity for the scrollable block (fields, primary CTA, social). The top
  /// navigation bar stays fully visible. Used by login email → confirm-profile.
  final double scrollableSectionOpacity;

  //*************************** Constructor ***********************************//
  const OnboardingInputTemplate({
    required this.title,
    required this.fieldLabel,
    required this.placeholder,
    required this.inputValue,
    required this.onInputChanged,
    required this.onNextPressed,
    required this.isNextEnabled,
    required this.isObscureText,
    required this.showSocialLogin,
    required this.fieldState,
    this.keyboardType,
    this.controller,
    this.readOnly = false,
    this.topVisual,
    this.errorMessage,
    this.noteMessage,
    this.isLoading = false,
    this.onBackPressed,
    this.showPasswordToggle = false,
    this.onPasswordToggle,
    this.navigationBar,
    this.nextButtonLabel,
    this.showSecondField = false,
    this.secondFieldLabel,
    this.secondPlaceholder,
    this.secondInputValue,
    this.onSecondInputChanged,
    this.secondFieldState,
    this.secondFieldObscureText = false,
    this.secondShowPasswordToggle = false,
    this.secondOnPasswordToggle,
    this.secondErrorMessage,
    this.secondNoteMessage,
    this.secondaryActionButton,
    this.showTopVisualPlaceholder = false,
    this.scrollableSectionOpacity = 1.0,
    super.key,
  });

  @override
  ConsumerState<OnboardingInputTemplate> createState() =>
      _OnboardingInputTemplateState();
}

class _OnboardingInputTemplateState
    extends ConsumerState<OnboardingInputTemplate> {
  final FocusNode _focusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();

  bool _isFirstFocused = false;
  bool _isSecondFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFirstFocused = _focusNode.hasFocus;
        });
      }
    });

    _secondFocusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isSecondFocused = _secondFocusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _secondFocusNode.dispose();
    super.dispose();
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const _NoStretchScrollBehavior(),
          child: Column(
            children: [
              //------------------------ Top Navigation ------------------------//
              _buildNavigation(),

            //------------------------ Scrollable Content --------------------//
            Expanded(
              child: IgnorePointer(
                ignoring: widget.scrollableSectionOpacity == 0,
                child: AnimatedOpacity(
                  opacity: widget.scrollableSectionOpacity.clamp(0.0, 1.0),
                  duration: SDeckMotion.fade,
                  curve: Curves.easeIn,
                  child: ScrollConfiguration(
                    behavior: const _NoStretchScrollBehavior(),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        children: [
                          //------------------------ Main Content --------------------------//
                          _buildMainContent(context),

                          //------------------------ Optional Social Login Section ---------//
                          if (widget.showSocialLogin) ...[
                            _buildDivider(context),
                            _buildSocialSection(context, ref),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )
  );
  }

  //*************************** Helper Methods ********************************//

  SDeckInputState _effectiveState(
    SDeckInputState providerState,
    bool isFocused,
  ) {
    if (providerState == SDeckInputState.error) {
      return SDeckInputState.error;
    }
    if (providerState == SDeckInputState.disabled) {
      return SDeckInputState.disabled;
    }
    if (isFocused) {
      return SDeckInputState.focused;
    }
    return providerState;
  }

  Widget _buildNavigation() {
    if (widget.navigationBar != null) {
      return widget.navigationBar!;
    }

    return SDeckTopNavigationBar.backWithLogo(
      onBackPressed: widget.onBackPressed,
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content starts under top bar; vertical spacing comes from nav padding.
          if (widget.showTopVisualPlaceholder) ...[
            SDeckVisualPlaceholder(
              height: SDeckVisualPlaceholder.heightForGridRow(context),
            ),
            SizedBox(height: SDeckSpace.gap16),
          ],

          //------------------------ First Field -------------------------//
          SDeckInput(
            size: SDeckInputSize.large,
            label: widget.fieldLabel,
            supportingText: widget.errorMessage ?? widget.noteMessage,
            placeholder: widget.placeholder,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            onChanged: widget.onInputChanged,
            obscureText: widget.isObscureText,
            state: _effectiveState(widget.fieldState, _isFirstFocused),
            focusNode: _focusNode,
            showPasswordToggle: widget.showPasswordToggle,
            onPasswordToggle: widget.onPasswordToggle,
            controller: widget.controller,
            readOnly: widget.readOnly,
          ),

          const SizedBox(height: SDeckSpace.gap8),

          //------------------------ Second Field ------------------------//
          if (widget.showSecondField) ...[
            SDeckInput(
              size: SDeckInputSize.large,
              label: widget.secondFieldLabel!,
              supportingText:
                  widget.secondErrorMessage ?? widget.secondNoteMessage,
              placeholder: widget.secondPlaceholder!,
              keyboardType: TextInputType.visiblePassword,
              onChanged: widget.onSecondInputChanged!,
              obscureText: widget.secondFieldObscureText,
              state: _effectiveState(
                widget.secondFieldState!,
                _isSecondFocused,
              ),
              focusNode: _secondFocusNode,
              showPasswordToggle: widget.secondShowPasswordToggle,
              onPasswordToggle: widget.secondOnPasswordToggle,
            ),

            if (widget.secondaryActionButton != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: SDeckSpace.gap8),
                child: widget.secondaryActionButton!,
              ),
            ],

            const SizedBox(height: SDeckSpace.gap8),
          ],

          //------------------------ Next Button -------------------------//
          SDeckSolidButton(
            text: widget.nextButtonLabel ?? "Next",
            size: SDeckButtonSize.large,
            fullWidth: true,
            enabled: widget.isNextEnabled,
            onPressed: widget.onNextPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: SDeckSpace.gap16),
        Center(
          child: Text(
            'or',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: context.component.textSecondary,
                ),
          ),
        ),
        const SizedBox(height: SDeckSpace.gap16),
      ],
    );
  }

  Widget _buildSocialSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        //------------------------ Google Button ------------------------------//
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
          child: SDeckOutlineButton(
            text: "Continue with Google",
            size: SDeckButtonSize.large,
            iconLocation: SDeckButtonIconLocation.left,
            icon: SDeckIcons(
              SDeckIcon.google,
              size: SDeckSize.size24,
            ),
            fullWidth: true,
            onPressed: () {
              final googleAuthService = ref.read(googleAuthServiceProvider);
              googleAuthService.handleGoogleSignIn(context, ref);
            },
          ),
        ),

        const SizedBox(height: SDeckSpace.gap8),

        //------------------------ Apple Button ------------------------------//
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
          child: SDeckOutlineButton(
            text: "Continue with Apple",
            size: SDeckButtonSize.large,
            iconLocation: SDeckButtonIconLocation.left,
            icon: SDeckIcons(
              SDeckIcon.apple,
              size: SDeckSize.size24,
            ),
            fullWidth: true,
            onPressed: () {},
          ),
        ),

        const SizedBox(height: SDeckSpace.gap16),
      ],
    );
  }
}