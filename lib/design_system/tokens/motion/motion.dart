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

  /// Reading duration per line of text (prototype rule of thumb).
  static const Duration readingPerLine = Duration(milliseconds: 1000);
}

