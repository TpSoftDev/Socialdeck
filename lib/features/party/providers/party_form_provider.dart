// -----------------------------------------------------------------------------
// party_form_provider.dart
// Synchronous create/join input. Widgets retain their own focus/controllers.
// -----------------------------------------------------------------------------
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/party_form_state.dart';

class PartyFormNotifier extends StateNotifier<PartyFormState> {
  PartyFormNotifier() : super(const PartyFormState());
  // Identical input should not make the form rebuild again.
  void updateName(String value) {
    if (state.name != value) state = state.copyWith(name: value);
  }

  void updateCode(String value) {
    if (state.code != value) state = state.copyWith(code: value);
  }

  void reset() => state = const PartyFormState();
}

final partyFormProvider =
    StateNotifierProvider.autoDispose<PartyFormNotifier, PartyFormState>(
      (ref) => PartyFormNotifier(),
    );
