import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';

/// FutureProvider that reads the onboardingComplete flag from Firestore for the current user.
/// Returns true if onboarding is complete, false otherwise.
final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  // Get the current user
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;

  // Reference to the user's document in Firestore
  final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final docSnap = await docRef.get();
  if (!docSnap.exists) return false;

  // Read the onboardingComplete flag (default to false if missing)
  final data = docSnap.data();
  return (data?['onboardingComplete'] ?? false) as bool;
});
