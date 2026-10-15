/*------------------------- deck_cards_page.dart -----------------------------*/
// Deck cards page. Shown after a deck is created, and later when one is opened.
// The title is the deck name. Photos come back from Camera Roll and stay on
// the deck until a backend exists.
//
// Usage: context.push(AppPaths.deckCards)
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/decks/decks_home/saved_deck.dart';
import 'package:socialdeck/features/decks/shared/move/sdeck_move_grid.dart';
import 'package:socialdeck/features/decks/shared/saved_card.dart';

//---------------------------- DeckCardsPage --------------------------------//
class DeckCardsPage extends StatefulWidget {
  const DeckCardsPage({
    super.key,
    required this.deck,
  });

  // The same object Decks home shows. Photos added here update its count.
  final SavedDeck deck;

  @override
  State<DeckCardsPage> createState() => _DeckCardsPageState();
}

class _DeckCardsPageState extends State<DeckCardsPage> {
  //*************************** Photos ****************************************//
  List<SavedCard> get _photoPaths => widget.deck.photoPaths;

  bool get _hasPhotos => _photoPaths.isNotEmpty;

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

  // Back returns to the name screen. Done jumps to Decks home and keeps the deck.
  Widget _buildTopBar() {
    return SDeckTopNavigationBar(
      left: SDeckTopBarLeft.back,
      type: SDeckTopBarType.subpage,
      right: SDeckTopBarRight.button,
      title: widget.deck.name,
      rightButtonLabel: 'Done',
      rightButtonSize: SDeckButtonSize.small,
      onRightPressed: _goToDecksHome,
    );
  }

  void _goToDecksHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget _buildBody(BuildContext context) {
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
            supportingText: '${_photoPaths.length}/${SavedDeck.maxCards}',
            padded: false,
          ),

          const SizedBox(height: SDeckSpace.gap12),

          //------------------------ Cards ----------------------------------//
          _buildPhotoGrid(),
          if (!_hasPhotos) ...[
            const SizedBox(height: SDeckSpace.gap12),
            _buildEmptyState(context),
          ],
        ],
      ),
    );
  }

  //*************************** Card Grid *************************************//
  // Same press-and-hold grid Quick Pics uses. This page draws the card.
  Widget _buildPhotoGrid() {
    return SDeckMoveGrid<SavedCard>(
      items: _photoPaths,
      leading: SDeckAddTarget(
        onTap: () => _showAddCardsSheet(context),
      ),
      onReorder: _saveCardOrder,
      tiltDegrees: (card) => card.tiltDegrees,
      itemBuilder: _card,
      heldItemBuilder: _heldCard,
    );
  }

  Widget _card(SavedCard card) {
    return SDeckPlayingCard(
      size: SDeckPlayingCardSize.small,
      shadow: SDeckPlayingCardShadow.none,
      imagePath: card.photoPath,
    );
  }

  // Held card stays straight and grows to 174 by 234.
  // The yellow border comes from moveHeld.
  Widget _heldCard(SavedCard card) {
    return SizedBox(
      width: 116 * 1.5,
      height: 156 * 1.5,
      child: FittedBox(
        fit: BoxFit.fill,
        child: SDeckPlayingCard(
          size: SDeckPlayingCardSize.small,
          shadow: SDeckPlayingCardShadow.none,
          state: SDeckPlayingCardState.moveHeld,
          imagePath: card.photoPath,
        ),
      ),
    );
  }

  void _saveCardOrder(List<SavedCard> next) {
    setState(() {
      _photoPaths
        ..clear()
        ..addAll(next);
    });
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
            final picked = await context.push<List<String>>(AppPaths.cameraRoll);
            if (!mounted || picked == null || picked.isEmpty) return;
            setState(() {
              _photoPaths.addAll(picked.map(SavedCard.new));
            });
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
}
