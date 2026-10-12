// -----------------------------------------------------------------------------
// party_failure.dart
// Typed failures shared by Party repositories and notifiers.
// Firebase exceptions are translated at the data boundary.
// -----------------------------------------------------------------------------
enum PartyError {
  unauthenticated,
  invalidInput,
  notFound,
  alreadyInParty,
  full,
  closed,
  forbidden,
  hostMustTransfer,
  noGame,
  invalidCards,
  notReady,
  busy,
  network,
  permissionDenied,
  conflict,
  unknown,
}

class PartyFailure implements Exception {
  const PartyFailure(this.code);
  final PartyError code;
  @override
  String toString() => 'PartyFailure(${code.name})';
}

void requireParty(bool condition, PartyError error) {
  if (!condition) throw PartyFailure(error);
}
