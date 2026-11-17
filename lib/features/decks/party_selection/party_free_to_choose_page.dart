/*------------------- party_free_to_choose_page.dart ------------------------*/
// Free-to-Choose browse screen for Party Pick 7. Shows Quick Pics + Decks,
// keeps a sticky SDeckCardList shelf across source switches, and confirms
// exactly 7 cards as List<NewDeckCardDraft>.
//
// Usage:
//   final drafts = await context.push<List<NewDeckCardDraft>>(
//     AppPaths.partyFreeToChoose,
//   );
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/decks/data/local_photo_resolver.dart';
import 'package:socialdeck/features/decks/domain/deck_card_entity.dart';
import 'package:socialdeck/features/decks/domain/deck_entity.dart';
import 'package:socialdeck/features/decks/domain/decks_repository.dart';
import 'package:socialdeck/features/decks/domain/quick_pics_entity.dart';
import 'package:socialdeck/features/decks/party_selection/party_free_to_choose_cards_page.dart';
import 'package:socialdeck/features/decks/party_selection/party_hand_selection.dart';
import 'package:socialdeck/features/decks/providers/decks_providers.dart';

//------------------------- PartyFreeToChoosePage ---------------------------//
class PartyFreeToChoosePage extends ConsumerStatefulWidget {
  const PartyFreeToChoosePage({super.key});

  @override
  ConsumerState<PartyFreeToChoosePage> createState() =>
      _PartyFreeToChoosePageState();
}

class _PartyFreeToChoosePageState
    extends ConsumerState<PartyFreeToChoosePage> {
  //*************************** Selection ***********************************//
  // Lives on this browse page so opening a deck / Quick Pics keeps the shelf.
  final List<DeckCardEntity> _selected = [];
  final Map<String, String> _resolvedPaths = {};
  final _resolver = const LocalPhotoResolver();
  bool _confirming = false;

  bool get _canConfirm =>
      !_confirming && PartyHandSelection.canConfirm(_selected.length);

  //*************************** Build ***************************************//
  @override
  Widget build(BuildContext context) {
    final decksAsync = ref.watch(decksWatchProvider);
    final quickPicsAsync = ref.watch(quickPicsWatchProvider);
    final decks = decksAsync.valueOrNull ?? const <DeckEntity>[];
    final quickPics =
        quickPicsAsync.valueOrNull ?? QuickPicsEntity();

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.none,
              title: 'Pick 7 Cards',
            ),
            Expanded(
              child: (decksAsync.isLoading && !decksAsync.hasValue) ||
                      (quickPicsAsync.isLoading && !quickPicsAsync.hasValue)
                  ? const Center(child: CircularProgressIndicator())
                  : _buildBody(
                      context,
                      decks: decks,
                      quickPics: quickPics,
                    ),
            ),
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
                onPressed: _canConfirm ? _onConfirmPressed : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required List<DeckEntity> decks,
    required QuickPicsEntity quickPics,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.margin16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SDeckImageTarget(
            title: 'Quick Pics',
            description: quickPics.isEmpty
                ? 'No photos saved yet'
                : '${quickPics.cardCount} photos',
            onTap: quickPics.isEmpty
                ? null
                : () => _openSource(
                      title: 'Quick Pics',
                      cards: quickPics.cards,
                    ),
          ),
          const SizedBox(height: SDeckSpace.gap16),
          SDeckSectionHeader(
            title: 'All Decks',
            supportingText: '${decks.length}',
            padded: false,
          ),
          const SizedBox(height: SDeckSpace.gap12),
          if (decks.isEmpty)
            Text(
              'Create a deck to handpick cards.',
              style: Theme.of(context).textTheme.body.copyWith(
                color: context.component.textSecondary,
              ),
            )
          else
            _buildDeckGrid(decks),
        ],
      ),
    );
  }

  Widget _buildDeckGrid(List<DeckEntity> decks) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: decks.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: SDeckSpace.gap12,
        mainAxisSpacing: SDeckSpace.gap12,
        childAspectRatio: 116 / 156,
      ),
      itemBuilder: (context, index) => _deckTile(decks[index]),
    );
  }

  Widget _deckTile(DeckEntity deck) {
    final empty = deck.cardCount == 0;
    return Center(
      child: SDeckDeckTarget(
        color: _resolveDeckColor(deck.colorKey),
        favorited: deck.favorited,
        deckTitle: deck.name,
        cardCount: '${deck.cardCount}',
        shadow: SDeckDeckTargetShadow.none,
        state: empty
            ? SDeckDeckTargetState.disabled
            : SDeckDeckTargetState.enabled,
        onTap: empty
            ? null
            : () => _openSource(title: deck.name, cards: deck.cards),
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
              onRemove: () => _removeCard(card),
            ),
        ],
      ),
    );
  }

  //*************************** Selection ***********************************//
  void _removeCard(DeckCardEntity card) {
    setState(() {
      _selected.removeWhere((picked) => picked.id == card.id);
      _resolvedPaths.remove(card.id);
    });
  }

  Future<void> _openSource({
    required String title,
    required List<DeckCardEntity> cards,
  }) async {
    final result =
        await Navigator.of(context).push<PartyFreeToChooseCardsResult>(
      MaterialPageRoute(
        builder: (_) => PartyFreeToChooseCardsPage(
          title: title,
          cards: cards,
          initialSelected: _selected,
          initialResolvedPaths: _resolvedPaths,
        ),
      ),
    );
    if (!mounted || result == null) return;

    setState(() {
      _selected
        ..clear()
        ..addAll(result.selected);
      _resolvedPaths
        ..clear()
        ..addAll(result.resolvedPaths);
    });
  }

  Future<void> _onConfirmPressed() async {
    if (!PartyHandSelection.canConfirm(_selected.length) || _confirming) {
      return;
    }
    setState(() => _confirming = true);

    final drafts = <NewDeckCardDraft>[];
    for (final card in _selected) {
      var path = _resolvedPaths[card.id];
      path ??= await _resolver.resolveCardPath(card);
      if (path == null) {
        if (!mounted) return;
        setState(() => _confirming = false);
        return;
      }
      drafts.add(
        NewDeckCardDraft(localPath: path, assetId: card.assetId),
      );
    }

    if (!mounted) return;
    context.pop(drafts);
  }

  SDeckColorPickerColor _resolveDeckColor(String colorKey) {
    for (final value in SDeckColorPickerColor.values) {
      if (value.name == colorKey) return value;
    }
    return SDeckColorPickerColor.brightCoral;
  }
}
