/*------------------------ mock_decks_repository.dart ------------------------*/
// In-memory reactive implementation of DecksRepository for local UI wiring,
// Dev Tools previews, and automated tests before connecting live Firestore.
// Emits immediate snapshots to new listeners and enforces the exact same
// limits (2 free decks, 52 deck cards, 100 Quick Pics) as Firestore.
//
// Usage:
//   final repo = MockDecksRepository();
//   await repo.createDeck(name: 'Fire Pics', colorKey: 'brightCoral');
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'dart:async';
import 'dart:math' as math;

import '../domain/deck_card_entity.dart';
import '../domain/deck_entity.dart';
import '../domain/decks_failure.dart';
import '../domain/decks_repository.dart';
import '../domain/quick_pics_entity.dart';

//--------------------------- MockDecksRepository ---------------------------//
class MockDecksRepository implements DecksRepository {
  MockDecksRepository({
    List<DeckEntity> initialDecks = const <DeckEntity>[],
    QuickPicsEntity? initialQuickPics,
    bool initialSocialdeckPlus = false,
    this.simulatedDelay = Duration.zero,
    math.Random? random,
    DateTime Function()? now,
  }) : _random = random ?? math.Random(),
       _now = now ?? DateTime.now,
       _isSocialdeckPlus = initialSocialdeckPlus,
       _quickPics = initialQuickPics ?? QuickPicsEntity() {
    for (var i = 0; i < initialDecks.length; i++) {
      final normalized = initialDecks[i].copyWith(orderIndex: i);
      normalized.validate();
      _decksById[normalized.id] = normalized;
    }
    _quickPics.validate();
  }

  //*************************** Dependencies & State ************************//
  final Duration simulatedDelay;
  final math.Random _random;
  final DateTime Function() _now;

  final Map<String, DeckEntity> _decksById = <String, DeckEntity>{};
  QuickPicsEntity _quickPics;
  bool _isSocialdeckPlus;
  int _idCounter = 0;

  final StreamController<List<DeckEntity>> _decksController =
      StreamController<List<DeckEntity>>.broadcast();
  final StreamController<QuickPicsEntity> _quickPicsController =
      StreamController<QuickPicsEntity>.broadcast();
  final StreamController<bool> _plusController =
      StreamController<bool>.broadcast();

  //*************************** Lifecycle ***********************************//
  void dispose() {
    _decksController.close();
    _quickPicsController.close();
    _plusController.close();
  }

  //*************************** Streams *************************************//
  @override
  Stream<List<DeckEntity>> watchDecks() {
    return Stream<List<DeckEntity>>.multi((controller) {
      controller.add(_sortedDecksSnapshot());
      final sub = _decksController.stream.listen(
        controller.add,
        onError: controller.addError,
      );
      controller.onCancel = sub.cancel;
    });
  }

  @override
  Stream<QuickPicsEntity> watchQuickPics() {
    return Stream<QuickPicsEntity>.multi((controller) {
      controller.add(_quickPics);
      final sub = _quickPicsController.stream.listen(
        controller.add,
        onError: controller.addError,
      );
      controller.onCancel = sub.cancel;
    });
  }

  @override
  Stream<bool> watchIsSocialdeckPlus() {
    return Stream<bool>.multi((controller) {
      controller.add(_isSocialdeckPlus);
      final sub = _plusController.stream.listen(
        controller.add,
        onError: controller.addError,
      );
      controller.onCancel = sub.cancel;
    });
  }

  //*************************** Deck Mutations ******************************//
  @override
  Future<DeckEntity> createDeck({
    required String name,
    required String colorKey,
  }) async {
    await _maybeDelay();
    requireDecks(
      _isSocialdeckPlus || _decksById.length < DeckEntity.freeDeckLimit,
      DecksError.freeDeckLimitReached,
      'Upgrade to Socialdeck+ to create more than ${DeckEntity.freeDeckLimit} decks.',
    );

    final cleanedName = DeckEntity.cleanName(name);
    final cleanedColor = DeckEntity.cleanColorKey(colorKey);
    final timestamp = _now();
    final deck = DeckEntity(
      id: _nextId('deck'),
      name: cleanedName,
      colorKey: cleanedColor,
      orderIndex: _decksById.length,
      tiltDegrees: generateRestingTiltDegrees(_random),
      createdAt: timestamp,
      updatedAt: timestamp,
    );
    deck.validate();

    _decksById[deck.id] = deck;
    _emitDecks();
    return deck;
  }

