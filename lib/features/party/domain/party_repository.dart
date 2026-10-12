// -----------------------------------------------------------------------------
// party_repository.dart
// Party operations consumed by Riverpod. The repository owns the signed-in UID;
// callers cannot impersonate another player by supplying an actor ID.
// -----------------------------------------------------------------------------
import 'party_models.dart';

abstract class PartyRepository {
  /// Listen for joining, leaving, kicking, or disbanding.
  Stream<String?> watchActivePartyId();

  /// Listen to public lobby data; selected card URLs are kept separately.
  Stream<Party?> watchParty(String partyId);

  Stream<List<PartyEvent>> watchEvents(String partyId);

  /// Read only the signed-in player's private cards.
  Stream<PartyHand?> watchMyHand(String partyId);

  /// Listen only to pending invitations for the current user.
  Stream<List<PartyInvitation>> watchInvitations();

  /// Create the party and claim its host's active session together.
  Future<String> createParty(String name);

  /// Join by code; an optional invitation is accepted in the same transaction.
  Future<String> joinParty(String code, String name, {String? invitationId});

  /// Leave atomically, handing host duties to the next player or closing an empty party.
  Future<void> leaveParty(String partyId);

  /// Close the party and release every member's active session.
  Future<void> disbandParty(String partyId);

  /// Save your name and character; pass null to clear the character.
  Future<void> updateIdentity(String partyId, String name, String? characterId);

  /// Host-only removal of another player.
  Future<void> kickPlayer(String partyId, String uid);

  /// Hand host privileges to an existing member.
  Future<void> promoteHost(String partyId, String uid);

  /// Save changed settings; identical settings keep current readiness.
  Future<void> selectGame(String partyId, PartyGame? game);

  /// Save owned card IDs and clear your Ready flag.
  Future<void> selectCards(String partyId, List<String> cardIds);

  /// Mark yourself ready only after selecting the required cards.
  Future<void> setReady(String partyId, bool ready);

  /// Host-only transition once everyone is ready.
  Future<void> startGame(String partyId);

  /// Create or refresh an in-app invitation for a user.
  Future<void> invitePlayer(String partyId, String recipientId);

  /// Decline an invitation addressed to you.
  Future<void> declineInvitation(String invitationId);
}

/// Adapter boundary for the separate Decks feature. Party never creates decks
/// or uploads photos. Its Firebase implementation reads the documented catalog.
abstract class PartyCardRepository {
  /// Read the signed-in user's saved deck catalog.
  Stream<List<PartyDeck>> watchDecks();

  Stream<List<PartyCard>> watchAllCards();

  /// Read cards from one of the user's decks.
  Stream<List<PartyCard>> watchCards(String deckId);
}
