/// Holds the user's current input for the profile onboarding step.
/// This class is a simple data holder and does not perform any validation.
/// It is used by the ProfileFormProvider to manage the state of the profile form.
class ProfileFormState {
  /// The username entered by the user.
  final String username;

  /// The local file path to the selected profile photo (null if not selected yet).
  final String? imagePath;

  /// The scale (zoom level) applied to the profile photo during adjustment.
  final double? scale;

  /// The horizontal pan offset applied to the profile photo during adjustment.
  final double? panX;

  /// The vertical pan offset applied to the profile photo during adjustment.
  final double? panY;

  /// Constructor with named parameters and sensible defaults.
  ProfileFormState({
    this.username = '',
    this.imagePath,
    this.scale,
    this.panX,
    this.panY,
  });

  /// Creates a copy of this state with optional new values.
  ProfileFormState copyWith({
    String? username,
    String? imagePath,
    double? scale,
    double? panX,
    double? panY,
  }) {
    return ProfileFormState(
      username: username ?? this.username,
      imagePath: imagePath ?? this.imagePath,
      scale: scale ?? this.scale,
      panX: panX ?? this.panX,
      panY: panY ?? this.panY,
    );
  }

  /// Override equality and hashCode for value comparison.
  /// This is needed for Riverpod and Flutter to detect state changes correctly.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileFormState &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          imagePath == other.imagePath &&
          scale == other.scale &&
          panX == other.panX &&
          panY == other.panY;

  @override
  int get hashCode => Object.hash(username, imagePath, scale, panX, panY);
}
