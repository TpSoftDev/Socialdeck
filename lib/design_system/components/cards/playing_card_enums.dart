/*-------------------------- playing_card_enums.dart -------------------------*/
// Shared enums for the SDeckPlayingCard component in the SocialDeck design
// system: Size, Shadow, and State.
//
// Usage:
//   SDeckPlayingCardSize.small
//   SDeckPlayingCardShadow.high
//   SDeckPlayingCardState.selected
/*--------------------------------------------------------------------------*/

//*************************** Enums **********************************//

// Controls card geometry: width, height, padding, and corner radii.
// All sizes share the same aspect ratio and scale from a single unit value.
// Ordered smallest to largest to stay consistent with the button size enum.
enum SDeckPlayingCardSize { extraSmall, small, medium, large, extraLarge }

// Controls the drop shadow. Hard offset shadows with no blur, growing from
// low to high.
enum SDeckPlayingCardShadow { none, low, medium, high }

// Controls the interaction state.
//
// - default_  is the plain card with an optional shadow.
// - selected  adds a sky-blue border and a soft blue glow.
// - moveHeld  adds a yellow border and a yellow glow while the card is held.
// - remove    shows a coral delete badge in the top-right corner.
enum SDeckPlayingCardState { default_, selected, moveHeld, remove }
