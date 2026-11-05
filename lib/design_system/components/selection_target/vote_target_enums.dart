/*-------------------------- vote_target_enums.dart --------------------------*/
// Shared enums for SDeckVoteTarget.
//
// Color picks the band fill and the rank color. Card position swaps which
// column holds the playing card.
//
// Usage:
//   SDeckVoteTargetColor.tangerine
//   SDeckVoteTargetCardPosition.left
/*--------------------------------------------------------------------------*/

/// Figma voteTarget Color. Tangerine is the #1 band. Mint green is the #2 band.
enum SDeckVoteTargetColor { tangerine, mintGreen }

/// Figma voteTarget Card Position.
enum SDeckVoteTargetCardPosition { left, right }

/// One voter photo in a vote target. A null [photoUrl] shows the checkerboard.
class SDeckVoteTargetVoter {
  final String? photoUrl;
  final double scale;
  final double panX;
  final double panY;
  final double rotation;

  const SDeckVoteTargetVoter({
    this.photoUrl,
    this.scale = 1.0,
    this.panX = 0.0,
    this.panY = 0.0,
    this.rotation = 0.0,
  });
}
