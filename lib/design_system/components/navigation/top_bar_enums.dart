/*----------------------------- top_bar_enums.dart -------------------------*/
// Shared enums for the top navigation bar component in the SocialDeck design system.
// These enums mirror the Figma topBar component playground properties exactly.
// Type controls title size, Left controls left slot content, Right controls right slot content.
//
// Usage:
//   SDeckTopBarType.page
//   SDeckTopBarLeft.back
//   SDeckTopBarRight.icon
/*--------------------------------------------------------------------------*/

//*************************** Enums **********************************//
/// Matches Figma "Type" property - controls title text style
enum SDeckTopBarType { page, subpage }

/// Controls what appears in the left slot of the top bar
enum SDeckTopBarLeft { back, logo, none }

/// Matches Figma "Right Component" property - controls right slot content
enum SDeckTopBarRight { icon, profile, button, skip, logo, none }
