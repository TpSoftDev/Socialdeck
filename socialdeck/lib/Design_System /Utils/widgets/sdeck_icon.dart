//------------------------------- sdeck_icon.dart ----------------------------//
// This file defines the SDeckIcon widget for the app.
// It provides a wrapper around SvgPicture.asset that preserves original Figma colors.
// Theme-aware icon selection is handled by the icons.dart ThemeExtension.
// It is used to ensure consistent icon rendering across the app.
//----------------------------------------------------------------------------//

//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//------------------------------- SDeckIcon ----------------------------------//
/// A theme-aware icon widget that preserves original Figma colors.
/// Theme switching is handled by the icons.dart ThemeExtension which selects
/// the appropriate icon file (defaultStroke for light, invertedStroke for dark).
/// This ensures icons maintain their intended appearance and contrast.

class SDeckIcon extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  final String iconPath;
  final double? width;
  final double? height;
  final Color? color;
  final String? semanticsLabel;

  //------------------------------- Constructor ----------------------------//
  const SDeckIcon(
    this.iconPath, {
    super.key,
    this.width = 24,
    this.height = 24,
    this.color,
    this.semanticsLabel,
  });

  //*************************** Named Constructors ***************************//

  //------------------------------- Small Size (16px) ---------------------//
  const SDeckIcon.small(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = 16,
       height = 16;

  //------------------------------- Medium Size (24px) --------------------//
  const SDeckIcon.medium(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = 24,
       height = 24;

  //------------------------------- Large Size (32px) ---------------------//
  const SDeckIcon.large(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = 32,
       height = 32;

  //------------------------------- Extra Large Size (48px) ---------------//
  const SDeckIcon.extraLarge(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = 48,
       height = 48;

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      width: width,
      height: height,
      // Only apply ColorFilter if a custom color is explicitly provided
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      semanticsLabel: semanticsLabel,
    );
  }
}
