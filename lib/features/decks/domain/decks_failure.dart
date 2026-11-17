/*--------------------------- decks_failure.dart -----------------------------*/
// Domain error codes, exception type, and validation helpers for Decks.
// Keeps business-rule failures independent of Firebase and Flutter so both
// MockDecksRepository and FirebaseDecksRepository surface identical errors.
//
// Usage:
//   requireDecks(name.isNotEmpty, DecksError.invalidName);
//   throw const DecksFailure(DecksError.freeDeckLimitReached);
/*--------------------------------------------------------------------------*/

//------------------------------- DecksError --------------------------------//
enum DecksError {
  invalidName,
  invalidInput,
  freeDeckLimitReached,
  deckCardLimitReached,
  quickPicsLimitReached,
  notFound,
  unauthenticated,
  permissionDenied,
  network,
  storageError,
  unknown,
}

//------------------------------ DecksFailure -------------------------------//
class DecksFailure implements Exception {
  const DecksFailure(this.code, [this.detail]);

  final DecksError code;
  final String? detail;

  @override
  String toString() =>
      detail == null ? 'DecksFailure(${code.name})' : 'DecksFailure(${code.name}: $detail)';
}

//*************************** Validation Guard ******************************//
void requireDecks(bool condition, DecksError error, [String? detail]) {
  if (!condition) {
    throw DecksFailure(error, detail);
  }
}
