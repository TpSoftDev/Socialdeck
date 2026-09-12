/*-------------------- social_page.dart --------------------------------*/
// Social page — friends grid, inbox preview, and find friends entry point.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  //---------------------------- Placeholders ------------------------------//

  // TODO(backend): Replace with your inbox provider list.
  static const _inboxPlaceholders = [
    ('tpsoftdev', 'invited you to Prompt\u2019d'),
    ('kingsley99', 'invited you to Cards Night'),
    ('zara_plays', 'wants to be your friend'),
    ('devmike', 'invited you to a Party'),
  ];

  // TODO(backend): Replace with your friends provider list.
  static const _friendsPlaceholders = [
    ('tpsoftdev', 'In Party'),
    ('kingsley99', 'Prompt\u2019d'),
    ('zara_plays', 'Home'),
    ('devmike', 'In Party'),
    ('nova_j', null),
    ('coolbeanz', null),
    ('ace_twenty', 'Home'),
    ('blitz_k', null),
    ('mxrcy', null),
  ];

  //------------------------------- Build ----------------------------------//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.none,
              type: SDeckTopBarType.page,
              right: SDeckTopBarRight.profile,
              title: 'Social',
            ),

            //------------------------ Scrollable Content -------------------//
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  SDeckSpace.padding16,
                  SDeckSpace.paddingZero,
                  SDeckSpace.padding16,
                  SDeckSpace.padding16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //------------------- Find Friends Entry -----------------//
                    SDeckImageTarget(
                      title: 'Find Friends',
                      description: 'Search and request to be friends',
                      onTap: () => context.go('/social/find-friends'),
                    ),

                    const SizedBox(height: SDeckSpace.gap16),

                    //------------------- Inbox Preview ---------------------//
                    SDeckSectionHeader(
                      title: 'Inbox',
                      // TODO(backend): Drive showDotIndicator from unread count > 0.
                      showDotIndicator: true,
                      navLinkTitle: 'View All',
                      onNavLinkTap: () => context.go('/social/inbox'),
                    ),

                    const SizedBox(height: SDeckSpace.gap8),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _inboxPlaceholders.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: SDeckSpace.gap8),
                      itemBuilder: (context, index) => SDeckBasicTarget(
                        cardType: SDeckBasicTargetCardType.button,
                        title: _inboxPlaceholders[index].$1,
                        description: _inboxPlaceholders[index].$2,
                        buttonLabel: 'Join',
                        onTap: () {},
                        onButtonPressed: () {},
                      ),
                    ),

                    const SizedBox(height: SDeckSpace.gap16),

                    //------------------- Friends Grid ----------------------//
                    const SDeckSectionHeader(title: 'Friends'),

                    const SizedBox(height: SDeckSpace.gap8),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: SDeckSpace.gap8,
                        mainAxisSpacing: SDeckSpace.gap8,
                        childAspectRatio: 0.68,
                      ),
                      itemCount: _friendsPlaceholders.length,
                      itemBuilder: (context, index) => SDeckFriendBlockTarget(
                        username: _friendsPlaceholders[index].$1,
                        indicatorText: _friendsPlaceholders[index].$2,
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
