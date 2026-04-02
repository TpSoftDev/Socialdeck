import 'dart:async';

class ProfileRedirectingState {
  final bool moveNext;
  final Timer? toMoveNext;

  //Constructor for State object
  const ProfileRedirectingState({
    this.moveNext = false,
    this.toMoveNext
  });

  //copyWith, as required to change the state
  ProfileRedirectingState copyWith({
    bool? moveNext,
    Timer? toMoveNext,
  }) {
    return ProfileRedirectingState(
      moveNext: moveNext ?? this.moveNext,
      toMoveNext: toMoveNext ?? this.toMoveNext,
    );
  }

  //Operator override, as needed by Flutter
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is ProfileRedirectingState &&
      moveNext == other.moveNext &&
      toMoveNext == other.toMoveNext;

  //Hashing override, as required by Flutter
  @override
  int get hashCode => Object.hash(
    moveNext,
    toMoveNext,
  );
}