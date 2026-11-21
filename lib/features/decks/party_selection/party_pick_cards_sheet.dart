/*--------------------- party_pick_cards_sheet.dart -------------------------*/
// Figma Pick 7 Cards / Change Cards method sheet for the Party lobby.
// Composes showSDeckBottomSheet + SDeckImageTarget so lobby handoff stays in
// decks/party_selection per the Phase 5 plan.
//
// Usage:
//   final method = await showPartyPickCardsSheet(
//     context: context,
//     hasHand: currentHand?.cards.isNotEmpty ?? false,
//   );
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//-------------------------- PartyPickCardsMethod ---------------------------//
enum PartyPickCardsMethod { singleDeck, freeToChoose, random }

//*************************** Sheet Entry ***********************************//
/// Returns the chosen method, or null if the sheet was dismissed.
Future<PartyPickCardsMethod?> showPartyPickCardsSheet({
  required BuildContext context,
  required bool hasHand,
}) async {
  PartyPickCardsMethod? method;

  await showSDeckBottomSheet(
    context: context,
    title: hasHand ? 'Change Cards' : 'Pick 7 Cards',
    buttons: [
      //----------------------------- Single Deck ---------------------------//
      SDeckImageTarget(
        title: 'Single Deck',
        description: 'Handpick 7 cards from one deck.',
        onTap: () {
          method = PartyPickCardsMethod.singleDeck;
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),

      //--------------------------- Free-to-Choose --------------------------//
      SDeckImageTarget(
        title: 'Free-to-Choose',
        description: 'Handpick all 7 cards yourself.',
        onTap: () {
          method = PartyPickCardsMethod.freeToChoose;
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),

      //------------------------------- Random ------------------------------//
      SDeckImageTarget(
        title: 'Random',
        description: '7 cards from any deck.',
        onTap: () {
          method = PartyPickCardsMethod.random;
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
    ],
  );

  return method;
}
