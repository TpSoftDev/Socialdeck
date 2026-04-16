// -----------------------------------------------------------------------------
// password_reset_oob_provider.dart
// -----------------------------------------------------------------------------
// Holds the Firebase [oobCode] from a password-reset email link (in-app flow).
// Cleared after [confirmPasswordReset] succeeds (later step).
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/firebase_password_reset_uri_parser.dart';

//------------------------------- PasswordResetOobState -----------------------------//
class PasswordResetOobState {
  final String? oobCode;

  const PasswordResetOobState({this.oobCode});
}

//------------------------------- PasswordResetOobNotifier -----------------------------//
class PasswordResetOobNotifier extends StateNotifier<PasswordResetOobState> {
  PasswordResetOobNotifier() : super(const PasswordResetOobState());

  void clear() {
    state = const PasswordResetOobState();
  }

  /// Parses [uri] and stores [oobCode] when it is a reset-password action.
  /// Returns whether a code was stored.
  bool tryIngestResetLink(Uri uri) {
    final code = parseFirebasePasswordResetOobCode(uri);
    if (code == null) return false;
    state = PasswordResetOobState(oobCode: code);
    return true;
  }
}

// -----------------------------------------------------------------------------
// Provider
// -----------------------------------------------------------------------------
final passwordResetOobProvider =
    StateNotifierProvider<PasswordResetOobNotifier, PasswordResetOobState>(
      (ref) => PasswordResetOobNotifier(),
    );
