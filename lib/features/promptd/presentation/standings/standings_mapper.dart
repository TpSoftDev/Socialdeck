import 'package:socialdeck/design_system/index.dart';
import '../../domain/promptd_standing.dart';
import 'promptd_leaderboard_row.dart';

// IA: Screens 4-8 use the same mapping. It never adds points or writes Firebase.
// Preserve the results owner's ordering and tied ranks; reject inconsistent input
// rather than silently choosing a winner or displaying a player twice.
List<PromptdLeaderboardEntry> mapPromptdStandings(
  List<PromptdStanding> standings,
) {
  final ids = <String>{};
  var previousRank = 0;
  final entries = <PromptdLeaderboardEntry>[];
  for (final player in standings) {
    if (!ids.add(player.playerId)) {
      throw ArgumentError('Duplicate player in leaderboard results');
    }
    if (player.rank < previousRank) {
      throw ArgumentError('Results must arrive in rank order');
    }
    previousRank = player.rank;
    final name = player.playerName.trim();
    final photo = player.photoUrl?.trim();
    entries.add(
      PromptdLeaderboardEntry(
        playerName: name.isEmpty ? 'Player' : name,
        points: player.points.toString(),
        photoUrl: photo == null || photo.isEmpty ? null : photo,
        standing: switch (player.rank) {
          1 => SDeckLeaderboardStanding.gold,
          2 => SDeckLeaderboardStanding.silver,
          3 => SDeckLeaderboardStanding.bronze,
          _ => SDeckLeaderboardStanding.plain,
        },
      ),
    );
  }
  // IA: A caller cannot accidentally edit a mapped results snapshot.
  return List.unmodifiable(entries);
}
