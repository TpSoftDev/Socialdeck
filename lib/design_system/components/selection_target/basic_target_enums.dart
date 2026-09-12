/*-------------------------- basic_target_enums.dart --------------------------*/
// cardType controls the card layout and what interactive elements appear.
// state controls the background color tint — only used with the time card type.
/*--------------------------------------------------------------------------*/

/// Controls the card layout.
///
/// - button      — text on the left, action button on the right
/// - buttonOrNot — text on the left, dismiss icon and optional button on the right
/// - time        — text with a timestamp, optional visual placeholder on the right
/// - empty       — no content, just a placeholder surface (pair with SDeckBasicTargetState.empty)
enum SDeckBasicTargetCardType {
  button,
  buttonOrNot,
  time,
  empty,
}

/// Controls the background color tint of a time card.
///
/// Status values (note, warning, info, link, success, error) only apply to
/// the time card type. The empty value must be paired with the empty card type.
enum SDeckBasicTargetState {
  defaultState,
  note,
  warning,
  info,
  link,
  success,
  error,
  empty,
}
