import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';

class ConfirmProfilePage extends StatelessWidget {
  const ConfirmProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    const username = "eth6hunt"; // placeholder for backend until provider wired

    return Scaffold(  
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar.backWithTitle(title: "Log In"),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(SDeckSpace.padding16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Center(child: _buildProfileCardSection(context))),

                    SizedBox(height: SDeckSpace.gap16),

                    _buildUsernameSection(context, username),

                    SizedBox(height: SDeckSpace.gap8),

                    _buildQuestionsSection(context),

                    SizedBox(height: SDeckSpace.gap16),

                    //------------------------ Confirm Button Section -------------//
                    _buildConfirmButtonSection(context),

                    SizedBox(height: SDeckSpace.gap16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCardSection(BuildContext context) {
    return Transform.scale(
      scale: 1.6,
      child: SDeckPlayingCard.small(
        imagePath: null, // placeholder for backend
        scale: 1.0,
        panX: 0.0,
        panY: 0.0,
      ),
    );
  }

  Widget _buildUsernameSection(BuildContext context, String username) {
    return Text(
      username,
      style: Theme.of(context).textTheme.h5.copyWith(color: context.component.textPrimary),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildQuestionsSection(BuildContext context) {
    return Text(
      "Is this your profile?",
      style: Theme.of(context).textTheme.h6.copyWith(color: context.component.textPrimary),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildConfirmButtonSection(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SDeckSolidButton(
        text: "That's me!",
        onPressed: () {
          // backend action & navigation
        },
      ),
    );
  }
}