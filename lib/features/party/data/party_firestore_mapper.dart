// -----------------------------------------------------------------------------
// party_firestore_mapper.dart
// Explicit serialization keeps Firebase/JSON shapes out of the domain layer.
// Malformed snapshots fail visibly instead of silently fabricating lobby data.
// -----------------------------------------------------------------------------
import '../domain/party_models.dart';

class PartyFirestoreMapper {
  const PartyFirestoreMapper._();

  static Map<String, dynamic> gameToMap(PartyGame game) => {
    'id': game.id,
    'rounds': game.rounds,
    'requiredCards': game.requiredCards,
    'mixCards': game.mixCards,
    'safeMode': game.safeMode,
  };

  static Party fromMap(String id, Map<String, dynamic> data) {
    final rawMembers = Map<String, dynamic>.from(data['members'] as Map);
    final rawGame = data['game'];
    final game = rawGame == null
        ? null
        : Map<String, dynamic>.from(rawGame as Map);
    return Party(
      id: id,
      hostId: data['hostId'] as String,
      phase: PartyPhase.values.byName(data['phase'] as String),
      revision: data['revision'] as int,
      game: game == null
          ? null
          : PartyGame(
              id: game['id'] as String,
              rounds: game['rounds'] as int,
              requiredCards: game['requiredCards'] as int,
              mixCards: game['mixCards'] as bool,
              safeMode: game['safeMode'] as bool,
            ),
      members:
          {
            for (final uid in (data['memberIds'] as List).cast<String>())
              uid: rawMembers[uid],
          }.map((uid, raw) {
            final m = Map<String, dynamic>.from(raw as Map);
            return MapEntry(
              uid,
              PartyMember(
                uid: uid,
                name: m['name'] as String,
                characterId: m['characterId'] as String?,
                cardCount: m['cardCount'] as int,
                selectionRevision: m['selectionRevision'] as int,
                ready: m['ready'] as bool,
              ),
            );
          }),
    );
  }

  /// Convert only the member being changed, rather than every lobby member.
  static Map<String, dynamic> memberToMap(PartyMember member) => {
    'name': member.name,
    'characterId': member.characterId,
    'cardCount': member.cardCount,
    'selectionRevision': member.selectionRevision,
    'ready': member.ready,
  };

  static Map<String, dynamic> toMap(Party party) => {
    'hostId': party.hostId,
    'phase': party.phase.name,
    'revision': party.revision,
    'game': party.game == null ? null : gameToMap(party.game!),
    'memberIds': party.members.keys.toList(),
    'members': party.members.map(
      (uid, member) => MapEntry(uid, memberToMap(member)),
    ),
  };

  static PartyCard card(String id, Map<String, dynamic> data) => PartyCard(
    id: id,
    deckId: data['deckId'] as String,
    imageUrl: data['imageUrl'] as String,
  );

  static Map<String, dynamic> handToMap(PartyHand hand) => {
    'revision': hand.revision,
    'cards': hand.cards
        .map((c) => {'id': c.id, 'deckId': c.deckId, 'imageUrl': c.imageUrl})
        .toList(),
  };

  static PartyHand handFromMap(Map<String, dynamic> data) => PartyHand(
    revision: data['revision'] as int,
    cards: (data['cards'] as List).map((raw) {
      final m = Map<String, dynamic>.from(raw as Map);
      return card(m['id'] as String, m);
    }),
  );

  static PartyInvitation invitation(String id, Map<String, dynamic> data) =>
      PartyInvitation(
        id: id,
        partyId: data['partyId'] as String,
        senderId: data['senderId'] as String,
        recipientId: data['recipientId'] as String,
        status: PartyInvitationStatus.values.byName(data['status'] as String),
      );
}
