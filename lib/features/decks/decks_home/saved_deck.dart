/*---------------------------- saved_deck.dart -------------------------------*/
// A deck the Decks pages share before a backend exists.
// Create writes one. Decks home and the deck cards page read the same object.
//
// Usage: DecksLibrary.instance.decks
/*--------------------------------------------------------------------------*/

import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/decks/shared/saved_card.dart';

//------------------------------- SavedDeck ---------------------------------//
class SavedDeck {
  SavedDeck({
    required this.name,
    required this.color,
  }) : tiltDegrees = randomTiltDegrees();

  // Name and color can change if the user goes back to the create screens.
  String name;
  SDeckColorPickerColor color;

  // Set once, from -2 to 2 degrees. The deck keeps this tilt when it moves.
  final double tiltDegrees;

  // Cards in this deck, in the order they were saved.
  final List<SavedCard> photoPaths = [];

  static const int maxCards = 52;
}

//----------------------------- DecksLibrary --------------------------------//
class DecksLibrary {
  DecksLibrary._();

  static final DecksLibrary instance = DecksLibrary._();

  // A free account stops at two decks. Buy turns Socialdeck+ on for this
  // session so the unlimited home can be tested. A restart clears it.
  static const int freeDeckLimit = 2;

  final List<SavedDeck> decks = [];

  bool isSocialdeckPlus = false;

  bool get isAtFreeLimit =>
      !isSocialdeckPlus && decks.length >= freeDeckLimit;
}
