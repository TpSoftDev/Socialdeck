/*------------------- party_pick_deck_cards_page.dart -----------------------*/
// Handpick exactly 7 cards from one DeckEntity after Party Pick a Deck.
// Reuses Camera Roll selection patterns (4-col SDeckMediaTarget grid + max 7)
// and SDeckCardList for the shelf. Save resolves on-device paths and pops
// List<NewDeckCardDraft> for the lobby upload path.
//
// Usage:
//   final drafts = await context.push<List<NewDeckCardDraft>>(
//     AppPaths.partyPickDeckCards,
//     extra: deck,
//   );
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/decks/data/local_photo_resolver.dart';
import 'package:socialdeck/features/decks/domain/deck_card_entity.dart';
import 'package:socialdeck/features/decks/domain/deck_entity.dart';
import 'package:socialdeck/features/decks/domain/decks_repository.dart';

//------------------------- PartyPickDeckCardsPage --------------------------//
class PartyPickDeckCardsPage extends StatefulWidget {
  const PartyPickDeckCardsPage({super.key, required this.deck});

  final DeckEntity deck;

  @override
  State<PartyPickDeckCardsPage> createState() => _PartyPickDeckCardsPageState();
}

class _PartyPickDeckCardsPageState extends State<PartyPickDeckCardsPage> {
  //*************************** Layout **************************************//
  static const int _columns = 4;
  static const int _handSize = 7;

  //*************************** Selection ***********************************//
  // Order in this list is the order shown in the shelf and uploaded.
  final List<DeckCardEntity> _selected = [];
  final Map<String, String> _resolvedPaths = {};
  final _resolver = const LocalPhotoResolver();

  bool get _canSave => _selected.length == _handSize;

  //*************************** Build ***************************************//
  @override
  Widget build(BuildContext context) {
    final cards = widget.deck.cards;

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildBody(context, cards)),
            _buildShelf(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SDeckTopNavigationBar(
      left: SDeckTopBarLeft.back,
      type: SDeckTopBarType.subpage,
      right: SDeckTopBarRight.button,
      title: widget.deck.name,
      rightButtonLabel: 'Save',
      rightButtonSize: SDeckButtonSize.small,
      onRightPressed: _canSave ? _onSavePressed : null,
    );
  }

  Widget _buildShelf() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SDeckSpace.margin16,
        SDeckSpace.gap12,
        SDeckSpace.margin16,
        SDeckSpace.margin16,
      ),
      child: SDeckCardList(
        items: [
          for (final card in _selected)
            SDeckCardListItem(
              imagePath: _resolvedPaths[card.id] ?? card.localPath,
              onRemove: () => _toggleCard(card),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<DeckCardEntity> cards) {
    if (cards.isEmpty) {
      return Center(
        child: Text(
          'This deck has no photos yet.',
          style: Theme.of(context).textTheme.body,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.margin16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _columns,
          crossAxisSpacing: SDeckSpace.gap4,
          mainAxisSpacing: SDeckSpace.gap4,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return _DeckCardThumbnail(
            imagePath: _resolvedPaths[card.id] ?? card.localPath,
            selected: _isSelected(card),
            corner: _cornerFor(index, cards.length),
            onTap: () => _toggleCard(card),
          );
        },
      ),
    );
  }

  //*************************** Selection ***********************************//
  bool _isSelected(DeckCardEntity card) {
    return _selected.any((picked) => picked.id == card.id);
  }

  SDeckMediaTargetCorner _cornerFor(int index, int count) {
    final isTop = index < _columns;
    final isBottom = index >= ((count - 1) ~/ _columns) * _columns;
    final column = index % _columns;
    final isLeft = column == 0;
    final isRight = column == _columns - 1;
    final lastRowIsFull = count % _columns == 0;

    if (isTop && isLeft) return SDeckMediaTargetCorner.topLeft;
    if (isTop && isRight) return SDeckMediaTargetCorner.topRight;
    if (isBottom && isLeft) return SDeckMediaTargetCorner.bottomLeft;
    if (isBottom && isRight && lastRowIsFull) {
      return SDeckMediaTargetCorner.bottomRight;
    }
    return SDeckMediaTargetCorner.none;
  }

  Future<void> _toggleCard(DeckCardEntity card) async {
    if (_isSelected(card)) {
      setState(() {
        _selected.removeWhere((picked) => picked.id == card.id);
        _resolvedPaths.remove(card.id);
      });
      return;
    }

    if (_selected.length >= _handSize) return;

    setState(() => _selected.add(card));

    final path = await _resolver.resolveCardPath(card);
    if (!mounted || !_isSelected(card)) return;
    if (path == null) {
      setState(() {
        _selected.removeWhere((picked) => picked.id == card.id);
      });
      return;
    }

    setState(() => _resolvedPaths[card.id] = path);
  }

  Future<void> _onSavePressed() async {
    final drafts = <NewDeckCardDraft>[];
    for (final card in _selected) {
      var path = _resolvedPaths[card.id];
      path ??= await _resolver.resolveCardPath(card);
      if (path == null) {
        if (!mounted) return;
        return;
      }
      drafts.add(
        NewDeckCardDraft(localPath: path, assetId: card.assetId),
      );
    }
    if (!mounted) return;
    context.pop(drafts);
  }
}

//--------------------------- Deck Card Thumbnail ---------------------------//
class _DeckCardThumbnail extends StatelessWidget {
  final String imagePath;
  final bool selected;
  final SDeckMediaTargetCorner corner;
  final VoidCallback onTap;

  const _DeckCardThumbnail({
    required this.imagePath,
    required this.selected,
    required this.corner,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(imagePath);
    final hasFile = imagePath.isNotEmpty && file.existsSync();

    return SDeckMediaTarget(
      image: hasFile ? FileImage(file) : null,
      selected: selected,
      corner: corner,
      onTap: onTap,
    );
  }
}
