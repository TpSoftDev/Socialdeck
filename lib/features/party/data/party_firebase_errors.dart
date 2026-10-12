// -----------------------------------------------------------------------------
// party_firebase_errors.dart
// Both Party repositories report the same error types to their providers.
// -----------------------------------------------------------------------------
import 'package:firebase_core/firebase_core.dart';
import '../domain/party_failure.dart';

class PartyFirebaseErrors {
  const PartyFirebaseErrors._();

  /// Keep Firebase-specific codes out of screens and domain state.
  static PartyFailure map(Object error) {
    if (error is PartyFailure) return error;
    if (error is FirebaseException) {
      return PartyFailure(switch (error.code) {
        'permission-denied' => PartyError.permissionDenied,
        'unauthenticated' => PartyError.unauthenticated,
        'unavailable' || 'deadline-exceeded' => PartyError.network,
        'aborted' || 'already-exists' => PartyError.conflict,
        'not-found' => PartyError.notFound,
        _ => PartyError.unknown,
      });
    }
    return const PartyFailure(PartyError.unknown);
  }

  /// Preserve the original stack trace when a snapshot stream fails.
  static Stream<T> stream<T>(Stream<T> source) =>
      source.handleError((Object error, StackTrace stack) {
        Error.throwWithStackTrace(map(error), stack);
      });
}
