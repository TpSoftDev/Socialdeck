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

  final Widget? topVisual;

  final String? errorMessage;
  final String? noteMessage;
  final bool isLoading;
  final VoidCallback? onBackPressed;
  final Widget? navigationBar;
  final String? nextButtonLabel;

  final bool showSecondField;
  final String? secondFieldLabel;
  final String? secondPlaceholder;
  final String? secondInputValue;
  final Function(String)? onSecondInputChanged;
  final SDeckInputState? secondFieldState;
  final bool secondFieldObscureText;
  final bool secondShowPasswordToggle;
  final VoidCallback? secondOnPasswordToggle;
  final String? secondErrorMessage;
  final String? secondNoteMessage;
  final Widget? secondaryActionButton;

  final bool showTopVisualPlaceholder;
  final double scrollableSectionOpacity;

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

  late final TextEditingController _internalController;
  late final TextEditingController _internalSecondController;

  bool _isFirstFocused = false;
  bool _isSecondFocused = false;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  TextEditingController get _effectiveSecondController =>
      _internalSecondController;

  @override
  void initState() {
    super.initState();

    _internalController = TextEditingController(text: widget.inputValue);
    _internalSecondController = TextEditingController(
      text: widget.secondInputValue ?? '',
    );

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
  void didUpdateWidget(covariant OnboardingInputTemplate oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null &&
        _internalController.text != widget.inputValue) {
      _internalController.value = _internalController.value.copyWith(
        text: widget.inputValue,
        selection: TextSelection.collapsed(offset: widget.inputValue.length),
        composing: TextRange.empty,
      );
    }

    final newSecondValue = widget.secondInputValue ?? '';
    if (_internalSecondController.text != newSecondValue) {
      _internalSecondController.value = _internalSecondController.value
          .copyWith(
            text: newSecondValue,
            selection: TextSelection.collapsed(offset: newSecondValue.length),
            composing: TextRange.empty,
          );
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _secondFocusNode.dispose();
    _internalController.dispose();
    _internalSecondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
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
                      duration: SDeckMotionDuration.normal,
                      curve: SDeckMotionCurve.easeIn,
                      child: AnimatedPadding(
                        duration: SDeckMotionDuration.normal,
                        curve: SDeckMotionCurve.easeInOut,
                        padding: EdgeInsets.only(
                          bottom: keyboardInset,
                        ),
                        child: ScrollConfiguration(
                          behavior: const _NoStretchScrollBehavior(),
                          child: SingleChildScrollView(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

    return SDeckTopNavigationBar.backWithTitleOnly(
      title: widget.title,
      onBackPressed: widget.onBackPressed,
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final resolvedTopVisual =
        widget.topVisual ??
        (widget.showTopVisualPlaceholder
            ? SDeckVisualPlaceholder(
              height: SDeckVisualPlaceholder.heightForGridRow(context),
            )
            : null);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (resolvedTopVisual != null) ...[
            resolvedTopVisual,
            const SizedBox(height: SDeckSpace.gap16),
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
            controller: _effectiveController,
            readOnly: widget.readOnly,
          ),

          const SizedBox(height: SDeckSpace.gap16),

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
              controller: _effectiveSecondController,
            ),

            if (widget.secondaryActionButton != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: SDeckSpace.gap8),
                child: widget.secondaryActionButton!,
              ),
            ],

            const SizedBox(height: SDeckSpace.gap16),
          ],

          //------------------------ Next Button -------------------------//
          SDeckSolidButton(
            text: widget.nextButtonLabel ?? 'Next',
            size: SDeckButtonSize.large,
            fullWidth: true,
            enabled: widget.isNextEnabled,
            onPressed: widget.onNextPressed,
          ),

          const SizedBox(height: SDeckSpace.gap16),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Column(
      children: [
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
            text: 'Continue with Google',
            size: SDeckButtonSize.large,
            iconLocation: SDeckButtonIconLocation.left,
            icon: SDeckIcons(SDeckIcon.google, size: SDeckSize.size24),
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
            text: 'Continue with Apple',
            size: SDeckButtonSize.large,
            iconLocation: SDeckButtonIconLocation.left,
            icon: SDeckIcons(SDeckIcon.apple, size: SDeckSize.size24),
            fullWidth: true,
            onPressed: () {},
          ),
        ),

        const SizedBox(height: SDeckSpace.gap16),
      ],
    );
  }
}
