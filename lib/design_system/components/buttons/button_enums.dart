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

/// Button interaction state. [hover] is the Figma Hover state.
/// Pressed takes priority over hover while the pointer is down.
enum SDeckButtonState { enabled, hover, pressed, disabled }

/// Outline button color. [primary] is Figma Color=Primary. [brightCoral] is
/// Color=Negative (outlineButtonBorderBrightCoral).
enum SDeckOutlineButtonColor { primary, brightCoral }

/// Solid button color. [primary] is Figma Color=Primary. [brightCoral] is
/// Color=Negative (solidButtonPrimarySurfaceBrightCoral).
enum SDeckSolidButtonColor { primary, brightCoral }

/// Text button color. [primary] is Figma Color=Primary. [brightCoral] is
/// Color=Negative (textButtonTextBrightCoral).
enum SDeckTextButtonColor { primary, brightCoral }
