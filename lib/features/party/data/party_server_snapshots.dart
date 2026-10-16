import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/party_failure.dart';

/// IA: Cached membership is useful history, but not current permission evidence.
/// A cache event can also occur on initial load, so do not claim definite offline
/// status. Keep listening after the error: server confirmation restores the UI.
Stream<DocumentSnapshot<T>> serverConfirmedSnapshots<T>(
  Stream<DocumentSnapshot<T>> source,
) => source.map((snapshot) {
  if (snapshot.metadata.isFromCache) {
    throw const PartyFailure(PartyError.connectionUnconfirmed);
  }
  return snapshot;
});
