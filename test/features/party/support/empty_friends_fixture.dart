import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/features/party/providers/party_social_provider.dart';

/// Hey team: this is the real invite screen with zero friends. Please refine
/// the empty-state copy/design here through the shared screen, so it also
/// updates the normal app. Keep code sharing available and Invite disabled. - IA
class EmptyFriendsDevPreview extends StatelessWidget {
  const EmptyFriendsDevPreview({super.key});

  @override
  Widget build(BuildContext context) => ProviderScope(
    // Scoped to this preview: never removes or writes Firebase friendships.
    overrides: [
      partyFriendsProvider.overrideWith((ref) => Stream.value(const [])),
    ],
    child: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text('Dev preview: no friends • sample code 123456'),
        ),
        Flexible(child: PartyInviteSheet(partyId: '123456')),
      ],
    ),
  );
}
