/*-------------------- social_inbox_page.dart -------------------------*/
// Social Inbox page — People and News notification tabs.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

//========================= SocialInboxPage ===================================//
class SocialInboxPage extends StatelessWidget {
  const SocialInboxPage({super.key});

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

                    // TODO(backend): Convert to ConsumerStatefulWidget.
                    // Drive selectedIndex from your inbox provider and wire
                    // onTabSelected to switch between People and News tabs.
                    //------------------- Tab Selector -------------------//
                    SDeckSocialTabSelector(
                      selectedIndex: 0,
                      tabs: const [
                        SDeckSocialTabItem(
                          label: 'People',
                          showUnreadDot: true,
                          dotColor: SDeckDotIndicatorColor.blue,
                        ),
                        SDeckSocialTabItem(
                          label: 'News',
                          showUnreadDot: true,
                          dotColor: SDeckDotIndicatorColor.blue,
                        ),
                      ],
                      onTabSelected: (_) {},
                    ),

                    const SizedBox(height: SDeckSpace.gap12),

                    //------------------- New Mail List -------------------//
                    // TODO(backend): Replace with a ListView built from the
                    // inbox provider's new mail stream (max 3 visible).
                    const _NewMailList(),

                    const SizedBox(height: SDeckSpace.gap12),

                    //------------------- Old Mail List -------------------//
                    // TODO(backend): Replace with a paginated ListView built
                    // from the inbox provider's old mail list (10 per page).
                    const _OldMailList(),
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

//========================= _NewMailList ======================================//
// New, unactioned inbox items — max 3 visible at once.
class _NewMailList extends StatelessWidget {
  const _NewMailList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TODO(backend): Populate from new mail list — invite type.
        SDeckSwipableTarget(
          onDelete: () {}, // TODO(backend): Dispatch delete notification action.
          child: SDeckBasicTarget(
            cardType: SDeckBasicTargetCardType.button,
            title: 'tpsoftdev',
            description: 'invited you to Prompt\u2019d',
            buttonLabel: 'Join',
            onButtonPressed: () {},
          ),
        ),

        const SizedBox(height: SDeckSpace.gap8),

        // TODO(backend): Populate from new mail list — friend request type.
        SDeckSwipableTarget(
          onDelete: () {}, // TODO(backend): Dispatch delete notification action.
          child: SDeckBasicTarget(
            cardType: SDeckBasicTargetCardType.buttonOrNot,
            title: 'sodie1',
            description: 'wants to be friends',
            buttonLabel: 'Accept',
            onButtonPressed: () {}, // TODO(backend): Dispatch accept friend request action.
            onDismiss: () {}, // TODO(backend): Dispatch decline friend request action.
          ),
        ),
      ],
    );
  }
}

//========================= _OldMailList ======================================//
// Previously actioned or expired inbox items.
class _OldMailList extends StatelessWidget {
  const _OldMailList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TODO(backend): Populate from old mail list.
        SDeckSwipableTarget(
          onDelete: () {}, // TODO(backend): Dispatch delete notification action.
          child: SDeckBasicTarget(
            cardType: SDeckBasicTargetCardType.time,
            state: SDeckBasicTargetState.note,
            title: 'friend2',
            description: 'is now your friend.',
            timestamp: '1h',
          ),
        ),

        const SizedBox(height: SDeckSpace.gap8),

        // TODO(backend): Populate from old mail list.
        SDeckSwipableTarget(
          onDelete: () {}, // TODO(backend): Dispatch delete notification action.
          child: SDeckBasicTarget(
            cardType: SDeckBasicTargetCardType.time,
            state: SDeckBasicTargetState.note,
            title: 'friend1',
            description: 'is now your friend.',
            timestamp: '3d',
          ),
        ),
      ],
    );
  }
}
