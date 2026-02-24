import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';



class InviteFriendsPage extends StatelessWidget {
  const InviteFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //------------------------ Top Navigation ------------------------//
            const SDeckTopNavigationBar.titleOnly(title: 'Invite Friends'),

            //------------------------ Visual Placeholder --------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: buildVisualPlaceholder(context),
            ),

            SizedBox(height: SDeckSpace.gap16),

            //------------------------ Body Text ----------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: Text("Invite some friends to get \nthe party started!", 
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: context.component.textSecondary),),
            ),
            //------------------------ --------------------------//  
            const SizedBox(height: SDeckSpace.gap16),

            //------------------------ Button Positioning --------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: SDeckSolidButton(
                text: "Send Invite",
                size: SDeckButtonSize.large,
                fullWidth: true,
                iconLocation: SDeckButtonIconLocation.right,
                icon: SDeckIcons(SDeckIcon.mail, size: SDeckSize.size24, color: context.component.iconPrimary,),
                onPressed: () {},
              ),
            ),
            //------------------------ Gap between buttons --------------------------//
            const SizedBox(height: SDeckSpace.gap8),

            //------------------------ Get Started Button --------------------------//
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: SDeckOutlineButton(
                text: "Get Started",
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



//*************************** Helper Methods ********************************//
//------------------------ Visual Placeholder ----------------------------//
  Widget buildVisualPlaceholder(BuildContext context) {
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