  @override
  Future<DeckEntity> updateDeck({
    required String deckId,
    String? name,
    String? colorKey,
    bool? favorited,
  }) async {
    await _maybeDelay();
    final existing = _requireDeck(deckId);
    final updated = existing.copyWith(
      name: name != null ? DeckEntity.cleanName(name) : existing.name,
      colorKey:
          colorKey != null ? DeckEntity.cleanColorKey(colorKey) : existing.colorKey,
      favorited: favorited ?? existing.favorited,
      updatedAt: _now(),
    );
    updated.validate();

    _decksById[deckId] = updated;
    _emitDecks();
    return updated;
  }

  @override
  Future<void> deleteDeck(String deckId) async {
    await _maybeDelay();
    _requireDeck(deckId);
    _decksById.remove(deckId);

    // Re-pack orderIndex values (0..n-1) so deletion never leaves index gaps.
    final remaining = _sortedDecksSnapshot();
    for (var i = 0; i < remaining.length; i++) {
      final deck = remaining[i];
      if (deck.orderIndex != i) {
        _decksById[deck.id] = deck.copyWith(orderIndex: i);
      }
    }
    _emitDecks();
  }

  @override
  Future<void> reorderDecks(List<String> orderedDeckIds) async {
    await _maybeDelay();
    requireDecks(
      orderedDeckIds.length == _decksById.length &&
          orderedDeckIds.toSet().length == _decksById.length &&
          orderedDeckIds.every(_decksById.containsKey),
      DecksError.invalidInput,
      'orderedDeckIds must contain every existing deck ID exactly once.',
    );

    final timestamp = _now();
    for (var i = 0; i < orderedDeckIds.length; i++) {
      final id = orderedDeckIds[i];
      final current = _decksById[id]!;
      if (current.orderIndex != i) {
        _decksById[id] = current.copyWith(orderIndex: i, updatedAt: timestamp);
      }
    }
    _emitDecks();
  }

  //*************************** Deck Card Mutations *************************//
  @override
  Future<DeckEntity> addCardsToDeck({
    required String deckId,
    required List<NewDeckCardDraft> drafts,
  }) async {
    await _maybeDelay();
    final existing = _requireDeck(deckId);
    if (drafts.isEmpty) return existing;

    requireDecks(
      existing.cards.length + drafts.length <= DeckEntity.maxCards,
      DecksError.deckCardLimitReached,
      'Adding ${drafts.length} cards exceeds the ${DeckEntity.maxCards}-card deck limit.',
    );

    final createdCards = drafts.map(_buildCardFromDraft).toList();
    final updated = existing.copyWith(
      cards: <DeckCardEntity>[...existing.cards, ...createdCards],
      updatedAt: _now(),
    );
    updated.validate();

    _decksById[deckId] = updated;
    _emitDecks();
    return updated;
  }

  @override
  Future<DeckEntity> reorderDeckCards({
    required String deckId,
    required List<String> orderedCardIds,
  }) async {
    await _maybeDelay();
    final existing = _requireDeck(deckId);
    final reordered = _reorderCardList(existing.cards, orderedCardIds);
    final updated = existing.copyWith(cards: reordered, updatedAt: _now());
    updated.validate();

    _decksById[deckId] = updated;
    _emitDecks();
    return updated;
  }

  @override
  Future<DeckEntity> removeCardsFromDeck({
    required String deckId,
    required Set<String> cardIds,
  }) async {
    await _maybeDelay();
    final existing = _requireDeck(deckId);
    if (cardIds.isEmpty) return existing;

    final filtered =
        existing.cards.where((card) => !cardIds.contains(card.id)).toList();
    final updated = existing.copyWith(cards: filtered, updatedAt: _now());
    updated.validate();

    _decksById[deckId] = updated;
    _emitDecks();
    return updated;
  }

