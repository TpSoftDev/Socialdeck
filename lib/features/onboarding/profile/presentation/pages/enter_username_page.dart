import 'package:socialdeck/features/onboarding/profile/utils/fade_swap.dart';
/*----------------------- enter_username_page.dart ----------------------------*/
// Enter Username Page
//
// Purpose:
// - Lets the user enter a profile name / username
// - Shows the selected profile-card visual above
// - Enables the Next button only when input is non-empty
// - Validates username when Next is pressed
//
// States covered:
// 1. Empty
//    - input empty
//    - Next disabled / greyed out
//
// 2. Typing / focused
//    - keyboard appears
//    - keyboard pushes the whole screen upward, including the Next button
//    - screen returns to normal when keyboard disappears
//    - Next button stays 16px above the keyboard
//
// 3. Filled
//    - input has text
//    - Next enabled
//
// 4. Error states after pressing Next
//    - unavailable username
//    - invalid characters
//    - blocked/unacceptable word
//
// Notes:
// - This file accepts an optional XFile image so the chosen image can
//   continue from Edit Photo into this screen.
// - Uses SDeckInput from the design system.
// - On successful validation, this screen transitions to InviteFriendsPage.
/*-----------------------------------------------------------------------*/

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/invite_friends_page.dart';
import 'package:socialdeck/features/onboarding/profile/providers/profile_provider.dart';

class EnterUsernamePage extends ConsumerStatefulWidget {
  const EnterUsernamePage({
    super.key,
  });

  @override
  ConsumerState<EnterUsernamePage> createState() => _EnterUsernamePageState();
}

class _EnterUsernamePageState extends ConsumerState<EnterUsernamePage> {
  //*************************** Controller / Focus ***************************//
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();

  // Scroll controller used by SDeckKeyboardAnchorListener to reveal content
  final ScrollController _keyboardScrollController = ScrollController();

  // Anchor key for the button area we want to keep visible above the keyboard
  final GlobalKey _nextButtonKey = GlobalKey();

  //*************************** Constants ***********************************//
  static const double _keyboardSectionGap = 10;
  static const double _navToContentFadeHeight = 28;

