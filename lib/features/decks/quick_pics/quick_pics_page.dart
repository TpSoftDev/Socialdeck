/*------------------------- quick_pics_page.dart -----------------------------*/
// Quick Pics page for the Decks feature.
// Empty until Camera Roll returns photos. Those paths stay on this page
// until a backend exists.
// No bottom nav — navigated to from the Decks page via context.push().
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/decks/shared/move/sdeck_move_grid.dart';
import 'package:socialdeck/features/decks/shared/saved_card.dart';

//------------------------------- QuickPicsPage -----------------------------//
class QuickPicsPage extends StatefulWidget {
  const QuickPicsPage({super.key});

  @override
  State<QuickPicsPage> createState() => _QuickPicsPageState();
}

class _QuickPicsPageState extends State<QuickPicsPage> {
  // Photos from Camera Roll, in the order they were saved.
  final List<SavedCard> _photoPaths = [];

  static const int _maxCards = 100;

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    final hasPhotos = _photoPaths.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.none,
              title: "Quick Pics",
            ),

            //------------------------ Main Content Area ---------------------//
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: SDeckSpace.margin16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //------------------------ All Cards Section --------------//
                    SDeckSectionHeader(
                      title: "All Cards",
                      supportingText: "${_photoPaths.length}/$_maxCards",
                    ),

                    const SizedBox(height: SDeckSpace.gap12),

                    //------------------------ Cards ---------------------------//
                    if (hasPhotos)
                      _buildPhotoGrid()
                    else ...[
                      SDeckAddTarget(
                        onTap: () => _showAddCardsSheet(context),
                      ),
                      const SizedBox(height: SDeckSpace.gap12),
                      _buildEmptyState(context),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Same press-and-hold grid the decks use. This page draws the card.
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
            "Save some cards for later!",
            style: Theme.of(context).textTheme.body.copyWith(
              color: context.component.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  //*************************** Private Methods *******************************//
  void _showAddCardsSheet(BuildContext context) {
    showSDeckBottomSheet(
      context: context,
      title: "Add Cards",
      buttons: [
        //-------------------- Shuffle Search Target -------------------------//
        SDeckImageTarget(
          title: 'Shuffle Search',
          description: 'Select from 16 random photos',
          onTap: () {},
        ),

        //-------------------- Camera Roll Button ---------------------------//
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

        //-------------------- Take a Photo Button --------------------------//
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
