import 'dart:math';
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
import '../decks_home/saved_deck.dart';
import 'saved_card.dart';

enum DeckPartySelectionMode { singleDeck, handpicked, random }

/// IA: Screen-only draft shared by the existing Decks and DeckCards pages.
/// It never mutates the library, uploads images, writes Firebase or enables Ready.
class DeckPartySelection extends ChangeNotifier {
  DeckPartySelection({required this.mode, required this.decks});
  final DeckPartySelectionMode mode;
  final List<SavedDeck> decks;
  final _selectedPaths = <String>{};
  SavedDeck? selectedDeck;
  bool _enabled = true;
  bool get enabled => _enabled;
  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      notifyListeners();
    }
  }

  List<SavedCard> unique(Iterable<SavedCard> cards) =>
      {for (final c in cards) c.photoPath: c}.values.toList();
  List<SavedCard> get allCards => unique(decks.expand((d) => d.photoPaths));
  List<SavedCard> get selectedCards => [
    for (final path in _selectedPaths)
      for (final card in allCards)
        if (card.photoPath == path) card,
  ];
  bool isSelected(SavedCard card) => _selectedPaths.contains(card.photoPath);
  void toggle(SavedCard card) {
    if (!enabled || !allCards.any((c) => c.photoPath == card.photoPath)) return;
    if (!_selectedPaths.remove(card.photoPath)) {
      _selectedPaths.add(card.photoPath);
    }
    notifyListeners();
  }

  void selectDeck(SavedDeck deck) {
    if (!enabled ||
        !decks.contains(deck) ||
        unique(deck.photoPaths).length < 7) {
      return;
    }
    selectedDeck = deck;
    notifyListeners();
  }

  List<SavedCard> get pool => switch (mode) {
    DeckPartySelectionMode.random => allCards,
    DeckPartySelectionMode.singleDeck =>
      decks.contains(selectedDeck)
          ? unique(selectedDeck!.photoPaths)
          : <SavedCard>[],
    DeckPartySelectionMode.handpicked => selectedCards,
  };
  bool get canConfirm => enabled && pool.length >= 7;
  List<SavedCard>? finish({Random? random}) {
    if (!canConfirm) return null;
    final candidates = [...pool]..shuffle(random ?? Random());
    return List.unmodifiable(candidates.take(7));
  }
}

/// IA: Same team tray/buttons in both existing screens, with one shared draft.
class DeckPartySelectionFooter extends StatelessWidget {
  const DeckPartySelectionFooter({
    super.key,
    required this.selection,
    required this.onConfirm,
  });
  final DeckPartySelection selection;
  final VoidCallback onConfirm;
  @override
  Widget build(BuildContext context) {
    final handpick = selection.mode == DeckPartySelectionMode.handpicked;
    final count = selection.pool.length;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (handpick)
            SDeckCardList(
              items: [
                for (final c in selection.selectedCards.reversed)
                  SDeckCardListItem(
                    imagePath: c.photoPath,
                    onRemove:
                        selection.enabled ? () => selection.toggle(c) : null,
                  ),
              ],
            ),
          const SizedBox(height: 8),
          Text(
            selection.enabled
                ? 'Preview only — saved cards and Ready will not change.'
                : 'The party changed. Go back to the lobby.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          SDeckSolidButton(
            fullWidth: true,
            onPressed: selection.canConfirm ? onConfirm : null,
            text:
                selection.mode == DeckPartySelectionMode.singleDeck
                    ? (selection.selectedDeck == null
                        ? 'None Selected'
                        : 'Use ${selection.selectedDeck!.name}')
                    : count < 7
                    ? '${7 - count} Cards Remaining'
                    : handpick
                    ? (count == 7
                        ? 'Use These 7 Cards'
                        : 'Use Any of $count Cards')
                    : 'Use 7 Random Cards',
          ),
        ],
      ),
    );
  }
}

// IA: Read-only selection layout; no reorder/add gestures in Party mode.
class DeckPartySelectionGrid<T> extends StatelessWidget {
  const DeckPartySelectionGrid({
    super.key,
    required this.items,
    required this.builder,
  });
  final List<T> items;
  final Widget Function(T) builder;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = ((constraints.maxWidth - 24) / 3).clamp(0.0, 116.0);
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final item in items)
            SizedBox(
              width: width,
              height: width * 156 / 116,
              child: FittedBox(child: builder(item)),
            ),
        ],
      );
    },
  );
}
