/*---------------------------- saved_card.dart -------------------------------*/
// One photo in Quick Pics or in a deck, before a backend exists.
// The tilt is chosen once so a reorder keeps the same angle.
//
// Usage: SavedCard(path)
/*--------------------------------------------------------------------------*/

import 'dart:math' as math;

//------------------------------- SavedCard ---------------------------------//
class SavedCard {
  SavedCard(this.photoPath) : tiltDegrees = randomTiltDegrees();

  final String photoPath;

  // Set once, from -2 to 2 degrees. The card keeps this while it rests.
  final double tiltDegrees;
}

final math.Random _tiltRandom = math.Random();

// Two decimal places, inclusive of -2.00 and 2.00.
double randomTiltDegrees() => (_tiltRandom.nextInt(401) - 200) / 100;
