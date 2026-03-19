/*-------------------- introduce_profile_card.dart -----------------------*/
// Introduce Profile Card Page
// Screen 2: Introduce the profile card feature
//
// Behavior:
// - Shows the same visual placeholder throughout the screen.
// - Displays the first line of text for 2 seconds.
// - Fades the first line out over 300ms.
// - Replaces it with the second line of text.
// - Fades the second line in over 300ms.
//
// UI/UX notes addressed:
// - Text is top-aligned so the first line stays in the same position.
// - A fixed-height text area prevents the text from jumping vertically.
// - Fade out happens first, then fade in, so the two texts do not overlap.
/*--------------------------------------------------------------------------*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';

class IntroduceProfileCardPage extends ConsumerStatefulWidget {
  const IntroduceProfileCardPage({super.key});

  @override
  ConsumerState<IntroduceProfileCardPage> createState() =>
      _IntroduceProfileCardPageState();
}

class _IntroduceProfileCardPageState
    extends ConsumerState<IntroduceProfileCardPage> {
  //*************************** Local UI State *******************************//
  // Controls whether the current text is visible or faded out.
  bool _isTextVisible = true;

  // Stores the current message shown on screen.
  String _displayText = "Hi there! I'm your profile card.";

  // Optional timer references for safer cleanup.
  Timer? _initialDelayTimer;
  Timer? _fadeOutTimer;

  @override
  void initState() {
    super.initState();
    _startTextSequence();
  }

  //*************************** Timed Text Sequence ***************************//
  // Sequence:
  // 1. Show first line for 2 seconds
  // 2. Fade out for 300ms
  // 3. Swap text
  // 4. Fade back in for 300ms
  void _startTextSequence() {
    _initialDelayTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      // Step 1: Fade current text out
      setState(() {
        _isTextVisible = false;
      });

      // Step 2: After fade-out completes, swap the text and fade in
      _fadeOutTimer = Timer(const Duration(milliseconds: 300), () {
        if (!mounted) return;

        setState(() {
          _displayText = "I'm feeling a bit… generic.\nLet's personalize me.";
          _isTextVisible = true;
        });
      });
    });
  }

  @override
  void dispose() {
    _initialDelayTimer?.cancel();
    _fadeOutTimer?.cancel();
    super.dispose();
  }

  //*************************** Build Method *******************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Empty Top Navigation ------------------------//
            // Empty title keeps the spacing consistent with the design.
            Padding(
              padding: const EdgeInsets.only(
                top: SDeckSpace.padding16,
                left: SDeckSpace.padding16,
                right: SDeckSpace.padding16,
                bottom: SDeckSpace.padding12,
              ),
              child: const SDeckTopNavigationBar.titleOnly(title: ''),
            ),

            //------------------------ Visual Placeholder --------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SDeckSpace.padding16,
              ),
              child: buildVisualPlaceholder(
                context,
                SDeckIcon.checkeredBackground,
              ),
            ),

            const SizedBox(height: SDeckSpace.gap16),

            //------------------------ Body Text Area ------------------------------//
            // Fixed height prevents layout jumping when switching from 1 line
            // to 2 lines of text.
            //
            // Align(topCenter) ensures both messages begin at the same vertical
            // position, matching the UI/UX designer's feedback.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SDeckSpace.padding16,
              ),
              child: SizedBox(
                height: 64,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                    opacity: _isTextVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Text(
                      _displayText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: context.component.textSecondary,
                          ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: SDeckSpace.gap16),
          ],
        ),
      ),
    );
  }
}

//*************************** Helper Methods ********************************//
//------------------------ Visual Placeholder ----------------------------//
// Reusable helper for the placeholder area.
// Right now it uses the checkered background asset from the design system.
Widget buildVisualPlaceholder(BuildContext context, String imagePath) {
  return Container(
    width: 370,
    height: 370,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
      image: DecorationImage(
        image: AssetImage(imagePath),
        fit: BoxFit.cover,
      ),
    ),
  );
}