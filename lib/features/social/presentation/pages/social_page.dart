/*-------------------- social_page.dart --------------------------------*/
// Social page — friends grid, inbox preview, and find friends entry point.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_invitations_list.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/party/providers/party_social_provider.dart';
import 'package:socialdeck/design_system/index.dart';

class SocialPage extends ConsumerWidget {
  const SocialPage({super.key});

  //------------------------------- Build ----------------------------------//

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      showDotIndicator:
                          ref
                              .watch(partyInvitationsProvider)
                              .asData
                              ?.value
                              .isNotEmpty ??
                          false,
                      navLinkTitle: 'View All',
                      onNavLinkTap: () => context.go('/social/inbox'),
                    ),

                    const SizedBox(height: SDeckSpace.gap8),

                    const PartyInvitationsList(showEmpty: true),

                    const SizedBox(height: SDeckSpace.gap16),

                    //------------------- Friends Grid ----------------------//
                    const SDeckSectionHeader(title: 'Friends'),

                    const SizedBox(height: SDeckSpace.gap8),

                    // IA: Social and Party invites share accepted Firebase friends.
                    // Never substitute sample people or invented presence on failure.
                    ref.watch(partyFriendsProvider).when(
                      skipLoadingOnRefresh: false,
                      loading: () => const LinearProgressIndicator(),
                      error: (_, __) => TextButton(
                        onPressed: () => ref.invalidate(partyFriendsProvider),
                        child: const Text('Could not load friends. Retry'),
                      ),
                      data: (friends) => friends.isEmpty
                          ? const Text('No friends yet. Use Find Friends to get started.')
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: SDeckSpace.gap8,
                                mainAxisSpacing: SDeckSpace.gap8,
                                childAspectRatio: 0.68,
                              ),
                              itemCount: friends.length,
                              itemBuilder: (context, index) => SDeckFriendBlockTarget(
                                key: ValueKey(friends[index].uid),
                                username: friends[index].name,
                                // Presence isn't connected yet; keep status absent.
                              ),
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
