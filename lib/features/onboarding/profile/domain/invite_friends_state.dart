class InviteFriendsState {
  final bool sendingInvite;

  //Constructor for State object
  const InviteFriendsState({
    this.sendingInvite = false,
  });

  //copyWith, as required to change the state
  InviteFriendsState copyWith({
    bool? sendingInvite,
  }) {
    return InviteFriendsState(
      sendingInvite: sendingInvite ?? this.sendingInvite,
    );
  }

  //Operator override, as needed by Flutter
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is InviteFriendsState &&
      sendingInvite == other.sendingInvite;

  //Hashing override, as required by Flutter
  @override
  int get hashCode => sendingInvite.hashCode;
}