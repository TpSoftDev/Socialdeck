import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import '../party.dart';
import '../providers/party_social_provider.dart';
import 'party_feedback.dart';

/// Home and Social share invitation state, validation and actions.
class PartyInvitationsList extends ConsumerStatefulWidget {
  const PartyInvitationsList({super.key, this.showEmpty = false});
  final bool showEmpty;
  @override
  ConsumerState<PartyInvitationsList> createState() =>
      _PartyInvitationsListState();
}

class _PartyInvitationsListState extends ConsumerState<PartyInvitationsList> {
  bool choosingName = false;

  String invitationTitle(PartyInvitation invite) {
    // IA: Resolve by sender UID, never by the current host (ownership can change).
    // Accepted-friend usernames take priority; otherwise use the sender's party
    // name. Missing/loading/denied data must not hide or block the invitation.
    final friends = ref.watch(partyFriendsProvider).asData?.value ?? [];
    String? name;
    for (final friend in friends) {
      if (friend.uid == invite.senderId && friend.name.trim().isNotEmpty) {
        name = friend.name.trim();
        break;
      }
    }
    name ??= ref.watch(partyByIdProvider(invite.partyId))
        .asData?.value?.members[invite.senderId]?.name.trim();
    // TODO(frontend, IA): Review long sender names in this existing tile.
    // Sender/fallback wiring is implemented; layout changes are deferred.
    return name == null || name.isEmpty
        ? 'Party invitation'
        : '$name invited you';
  }

  bool invitationAvailable(
    AsyncValue<List<PartyInvitation>> snapshot,
    String? viewer,
    String actor,
    PartyInvitation invite,
  ) =>
      viewer == actor &&
      !snapshot.isLoading &&
      !snapshot.hasError &&
      (snapshot.asData?.value.any(
            (item) =>
                item.id == invite.id &&
                item.partyId == invite.partyId &&
                item.recipientId == actor &&
                item.status == PartyInvitationStatus.pending,
          ) ??
          false);

  Future<void> accept(PartyInvitation invite) async {
    if (choosingName || ref.read(partyActionsProvider).isLoading) return;
    final actor = ref.read(currentUserProvider)?.uid;
    if (actor == null ||
        !invitationAvailable(
          ref.read(partyInvitationsProvider),
          actor,
          actor,
          invite,
        )) {
      return;
    }
    setState(() => choosingName = true);
    try {
      // The dialog can outlive its invitation or the account that opened it.
      final name = await partyNameDialog(
        context,
        canSubmit: (dialogRef) => invitationAvailable(
          dialogRef.watch(partyInvitationsProvider),
          dialogRef.watch(currentUserProvider)?.uid,
          actor,
          invite,
        ),
      );
      if (!mounted ||
          name == null ||
          !invitationAvailable(
            ref.read(partyInvitationsProvider),
            ref.read(currentUserProvider)?.uid,
            actor,
            invite,
          )) {
        return;
      }
      // Membership may change while the name dialog is open.
      final current = ref.read(activePartyProvider);
      if (current.isLoading ||
          current.hasError ||
          !current.hasValue ||
          (current.asData?.value != null &&
              current.asData!.value!.phase != PartyPhase.closed)) {
        partyToast(
          context,
          'Return to your current party or retry the party connection before joining.',
        );
        return;
      }
      final ok = await ref
          .read(partyActionsProvider.notifier)
          .acceptInvitation(invite, name);
      if (!mounted || ref.read(currentUserProvider)?.uid != actor) return;
      if (ok) {
        context.go('/home/party/${invite.partyId}');
      } else {
        partyToast(
          context,
          partyErrorMessage(ref.read(partyActionsProvider).error),
        );
      }
    } finally {
      if (mounted) setState(() => choosingName = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(currentUserProvider) == null) {
      return widget.showEmpty
          ? const Text('Sign in to view party invitations.')
          : const SizedBox.shrink();
    }
    final actions = ref.watch(partyActionsProvider);
    final active = ref.watch(activePartyProvider);
    final party = active.asData?.value;
    final busy = choosingName || actions.isLoading;
    final canJoin =
        !busy &&
        active.hasValue &&
        !active.isLoading &&
        !active.hasError &&
        (party == null || party.phase == PartyPhase.closed);
    return ref
        .watch(partyInvitationsProvider)
        .when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) => TextButton(
            onPressed: () => ref.invalidate(partyInvitationsProvider),
            child: const Text('Could not load party invites. Retry'),
          ),
          data: (items) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (items.isEmpty && widget.showEmpty)
                const Text('No pending party invitations.'),
              if (items.isNotEmpty &&
                  party != null &&
                  party.phase != PartyPhase.closed)
                const Text(
                  'Leave your current party before accepting another invitation.',
                ),
              if (items.isNotEmpty && active.hasError)
                TextButton(
                  onPressed: () => retryPartySession(ref),
                  child: const Text('Retry party connection'),
                ),
              for (final invite in items)
                SDeckInboxPeopleTile(
                  title: invitationTitle(invite),
                  subtitle: 'Party ${invite.partyId}',
                  variant: SDeckInboxPeopleTileVariant.partyInvite,
                  showReject: true,
                  onPrimaryPressed: canJoin ? () => accept(invite) : null,
                  onRejectPressed: busy
                      ? null
                      : () async {
                          final ok = await ref
                              .read(partyActionsProvider.notifier)
                              .declineInvitation(invite.id);
                          if (context.mounted && !ok) {
                            partyToast(
                              context,
                              partyErrorMessage(
                                ref.read(partyActionsProvider).error,
                              ),
                            );
                          }
                        },
                ),
            ],
          ),
        );
  }
}
