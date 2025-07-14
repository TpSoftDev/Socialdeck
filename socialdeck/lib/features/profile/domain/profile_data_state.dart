// -----------------------------------------------------------------------------
// profile_data_state.dart
// -----------------------------------------------------------------------------
// Domain model for profile data state in the main app.
// This class holds the user's profile information fetched from Firestore
// including username, photo URL, and image transform data.
// -----------------------------------------------------------------------------

/// Immutable state model for user profile data.
///
/// This class holds the profile information needed to display the user's
/// profile page, including their username, profile photo, and saved
/// image adjustments from the onboarding process.
class ProfileDataState {
  /// The user's username (without @ prefix)
  final String username;

  /// Firebase Storage URL for profile photo (null if no photo)
  final String? photoUrl;

  /// Image scale factor from profile adjustment (1.0 = normal size)
  final double scale;

  /// Horizontal pan offset from profile adjustment (0.0 = centered)
  final double panX;

  /// Vertical pan offset from profile adjustment (0.0 = centered)
  final double panY;

  //------------------------------- Constructor -----------------------------//
  const ProfileDataState({
    required this.username,
    this.photoUrl,
    this.scale = 1.0,
    this.panX = 0.0,
    this.panY = 0.0,
  });

  /// Returns a copy of this state with the given fields updated.
  ProfileDataState copyWith({
    String? username,
    String? photoUrl,
    double? scale,
    double? panX,
    double? panY,
  }) {
    return ProfileDataState(
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      scale: scale ?? this.scale,
      panX: panX ?? this.panX,
      panY: panY ?? this.panY,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileDataState &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          photoUrl == other.photoUrl &&
          scale == other.scale &&
          panX == other.panX &&
          panY == other.panY;

  @override
  int get hashCode => Object.hash(username, photoUrl, scale, panX, panY);
}
