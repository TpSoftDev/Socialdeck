class EnterUsernameState{

  final bool yes;
  final bool no;

  //Constructor for needed fields
  const EnterUsernameState({
    this.yes = true,
    this.no = false,
  });

  EnterUsernameState copyWith({
    bool? yes,
    bool? no,
  }) {
    return EnterUsernameState(
      yes: yes ?? this.yes,
      no: no ?? this.no,
    );
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is EnterUsernameState &&
      yes == other.yes;
      

  @override
  int get hashCode => Object.hash(
      yes,
      no,
    );

}