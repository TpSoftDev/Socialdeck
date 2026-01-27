/*----------------------------- colors_main_semantic.dart --------------------*/
// Main Semantic Color Palette - ThemeExtension
// The semantic color palette defines colors by their intended meaning or purpose
// within the interface, rather than by their appearance. These tokens translate
// base and brand colors into functional roles—such as primary, surface, background,
// error, or success—to ensure consistent use across light and dark themes.
//
// Usage:
//   context.semantic.surfaceError
//   Theme.of(context).extension<SDeckSemanticColors>()?.surfaceError
/*----------------------------------------------------------------------------*/

//-------------------------------- Imports -----------------------------------//
import 'package:flutter/material.dart';
import 'colors_brand.dart';

//------------------------------- SDeckSemanticColors ------------------------//
class SDeckSemanticColors extends ThemeExtension<SDeckSemanticColors> {
  //*************************** Background & Surface ***************************//
  final Color surface;
  final Color surfaceVariant;
  final Color surfaceInverse;
  final Color surfaceError;
  final Color surfaceSuccess;
  final Color surfaceWarning;
  final Color surfaceInfo;
  final Color surfaceLink;
  final Color surfaceNote;

  //*************************** Primary Colors *******************************//
  final Color primary;
  final Color onPrimary;

  //*************************** Secondary Colors *****************************//
  final Color secondary;
  final Color secondaryVariant;

  //*************************** Tertiary Colors *****************************//
  final Color tertiary;
  final Color tertiaryVariant;

  //*************************** Outline & Misc *******************************//
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;

  //*************************** Error Colors *********************************//
  final Color error;

  //*************************** Success Colors *******************************//
  final Color success;

  //*************************** Warning Colors *******************************//
  final Color warning;

  //*************************** Information Colors ***************************//
  final Color info;

  //*************************** Link Colors **********************************//
  final Color link;

  //*************************** Note Colors **********************************//
  final Color note;

  //*************************** Constructor **********************************//
  const SDeckSemanticColors({
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceInverse,
    required this.surfaceError,
    required this.surfaceSuccess,
    required this.surfaceWarning,
    required this.surfaceInfo,
    required this.surfaceLink,
    required this.surfaceNote,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.secondaryVariant,
    required this.tertiary,
    required this.tertiaryVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.link,
    required this.note,
  });

  //----------------------------- Light Theme Factory --------------------------//
  static SDeckSemanticColors get light {
    return SDeckSemanticColors(
      surface: SDeckBrandColors.warmOffWhite(Brightness.light),
      surfaceVariant: SDeckBrandColors.coolGrayLightest(Brightness.light),
      surfaceInverse: SDeckBrandColors.slateGray(Brightness.light),
      surfaceError: SDeckBrandColors.brightCoralLightest(Brightness.light),
      surfaceSuccess: SDeckBrandColors.mintGreenLightest(Brightness.light),
      surfaceWarning: SDeckBrandColors.vibrantYellowLightest(Brightness.light),
      surfaceInfo: SDeckBrandColors.skyBlueLightest(Brightness.light),
      surfaceLink: SDeckBrandColors.lavenderLightest(Brightness.light),
      surfaceNote: SDeckBrandColors.coolGrayLightest(Brightness.light),
      primary: SDeckBrandColors.coolGrayDarkest(Brightness.light),
      onPrimary: SDeckBrandColors.warmOffWhite(Brightness.light),
      secondary: SDeckBrandColors.coolGrayDark(Brightness.light),
      secondaryVariant: SDeckBrandColors.coolGray(Brightness.light),
      tertiary: SDeckBrandColors.coolGrayLightest(Brightness.light),
      tertiaryVariant: SDeckBrandColors.coolGrayLight(Brightness.light),
      outline: const Color.fromRGBO(31, 31, 31, 0.20), // #1F1F1F @ 20%
      outlineVariant: const Color.fromRGBO(245,245,245, 0.20), // #F5F5F5 @ 20%
      shadow: const Color.fromRGBO(31, 31, 31, 0.20), // #1F1F1F @ 20%
      scrim: const Color.fromRGBO(31, 31, 31, 0.25), // #1F1F1F @ 25%
      error: SDeckBrandColors.brightCoral(Brightness.light),
      success: SDeckBrandColors.mintGreen(Brightness.light),
      warning: SDeckBrandColors.vibrantYellow(Brightness.light),
      info: SDeckBrandColors.skyBlue(Brightness.light),
      link: SDeckBrandColors.lavender(Brightness.light),
      note: SDeckBrandColors.coolGrayDark(Brightness.light),
    );
  }

