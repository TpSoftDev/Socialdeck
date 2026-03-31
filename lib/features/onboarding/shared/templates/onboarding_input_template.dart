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

  final String title; // "Log In" vs "Sign Up"
  final String fieldLabel; // "Username or Email" vs "Email"
  final String placeholder; // "Enter username/email" vs "Enter your email address"
  final String inputValue; // Current input text
  final Function(String) onInputChanged; // Callback when user types
  final VoidCallback onNextPressed; // Callback when Next button pressed
  final bool isNextEnabled; // Whether Next button should be enabled
  final TextInputType? keyboardType; // Email vs text keyboard
  final bool isObscureText; // Whether the text is obscured
  final bool showSocialLogin; // Whether to show the social login section
  final SDeckInputState fieldState; // State of the text field
  final bool
  showPasswordToggle; // Whether to show the eye icon for password fields
  final VoidCallback?
  onPasswordToggle; // Callback for toggling password visibility
  final TextEditingController?
  controller; // Controller for the first field (optional)
  final bool readOnly; // Whether the first field is read-only (default: false)

  /// Optional error message to display below the field (shows error card if not null)
  final String? errorMessage;

  /// Optional note message to display below the field (shows note card if not null and no error)
  final String? noteMessage;

  /// Whether to show a loading spinner on the Next button
  final bool isLoading;

  /// Optional callback for custom back button behavior
  /// If null, uses default Navigator.pop(context) behavior
  final VoidCallback? onBackPressed;

  /// Optional custom navigation bar widget. If provided, overrides default nav bar.
  final Widget? navigationBar;

  /// Optional label for the main action button (defaults to 'Next')
  final String? nextButtonLabel;

  //*************************** Optional Second Field Parameters **************//
  // These are for screens that need TWO input fields (like confirm password)
  // NULL SAFETY EXPLANATION:
  // - When showSecondField is FALSE: all these parameters can be null (safe)
  // - When showSecondField is TRUE: you MUST provide non-null values for required ones
  // - The ! operator is safe because we only use these inside if(showSecondField) blocks

  final bool showSecondField; // Turn second field on/off (like showSocialLogin)
  final String?
  secondFieldLabel; // "Confirm Password" - null when showSecondField is false
  final String?
  secondPlaceholder; // "Confirm your password" - null when showSecondField is false
  final String?
  secondInputValue; // Current text in second field - null when showSecondField is false
  final Function(String)?
  onSecondInputChanged; // Callback when user types in second field - null when showSecondField is false
  final SDeckInputState?
  secondFieldState; // Visual state of second field - null when showSecondField is false
  final bool secondFieldObscureText; // Whether second field should hide text
  final bool
  secondShowPasswordToggle; // Whether to show the eye icon for confirm password
  final VoidCallback?
  secondOnPasswordToggle; // Callback for toggling confirm password visibility

  /// Optional error message to display below the second field (shows error card if not null)
  final String? secondErrorMessage;

  /// Optional custom widget to show below the second field (e.g., a button)
  final Widget? secondaryActionButton;

  /// Figma visual placeholder under the title (e.g. Log In banner). Off by default
  /// so sign-up and other flows using this template stay unchanged.
  final bool showTopVisualPlaceholder;

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
    this.controller, // New: controller for first field
    this.readOnly = false, // New: readOnly for first field
    // Optional second field parameters with safe defaults
    this.showSecondField = false, // Default: single field (like existing pages)
    this.secondFieldLabel, // Default: null (safe when showSecondField is false)
    this.secondPlaceholder, // Default: null (safe when showSecondField is false)
    this.secondInputValue, // Default: null (safe when showSecondField is false)
    this.onSecondInputChanged, // Default: null (safe when showSecondField is false)
    this.secondFieldState, // Default: null (safe when showSecondField is false)
    this.secondFieldObscureText = false, // Default: don't hide text
    this.secondShowPasswordToggle = false,
    this.secondOnPasswordToggle,
    this.errorMessage,
    this.noteMessage,
    this.isLoading = false, // Default: not loading
    this.onBackPressed,
    this.showPasswordToggle = false,
    this.onPasswordToggle,
    this.navigationBar, // New: custom navigation bar
    this.nextButtonLabel, // New: customizable main button label
    this.secondErrorMessage,
    this.secondaryActionButton,
    this.showTopVisualPlaceholder = false,
    super.key,
  });

  @override
  ConsumerState<OnboardingInputTemplate> createState() =>
      _OnboardingInputTemplateState();
}