  @override
  Future<DeckEntity> updateDeckCardTransform({
    required String deckId,
    required String cardId,
    required double scale,
    required double panX,
    required double panY,
    required double rotation,
  }) async {
    await _maybeDelay();
    final existing = _requireDeck(deckId);
    final index = existing.cards.indexWhere((card) => card.id == cardId);
    requireDecks(index != -1, DecksError.notFound, 'Card $cardId not found.');

    final nextCards = List<DeckCardEntity>.of(existing.cards);
    nextCards[index] = nextCards[index].copyWith(
      scale: scale,
      panX: panX,
      panY: panY,
      rotation: rotation,
    );

    final updated = existing.copyWith(cards: nextCards, updatedAt: _now());
    updated.validate();

    _decksById[deckId] = updated;
    _emitDecks();
    return updated;
  }

  //*************************** Quick Pics Mutations ************************//
  @override
  Future<QuickPicsEntity> addCardsToQuickPics(
    List<NewDeckCardDraft> drafts,
  ) async {
    await _maybeDelay();
    if (drafts.isEmpty) return _quickPics;

    requireDecks(
      _quickPics.cards.length + drafts.length <= QuickPicsEntity.maxCards,
      DecksError.quickPicsLimitReached,
      'Adding ${drafts.length} cards exceeds the ${QuickPicsEntity.maxCards}-card Quick Pics limit.',
    );

    final createdCards = drafts.map(_buildCardFromDraft).toList();
    final updated = _quickPics.copyWith(
      cards: <DeckCardEntity>[..._quickPics.cards, ...createdCards],
      updatedAt: _now(),
    );
    updated.validate();

    _quickPics = updated;
    _quickPicsController.add(_quickPics);
    return _quickPics;
  }

  @override
  Future<QuickPicsEntity> reorderQuickPics(List<String> orderedCardIds) async {
    await _maybeDelay();
    final reordered = _reorderCardList(_quickPics.cards, orderedCardIds);
    final updated = _quickPics.copyWith(cards: reordered, updatedAt: _now());
    updated.validate();

    _quickPics = updated;
    _quickPicsController.add(_quickPics);
    return _quickPics;
  }

  @override
  Future<QuickPicsEntity> removeCardsFromQuickPics(Set<String> cardIds) async {
    await _maybeDelay();
    if (cardIds.isEmpty) return _quickPics;

    final filtered =
        _quickPics.cards.where((card) => !cardIds.contains(card.id)).toList();
    final updated = _quickPics.copyWith(cards: filtered, updatedAt: _now());
    updated.validate();

    _quickPics = updated;
    _quickPicsController.add(_quickPics);
    return _quickPics;
  }

  //*************************** Entitlements ********************************//
  @override
  Future<void> setSocialdeckPlus(bool enabled) async {
    await _maybeDelay();
    if (_isSocialdeckPlus == enabled) return;
    _isSocialdeckPlus = enabled;
    _plusController.add(_isSocialdeckPlus);
  }

  //*************************** Private Helpers *****************************//
  Future<void> _maybeDelay() async {
    if (simulatedDelay > Duration.zero) {
      await Future<void>.delayed(simulatedDelay);
    }
  }

  String _nextId(String prefix) {
    _idCounter += 1;
    return '${prefix}_${_now().microsecondsSinceEpoch}_$_idCounter';
  }

  DeckEntity _requireDeck(String deckId) {
    final deck = _decksById[deckId];
    requireDecks(deck != null, DecksError.notFound, 'Deck $deckId not found.');
    return deck!;
  }

  DeckCardEntity _buildCardFromDraft(NewDeckCardDraft draft) {
    return DeckCardEntity.create(
      id: _nextId('card'),
      localPath: draft.localPath,
      assetId: draft.assetId,
      tiltDegrees: draft.tiltDegrees,
      random: _random,
    );
  }

  List<DeckCardEntity> _reorderCardList(
    List<DeckCardEntity> current,
    List<String> orderedIds,
  ) {
    final byId = <String, DeckCardEntity>{
      for (final card in current) card.id: card,
    };
    requireDecks(
      orderedIds.length == byId.length &&
          orderedIds.toSet().length == byId.length &&
          orderedIds.every(byId.containsKey),
      DecksError.invalidInput,
      'orderedCardIds must match the current card set exactly.',
    );
    return <DeckCardEntity>[for (final id in orderedIds) byId[id]!];
  }

  List<DeckEntity> _sortedDecksSnapshot() {
    final list = _decksById.values.toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return List<DeckEntity>.unmodifiable(list);
  }

  void _emitDecks() {
    _decksController.add(_sortedDecksSnapshot());
  }
}
