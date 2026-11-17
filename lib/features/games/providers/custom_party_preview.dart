import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import '../domain/party_ai_setup.dart';
import '../data/firebase_party_ai_setup_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/game_setup_state.dart';

// IA: Target captures the party/revision being edited. The local map is a legacy test preview.
// Normal app summaries are restored from the account-scoped Firebase stream below.
final customSetupTargetProvider =
    StateProvider<({String uid, String partyId, int revision})?>((ref) => null);
final customPartyPreviewsProvider =
    StateProvider<Map<String, ({int revision, GameSetupState draft})>>(
      (ref) => {},
    );

final partyAiSetupRepositoryProvider = Provider.autoDispose<
  PartyAiSetupRepository
>((ref) {
  final uid = ref.watch(currentUserProvider.select((u) => u?.uid));
  if (uid == null) throw StateError('Sign in to read the party setup.');
  return FirebasePartyAiSetupRepository(uid);
  // IA: Follow the scoped account used by preview screens and account-switch tests.
}, dependencies: [currentUserProvider]);
final savedPartyAiSetupProvider = StreamProvider.autoDispose
    .family<PartyAiSetup?, String>((ref, id) {
      if (ref.watch(currentUserProvider) == null) return Stream.value(null);
      return ref.watch(partyAiSetupRepositoryProvider).watch(id);
    }, dependencies: [currentUserProvider, partyAiSetupRepositoryProvider]);
