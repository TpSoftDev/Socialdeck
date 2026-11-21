// IA: Input contract for completed results, not a scoring implementation.
// The game-results owner supplies points and rank. Equal ranks remain ties.
class PromptdStanding {
  PromptdStanding({
    required this.playerId,
    required this.playerName,
    required this.points,
    required this.rank,
    this.photoUrl,
  }) {
    if (playerId.trim().isEmpty) {
      throw ArgumentError.value(playerId, 'playerId', 'Must identify a player');
    }
    if (rank < 1) {
      throw ArgumentError.value(rank, 'rank', 'Must be at least 1');
    }
  }

  final String playerId;
  final String playerName;
  final int points;
  final int rank;
  final String? photoUrl;
}
