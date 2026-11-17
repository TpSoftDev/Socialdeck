/*---------------------- party_hand_selection.dart --------------------------*/
// Shared Free-to-Choose CTA labels for Party Pick 7. Hand size is exactly 7.
/*--------------------------------------------------------------------------*/

//--------------------------- PartyHandSelection ----------------------------//
class PartyHandSelection {
  const PartyHandSelection._();

  static const int handSize = 7;

  /// CTA under the shelf: remaining count, or confirm when exactly 7.
  static String ctaLabel(int selectedCount) {
    if (selectedCount < handSize) {
      return '${handSize - selectedCount} Cards Remaining';
    }
    return 'Use These 7 Cards';
  }

  static bool canConfirm(int selectedCount) => selectedCount == handSize;
}
