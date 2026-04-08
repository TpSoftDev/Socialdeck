class ProfileRedirectingState {
  final bool moveNext;

  //Constructor for State object
  const ProfileRedirectingState({
    this.moveNext = false,
  });

  //copyWith, as required to change the state
  ProfileRedirectingState copyWith({
    bool? moveNext,
  }) {
    return ProfileRedirectingState(
      moveNext: moveNext ?? this.moveNext,
    );
  }

  //Operator override, as needed by Flutter
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is ProfileRedirectingState &&
      moveNext == other.moveNext;

  //Hashing override, as required by Flutter
  @override
  int get hashCode => moveNext.hashCode;
}