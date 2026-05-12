/*-------------------- social_page.dart -----------------------*/
// Social Page for the main app
// Displays a placeholder "Coming Soon!" message
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:go_router/go_router.dart';

class SocialPage extends ConsumerWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            SDeckSpace.padding16,
            SDeckSpace.padding16,
            SDeckSpace.padding16,
            SDeckSpace.padding16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SocialHeader(onProfileTap: () {}),

              const SizedBox(height: SDeckSpace.gap16),

              SDeckSocialActionCard(
                title: 'Find Friends',
                description: 'Search and request to be friends',
                onTap: () => context.go('/social/find-friends'),
              ),

              const SizedBox(height: SDeckSpace.gap16),

              SDeckSocialSectionHeader(
                title: 'Inbox',
                showUnreadDot: true,
                trailing: _ViewAllButton(
                  onTap: () => context.go('/social/inbox'),
                ),
              ),

              const SizedBox(height: SDeckSpace.gap8),

              SDeckSocialInviteTile(
                username: 'tpsoftdev',
                subtitle: 'invited you to Prompt’d',
                onPressed: () => context.go('/social/inbox'),
              ),

              const SizedBox(height: SDeckSpace.gap16),

              const SDeckSocialSectionHeader(title: 'Friends'),

              const SizedBox(height: SDeckSpace.gap8),

              GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: SDeckSpace.gap8,
                mainAxisSpacing: SDeckSpace.gap8,
                childAspectRatio: 0.74,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  SDeckFriendPreviewCard(
                    username: 'tpsoftdev',
                    status: 'In Party',
                  ),
                  SDeckFriendPreviewCard(
                    username: 'friend1',
                    status: 'Prompt’d',
                  ),
                  SDeckFriendPreviewCard(username: 'friend2', status: 'Home'),
                  SDeckFriendPreviewCard(username: 'friend3', status: 'Home'),
                  SDeckFriendPreviewCard(username: 'friend4', status: 'Home'),
                  SDeckFriendPreviewCard(username: 'friend5', status: 'Home'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialHeader extends StatelessWidget {
  final VoidCallback? onProfileTap;

  const _SocialHeader({this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Social',
            style: Theme.of(
              context,
            ).textTheme.h3.copyWith(color: context.component.textPrimary),
          ),
        ),
        GestureDetector(
          onTap: onProfileTap,
          child: const SDeckVisualPlaceholder(
            width: 48,
            height: 48,
            borderRadius: BorderRadius.all(
              Radius.circular(SDeckRadius.borderRadiusZero),
            ),
          ),
        ),
      ],
    );
  }
}

class _ViewAllButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _ViewAllButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            'View All',
            style: Theme.of(context).textTheme.bodyMediumFigma.copyWith(
              color: context.component.textSecondary,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(width: SDeckSpace.gap4),
          SDeckIcons(
            SDeckIcon.rightChevron,
            size: SDeckSize.size16,
            color: context.component.iconSecondary,
          ),
        ],
      ),
    );
  }
}
