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
import 'package:image_picker/image_picker.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/design_system/components/inputs/input_enums.dart';
import 'package:socialdeck/design_system/components/inputs/sdeck_input.dart';
import 'package:socialdeck/features/sprint2_training/reference/invite_friends/presentation/pages/invite_friends_page.dart';

class EnterUsernamePage extends ConsumerStatefulWidget {
  /// Carries the selected/edited image from Edit Photo.
  /// If null, the screen falls back to the placeholder.
  final XFile? image;

  const EnterUsernamePage({
    super.key,
    this.image,
  });

  @override
  ConsumerState<EnterUsernamePage> createState() => _EnterUsernamePageState();
}

class _EnterUsernamePageState extends ConsumerState<EnterUsernamePage> {
  //*************************** Controller / Focus ***************************//
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();

  //*************************** UI State ************************************//
  bool _visible = false;
  bool _isFocused = false;
  bool _isSubmitting = false;
  String? _errorText;

  // Example local validation lists.
  // Replace later with backend/provider availability checks if needed.
  final Set<String> _takenUsernames = {
    'ethan',
    'admin',
    'test',
  };

  final Set<String> _blockedWords = {
    'badword123',
  };

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(_handleFocusChange);
    _startEntranceAnimation();
  }

  //*************************** Entrance Animation ***************************//
  Future<void> _startEntranceAnimation() async {
    await Future.delayed(SDeckMotionDuration.microDelay);

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
  String? _validateUsername(String username) {
    if (username.isEmpty) {
      return 'Please enter a username.';
    }

    // Only letters, numbers, underscores.
    final RegExp validPattern = RegExp(r'^[A-Za-z0-9_]+$');
    if (!validPattern.hasMatch(username)) {
      return 'Please only use letters, numbers, or underscores.';
    }

    if (_blockedWords.contains(username.toLowerCase())) {
      return 'Please choose a different username.';
    }

    if (_takenUsernames.contains(username.toLowerCase())) {
      return 'This username is taken or unavailable.';
    }

    return null;
  }

  //*************************** Submit **************************************//
  Future<void> _onNext() async {
    if (!_isNextEnabled) return;

    final username = _trimmedUsername;

    setState(() {
      _errorText = null;
      _isSubmitting = true;
    });

    await Future.delayed(SDeckMotionDuration.microDelay);

    final validationError = _validateUsername(username);

    if (!mounted) return;

    if (validationError != null) {
      setState(() {
        _errorText = validationError;
        _isSubmitting = false;
      });
      return;
    }

    setState(() {
      _visible = false;
    });

    await Future.delayed(SDeckMotionDuration.fade);

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
              image: widget.image != null
                  ? FileImage(File(widget.image!.path))
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

    return Scaffold(
      // Let Scaffold resize when keyboard appears so the whole layout,
      // including the button, is pushed upward automatically.
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: AnimatedPadding(
                  duration: SDeckMotionDuration.dialog,
                  curve: SDeckMotionCurve.standard,
                  padding: EdgeInsets.fromLTRB(
                    SDeckSpace.padding16,
                    SDeckSpace.padding16,
                    SDeckSpace.padding16,
                    MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //------------------------ Title ------------------------//
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: SDeckSpace.padding12,
                        ),
                        child: Text(
                          'Profile Name',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: context.component.textPrimary,
                              ),
                        ),
                      ),

                      //------------------------ Placeholder ------------------//
                      SDeckFadeSwap(
                        visible: _visible,
                        child: Center(
                          child: _buildPlaceholderVisual(
                            size: visualSize,
                          ),
                        ),
                      ),

                      const SizedBox(height: SDeckSpace.gap16),

                      //------------------------ Prompt Text ------------------//
                      SDeckFadeSwap(
                        visible: _visible,
                        child: Text(
                          'Now give me a name.\nAnything you like.',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: context.component.textSecondary,
                                  ),
                        ),
                      ),

                      const SizedBox(height: SDeckSpace.gap16),

                      //------------------------ Username Input ---------------//
                      SDeckFadeSwap(
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

                      //------------------------ Next Button ------------------//
                      SDeckFadeSwap(
                        visible: _visible,
                        child: Opacity(
                          opacity: _isNextEnabled ? 1.0 : 0.45,
                          child: SizedBox(
                            width: double.infinity,
                            child: SDeckSolidButton(
                              text: _isSubmitting ? 'Loading...' : 'Next',
                              size: SDeckButtonSize.large,
                              fullWidth: true,
                              onPressed: _isNextEnabled ? _onNext : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}