  //*************************** UI State ************************************//
  bool _visible = false;
  bool _isFocused = false;
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(_handleFocusChange);
    _startEntranceAnimation();
  }

  //*************************** Entrance Animation ***************************//
  Future<void> _startEntranceAnimation() async {
    await Future.delayed(SDeckMotionDuration.fast);

    if (!mounted) return;

    setState(() {
      _visible = true;
    });
  }

  //*************************** Focus Tracking *******************************//
  void _handleFocusChange() {
    if (!mounted) return;

    setState(() {
      _isFocused = _usernameFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    _keyboardScrollController.dispose();
    super.dispose();
  }

  //*************************** Derived Helpers *****************************//
  String get _trimmedUsername => _usernameController.text.trim();

  bool get _hasInput => _trimmedUsername.isNotEmpty;

  bool get _isNextEnabled => _hasInput && !_isSubmitting;

  bool get _showErrorState => _errorText != null;

  SDeckInputState get _inputState {
    if (_isSubmitting) {
      return SDeckInputState.disabled;
    }

    if (_showErrorState) {
      return SDeckInputState.error;
    }

    if (_isFocused) {
      return SDeckInputState.focused;
    }

    if (_hasInput) {
      return SDeckInputState.filled;
    }

    return SDeckInputState.hint;
  }

  //*************************** Validation **********************************//
  Future<String?> _validateUsername() async {
    if (await ref.read(profileCardProvider.notifier).usernameCorrectFormat()) {
      return 'Please only use letters, numbers, or underscores.';
    }

    if (!await ref.read(profileCardProvider.notifier).usernameClean()) {
      return 'Please choose a different username.';
    }

    if (!await ref.read(profileCardProvider.notifier).usernameAvailable()) {
      return 'This username is taken or unavailable.';
    }

    return null;
  }

  //*************************** Submit from keyboard ************************//
  Future<void> _onUsernameSubmitted(String _) async {
    if (!_isNextEnabled) {
      FocusScope.of(context).unfocus();
      return;
    }

    await _onNext();
  }

  //*************************** Submit **************************************//
  Future<void> _onNext() async {
    if (!_isNextEnabled) return;

    await ref.read(profileCardProvider.notifier).usernameChange(_trimmedUsername);

    setState(() {
      _errorText = null;
      _isSubmitting = true;
    });

    await Future.delayed(SDeckMotionDuration.fast);

    final validationError = await _validateUsername();

    if (!mounted) return;

    if (validationError != null) {
      setState(() {
        _errorText = validationError;
        _isSubmitting = false;
      });
      return;
    }

    await ref.read(profileCardProvider.notifier).submitProfileToServer();

    setState(() {
      _visible = false;
    });

    await Future.delayed(SDeckMotionDuration.normal);

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const InviteFriendsPage(),
      ),
    );

    if (!mounted) return;

    setState(() {
      _visible = true;
    });
  }

  //*************************** Placeholder Visual **************************//
  Widget _buildPlaceholderVisual({
    required double size,
  }) {
    final state = ref.watch(profileCardProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        SDeckRadius.borderRadius16,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: state.profileImage != null
                  ? FileImage(File(state.profileImage!.path))
                  : const AssetImage(SDeckIcon.checkeredBackground)
                      as ImageProvider,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
      ),
    );
  }

  //*************************** Build ***************************************//
  @override
  Widget build(BuildContext context) {
    const double visualSize = 370;

    final viewInsetsBottom = MediaQuery.viewInsetsOf(context).bottom;
    final keyboardOpen = viewInsetsBottom > 0;
    final navSurface = context.component.navigationSurface;

    return Scaffold(
      // Manual keyboard handling, same idea as login_password_page.dart
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //------------------------ Top Title ---------------------------//
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SDeckSpace.padding16,
                SDeckSpace.padding16,
                SDeckSpace.padding16,
                SDeckSpace.padding12,
              ),
              child: Text(
                'Profile Name',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: context.component.textPrimary,
                    ),
              ),
            ),

            //------------------------ Scrollable Content ------------------//
            Expanded(
              child: SDeckKeyboardAnchorListener(
                // Keep the button area visible above keyboard
                anchorKey: _nextButtonKey,
                focusNode: _usernameFocusNode,
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
                          //-------------------- Profile Visual -------------//
                          FadeSwap(
                            visible: _visible,
                            child: Center(
                              child: _buildPlaceholderVisual(
                                size: visualSize,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: keyboardOpen
                                ? _keyboardSectionGap
                                : SDeckSpace.gap16,
                          ),

                          //-------------------- Prompt Text ----------------//
                          FadeSwap(
                            visible: _visible,
                            child: Text(
                              'Now give me a name.\nAnything you like.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: context.component.textSecondary,
                                  ),
                            ),
                          ),

                          SizedBox(
                            height: keyboardOpen
                                ? _keyboardSectionGap
                                : SDeckSpace.gap16,
                          ),

                          //-------------------- Username Input ------------//
                          FadeSwap(
                            visible: _visible,
                            child: SDeckInput(
                              label: 'Username',
                              placeholder: 'Enter a username',
                              supportingText: _errorText ??
                                  'Use only letters, numbers, or underscores.',
                              state: _inputState,
                              size: SDeckInputSize.large,
                              focusNode: _usernameFocusNode,
                              controller: _usernameController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              onSubmitted: _onUsernameSubmitted,
                              onChanged: (_) {
                                if (_errorText != null) {
                                  setState(() {
                                    _errorText = null;
                                  });
                                } else {
                                  setState(() {});
                                }
                              },
                            ),
                          ),

                          const SizedBox(height: SDeckSpace.gap16),

                          //-------------------- Next Button ---------------//
                          KeyedSubtree(
                            key: _nextButtonKey,
                            child: FadeSwap(
                              visible: _visible,
                              child: Opacity(
                                opacity: _isNextEnabled ? 1.0 : 0.45,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: SDeckSolidButton(
                                    text: _isSubmitting ? 'Loading...' : 'Next',
                                    size: SDeckButtonSize.large,
                                    fullWidth: true,
                                    onPressed: _onNext,
                                    enabled: _isNextEnabled,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //-------------------- Top Fade Overlay --------------//
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
    );
  }
}