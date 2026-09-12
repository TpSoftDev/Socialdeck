/*-------------------------- deck_target_enums.dart --------------------------*/
// Shared enums for the SDeckDeckTarget component in the SocialDeck design
// system. Color reuses SDeckColorPickerColor so picker and deck stay in sync.
//
// Usage:
//   SDeckDeckTargetState.selected
//   SDeckDeckTargetShadow.medium
/*--------------------------------------------------------------------------*/

//*************************** Enums **********************************//

// Controls the hard drop shadow. Same levels as the playing card shadow enum.
enum SDeckDeckTargetShadow { none, low, medium, high }

// Controls interaction chrome: border, glow, dim overlay, and scale.
//
// - enabled   default border, base size 116x156
// - selected  sky-blue border and low blue glow
// - disabled  dim overlay on top of the card
// - moveHeld  yellow border, high yellow glow, scaled to 174x234
enum SDeckDeckTargetState { enabled, selected, disabled, moveHeld }
