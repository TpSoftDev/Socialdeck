/*---------------------- home_tutorial_provider.dart ------------------------*/
// Persists Home tutorial completion on users/{uid}.homeTutorialComplete so the
// forced tutorial (tile + overlay) only runs once after onboarding.
//
// Usage:
//   ref.watch(homeTutorialCompleteProvider).whenData(...); // wait for real flag
//   await markHomeTutorialComplete(uid);
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';

//----------------------- homeTutorialCompleteProvider ----------------------//
/// Live flag from the signed-in user's Firestore doc.
///
/// Stays loading while auth is unresolved (null user). Do **not** emit
/// `false` for that case — Home would treat it as "not completed" and lock
/// the tutorial on before Firestore can say `true`.
///
/// Missing/false on a real user doc → show tutorial; true → no Tutorial tile.
final homeTutorialCompleteProvider = StreamProvider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return const Stream<bool>.empty();
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
