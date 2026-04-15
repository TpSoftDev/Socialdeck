// -----------------------------------------------------------------------------
// password_reset_send_provider.dart
// -----------------------------------------------------------------------------
// Orchestrates [LoginRepository.sendPasswordResetEmail] for the forgot-password UI.
// -----------------------------------------------------------------------------

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/login_repository.dart';
import '../domain/password_reset_send_state.dart';
import 'login_repository_provider.dart';

//------------------------------- PasswordResetSendNotifier -----------------------------//
class PasswordResetSendNotifier extends StateNotifier<PasswordResetSendState> {
  PasswordResetSendNotifier(this._repository)
    : super(const PasswordResetSendState());

  final LoginRepository _repository;

  /// Clears loading and errors (e.g. when opening the screen).
  void reset() {
    state = const PasswordResetSendState();
  }

  /// Sends the reset email. Returns `true` if Firebase accepted the request.
  Future<bool> sendResetEmail(String email) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      state = const PasswordResetSendState(
        errorMessage:
            'Go back and enter your email so we know where to send the link.',
      );
      return false;
    }

    state = const PasswordResetSendState(isLoading: true);
    try {
      await _repository.sendPasswordResetEmail(trimmed);
      state = const PasswordResetSendState(
        isLoading: false,
        emailSent: true,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      state = PasswordResetSendState(
        isLoading: false,
        errorMessage: _messageForCode(e.code),
      );
      return false;
    } catch (_) {
      state = const PasswordResetSendState(
        isLoading: false,
        errorMessage:
            "This action isn't available right now. Try again shortly.",
      );
      return false;
    }
  }

  static String _messageForCode(String code) {
    switch (code) {
      case 'too-many-requests':
      case 'network-request-failed':
        return "This action isn't available right now. Try again shortly.";
      case 'invalid-email':
        return "That email address doesn't look valid.";
      default:
        return 'Something went wrong. Try again.';
    }
  }
}

// -----------------------------------------------------------------------------
// Provider
// -----------------------------------------------------------------------------
final passwordResetSendProvider =
    StateNotifierProvider<PasswordResetSendNotifier, PasswordResetSendState>(
      (ref) => PasswordResetSendNotifier(ref.watch(loginRepositoryProvider)),
    );
