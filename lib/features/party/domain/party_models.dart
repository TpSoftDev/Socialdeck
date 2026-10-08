// -----------------------------------------------------------------------------
// party_models.dart
// Immutable Party snapshots and value objects, independent of Flutter/Firebase.
// Private card selections are deliberately excluded from public lobby members.
// -----------------------------------------------------------------------------
import 'party_failure.dart';

enum PartyPhase { lobby, playing, closed }

enum PartyInvitationStatus { pending, accepted, declined }

class PartyGame {
  const PartyGame({
    this.id = 'promptd',
    this.rounds = 3,
    this.requiredCards = 7,
    this.mixCards = false,
    this.safeMode = false,
  });
  final String id;
  final int rounds;
  final int requiredCards;
  final bool mixCards;
  final bool safeMode;

  // Compare values so saving unchanged settings does not reset everyone's Ready.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartyGame &&
          id == other.id &&
          rounds == other.rounds &&
          requiredCards == other.requiredCards &&
          mixCards == other.mixCards &&
          safeMode == other.safeMode;

  @override
  int get hashCode =>
      Object.hash(id, rounds, requiredCards, mixCards, safeMode);

  /// Reject settings that the current game does not support.
  void validate() {
    requireParty(
      id == 'promptd' && rounds >= 1 && rounds <= 5 && requiredCards == 7,
      PartyError.invalidInput,
    );
  }
}

class PartyMember {
  const PartyMember({
    required this.uid,
    required this.name,
    this.characterId,
    this.cardCount = 0,
    this.selectionRevision = -1,
    this.ready = false,
  });
  final String uid;
  final String name;
  final String? characterId;
  final int cardCount;
  final int selectionRevision;
  final bool ready;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartyMember &&
          uid == other.uid &&
          name == other.name &&
          characterId == other.characterId &&
          cardCount == other.cardCount &&
          selectionRevision == other.selectionRevision &&
          ready == other.ready;

  @override
  int get hashCode =>
      Object.hash(uid, name, characterId, cardCount, selectionRevision, ready);

  PartyMember withIdentity(String name, String? characterId) => PartyMember(
    uid: uid,
    name: name,
    characterId: characterId,
    cardCount: cardCount,
    selectionRevision: selectionRevision,
    ready: ready,
  );

  PartyMember withSelection(int count, int revision, {bool ready = false}) =>
      PartyMember(
        uid: uid,
        name: name,
        characterId: characterId,
        cardCount: count,
        selectionRevision: revision,
        ready: ready,
      );
}

class Party {
  Party({
    required this.id,
    required this.hostId,
    required Map<String, PartyMember> members,
    this.phase = PartyPhase.lobby,
    this.game,
    this.revision = 0,
  }) : members = Map.unmodifiable(members);
  static const maxPlayers = 8;
  static const minPlayers = 2;
  final String id;
  String get code => id;
  final String hostId;
  final Map<String, PartyMember> members;
  final PartyPhase phase;
  final PartyGame? game;
  final int revision;

  /// A saved Ready flag counts only for the current settings version.
  bool isReady(String uid) {
    final member = members[uid];
    return game != null &&
        member != null &&
        member.ready &&
        member.selectionRevision == revision &&
        member.cardCount == game!.requiredCards;
  }

  bool get canStart =>
      phase == PartyPhase.lobby &&
      game != null &&
      members.length >= minPlayers &&
      members.keys.every(isReady);

  Party copyWith({
    String? hostId,
    Map<String, PartyMember>? members,
    PartyPhase? phase,
    PartyGame? game,
    int? revision,
    bool clearGame = false,
  }) => Party(
    id: id,
    hostId: hostId ?? this.hostId,
    members: members ?? this.members,
    phase: phase ?? this.phase,
    game: clearGame ? null : game ?? this.game,
    revision: revision ?? this.revision,
  );
}

class PartyCard {
  const PartyCard({
    required this.id,
    required this.deckId,
    required this.imageUrl,
  });
  final String id;
  final String deckId;
  final String imageUrl;
}

class PartyDeck {
  const PartyDeck({
    required this.id,
    required this.name,
    this.favorite = false,
  });
  final bool favorite;
  final String id;
  final String name;
}

class PartyHand {
  PartyHand({required Iterable<PartyCard> cards, required this.revision})
    : cards = List.unmodifiable(cards);
  final List<PartyCard> cards;
  final int revision;
}

class PartyEvent {
  const PartyEvent({required this.id, required this.type, required this.name});
  final String id;
  final String type;
  final String name;
}

class PartyInvitation {
  const PartyInvitation({
    required this.id,
    required this.partyId,
    required this.senderId,
    required this.recipientId,
    required this.status,
  });
  final String id;
  final String partyId;
  final String senderId;
  final String recipientId;
  final PartyInvitationStatus status;
}
