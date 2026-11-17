/*-------------------------- decks_providers.dart ---------------------------*/
// Authentication-scoped Riverpod providers for Decks and Quick Pics streams.
// Uses MockDecksRepository during local UI wiring so screens can be tested on
// device first, then swaps cleanly to FirebaseDecksRepository in Phase 4.
//
// Usage:
//   final decksAsync = ref.watch(decksWatchProvider);
//   final deckAsync = ref.watch(deckByIdProvider(deckId));
//   final quickPicsAsync = ref.watch(quickPicsWatchProvider);
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';

import '../data/firebase_decks_repository.dart';
import '../domain/deck_entity.dart';
import '../domain/decks_failure.dart';
import '../domain/decks_repository.dart';
import '../domain/quick_pics_entity.dart';

//*************************** Repository Provider ***************************//
/// Scoped to the current Firebase Auth UID so signing out or switching accounts
/// disposes previous Firestore streams automatically.
final decksRepositoryProvider = Provider<DecksRepository>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw const DecksFailure(DecksError.unauthenticated);
  }

  return FirebaseDecksRepository(uid: user.uid);
});

//*************************** Stream Providers ******************************//
/// Live ordered list of the signed-in user's decks.
final decksWatchProvider = StreamProvider<List<DeckEntity>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return Stream<List<DeckEntity>>.value(const <DeckEntity>[]);
  }
  return ref.watch(decksRepositoryProvider).watchDecks();
});

/// Live lookup of a single deck by ID, derived from [decksWatchProvider] so
/// DecksPage and DeckCardsPage share one underlying stream subscription.
final deckByIdProvider = Provider.family<AsyncValue<DeckEntity?>, String>((
  ref,
  deckId,
) {
  return ref.watch(decksWatchProvider).whenData((decks) {
    for (final deck in decks) {
      if (deck.id == deckId) return deck;
    }
    return null;
  });
});

/// Live Quick Pics collection (`users/{uid}/quickPics/main`).
/// Note: intentionally NOT autoDispose so navigating back to DecksPage keeps
/// the stream warm in memory without flashing a loading spinner on re-entry.
final quickPicsWatchProvider = StreamProvider<QuickPicsEntity>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return Stream<QuickPicsEntity>.value(QuickPicsEntity());
  }
  return ref.watch(decksRepositoryProvider).watchQuickPics();
});

/// Live Socialdeck+ entitlement flag (`false` enforces the 2-deck free limit).
final isSocialdeckPlusProvider = StreamProvider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return Stream<bool>.value(false);
  }
  return ref.watch(decksRepositoryProvider).watchIsSocialdeckPlus();
});
