/*---------------- confirm_profile_page.dart ----------------*/
// lib/features/sprint2_training/confirm_profile/presentation/pages/confirm_profile_page.dart
// Confirm Profile screen UI: displays profile card preview, username,
// confirmation prompt, and “That’s me!” button.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/sprint2_training/confirm_profile/providers/confirm_profile_provider.dart';

//This is the widget shell, the backend code.
class ConfirmProfilePage extends ConsumerStatefulWidget {
  const ConfirmProfilePage({super.key});

  @override
  ConsumerState<ConfirmProfilePage> createState() => _ConfirmProfilePageState();

}


//The state, where everything lives. This is the frontend code and some backend code is at.
class _ConfirmProfilePageState extends ConsumerState<ConfirmProfilePage> {
//Backend code starts here
//Method Callbacks
Future<void> _retrieveProfileUsername() async {
  await ref.read(confirmProfileProvider.notifier).retrieveProfileUsername();
}

Future<void> _retrieveProfileImage() async {
  await ref.read(confirmProfileProvider.notifier).retrieveProfileImage();
}

Future<void> _retrieveBoth() async {
  await ref.read(confirmProfileProvider.notifier).retrieveBoth();
}








//Frontend code starts here
  @override
  Widget build(BuildContext context) {
    //Reading the current state of the screen, will cause a rebuild when the state changes. Comment out if need to make changes
    final state = ref.watch(confirmProfileProvider);

    String username = "Before Loading";
    if(state.profileName != null){
      username = state.profileName as String;
    } else if (state.errorMessage != null){
      username = state.errorMessage as String;
    }

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
                  color: context.component.textSecondary,
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
                enabled: state.canPressButton,
                onPressed: () {
                  _retrieveBoth();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCardSection(BuildContext context) {
    // backend replace checkered with provider photourl
    final state = ref.watch(confirmProfileProvider);
    String imageURL = SDeckIcon.checkeredBackground;
    if(state.imageURL != null){
      imageURL = state.imageURL as String;
    }
    
    return Container(
      width: 370,
      height: 370,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        image: DecorationImage(
          image: AssetImage(imageURL),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}