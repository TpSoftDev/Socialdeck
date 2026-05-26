/*-------------------- social_page.dart -----------------------*/
// Social Page for the main app
// Displays a placeholder "Coming Soon!" message
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:go_router/go_router.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.none,
              type: SDeckTopBarType.page,
              right: SDeckTopBarRight.profile,
              title: "Social",
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  SDeckSpace.padding16,
                  0,
                  SDeckSpace.padding16,
                  SDeckSpace.padding16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SDeckImageTarget(
                      title: 'Find Friends',
                      description: 'Search and request to be friends',
                      onTap: () => context.go('/social/find-friends'),
                    ),

                    const SizedBox(height: SDeckSpace.gap16),

                    SDeckSectionHeader(
                      title: 'Inbox',
                      showDotIndicator: true,
                      navLinkTitle: 'View All',
                      onNavLinkTap: () => context.go('/social/inbox'),
                    ),

                    const SizedBox(height: SDeckSpace.gap8),

                    SDeckBasicTarget(
                      cardType: SDeckBasicTargetCardType.button,
                      title: 'tpsoftdev',
                      description: 'invited you to Prompt\u2019d',
                      buttonLabel: 'Join',
                      onTap: () {},
                      onButtonPressed: () {},
                    ),

                    const SizedBox(height: SDeckSpace.gap16),

                    const SDeckSectionHeader(title: 'Friends'),

                    const SizedBox(height: SDeckSpace.gap8),

                    GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: SDeckSpace.gap8,
                      mainAxisSpacing: SDeckSpace.gap8,
                      // Avatar is square (full cell width) + gap4 + username 18px
                      // + indicator 16px + pb4 = ~42px of text below the avatar.
                      // 0.68 keeps cells just tall enough for the avatar+text on
                      // all common phone widths without overflow.
                      childAspectRatio: 0.68,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        SDeckFriendBlockTarget(
                          username: 'tpsoftdev',
                          indicatorText: 'In Party',
                        ),
                        SDeckFriendBlockTarget(
                          username: 'friend1',
                          indicatorText: 'Prompt\u2019d',
                        ),
                        SDeckFriendBlockTarget(
                          username: 'friend2',
                          indicatorText: 'Home',
                        ),
                        SDeckFriendBlockTarget(username: 'friend3'),
                        SDeckFriendBlockTarget(username: 'friend4'),
                        SDeckFriendBlockTarget(username: 'friend5'),
                      ],
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

