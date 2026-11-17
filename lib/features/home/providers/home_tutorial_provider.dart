/*---------------------- home_tutorial_provider.dart ------------------------*/
// Persists Home tutorial completion on users/{uid}.homeTutorialComplete so the
// forced tutorial (tile + overlay) only runs once after onboarding.
//
// Usage:
//   final done = ref.watch(homeTutorialCompleteProvider).valueOrNull ?? false;
//   await markHomeTutorialComplete(uid);
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';

//----------------------- homeTutorialCompleteProvider ----------------------//
/// Live flag from the signed-in user's Firestore doc. Missing/false → show
/// tutorial; true → Home stays fully interactive with no Tutorial tile.
final homeTutorialCompleteProvider = StreamProvider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return Stream<bool>.value(false);
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((snap) => snap.data()?['homeTutorialComplete'] == true);
});

//*************************** Mutations *************************************//
/// Merges [homeTutorialComplete] = true onto the user doc. Idempotent.
Future<void> markHomeTutorialComplete(String uid) {
  return FirebaseFirestore.instance.collection('users').doc(uid).set(
    <String, dynamic>{'homeTutorialComplete': true},
    SetOptions(merge: true),
  );
}
