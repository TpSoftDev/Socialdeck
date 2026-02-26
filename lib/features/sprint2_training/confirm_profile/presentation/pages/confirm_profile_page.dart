/*---------------- confirm_profile_page.dart ----------------*/
// lib/features/sprint2_training/confirm_profile/presentation/pages/confirm_profile_page.dart
// Confirm Profile screen UI: displays profile card preview, username,
// confirmation prompt, and “That’s me!” button.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class ConfirmProfilePage extends StatelessWidget {
  const ConfirmProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const username = "eth6nhunt";

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SDeckTopNavigationBar.backWithTitleOnly(title: "Log In"),

            //------------------------ Profile Card ----------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: _buildProfileCardSection(context),
            ),

            const SizedBox(height: SDeckSpace.gap16),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: Text(
                username,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.h6.copyWith(
                  color: context.component.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: SDeckSpace.gap16),

            //------------------------ Question Text ----------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: Text(
                "Is this your profile card?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMediumFigma.copyWith(
                  color: context.component.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: SDeckSpace.gap16),

            //------------------------ Button Positioning --------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: SDeckSolidButton(
                text: "That’s me!",
                size: SDeckButtonSize.large,
                fullWidth: true,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCardSection(BuildContext context) {
    return Container(
      width: 370,
      height: 370,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        image: const DecorationImage(
          image: AssetImage(SDeckIcon.checkeredBackground),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}