// -----------------------------------------------------------------------------
// profile_data_provider.dart
// -----------------------------------------------------------------------------
// FutureProvider that fetches the current user's profile data from Firestore.
// Uses existing FirebaseLoginRepository to get profile information and
// converts it to ProfileDataState for the profile page UI.
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'package:socialdeck/features/login/data/firebase_login_repository.dart';
import '../domain/profile_data_state.dart';

/// FutureProvider that fetches the current user's profile data from Firestore.
/// Returns ProfileDataState with username, photo URL, and transform data.
final profileDataProvider = FutureProvider<ProfileDataState>((ref) async {
  // Get the current user
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw Exception('User not logged in');
  }

  // Use existing FirebaseLoginRepository to get profile data
  final repository = FirebaseLoginRepository();
  final profileMap = await repository.getUserProfileData(user.uid);

  if (profileMap == null) {
    throw Exception('No profile data found for user');
  }

  // Convert Map<String, dynamic> to ProfileDataState
  return ProfileDataState(
    username: profileMap['username'] as String? ?? 'Unknown User',
    photoUrl: profileMap['photoUrl'] as String?,
    scale: (profileMap['scale'] as num?)?.toDouble() ?? 1.0,
    panX: (profileMap['panX'] as num?)?.toDouble() ?? 0.0,
    panY: (profileMap['panY'] as num?)?.toDouble() ?? 0.0,
  );
});
