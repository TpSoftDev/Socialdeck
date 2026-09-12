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

/// Input visual state — border, background, and field text tone.
///
/// **Figma-aligned usage:** With a [TextEditingController] on [SDeckInput], the
/// widget derives **hint** vs **focused** chrome from trimmed text; pass **error**
/// / **disabled** only. Without a controller, [filled] means “has a value” (same
/// chrome as focused); raw [focused] is normalized to hint so an empty field never
/// shows the active border from focus alone.
enum SDeckInputState {
  hint,
  focused,
  filled,
  disabled,
  error,
}
