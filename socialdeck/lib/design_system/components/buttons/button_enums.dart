/*-------------------------- button_enums.dart ------------------------------*/
// Shared enums for button components in the SocialDeck design system
// These enums are used by both solid and hollow button components
/*--------------------------------------------------------------------------*/

//------------------------------- Enums -------------------------------------//

/// Button size variations - affects padding, text size, and icon spacing
///
/// Maps to specific design specs:
/// • small: 14px text, minimal padding (0px vertical, 8px horizontal)
/// • medium: 16px text, standard padding (8px vertical, 16px horizontal)
/// • large: 18px text, generous padding (20px vertical, 24px horizontal)
enum SDeckButtonSize {
  small, 
  medium, 
  large, 
}

/// Button radius style - controls corner rounding
///
/// Design specs:
/// • squared: 8px radius on all buttons
/// • round: 24px (small/medium) or 32px (large) radius
enum SDeckButtonRadius {
  squared, 
  round, 
}

/// Icon configuration - determines icon placement and layout
///
/// Affects button content layout and spacing:
/// • none: Text only, centered
/// • left: Icon + gap + text, left-aligned content
/// • right: Text + gap + icon, right-aligned content
enum SDeckButtonIconConfig {
  none, 
  left, 
  right, 
}

/// Button interaction state (controls colors)
enum SDeckButtonState {
  enabled, // Normal interactive state
  hover, // Mouse hover feedback (desktop)
  pressed, // Touch/click down feedback
  disabled, // Non-interactive state
}
