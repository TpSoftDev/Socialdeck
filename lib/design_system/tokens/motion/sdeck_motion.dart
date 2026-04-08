/*-------------------------- sdeck_motion.dart ---------------------------*/
// Socialdeck Design System Motion Tokens
//
// Purpose:
// - Central place for reusable animation durations and reading-time helpers
// - Keeps transitions aligned with UI/UX expectations across screens
//
// Current rules from UI/UX:
// - Single-motion transitions (sheet, popup, slide): 300ms
// - Full fade content swap: 300ms fade out + 300ms fade in = 600ms total
// - Timed dialogue / walkthrough text: 2 seconds per line of text
/*-----------------------------------------------------------------------*/

import 'package:flutter/material.dart';

/// Shared animation durations used across the Socialdeck design system.
///
/// Use these instead of hardcoding Duration(milliseconds: 300) repeatedly.
class SDeckMotionDuration {
  SDeckMotionDuration._();

  /// Standard single fade duration.
  static const Duration fade = Duration(milliseconds: 300);

  /// Standard bottom sheet slide duration.
  static const Duration sheet = Duration(milliseconds: 300);

  /// Standard dialog / popup appearance duration.
  static const Duration dialog = Duration(milliseconds: 300);

  /// Total duration for a full content swap:
  /// old content fades out (300ms) + new content fades in (300ms).
  static const Duration contentSwap = Duration(milliseconds: 600);

  /// Small helper delay sometimes useful before starting a fade.
  static const Duration microDelay = Duration(milliseconds: 50);
}

/// Shared motion curves.
///
/// Keeping curves centralized makes it easier to adjust app feel later.
class SDeckMotionCurve {
  SDeckMotionCurve._();

  static const Curve standard = Curves.easeInOut;
  static const Curve enter = Curves.easeIn;
  static const Curve exit = Curves.easeOut;
}

/// Shared reading-time helpers for timed onboarding / dialogue screens.
///
/// UI/UX guidance:
/// - 2 seconds per line of text
class SDeckMotionTiming {
  SDeckMotionTiming._();

  /// Base reading time per line of text.
  static const Duration perLineReadTime = Duration(seconds: 2);

  /// Returns reading time based on an explicit line count.
  static Duration readingTimeForLines(int lineCount) {
    final safeLineCount = lineCount < 1 ? 1 : lineCount;
    return Duration(seconds: safeLineCount * 2);
  }

  /// Returns reading time based on the number of line breaks in a string.
  ///
  /// Example:
  /// "Hello" -> 1 line -> 2 seconds
  /// "Hello\nWorld" -> 2 lines -> 4 seconds
  static Duration readingTimeForText(String text) {
    final int lineCount = '\n'.allMatches(text).length + 1;
    return readingTimeForLines(lineCount);
  }
}
