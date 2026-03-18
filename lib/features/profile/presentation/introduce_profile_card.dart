/*-------------------- introduce_profile_card.dart -----------------------*/
// Introduce Profile Card Page
// Screen 2: Introduce the profile card feature
// Shows a card with a profile picture and a prompt message that will
// transition to another message after a delay.
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
  bool _showSecondText = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _showSecondText = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _showSecondText
        ? "I'm feeling a bit… generic.\nLet's personalize me."
        : "Hi there! I'm your profile card.";

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Empty Top Navigation ------------------------//
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

            //------------------------ Body Text ----------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SDeckSpace.padding16,
              ),
              child: SizedBox(
                height: 60.0,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      displayText,
                      key: ValueKey(displayText),
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