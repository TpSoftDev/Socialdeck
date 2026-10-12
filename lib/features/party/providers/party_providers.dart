// -----------------------------------------------------------------------------
// party_providers.dart
// Authentication-scoped repositories and disposable Firestore subscriptions.
// watch these providers for data; read partyActionsProvider.notifier for actions.
// A page leaving the tree stops listeners, not the persisted party membership.
// -----------------------------------------------------------------------------
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import '../data/firebase_party_repository.dart';
import '../data/firebase_party_card_repository.dart';
import '../domain/party_failure.dart';
import '../domain/party_models.dart';
import '../domain/party_repository.dart';

final partyRepositoryProvider = Provider.autoDispose<PartyRepository>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) throw const PartyFailure(PartyError.unauthenticated);
  return FirebasePartyRepository(uid: user.uid);
});

final partyCardRepositoryProvider = Provider.autoDispose<PartyCardRepository>((
  ref,
) {
  final user = ref.watch(currentUserProvider);
  if (user == null) throw const PartyFailure(PartyError.unauthenticated);
  return FirebasePartyCardRepository(uid: user.uid);
});

final activePartyIdProvider = StreamProvider.autoDispose<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);
  return ref.watch(partyRepositoryProvider).watchActivePartyId();
});

final partyByIdProvider = StreamProvider.autoDispose.family<Party?, String>(
  (ref, id) => ref.watch(partyRepositoryProvider).watchParty(id),
);

final activePartyProvider = Provider.autoDispose<AsyncValue<Party?>>((ref) {
  // Watch the outer session separately so a membership change immediately
  // switches the inner listener rather than waiting for an infinite stream.
  return ref
      .watch(activePartyIdProvider)
      .when(
        skipLoadingOnRefresh: false,
        skipLoadingOnReload: false,
        data: (id) => id == null
            ? const AsyncData(null)
            : ref.watch(partyByIdProvider(id)),
        loading: () => const AsyncLoading(),
        error: (error, stack) => AsyncError(error, stack),
      );
});

final partyHandProvider = StreamProvider.autoDispose.family<PartyHand?, String>(
  (ref, id) => ref.watch(partyRepositoryProvider).watchMyHand(id),
);

final partyInvitationsProvider =
    StreamProvider.autoDispose<List<PartyInvitation>>((ref) {
      if (ref.watch(currentUserProvider) == null) return Stream.value(const []);
      return ref.watch(partyRepositoryProvider).watchInvitations();
    });

final partyEventsProvider = StreamProvider.autoDispose
    .family<List<PartyEvent>, String>(
      (ref, id) => ref.watch(partyRepositoryProvider).watchEvents(id),
    );

final partyAllCardsProvider = StreamProvider.autoDispose<List<PartyCard>>(
  (ref) => ref.watch(partyCardRepositoryProvider).watchAllCards(),
);

final partyDecksProvider = StreamProvider.autoDispose<List<PartyDeck>>(
  (ref) => ref.watch(partyCardRepositoryProvider).watchDecks(),
);

final partyDeckCardsProvider = StreamProvider.autoDispose
    .family<List<PartyCard>, String>(
      (ref, deckId) =>
          ref.watch(partyCardRepositoryProvider).watchCards(deckId),
    );
