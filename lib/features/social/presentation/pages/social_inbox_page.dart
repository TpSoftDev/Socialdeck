import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

class SocialInboxPage extends ConsumerStatefulWidget {
  const SocialInboxPage({super.key});

  @override
  ConsumerState<SocialInboxPage> createState() => _SocialInboxPageState();
}

class _SocialInboxPageState extends ConsumerState<SocialInboxPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              title: 'Inbox',
              onLeftPressed: () => context.go('/social'),
            ),
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
                    const SDeckVisualPlaceholder(
                      height: 96,
                      borderRadius: BorderRadius.all(
                        Radius.circular(SDeckRadius.borderRadiusZero),
                      ),
                    ),

                    const SizedBox(height: SDeckSpace.gap8),

                    SDeckSocialTabSelector(
                      selectedIndex: _selectedTabIndex,
                      tabs: const [
                        SDeckSocialTabItem(
                          label: 'People',
                          showUnreadDot: true,
                        ),
                        SDeckSocialTabItem(
                          label: 'News',
                          showUnreadDot: true,
                        ),
                      ],
                      onTabSelected: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                    ),

                    const SizedBox(height: SDeckSpace.gap8),

                    if (_selectedTabIndex == 0)
                      const _PeopleInboxList()
                    else
                      const _NewsPlaceholder(),
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

class _PeopleInboxList extends StatelessWidget {
  const _PeopleInboxList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SDeckInboxPeopleTile(
          title: 'tpsoftdev',
          subtitle: 'invited you to Prompt’d',
          variant: SDeckInboxPeopleTileVariant.partyInvite,
          onPrimaryPressed: () {},
        ),
        const SizedBox(height: SDeckSpace.gap8),

        SDeckInboxPeopleTile(
          title: 'social',
          subtitle: 'wants to be friends',
          variant: SDeckInboxPeopleTileVariant.friendRequest,
          onRejectPressed: () {},
          onPrimaryPressed: () {},
        ),
        const SizedBox(height: SDeckSpace.gap8),

        const SDeckInboxPeopleTile(
          title: 'friend2',
          subtitle: 'is now your friend.',
          variant: SDeckInboxPeopleTileVariant.friendOnly,
        ),
        const SizedBox(height: SDeckSpace.gap8),

        const SDeckInboxPeopleTile(
          title: 'friend1',
          subtitle: 'is now your friend.',
          variant: SDeckInboxPeopleTileVariant.friendOnly,
        ),
      ],
    );
  }
}

class _NewsPlaceholder extends StatelessWidget {
  const _NewsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SDeckInboxPeopleTile(
          title: 'SD v0.2 Is Here',
          subtitle: 'Releasing version 0.2',
          variant: SDeckInboxPeopleTileVariant.friendOnly,
        ),
      ],
    );
  }
}