class _OnboardingInputTemplateState
    extends ConsumerState<OnboardingInputTemplate> {
  //*************************** Focus Nodes ***********************************//
  final FocusNode _focusNode = FocusNode();
  final FocusNode _secondFocusNode = FocusNode();

  bool _isFirstFocused = false;
  bool _isSecondFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFirstFocused = _focusNode.hasFocus);
    });
    _secondFocusNode.addListener(() {
      setState(() => _isSecondFocused = _secondFocusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _secondFocusNode.dispose();
    super.dispose();
  }

  /// Returns the effective display state for a field.
  /// Error and disabled always win. Otherwise, focused overrides hint/filled
  /// while the keyboard is up.
  SDeckInputState _effectiveState(SDeckInputState providerState, bool isFocused) {
    if (providerState == SDeckInputState.error) return SDeckInputState.error;
    if (providerState == SDeckInputState.disabled) return SDeckInputState.disabled;
    if (isFocused) return SDeckInputState.focused;
    return providerState;
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation (Fixed) ---------------//
            _buildNavigation(),

            //------------------------ Scrollable Content --------------------//
            Expanded(
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
          ],
        ),
      ),
    );
  }

  //**************************** Helper Methods ********************************//
  Widget _buildNavigation() {
    if (widget.navigationBar != null) return widget.navigationBar!;
    return SDeckTopNavigationBar.backWithTitleOnly(
      title: widget.title,
      onBackPressed: widget.onBackPressed,
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.margin16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title lives in SDeckTopNavigationBar.backWithTitleOnly (Figma page header).
          SizedBox(height: SDeckSpace.gap16),

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
          SizedBox(height: SDeckSpace.gap16),

          //------------------------ Second Field (Optional) -------------//
          if (widget.showSecondField) ...[
            SDeckInput(
              size: SDeckInputSize.large,
              label: widget.secondFieldLabel!,
              supportingText: widget.secondErrorMessage,
              placeholder: widget.secondPlaceholder!,
              keyboardType: TextInputType.visiblePassword,
              onChanged: widget.onSecondInputChanged!,
              obscureText: widget.secondFieldObscureText,
              state: _effectiveState(widget.secondFieldState!, _isSecondFocused),
              focusNode: _secondFocusNode,
              showPasswordToggle: widget.secondShowPasswordToggle,
              onPasswordToggle: widget.secondOnPasswordToggle,
            ),
            if (widget.secondaryActionButton != null)
              Padding(
                padding: const EdgeInsets.only(top: SDeckSpace.gap8),
                child: widget.secondaryActionButton!,
              ),
            SizedBox(height: SDeckSpace.gap8),
          ],

          //================ Next Button ================//
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

  //---------------------------------- Divider Widget ------------------------//
  Widget _buildDivider(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SDeckSpace.gap16),
        Center(
          child: Text(
            'or',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: context.component.textPrimary,
            ),
          ),
        ),
        SizedBox(height: SDeckSpace.gap16),
      ],
    );
  }

  //----------------------------- Social Login Widget ------------------------//
  Widget _buildSocialSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        //------------------------ Google Button ------------------------------//
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.margin16),
          child: SDeckOutlineButton(
            text: "Continue with Google",
            size: SDeckButtonSize.large,
            iconLocation: SDeckButtonIconLocation.left,
            icon: SDeckIcons(
              SDeckIcon.google,
              size: SDeckSize.size24,
              // No color - preserves original multi-colored Google logo
            ),
            fullWidth: true,
            onPressed: () {
              // Call Google authentication service
              final googleAuthService = ref.read(googleAuthServiceProvider);
              googleAuthService.handleGoogleSignIn(context, ref);
            },
          ),
        ),
        SizedBox(height: 8.0),
        //------------------------- Apple Button ---------------------------//
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SDeckOutlineButton(
            text: "Continue with Apple",
            size: SDeckButtonSize.large,
            iconLocation: SDeckButtonIconLocation.left,
            icon: SDeckIcons(
              SDeckIcon.apple,
              size: SDeckSize.size24,
              // No color - preserves original Apple logo color
            ),
            fullWidth: true,
            onPressed: () => print('Continue with Apple'),
          ),
        ),
      ],
    );
  }
}
