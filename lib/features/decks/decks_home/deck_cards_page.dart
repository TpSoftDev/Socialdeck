/*------------------------- deck_cards_page.dart -----------------------------*/
// Deck cards page shown after creating a deck or tapping one on Decks home.
// Watches the live DeckEntity via deckByIdProvider(deckId) and persists Camera
// Roll picks and press-and-hold card reorders through decksActionsProvider.
//
// Usage: context.push(AppPaths.deckCards, extra: deck)
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/decks/domain/deck_card_entity.dart';
import 'package:socialdeck/features/decks/domain/deck_entity.dart';
import 'package:socialdeck/features/decks/domain/decks_failure.dart';
import 'package:socialdeck/features/decks/domain/decks_repository.dart';
import 'package:socialdeck/features/decks/providers/decks_actions_provider.dart';
import 'package:socialdeck/features/decks/providers/decks_providers.dart';
import 'package:socialdeck/features/decks/shared/move/sdeck_move_grid.dart';

//---------------------------- DeckCardsPage --------------------------------//
class DeckCardsPage extends ConsumerStatefulWidget {
  const DeckCardsPage({
    super.key,
    required this.deckId,
    this.initialTitle = 'Your Deck',
  });

  final String deckId;
  final String initialTitle;

  @override
  ConsumerState<DeckCardsPage> createState() => _DeckCardsPageState();
}

class _DeckCardsPageState extends ConsumerState<DeckCardsPage> {
  //*************************** Toast State ***********************************//
  ({SDeckToastStatus status, String title, String description})? _toast;

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    // Keep autoDispose actions alive for Camera Roll / reorder awaits.
    ref.watch(decksActionsProvider);
    final deckAsync = ref.watch(deckByIdProvider(widget.deckId));
    final deck = deckAsync.valueOrNull;
    final cards = deck?.cards ?? const <DeckCardEntity>[];
    final title = deck?.name ?? widget.initialTitle;

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(title),

            if (_toast != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  SDeckSpace.margin16,
                  0,
                  SDeckSpace.margin16,
                  SDeckSpace.gap12,
                ),
                child: SDeckToast(
                  status: _toast!.status,
                  title: _toast!.title,
                  description: _toast!.description,
                  onDismiss: () => setState(() => _toast = null),
                ),
              ),

            Expanded(
              child: deckAsync.isLoading && !deckAsync.hasValue
                  ? const Center(child: CircularProgressIndicator())
                  : _buildBody(context, cards),
            ),
          ],
        ),
      ),
    );
  }

  // Back returns to the previous screen. Done jumps to Decks home and keeps the deck.
  Widget _buildTopBar(String title) {
    return SDeckTopNavigationBar(
      left: SDeckTopBarLeft.back,
      type: SDeckTopBarType.subpage,
      right: SDeckTopBarRight.button,
      title: title,
      rightButtonLabel: 'Done',
      rightButtonSize: SDeckButtonSize.small,
      onRightPressed: _goToDecksHome,
    );
  }

  void _goToDecksHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget _buildBody(BuildContext context, List<DeckCardEntity> cards) {
    final hasPhotos = cards.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: SDeckSpace.margin16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //------------------------ All Cards ------------------------------//
          // Unpadded so the title sits on the page and lines up with the cards.
          SDeckSectionHeader(
            title: 'All Cards',
            supportingText: '${cards.length}/${DeckEntity.maxCards}',
            padded: false,
          ),

          const SizedBox(height: SDeckSpace.gap12),

          //------------------------ Cards ----------------------------------//
          _buildPhotoGrid(cards),
          if (!hasPhotos) ...[
            const SizedBox(height: SDeckSpace.gap12),
            _buildEmptyState(context),
          ],
        ],
      ),
    );
  }

  //*************************** Card Grid *************************************//
  // Same press-and-hold grid Quick Pics uses. This page draws the card.
  Widget _buildPhotoGrid(List<DeckCardEntity> cards) {
    return SDeckMoveGrid<DeckCardEntity>(
      items: cards,
      leading: SDeckAddTarget(
        onTap: () => _showAddCardsSheet(context),
      ),
      onReorder: _saveCardOrder,
      tiltDegrees: (card) => card.tiltDegrees,
      itemBuilder: _card,
      heldItemBuilder: _heldCard,
    );
  }

  Widget _card(DeckCardEntity card) {
    return SDeckPlayingCard(
      size: SDeckPlayingCardSize.small,
      shadow: SDeckPlayingCardShadow.none,
      imagePath: card.localPath,
      scale: card.scale,
      panX: card.panX,
      panY: card.panY,
    );
  }

  // Held card stays straight and grows to 174 by 234.
  // The yellow border comes from moveHeld.
  Widget _heldCard(DeckCardEntity card) {
    return SizedBox(
      width: 116 * 1.5,
      height: 156 * 1.5,
      child: FittedBox(
        fit: BoxFit.fill,
        child: SDeckPlayingCard(
          size: SDeckPlayingCardSize.small,
          shadow: SDeckPlayingCardShadow.none,
          state: SDeckPlayingCardState.moveHeld,
          imagePath: card.localPath,
          scale: card.scale,
          panX: card.panX,
          panY: card.panY,
        ),
      ),
    );
  }

  Future<void> _saveCardOrder(List<DeckCardEntity> next) async {
    final orderedIds = next.map((card) => card.id).toList();
    final ok = await ref
        .read(decksActionsProvider.notifier)
        .reorderDeckCards(deckId: widget.deckId, orderedCardIds: orderedIds);
    if (!mounted || ok) return;
    _showErrorToast();
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
            'Add cards to your deck!',
            style: Theme.of(context).textTheme.body.copyWith(
              color: context.component.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  //*************************** Add Cards *************************************//
  // Same sheet Quick Pics uses. Camera Roll is the only action wired so far.
  void _showAddCardsSheet(BuildContext context) {
    showSDeckBottomSheet(
      context: context,
      title: 'Add Cards',
      buttons: [
        //-------------------- Shuffle Search --------------------------------//
        SDeckImageTarget(
          title: 'Shuffle Search',
          description: 'Select from 16 random photos',
          onTap: () {},
        ),

        //-------------------- Camera Roll -----------------------------------//
        SDeckSolidButton(
          text: 'Camera Roll',
          size: SDeckButtonSize.large,
          iconLocation: SDeckButtonIconLocation.left,
          iconTextGap: SDeckSpace.gap6,
          icon: SDeckIcons(
            SDeckIcon.grid,
            size: SDeckSize.size24,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            final picked = await context.push<List<NewDeckCardDraft>>(
              AppPaths.cameraRoll,
            );
            if (!mounted || picked == null || picked.isEmpty) return;

            final updated = await ref
                .read(decksActionsProvider.notifier)
                .addCardsToDeck(deckId: widget.deckId, drafts: picked);
            if (!mounted || updated != null) return;
            _showErrorToast();
          },
        ),

        //-------------------- Take a Photo ----------------------------------//
        SDeckOutlineButton(
          text: 'Take a Photo',
          size: SDeckButtonSize.large,
          iconLocation: SDeckButtonIconLocation.left,
          iconTextGap: SDeckSpace.gap6,
          icon: SDeckIcons(
            SDeckIcon.camera,
            size: SDeckSize.size24,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  void _showErrorToast() {
    final error = ref.read(decksActionsProvider).error;
    final isLimit = error == DecksError.deckCardLimitReached;
    setState(() {
      _toast = (
        status: isLimit ? SDeckToastStatus.warning : SDeckToastStatus.error,
        title: decksErrorTitle(error),
        description: decksErrorMessage(error),
      );
    });
  }
}
