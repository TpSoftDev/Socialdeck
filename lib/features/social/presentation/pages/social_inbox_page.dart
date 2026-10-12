/*-------------------- social_inbox_page.dart -------------------------*/
// Social Inbox page — People and News notification tabs.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_invitations_list.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

//========================= SocialInboxPage ===================================//
class SocialInboxPage extends ConsumerStatefulWidget {
  const SocialInboxPage({super.key});

  @override
  ConsumerState<SocialInboxPage> createState() => _SocialInboxPageState();
}

class _SocialInboxPageState extends ConsumerState<SocialInboxPage> {
  int tab = 0;
  //------------------------------- Build ------------------------------------//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ----------------------//
            SDeckTopNavigationBar(
              type: SDeckTopBarType.subpage,
              left: SDeckTopBarLeft.back,
              title: 'Inbox',
              right: SDeckTopBarRight.profile,
              onLeftPressed: () => context.go('/social'),
            ),

            //------------------------ Scrollable Content ------------------//
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  SDeckSpace.padding16,
                  SDeckSpace.paddingZero,
                  SDeckSpace.padding16,
                  SDeckSpace.padding16,
                ),
                child: Column(
                  children: [
                    //------------------- Rive Animation ------------------//
                    AspectRatio(
                      aspectRatio: 370 / 92.5,
                      child: const SDeckVisualPlaceholder(),
                    ),

                    const SizedBox(height: SDeckSpace.gap12),

                    SDeckSocialTabSelector(
                      selectedIndex: tab,
                      tabs: [
                        SDeckSocialTabItem(
                          label: 'People',
                          showUnreadDot:
                              ref
                                  .watch(partyInvitationsProvider)
                                  .asData
                                  ?.value
                                  .isNotEmpty ??
                              false,
                          dotColor: SDeckDotIndicatorColor.blue,
                        ),
                        SDeckSocialTabItem(
                          label: 'News',
                          showUnreadDot: false,
                          dotColor: SDeckDotIndicatorColor.blue,
                        ),
                      ],
                      onTabSelected: (index) => setState(() => tab = index),
                    ),

                    const SizedBox(height: SDeckSpace.gap12),

                    //------------------- New Mail List -------------------//
                    if (tab == 0)
                      const PartyInvitationsList(showEmpty: true)
                    else
                      const Text('No news available.'),

                    const SizedBox(height: SDeckSpace.gap12),

                    //------------------- Old Mail List -------------------//
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
