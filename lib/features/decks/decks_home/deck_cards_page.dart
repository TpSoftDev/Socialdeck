/*------------------------- deck_cards_page.dart -----------------------------*/
// Deck Cards page — shown after creating a deck (and later when opening one).
// Title is the deck name. Section lists all cards with a count; first cell is
// addTarget, then playing cards. Matches Figma Create Deck → Cards frame.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//---------------------------- DeckCardsPage --------------------------------//
class DeckCardsPage extends StatelessWidget {
  const DeckCardsPage({
    super.key,
    required this.deckName,
    this.selectedColor = SDeckColorPickerColor.brightCoral,
    this.cardCount = 2,
    this.maxCards = 52,
  });

  final String deckName;
  final SDeckColorPickerColor selectedColor;
  final int cardCount;
  final int maxCards;

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    // selectedColor reserved for deckTarget / deck chrome once that ships.
    final _ = selectedColor;

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.none,
              title: deckName,
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
                    //------------------------ Section Header -----------------//
                    SDeckSectionHeader(
                      title: 'All Cards',
                      supportingText: '$cardCount/$maxCards',
                    ),

                    const SizedBox(height: SDeckSpace.gap12),

                    //------------------------ Card Row -----------------------//
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SDeckAddTarget(
                          onTap: () {
                            // Add card flow not wired yet.
                          },
                        ),
                        const SizedBox(width: SDeckSpace.gap12),
                        const SDeckPlayingCard(
                          size: SDeckPlayingCardSize.small,
                          shadow: SDeckPlayingCardShadow.none,
                          state: SDeckPlayingCardState.default_,
                        ),
                        const SizedBox(width: SDeckSpace.gap12),
           
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