  //----------------------------- Dark Theme Factory -------------------------//
  static SDeckSemanticColors get dark {
    return SDeckSemanticColors(
      surface: SDeckBrandColors.slateGray(Brightness.dark),
      surfaceVariant: SDeckBrandColors.coolGrayDark(Brightness.dark),
      surfaceInverse: SDeckBrandColors.warmOffWhite(Brightness.dark),
      surfaceError: SDeckBrandColors.brightCoralDarkest(Brightness.dark),
      surfaceSuccess: SDeckBrandColors.mintGreenDarkest(Brightness.dark),
      surfaceWarning: SDeckBrandColors.vibrantYellowDarkest(Brightness.dark),
      surfaceInfo: SDeckBrandColors.skyBlueDarkest(Brightness.dark),
      surfaceLink: SDeckBrandColors.lavenderDarkest(Brightness.dark),
      surfaceNote: SDeckBrandColors.coolGrayDarkest(Brightness.dark),
      primary: SDeckBrandColors.coolGrayLightest(Brightness.dark),
      onPrimary: SDeckBrandColors.slateGray(Brightness.dark),
      secondary: SDeckBrandColors.coolGrayLight(Brightness.dark),
      secondaryVariant: SDeckBrandColors.coolGray(Brightness.dark),
      tertiary: SDeckBrandColors.coolGrayDarkest(Brightness.dark),
      tertiaryVariant: SDeckBrandColors.coolGrayDark(Brightness.dark),
      outline: const Color.fromRGBO(245, 245, 245, 0.20), // #F5F5F5 @ 20%
      outlineVariant: const Color.fromRGBO(31, 31, 31, 0.20), // #1F1F1F @ 20%
      shadow: const Color.fromRGBO(235, 235, 235, 0.20), // #EBEBEB @ 20%
      scrim: const Color.fromRGBO(31, 31, 31, 0.25), // #1F1F1F @ 25%
      error: SDeckBrandColors.brightCoral(Brightness.dark),
      success: SDeckBrandColors.mintGreen(Brightness.dark),
      warning: SDeckBrandColors.vibrantYellow(Brightness.dark),
      info: SDeckBrandColors.skyBlue(Brightness.dark),
      link: SDeckBrandColors.lavender(Brightness.dark),
      note: SDeckBrandColors.coolGrayLight(Brightness.dark),
    );
  }

  //----------------------------- Copy With -----------------------------------//
  /// Creates a new instance with optionally updated properties.
  /// If a parameter is provided (not null), it replaces the current value.
  /// If a parameter is null, the current value is kept unchanged.
  /// Example: semanticColors.copyWith(surfaceError: Colors.red)
  ///          creates a copy with only that property changed.
  @override
  ThemeExtension<SDeckSemanticColors> copyWith({
    Color? surface,
    Color? surfaceVariant,
    Color? surfaceInverse,
    Color? surfaceError,
    Color? surfaceSuccess,
    Color? surfaceWarning,
    Color? surfaceInfo,
    Color? surfaceLink,
    Color? surfaceNote,
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? secondaryVariant,
    Color? tertiary,
    Color? tertiaryVariant,
    Color? outline,
    Color? outlineVariant,
    Color? shadow,
    Color? scrim,
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
    Color? link,
    Color? note,
  }) {
    return SDeckSemanticColors(
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      surfaceInverse: surfaceInverse ?? this.surfaceInverse,
      surfaceError: surfaceError ?? this.surfaceError,
      surfaceSuccess: surfaceSuccess ?? this.surfaceSuccess,
      surfaceWarning: surfaceWarning ?? this.surfaceWarning,
      surfaceInfo: surfaceInfo ?? this.surfaceInfo,
      surfaceLink: surfaceLink ?? this.surfaceLink,
      surfaceNote: surfaceNote ?? this.surfaceNote,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      secondaryVariant: secondaryVariant ?? this.secondaryVariant,
      tertiary: tertiary ?? this.tertiary,
      tertiaryVariant: tertiaryVariant ?? this.tertiaryVariant,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      shadow: shadow ?? this.shadow,
      scrim: scrim ?? this.scrim,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      link: link ?? this.link,
      note: note ?? this.note,
    );
  }

  //----------------------------- Lerp ---------------------------------------//
  /// Linearly interpolates (blends) between this instance and another.
  /// The `t` parameter controls the blend: 0.0 = this instance, 1.0 = other instance.
  /// Used by Flutter to smoothly transition between themes during animations.
  /// Example: lerp(lightTheme, darkTheme, 0.5) returns a theme halfway between them.
  @override
  ThemeExtension<SDeckSemanticColors> lerp(
    ThemeExtension<SDeckSemanticColors>? other,
    double t,
  ) {
    if (other is! SDeckSemanticColors) return this;

    return SDeckSemanticColors(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      surfaceInverse: Color.lerp(surfaceInverse, other.surfaceInverse, t)!,
      surfaceError: Color.lerp(surfaceError, other.surfaceError, t)!,
      surfaceSuccess: Color.lerp(surfaceSuccess, other.surfaceSuccess, t)!,
      surfaceWarning: Color.lerp(surfaceWarning, other.surfaceWarning, t)!,
      surfaceInfo: Color.lerp(surfaceInfo, other.surfaceInfo, t)!,
      surfaceLink: Color.lerp(surfaceLink, other.surfaceLink, t)!,
      surfaceNote: Color.lerp(surfaceNote, other.surfaceNote, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryVariant:
          Color.lerp(secondaryVariant, other.secondaryVariant, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      tertiaryVariant: Color.lerp(tertiaryVariant, other.tertiaryVariant, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      link: Color.lerp(link, other.link, t)!,
      note: Color.lerp(note, other.note, t)!,
    );
  }
}
