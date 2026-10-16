import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/features/games/data/mock_game_setup_repository.dart';
import 'package:socialdeck/features/games/domain/game_setup_state.dart';
import 'package:socialdeck/features/games/domain/games_include.dart';
import 'package:socialdeck/features/games/presentation/pages/prompt_settings_page.dart';
import 'package:socialdeck/features/games/providers/game_setup_provider.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import '../party.dart';
import 'party_feedback.dart';

// A route-local draft keeps cancelled edits out of the team's setup provider.
class _PartySettingsDraft extends GameSetupNotifier {
  _PartySettingsDraft(PartyGame? game) : super(MockGameSetupRepository()) {
    state = GameSetupState(
      gameSelection: GameChoice.Promptd,
      rounds: game?.rounds ?? 3,
      mixCards: game?.mixCards ?? false,
      safeMode: game?.safeMode ?? false,
    );
  }
}

/// Reuses the team's settings UI and saves through the real Party repository.
class PartySettingsPage extends StatelessWidget {
  const PartySettingsPage({
    super.key,
    required this.party,
    required this.actorId,
  });
  final Party party;
  final String actorId;

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [
      gameSetupProvider.overrideWith((ref) => _PartySettingsDraft(party.game)),
    ],
    child: _PartySettingsBody(party: party, actorId: actorId),
  );
}

class _PartySettingsBody extends ConsumerStatefulWidget {
  const _PartySettingsBody({required this.party, required this.actorId});
  final Party party;
  final String actorId;

  @override
  ConsumerState<_PartySettingsBody> createState() => _PartySettingsBodyState();
}

class _PartySettingsBodyState extends ConsumerState<_PartySettingsBody> {
  bool saving = false;

  bool canEdit(AsyncValue<Party?> snapshot, String? uid) {
    final current = snapshot.asData?.value;
    return !snapshot.isLoading &&
        !snapshot.hasError &&
        uid == widget.actorId &&
        current != null &&
        current.hostId == uid &&
        current.members.containsKey(uid) &&
        current.phase == PartyPhase.lobby &&
        current.revision == widget.party.revision;
  }

  Future<void> save() async {
    // A previously captured button callback must also recheck current rights.
    if (!mounted ||
        saving ||
        !canEdit(
          ref.read(partyByIdProvider(widget.party.id)),
          ref.read(currentUserProvider)?.uid,
        ) ||
        ref.read(partyActionsProvider).isLoading) {
      return;
    }
    final draft = ref.read(gameSetupProvider);
    final game = PartyGame(
      rounds: draft.rounds,
      mixCards: draft.mixCards,
      safeMode: draft.safeMode,
    );
    setState(() => saving = true);
    final actions = ref.read(partyActionsProvider.notifier);
    final succeeded = await actions.selectGame(
      widget.party.id,
      game,
      expectedRevision: widget.party.revision,
    );
    if (!mounted) return;
    setState(() => saving = false);
    // Signing out disposes the old action provider; never read its replacement.
    if (ref.read(currentUserProvider)?.uid != widget.actorId) return;
    if (succeeded) {
      Navigator.of(context).pop(true);
    } else {
      partyToast(
        context,
        partyErrorMessage(ref.read(partyActionsProvider).error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(partyByIdProvider(widget.party.id));
    final uid = ref.watch(currentUserProvider)?.uid;
    final allowed = canEdit(snapshot, uid);
    // Keep the action provider observed while a save is pending.
    final actionState = ref.watch(partyActionsProvider);
    final busy = saving || (uid != null && actionState.isLoading);
    return PopScope(
      canPop: !saving,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!allowed)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    snapshot.hasError
                        ? 'Could not load the party. Return and retry the connection.'
                        : 'The party changed. Return to the lobby before editing settings.',
                  ),
                ),
              if (busy) const LinearProgressIndicator(),
              Expanded(
                child: AbsorbPointer(
                  absorbing: !allowed || busy,
                  child: PromptSettingsPage(
                    enabled: allowed && !busy,
                    onBackToParty: save,
                    onCancel: saving ? null : () => Navigator.of(context).pop(),
                    // AI setup remains owned by the games feature. Its mock
                    // generation actions must not run from a live Party lobby.
                    showCustomSettings: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
