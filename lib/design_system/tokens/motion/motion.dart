/*------------------------------- motion.dart --------------------------------*/
// Motion tokens for the Socialdeck design system
// Centralizes animation timings and interaction delays defined by design.
/*--------------------------------------------------------------------------*/

/// Motion tokens (durations) used across the app.
///
/// Keeping these centralized prevents hard-coded durations scattered
/// throughout screens and makes it easy to match the prototype spec.
class SDeckMotion {
  /// Standard fade in/out duration from Figma prototype rules.
  static const Duration fade = Duration(milliseconds: 300);

  /// Standard slide in/out duration from Figma prototype rules.
  static const Duration slide = Duration(milliseconds: 300);

  /// Smart animate duration used by transition frames in Figma prototype flows.
  /// Example: confirm profile transition uses 400ms with an ease-in curve.
  static const Duration smartAnimate = Duration(milliseconds: 400);

  /// Reading/hold duration token used for moments where content is shown before
  /// the next reveal. Tuned to match prototype pacing in the login flow.
  static const Duration readingPerLine = Duration(milliseconds: 1200);

  /// Placeholder hold between email step fade-out and confirm-profile route.
  /// Reserves time for a future Rive bridge animation between screens.
  static const Duration riveAnimationPlaceholder = Duration(milliseconds: 1000);

  /// Pause after primary visuals appear, before secondary copy or actions
  static const Duration revealDelay = Duration(milliseconds: 3000);
}

