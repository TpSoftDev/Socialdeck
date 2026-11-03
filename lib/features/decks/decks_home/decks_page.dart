/*---------------------------- decks_page.dart -------------------------------*/
// Decks home. Quick Pics sits on top. All Decks is empty until a deck is
// created, then the add button and the decks share one row.
// The deck list lives in DecksLibrary until a backend exists.
//
// Usage: the Decks tab.
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/decks/decks_home/saved_deck.dart';
import 'package:socialdeck/features/decks/shared/move/sdeck_move_grid.dart';

//------------------------------- DecksPage ---------------------------------//
class DecksPage extends StatefulWidget {
  const DecksPage({super.key});

  @override
  State<DecksPage> createState() => _DecksPageState();
}

class _DecksPageState extends State<DecksPage> {
  //*************************** Decks *****************************************//
  List<SavedDeck> get _decks => DecksLibrary.instance.decks;

  bool get _hasDecks => _decks.isNotEmpty;

  bool get _isPlus => DecksLibrary.instance.isSocialdeckPlus;

  // Free shows 1/2. Socialdeck+ shows the count alone.
  String get _deckCountLabel => _isPlus
      ? '${_decks.length}'
      : '${_decks.length}/${DecksLibrary.freeDeckLimit}';

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return const SDeckTopNavigationBar(
      left: SDeckTopBarLeft.none,
      type: SDeckTopBarType.page,
      right: SDeckTopBarRight.profile,
      title: 'Decks',
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: SDeckSpace.margin16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //------------------------ Quick Pics ------------------------------//
          SDeckImageTarget(
            title: 'Quick Pics',
            description: 'Save cards to revisit or replay',
            onTap: () => context.push(AppPaths.quickPics),
          ),

          SizedBox(height: _hasDecks ? SDeckSpace.gap12 : SDeckSpace.gap16),

          //------------------------ All Decks -------------------------------//
          // Unpadded so the title sits on the page and lines up with the row.
          SDeckSectionHeader(
            title: 'All Decks',
            supportingText: _deckCountLabel,
            padded: false,
          ),

          const SizedBox(height: SDeckSpace.gap12),

          if (_hasDecks) ...[
            _buildDeckRow(),
            if (!_isPlus) ...[
              const SizedBox(height: SDeckSpace.gap12),
              SDeckImageTarget(
                title: 'More Decks?',
                description: 'Get Socialdeck+ for more!',
                onTap: _showMoreDecksDialog,
              ),
            ],
          ] else ...[
            SDeckAddTarget(onTap: _startCreateDeck),
            const SizedBox(height: SDeckSpace.gap12),
            _buildEmptyState(context),
          ],
        ],
      ),
    );
  }

  //*************************** Deck Row **************************************//
  // Shared move grid. This page only draws the deck, including the held look.
  Widget _buildDeckRow() {
    return SDeckMoveGrid<SavedDeck>(
      items: _decks,
      leading: SDeckAddTarget(onTap: _startCreateDeck),
      onItemTap: _openDeck,
      onReorder: _saveDeckOrder,
      itemBuilder: _deckTarget,
      tiltDegrees: (deck) => deck.tiltDegrees,
      heldItemBuilder: (deck) => _deckTarget(
        deck,
        state: SDeckDeckTargetState.moveHeld,
      ),
    );
  }

  Widget _deckTarget(
    SavedDeck deck, {
    SDeckDeckTargetState state = SDeckDeckTargetState.enabled,
  }) {
    return SDeckDeckTarget(
      color: deck.color,
      deckTitle: deck.name,
      cardCount: '${deck.photoPaths.length}/${SavedDeck.maxCards}',
      shadow: SDeckDeckTargetShadow.none,
      state: state,
    );
  }

  void _saveDeckOrder(List<SavedDeck> next) {
    final list = DecksLibrary.instance.decks;
    list
      ..clear()
      ..addAll(next);
    setState(() {});
  }

  //*************************** Empty State ***********************************//
  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 370 / 185,
          child: SDeckVisualPlaceholder(
            borderRadius: BorderRadius.circular(
              SDeckRadius.borderRadius16,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'Create your first deck!',
            style: Theme.of(context).textTheme.body.copyWith(
              color: context.component.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  //*************************** Actions ***************************************//
  // A third deck is past the free limit, so add opens the upgrade dialog.
  Future<void> _startCreateDeck() async {
    if (DecksLibrary.instance.isAtFreeLimit) {
      _showMoreDecksDialog();
      return;
    }

    await context.push(AppPaths.newDeckColor);
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _openDeck(SavedDeck deck) async {
    await context.push(AppPaths.deckCards, extra: deck);
    if (!mounted) return;
    setState(() {});
  }

  // Store goes to the store. Buy turns on Socialdeck+ for this session.
  void _showMoreDecksDialog() {
    final dialogWidth =
        MediaQuery.sizeOf(context).width - (2 * SDeckSpace.margin32);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(SDeckSpace.margin32),
          child: SDeckDialog(
            title: 'More Decks?',
            description: 'Upgrade to Socialdeck+ for infinite decks and more!',
            dialogWidth: dialogWidth,
            contentHeight: (dialogWidth - SDeckSpace.padding24 * 2) * 185 / 370,
            content: const SDeckVisualPlaceholder(),
            secondaryButtonText: 'Store',
            primaryButtonText: 'Buy',
            onSecondaryPressed: () {
              Navigator.of(dialogContext).pop();
              context.push(AppPaths.store);
            },
            onPrimaryPressed: () {
              DecksLibrary.instance.isSocialdeckPlus = true;
              Navigator.of(dialogContext).pop();
              setState(() {});
            },
            onClose: () => Navigator.of(dialogContext).pop(),
          ),
        );
      },
    );
  }
}
