/*--------------------- leaderboard_container_enums.dart --------------------*/
// Standing for SDeckLeaderboardContainer.
//
// Gold, silver, and bronze are the podium rows. Plain is the Figma Default
// standing used from 4th place down. Tournament replaces the score with the
// winning card.
//
// Usage:
//   SDeckLeaderboardStanding.gold
//   SDeckLeaderboardStanding.tournament
/*--------------------------------------------------------------------------*/

/// Figma leaderboardContainer Standing.
enum SDeckLeaderboardStanding { gold, silver, bronze, plain, tournament }
