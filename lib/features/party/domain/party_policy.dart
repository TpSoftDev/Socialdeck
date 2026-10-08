// -----------------------------------------------------------------------------
// party_policy.dart
// Pure Party transition logic reused by repositories and covered by unit tests.
// Firestore rules independently enforce authorization for untrusted clients.
// -----------------------------------------------------------------------------
import 'party_failure.dart';
import 'party_models.dart';

class PartyPolicy {
  const PartyPolicy._();

  /// Trim user input before checking the display-name length.
  static String cleanName(String value) {
    final name = value.trim();
    requireParty(name.isNotEmpty && name.length <= 24, PartyError.invalidInput);
    return name;
  }

  /// Keep join-code validation in one place.
  static String cleanCode(String value) {
    final code = value.trim();
    requireParty(RegExp(r'^\d{6}$').hasMatch(code), PartyError.invalidInput);
    return code;
  }

  /// Only current members may change a party.
  static void member(Party party, String uid) {
    requireParty(party.members.containsKey(uid), PartyError.forbidden);
    requireParty(party.phase != PartyPhase.closed, PartyError.closed);
  }

  /// Use this check before every host-only action.
  static void host(Party party, String uid) {
    PartyPolicy.member(party, uid);
    requireParty(party.hostId == uid, PartyError.forbidden);
  }

  /// Card and settings changes stop when the game starts.
  static void lobby(Party party) {
    requireParty(party.phase == PartyPhase.lobby, PartyError.closed);
  }

  /// Add one player without changing the existing snapshot.
  static Party join(Party party, String uid, String name) {
    lobby(party);
    requireParty(!party.members.containsKey(uid), PartyError.alreadyInParty);
    requireParty(party.members.length < Party.maxPlayers, PartyError.full);
    return party.copyWith(
      members: {
        ...party.members,
        uid: PartyMember(uid: uid, name: cleanName(name)),
      },
    );
  }

  /// A host must transfer ownership before leaving.
  static Party remove(Party party, String actor, String target) {
    member(party, actor);
    requireParty(party.members.containsKey(target), PartyError.notFound);
    if (actor != target) host(party, actor);
    requireParty(target != party.hostId, PartyError.hostMustTransfer);
    final members = Map<String, PartyMember>.of(party.members)..remove(target);
    return party.copyWith(members: members);
  }

  /// All signed-in members can host the free beta; preserve server join order.
  static Party leave(Party party, String uid) {
    member(party, uid);
    if (party.hostId != uid) return remove(party, uid, uid);
    if (party.members.length == 1) return disband(party, uid);
    final remaining = Map<String, PartyMember>.of(party.members)..remove(uid);
    return party.copyWith(hostId: remaining.keys.first, members: remaining);
  }

  /// Transfer ownership to someone already in the party.
  static Party promote(Party party, String actor, String target) {
    host(party, actor);
    requireParty(party.members.containsKey(target), PartyError.notFound);
    return party.copyWith(hostId: target);
  }

  /// Change a player's display name or character, keeping their cards.
  static Party identity(
    Party party,
    String uid,
    String name,
    String? character,
  ) {
    PartyPolicy.member(party, uid);
    requireParty(
      character == null || (character.isNotEmpty && character.length <= 64),
      PartyError.invalidInput,
    );
    return party.copyWith(
      members: {
        ...party.members,
        uid: party.members[uid]!.withIdentity(cleanName(name), character),
      },
    );
  }

  /// Changed settings make old card selections and Ready flags stale.
  static Party selectGame(Party party, String actor, PartyGame? game) {
    host(party, actor);
    lobby(party);
    game?.validate();
    if (party.game == game) return party; // Preserve cards and readiness.
    // A new revision invalidates every previous selection/readiness without
    // rewriting each private hand.
    return party.copyWith(
      game: game,
      clearGame: game == null,
      revision: party.revision + 1,
    );
  }

  /// Allow a partial selection, but clear Ready whenever cards change.
  static Party selectCards(Party party, String uid, List<PartyCard> cards) {
    PartyPolicy.member(party, uid);
    lobby(party);
    final game = party.game;
    requireParty(game != null, PartyError.noGame);
    requireParty(
      cards.length <= game!.requiredCards &&
          cards.map((c) => c.id).toSet().length == cards.length &&
          cards.every((c) => c.id.isNotEmpty && c.deckId.isNotEmpty),
      PartyError.invalidCards,
    );
    return party.copyWith(
      members: {
        ...party.members,
        uid: party.members[uid]!.withSelection(cards.length, party.revision),
      },
    );
  }

  /// A player needs a full, current selection before becoming ready.
  static Party setReady(Party party, String uid, bool ready) {
    PartyPolicy.member(party, uid);
    lobby(party);
    final member = party.members[uid]!;
    if (ready) {
      requireParty(party.game != null, PartyError.noGame);
      requireParty(
        member.cardCount == party.game!.requiredCards &&
            member.selectionRevision == party.revision,
        PartyError.invalidCards,
      );
    }
    return party.copyWith(
      members: {
        ...party.members,
        uid: member.withSelection(
          member.cardCount,
          member.selectionRevision,
          ready: ready,
        ),
      },
    );
  }

  /// Start only when every player is ready.
  static Party start(Party party, String actor) {
    host(party, actor);
    requireParty(party.canStart, PartyError.notReady);
    return party.copyWith(phase: PartyPhase.playing);
  }

  /// Close the party; the repository also clears its active sessions.
  static Party disband(Party party, String actor) {
    host(party, actor);
    return party.copyWith(phase: PartyPhase.closed);
  }
}
