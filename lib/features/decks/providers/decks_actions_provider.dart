/*----------------------- decks_actions_provider.dart -----------------------*/
// Command state and StateNotifier for all Decks and Quick Pics mutations.
// Guards against duplicate button taps, catches repository exceptions into
// typed DecksError values, and stays safe across sign-out rebuilds.
//
// Usage:
//   final busy = ref.watch(decksActionsProvider).isLoading;
//   final deck = await ref.read(decksActionsProvider.notifier).createDeck(
//     name: 'Fire Pics',
//     colorKey: 'brightCoral',
//   );
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';

import '../domain/deck_entity.dart';
import '../domain/decks_failure.dart';
import '../domain/decks_repository.dart';
import 'decks_providers.dart';

//---------------------------- DecksAsyncStatus -----------------------------//
enum DecksAsyncStatus { idle, loading, success, failure }

//---------------------------- DecksActionState -----------------------------//
class DecksActionState {
  const DecksActionState({
    this.status = DecksAsyncStatus.idle,
    this.error,
    this.detail,
  });

  final DecksAsyncStatus status;
  final DecksError? error;
  final String? detail;

  bool get isLoading => status == DecksAsyncStatus.loading;
  bool get hasError => status == DecksAsyncStatus.failure && error != null;
}

//--------------------------- DecksActionsNotifier --------------------------//
class DecksActionsNotifier extends StateNotifier<DecksActionState> {
  DecksActionsNotifier(this._boundRepository) : super(const DecksActionState());

  final DecksRepository? _boundRepository;

  DecksRepository get _repository =>
      _boundRepository ??
      (throw const DecksFailure(DecksError.unauthenticated));

  void clearError() {
    if (!state.isLoading) {
      state = const DecksActionState();
    }
  }

  //*************************** Guarded Runners *****************************//
  Future<T?> _runResult<T>(Future<T> Function() operation) async {
    if (!mounted || state.isLoading) return null;
    state = const DecksActionState(status: DecksAsyncStatus.loading);
    try {
      final result = await operation();
      // Operation already succeeded. If autoDispose tore us down mid-await,
      // still return the result so callers do not treat a real write as failure.
      if (mounted) {
        state = const DecksActionState(status: DecksAsyncStatus.success);
      }
      return result;
    } catch (error) {
      if (mounted) {
        final failure =
            error is DecksFailure
                ? error
                : DecksFailure(DecksError.unknown, error.toString());
        state = DecksActionState(
          status: DecksAsyncStatus.failure,
          error: failure.code,
          detail: failure.detail,
        );
      }
      return null;
    }
  }

  Future<bool> _runCommand(Future<void> Function() operation) async {
    final completed = await _runResult<bool>(() async {
      await operation();
      return true;
    });
    return completed ?? false;
  }

  //*************************** Deck Commands *******************************//
  Future<DeckEntity?> createDeck({
    required String name,
    required String colorKey,
  }) {
    return _runResult(
      () => _repository.createDeck(name: name, colorKey: colorKey),
    );
  }

  Future<DeckEntity?> updateDeck({
    required String deckId,
    String? name,
    String? colorKey,
    bool? favorited,
  }) {
    return _runResult(
      () => _repository.updateDeck(
        deckId: deckId,
        name: name,
        colorKey: colorKey,
        favorited: favorited,
      ),
    );
  }

  Future<bool> deleteDeck(String deckId) {
    return _runCommand(() => _repository.deleteDeck(deckId));
  }

  Future<bool> reorderDecks(List<String> orderedDeckIds) {
    return _runCommand(() => _repository.reorderDecks(orderedDeckIds));
  }

  //*************************** Deck Card Commands **************************//
  Future<DeckEntity?> addCardsToDeck({
    required String deckId,
    required List<NewDeckCardDraft> drafts,
  }) {
    return _runResult(
      () => _repository.addCardsToDeck(deckId: deckId, drafts: drafts),
    );
  }

  Future<bool> reorderDeckCards({
    required String deckId,
    required List<String> orderedCardIds,
  }) {
    return _runCommand(() async {
      await _repository.reorderDeckCards(
        deckId: deckId,
        orderedCardIds: orderedCardIds,
      );
    });
  }

  Future<bool> removeCardsFromDeck({
    required String deckId,
    required Set<String> cardIds,
  }) {
    return _runCommand(() async {
      await _repository.removeCardsFromDeck(deckId: deckId, cardIds: cardIds);
    });
  }

  //*************************** Quick Pics Commands *************************//
  Future<bool> addCardsToQuickPics(List<NewDeckCardDraft> drafts) {
    return _runCommand(() async {
      await _repository.addCardsToQuickPics(drafts);
    });
  }

  Future<bool> reorderQuickPics(List<String> orderedCardIds) {
    return _runCommand(() async {
      await _repository.reorderQuickPics(orderedCardIds);
    });
  }

  Future<bool> removeCardsFromQuickPics(Set<String> cardIds) {
    return _runCommand(() async {
      await _repository.removeCardsFromQuickPics(cardIds);
    });
  }

  //*************************** Entitlement Commands ************************//
  Future<bool> setSocialdeckPlus(bool enabled) {
    return _runCommand(() => _repository.setSocialdeckPlus(enabled));
  }
}

//*************************** Provider & Error Copy *************************//
final decksActionsProvider =
    StateNotifierProvider.autoDispose<DecksActionsNotifier, DecksActionState>((
      ref,
    ) {
      final user = ref.watch(currentUserProvider);
      return DecksActionsNotifier(
        user == null ? null : ref.watch(decksRepositoryProvider),
      );
    });

String decksErrorTitle(DecksError? error) {
  switch (error) {
    case DecksError.freeDeckLimitReached:
      return 'Deck Limit Reached';
    case DecksError.deckCardLimitReached:
      return 'Deck Full';
    case DecksError.quickPicsLimitReached:
      return 'Quick Pics Full';
    case DecksError.unauthenticated:
      return 'Sign In Required';
    case DecksError.permissionDenied:
      return 'Permission Denied';
    case DecksError.network:
      return 'Network Issue';
    case DecksError.storageError:
      return 'Photo Error';
    case DecksError.notFound:
      return 'Not Found';
    case DecksError.invalidName:
    case DecksError.invalidInput:
    case DecksError.unknown:
    case null:
      return 'Update Failed';
  }
}

String decksErrorMessage(DecksError? error) {
  switch (error) {
    case DecksError.invalidName:
      return 'Deck names must be between 1 and ${DeckEntity.maxNameLength} characters.';
    case DecksError.freeDeckLimitReached:
      return 'Free accounts can save up to ${DeckEntity.freeDeckLimit} decks.';
    case DecksError.deckCardLimitReached:
      return 'Each deck can hold up to ${DeckEntity.maxCards} cards.';
    case DecksError.quickPicsLimitReached:
      return 'Quick Pics can hold up to 100 cards.';
    case DecksError.notFound:
      return 'That deck or card could not be found.';
    case DecksError.unauthenticated:
      return 'Sign in to manage your decks.';
    case DecksError.permissionDenied:
      return 'You do not have permission to update this deck.';
    case DecksError.network:
      return 'Network issue while saving your deck. Please try again.';
    case DecksError.storageError:
      return 'Could not prepare your selected photos. Please try again.';
    case DecksError.invalidInput:
    case DecksError.unknown:
    case null:
      return 'Something went wrong while updating your decks.';
  }
}
