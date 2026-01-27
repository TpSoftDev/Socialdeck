/*----------------------------- button_enums.dart -------------------------*/
// Shared enums for button components in the SocialDeck design system.
// These enums define size variations, shapes, icon locations, and interaction
// states that control button appearance and behavior across all button types.
//
// Usage:
//   SDeckButtonSize.large
//   SDeckButtonShape.round
//   SDeckButtonIconLocation.left
/*--------------------------------------------------------------------------*/

//*************************** Enums **********************************//
/// Button size variations - affects padding, text size, and icon spacing
enum SDeckButtonSize { small, medium, large }

/// Button shape - controls corner rounding
enum SDeckButtonShape { default_, round }

/// Icon location - determines icon placement and layout
enum SDeckButtonIconLocation { none, left, right, only }

/// Button interaction state - controls visual appearance based on user interaction
enum SDeckButtonState { enabled, pressed, disabled }
