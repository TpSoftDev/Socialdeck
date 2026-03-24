/*----------------------- invite_friend_states.dart -----------------------*/
// Domain state for the Invite Friends screen.
// Holds a snapshot of the screen's condition at any given moment.
// Pure Dart — no Firebase, no Riverpod, no dependencies.
//
// Usage:
//   InviteFriendsState()
//   state.copyWith(isLoading: true)
/*--------------------------------------------------------------------------*/

//------------------------------- InviteFriendsState ----------------------//
class InviteFriendsState {
  //these are like light switches.
  // These are data fields.
  // They are containers that hold a snapshot of the screen at any given moment.
  // They do NOT do anything — they just describe the current condition.
  // Like a scoreboard: it shows the score but it does not play the game.
  //
  // final = once this object is created, these values cannot change.
  // To "change" state, you create a brand new object using copyWith.
  final bool isLoading;
  final bool inviteSent;
  final String? errorMessage;
  final String? successMessage;

  // Constructor — sets the starting values when a new state object is created.
  // Default values mean: screen starts with nothing loading, nothing sent, no messages.
  const InviteFriendsState({
    this.isLoading = false,
    this.inviteSent = false,
    this.errorMessage = null,
    this.successMessage = null,
  });

  //*************************** copyWith ************************************//
  // Creates a BRAND NEW state object with only the specified fields changed.
  // Every field you do NOT pass in stays the same as before (this.fieldName).
  // Every field you DO pass in gets the new value.
  //
  // IMPORTANT — the nullable field problem:
  //   errorMessage and successMessage use ??
  //   This means: if you pass null, it keeps the OLD value (does not clear it).
  //   To intentionally clear an error, the provider resets the whole state
  //   instead of trying to pass null here. This is a known limitation of ??.
  InviteFriendsState copyWith({
    bool? isLoading,
    bool? inviteSent,
    String? errorMessage,
    String? successMessage,
  }) {
    return InviteFriendsState(
      isLoading: isLoading ?? this.isLoading,
      inviteSent: inviteSent ?? this.inviteSent,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  //*************************** Equality ************************************//
  // Dart compares objects by memory address by default.
  // Overriding == tells Dart: "compare by VALUES, not by address."
  // Riverpod uses == to decide whether to rebuild the screen.
  // Without this, every copyWith creates a new object that Dart thinks is
  // different — causing unnecessary rebuilds even when nothing changed.
  // RULE: every field in the class must appear here. Miss one and two states
  // that differ only by that field will look equal to Dart — a silent bug.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InviteFriendsState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          inviteSent == other.inviteSent &&
          errorMessage == other.errorMessage &&
          successMessage == other.successMessage;

  //*************************** Hash Code ***********************************//
  // hashCode must always be overridden alongside ==.
  // If == says two objects are equal, their hashCode must also match.
  // They are always a pair — never override one without the other.
  // Object.hash() is the modern Dart way — better distribution than ^ (XOR).
  // Every field listed in == must also appear here.
  @override
  int get hashCode => Object.hash(
        isLoading,
        inviteSent,
        errorMessage,
        successMessage,
      );
}