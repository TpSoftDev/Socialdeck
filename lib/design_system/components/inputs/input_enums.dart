/*----------------------------- input_enums.dart -------------------------*/
// Shared enums for input components in the SocialDeck design system.
// These enums define size variations and visual states that control input
// appearance and behavior, matching Figma's Input component properties.
//
// Usage:
//   SDeckInputSize.large
//   SDeckInputState.focused
/*--------------------------------------------------------------------------*/

//*************************** Enums **********************************//
/// Input size variations - affects padding and text size
enum SDeckInputSize {
  medium, // 16px text, 16px/12px padding
  large, // 20px text, 16px padding
}

/// Input visual state - controls border color, background, and text appearance
enum SDeckInputState {
  hint, // Default placeholder state (no text, not focused)
  focused, // Keyboard is up, user is actively typing (automatic)
  filled, // Keyboard is down, has text in field (automatic)
  disabled, // Field is disabled (manual override)
  error, // Validation error (manual override)
}
