import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/home/presentation/dialogs/home_party_flow_dialogs.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import '../party.dart';
import 'party_feedback.dart';
import 'party_invitations_list.dart';

/// Home subscribes to membership instead of relying on navigation extras.
class PartyHomeControls extends ConsumerStatefulWidget {
  const PartyHomeControls({super.key});

  @override
  ConsumerState<PartyHomeControls> createState() => _PartyHomeControlsState();
}

class _PartyHomeControlsState extends ConsumerState<PartyHomeControls> {
  bool _flowOpen = false;

  Future<void> submit(
    BuildContext context,
    WidgetRef ref,
    Future<bool> Function(PartyActionsNotifier) action,
  ) async {
    final ok = await action(ref.read(partyActionsProvider.notifier));
    if (!context.mounted) return;
    final state = ref.read(partyActionsProvider);
    if (ok && state.partyId != null) {
      // Dev Tools sits outside the main shell; replace it instead of duplicating it.
      context.go('/home/party/${state.partyId}');
    } else if (!ok) {
      partyToast(context, partyErrorMessage(state.error));
    }
  }

  Future<void> openPartyFlow(
    BuildContext context,
    WidgetRef ref, {
    required bool joining,
  }) async {
    if (_flowOpen) return;
    // One modal flow at a time, including the leave confirmation and forms.
    _flowOpen = true;
    try {
      await _openPartyFlow(context, ref, joining: joining);
    } finally {
      _flowOpen = false;
    }
  }

  Future<void> _openPartyFlow(
    BuildContext context,
    WidgetRef ref, {
    required bool joining,
  }) async {
    final active = ref.read(activePartyProvider);
    if (ref.read(partyActionsProvider).isLoading) {
      partyToast(context, 'Please wait for your current party action.');
      return;
    }
    if (!active.hasValue || active.isLoading || active.hasError) {
      partyToast(
        context,
        active.hasError
            ? 'Could not load your party. Tap Retry party connection.'
            : 'Your party is still loading. Please try again shortly.',
      );
      return;
    }
    final party = active.asData?.value;
    if (party != null && party.phase != PartyPhase.closed) {
      final actor = ref.read(currentUserProvider)?.uid;
      LeavePartyDialogChoice? choice;
      // Use the same Home dialog as the team's frontend preview.
      await HomePartyFlowDialogs.showLeavePartyThen(context,
        canDisband: actor == party.hostId,
        onLeaveParty: () => choice = LeavePartyDialogChoice.leave,
        onDisbandParty: () => choice = LeavePartyDialogChoice.disband,
      );
      if (choice == null || !context.mounted ||
          ref.read(currentUserProvider)?.uid != actor) {
        return;
      }
      final latest = ref.read(activePartyProvider);
      final current = latest.asData?.value;
      if (latest.isLoading || latest.hasError || current?.id != party.id ||
          (choice == LeavePartyDialogChoice.disband && current?.hostId != actor)) {
        return;
      }
      // Only continue after the selected operation succeeds.
      final actions = ref.read(partyActionsProvider.notifier);
      final ok = choice == LeavePartyDialogChoice.disband
          ? await actions.disbandParty(party.id)
          : await actions.leaveParty(party.id);
      if (!context.mounted) return;
      if (!ok) {
        partyToast(
          context,
          partyErrorMessage(ref.read(partyActionsProvider).error),
        );
        return;
      }
      if (choice == LeavePartyDialogChoice.disband) return;
    }
    if (!context.mounted) return;
    if (joining) {
      await HomePartyFlowDialogs.showJoinPartyFlow(
        context,
        onJoinCompleted:
            (ctx, name, code) =>
                submit(ctx, ref, (a) => a.joinParty(code, name)),
      );
    } else {
      await HomePartyFlowDialogs.showCreatePartyLetsBegin(
        context,
        onNamedComplete:
            (ctx, name) => submit(ctx, ref, (a) => a.createParty(name)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(currentUserProvider) == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Sign in to create or join a party.'),
      );
    }
    final active = ref.watch(activePartyProvider);
    final actions = ref.watch(partyActionsProvider);

    final party = active.asData?.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (actions.isLoading || active.isLoading)
          const LinearProgressIndicator(),
        if (active.hasError) ...[
          Text(partyErrorMessage(active.error)),
          TextButton(
            onPressed: () => retryPartySession(ref),
            child: const Text('Retry party connection'),
          ),
        ],
        if (party != null && party.phase != PartyPhase.closed) ...[
          SDeckSelectionTargetCard(
            title: "${party.members[party.hostId]?.name ?? 'Your'}'s Party",
            description:
                party.game == null
                    ? 'No game selected · ${party.members.length}/8'
                    : "Prompt'd · ${party.phase == PartyPhase.playing ? 'In game' : 'Lobby'}",
            backgroundAssetPath: SDeckIcon.checkeredBackground,
            onTap: () => context.go('/home/party/${party.id}'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Return to your party to leave or disband before creating another.',
          ),
        ],
        SDeckSelectionTargetCard(
          title: 'Create Party',
          description: 'Start a new game',
          backgroundAssetPath: SDeckIcon.checkeredBackground,
          onTap: () => openPartyFlow(context, ref, joining: false),
        ),
        const SizedBox(height: 8),
        SDeckSelectionTargetCard(
          title: 'Join a Party',
          description: 'Insert a game code',
          backgroundAssetPath: SDeckIcon.checkeredBackground,
          onTap: () => openPartyFlow(context, ref, joining: true),
        ),
        const PartyInvitationsList(),
      ],
    );
  }
}
