import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import '../party.dart';
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

  Future<void> accept(PartyInvitation invite) async {
    if (choosingName || ref.read(partyActionsProvider).isLoading) return;
    setState(() => choosingName = true);
    try {
      final name = await partyNameDialog(context);
      if (!mounted || name == null) return;
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
      if (!mounted) return;
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
          error:
              (error, _) => TextButton(
                onPressed: () => ref.invalidate(partyInvitationsProvider),
                child: const Text('Could not load party invites. Retry'),
              ),
          data:
              (items) => Column(
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
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Party invitation · ${invite.partyId}'),
                            Wrap(
                              spacing: 8,
                              children: [
                                TextButton(
                                  onPressed:
                                      canJoin ? () => accept(invite) : null,
                                  child: const Text('Join'),
                                ),
                                TextButton(
                                  onPressed:
                                      busy
                                          ? null
                                          : () async {
                                            final ok = await ref
                                                .read(
                                                  partyActionsProvider.notifier,
                                                )
                                                .declineInvitation(invite.id);
                                            if (context.mounted && !ok) {
                                              partyToast(
                                                context,
                                                partyErrorMessage(
                                                  ref
                                                      .read(
                                                        partyActionsProvider,
                                                      )
                                                      .error,
                                                ),
                                              );
                                            }
                                          },
                                  child: const Text('Decline'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
        );
  }
}
