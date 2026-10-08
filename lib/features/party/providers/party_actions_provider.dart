// -----------------------------------------------------------------------------
// party_actions_provider.dart
// Command status, independent of server snapshots. Returns success to allow the
// page to navigate only after persistence succeeds. Prevents duplicate submits.
// -----------------------------------------------------------------------------
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/party_action_state.dart';
import '../domain/party_failure.dart';
import '../domain/party_models.dart';
import '../domain/party_repository.dart';
import 'party_providers.dart';

class PartyActionsNotifier extends StateNotifier<PartyActionState> {
  PartyActionsNotifier(this._repository) : super(const PartyActionState());
  final PartyRepository _repository;

  void reset() {
    if (!state.isLoading) state = const PartyActionState();
  }

  // Ignore double taps and do not update a page that has already been disposed.
  Future<bool> _submit(Future<String?> Function() action) async {
    if (!mounted || state.isLoading) return false;
    state = const PartyActionState(status: PartyAsyncStatus.loading);
    try {
      final id = await action();
      if (!mounted) return false;
      state = PartyActionState(status: PartyAsyncStatus.success, partyId: id);
      return true;
    } catch (error) {
      if (mounted) {
        state = PartyActionState(
          status: PartyAsyncStatus.failure,
          error: error is PartyFailure ? error.code : PartyError.unknown,
        );
      }
      return false;
    }
  }

  Future<bool> _command(Future<void> Function() command) => _submit(() async {
    await command();
    return null;
  });

  Future<bool> createParty(String name) =>
      _submit(() => _repository.createParty(name));
  Future<bool> joinParty(String code, String name) =>
      _submit(() => _repository.joinParty(code, name));
  Future<bool> acceptInvitation(PartyInvitation invitation, String name) =>
      _submit(
        () => _repository.joinParty(
          invitation.partyId,
          name,
          invitationId: invitation.id,
        ),
      );
  Future<bool> leaveParty(String id) =>
      _command(() => _repository.leaveParty(id));
  Future<bool> disbandParty(String id) =>
      _command(() => _repository.disbandParty(id));
  Future<bool> updateIdentity(String id, String name, String? characterId) =>
      _command(() => _repository.updateIdentity(id, name, characterId));
  Future<bool> kickPlayer(String id, String uid) =>
      _command(() => _repository.kickPlayer(id, uid));
  Future<bool> promoteHost(String id, String uid) =>
      _command(() => _repository.promoteHost(id, uid));
  Future<bool> selectGame(String id, PartyGame? game) =>
      _command(() => _repository.selectGame(id, game));
  Future<bool> selectCards(String id, List<String> cardIds) =>
      _command(() => _repository.selectCards(id, cardIds));
  Future<bool> setReady(String id, bool ready) =>
      _command(() => _repository.setReady(id, ready));
  Future<bool> startGame(String id) =>
      _command(() => _repository.startGame(id));
  Future<bool> invitePlayer(String id, String uid) =>
      _command(() => _repository.invitePlayer(id, uid));
  Future<bool> declineInvitation(String id) =>
      _command(() => _repository.declineInvitation(id));
}

final partyActionsProvider =
    StateNotifierProvider.autoDispose<PartyActionsNotifier, PartyActionState>(
      (ref) => PartyActionsNotifier(ref.watch(partyRepositoryProvider)),
    );
