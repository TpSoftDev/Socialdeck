/*---------------- party_free_to_choose_cards_page.dart ---------------------*/
// Card grid for one Free-to-Choose source (a deck or Quick Pics). Carries the
// browse-page shelf selection in and out so picks persist across sources.
// Figma: 3-col All Cards grid, sticky shelf, and CTA that can confirm the hand
// ("Use These 7 Cards" / "Use Any of N Cards") or return shelf state on back.
//
// Usage:
//   final result = await Navigator.of(context).push<PartyFreeToChooseCardsResult>(
//     MaterialPageRoute(
//       builder: (_) => PartyFreeToChooseCardsPage(
//         title: 'Quick Pics',
//         cards: quickPics.cards,
//         initialSelected: selected,
//         initialResolvedPaths: paths,
//       ),
//     ),
//   );
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/decks/data/local_photo_resolver.dart';
import 'package:socialdeck/features/decks/domain/deck_card_entity.dart';
import 'package:socialdeck/features/decks/party_selection/party_hand_selection.dart';

//---------------------- PartyFreeToChooseCardsResult -----------------------//
class PartyFreeToChooseCardsResult {
  const PartyFreeToChooseCardsResult({
    required this.selected,
    required this.resolvedPaths,
    this.confirmed = false,
  });

  final List<DeckCardEntity> selected;
  final Map<String, String> resolvedPaths;

  /// True when the user tapped Use These 7 / Use Any of N on this screen.
  final bool confirmed;
}

//---------------------- PartyFreeToChooseCardsPage -------------------------//
class PartyFreeToChooseCardsPage extends StatefulWidget {
  const PartyFreeToChooseCardsPage({
    super.key,
    required this.title,
    required this.cards,
    required this.initialSelected,
    required this.initialResolvedPaths,
  });

  final String title;
  final List<DeckCardEntity> cards;
  final List<DeckCardEntity> initialSelected;
  final Map<String, String> initialResolvedPaths;

  @override
  State<PartyFreeToChooseCardsPage> createState() =>
      _PartyFreeToChooseCardsPageState();
}

class _PartyFreeToChooseCardsPageState
    extends State<PartyFreeToChooseCardsPage> {
  //*************************** Layout **************************************//
  // Figma Select Cards wrap list: 3 columns, deck-target-like tile ratio.
  static const int _columns = 3;

  //*************************** Selection ***********************************//
  late final List<DeckCardEntity> _selected;
  late final Map<String, String> _resolvedPaths;
  final _resolver = const LocalPhotoResolver();

  @override
  void initState() {
    super.initState();
    _selected = List<DeckCardEntity>.from(widget.initialSelected);
    _resolvedPaths = Map<String, String>.from(widget.initialResolvedPaths);
  }

  PartyFreeToChooseCardsResult _result({bool confirmed = false}) {
    return PartyFreeToChooseCardsResult(
      selected: List<DeckCardEntity>.unmodifiable(_selected),
      resolvedPaths: Map<String, String>.unmodifiable(_resolvedPaths),
      confirmed: confirmed,
    );
  }

  //*************************** Build ***************************************//
  @override
  Widget build(BuildContext context) {
    final canConfirm = PartyHandSelection.canConfirm(_selected.length);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        context.pop(_result());
      },
      child: Scaffold(
        backgroundColor: context.semantic.surface,
        body: SafeArea(
          child: Column(
            children: [
              SDeckTopNavigationBar(
                left: SDeckTopBarLeft.back,
                type: SDeckTopBarType.subpage,
                right: SDeckTopBarRight.none,
                title: widget.title,
                onLeftPressed: () => context.pop(_result()),
              ),
              Expanded(child: _buildBody(context)),
              _buildShelf(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  SDeckSpace.margin16,
                  0,
                  SDeckSpace.margin16,
                  SDeckSpace.margin16,
                ),
                child: SDeckSolidButton(
                  text: PartyHandSelection.ctaLabel(_selected.length),
                  size: SDeckButtonSize.large,
                  fullWidth: true,
                  onPressed: canConfirm
                      ? () => context.pop(_result(confirmed: true))
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShelf() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SDeckSpace.margin16,
        SDeckSpace.gap12,
        SDeckSpace.margin16,
        SDeckSpace.gap12,
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

  Widget _buildBody(BuildContext context) {
    final cards = widget.cards;
    if (cards.isEmpty) {
      return Center(
        child: Text(
          'No photos in this source yet.',
          style: Theme.of(context).textTheme.body,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.margin16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SDeckSectionHeader(
            title: 'All Cards',
            supportingText: '${cards.length}',
            padded: false,
          ),
          const SizedBox(height: SDeckSpace.gap12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _columns,
              crossAxisSpacing: SDeckSpace.gap12,
              mainAxisSpacing: SDeckSpace.gap12,
              childAspectRatio: 116 / 156,
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
        ],
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

    // Figma allows selecting past 7, then "Use Any of N Cards".
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
