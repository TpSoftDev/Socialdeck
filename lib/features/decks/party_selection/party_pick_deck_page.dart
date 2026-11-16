/*----------------------- party_pick_deck_page.dart -------------------------*/
// Figma Pick a Deck screen for Party Single Deck selection. Shows the signed-in
// user's Decks as SDeckDeckTarget tiles, dims decks with fewer than 7 cards,
// and returns the chosen DeckEntity so the lobby can draw 7 and sync.
//
// Usage:
//   final deck = await context.push<DeckEntity>(AppPaths.partyPickDeck);
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/decks/domain/deck_entity.dart';
import 'package:socialdeck/features/decks/providers/decks_providers.dart';

//----------------------------- PartyPickDeckPage ---------------------------//
class PartyPickDeckPage extends ConsumerStatefulWidget {
  const PartyPickDeckPage({super.key});

  @override
  ConsumerState<PartyPickDeckPage> createState() => _PartyPickDeckPageState();
}

class _PartyPickDeckPageState extends ConsumerState<PartyPickDeckPage> {
  //*************************** Selection ***********************************//
  String? _selectedDeckId;

  static const int _handSize = 7;

  //*************************** Build ***************************************//
  @override
  Widget build(BuildContext context) {
    final decksAsync = ref.watch(decksWatchProvider);
    final decks = decksAsync.valueOrNull ?? const <DeckEntity>[];
    final eligibleCount =
        decks.where((deck) => deck.cardCount >= _handSize).length;

    DeckEntity? selected;
    for (final deck in decks) {
      if (deck.id == _selectedDeckId) {
        selected = deck;
        break;
      }
    }

    final canConfirm =
        selected != null && selected.cardCount >= _handSize;

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.none,
              title: 'Pick a Deck',
            ),
            Expanded(
              child: decksAsync.isLoading && !decksAsync.hasValue
                  ? const Center(child: CircularProgressIndicator())
                  : _buildBody(
                      context,
                      decks: decks,
                      eligibleCount: eligibleCount,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SDeckSpace.margin16,
                SDeckSpace.gap12,
                SDeckSpace.margin16,
                SDeckSpace.margin16,
              ),
              child: SDeckSolidButton(
                text: canConfirm
                    ? 'Use ${selected!.name}'
                    : 'None Selected',
                size: SDeckButtonSize.large,
                fullWidth: true,
                onPressed: canConfirm
                    ? () => context.pop(selected)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //*************************** Body ****************************************//
  Widget _buildBody(
    BuildContext context, {
    required List<DeckEntity> decks,
    required int eligibleCount,
  }) {
    if (decks.isEmpty) {
      return Center(
        child: Text(
          'Create a deck with at least $_handSize cards first.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body.copyWith(
            color: context.component.textSecondary,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.margin16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SDeckSectionHeader(
            title: 'All Decks',
            supportingText: '$eligibleCount/${decks.length}',
            padded: false,
          ),
          const SizedBox(height: SDeckSpace.gap12),
          _buildDeckGrid(decks),
        ],
      ),
    );
  }

  // Figma: 3-column deckTarget grid (116×156 tiles).
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
    final eligible = deck.cardCount >= _handSize;
    final selected = deck.id == _selectedDeckId;
    final state = !eligible
        ? SDeckDeckTargetState.disabled
        : selected
            ? SDeckDeckTargetState.selected
            : SDeckDeckTargetState.enabled;

    return Center(
      child: SDeckDeckTarget(
        color: _resolveDeckColor(deck.colorKey),
        favorited: deck.favorited,
        deckTitle: deck.name,
        cardCount: '${deck.cardCount}',
        shadow: SDeckDeckTargetShadow.none,
        state: state,
        onTap: eligible
            ? () => setState(() => _selectedDeckId = deck.id)
            : null,
      ),
    );
  }

  SDeckColorPickerColor _resolveDeckColor(String colorKey) {
    for (final value in SDeckColorPickerColor.values) {
      if (value.name == colorKey) return value;
    }
    return SDeckColorPickerColor.brightCoral;
  }
}
