// -----------------------------------------------------------------------------
// party_action_state.dart
// State of a submitted command, separate from the live lobby snapshot.
// UI can map the error enum to screen-specific messages in a later pass.
// -----------------------------------------------------------------------------
import 'party_failure.dart';

enum PartyAsyncStatus { idle, loading, success, failure }

class PartyActionState {
  const PartyActionState({
    this.status = PartyAsyncStatus.idle,
    this.error,
    this.partyId,
  });
  final PartyAsyncStatus status;
  final PartyError? error;
  final String? partyId;
  bool get isLoading => status == PartyAsyncStatus.loading;
}
