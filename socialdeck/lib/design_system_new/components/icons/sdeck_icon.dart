/*------------------------------- sdeck_icon.dart ---------------------------*/
// Icon component for the SocialDeck design system
// Theme-aware icon widget that preserves original Figma colors
// Uses standardized spacing tokens for consistent sizing
//
// Usage: SDeckIcon(context.icons.home) or SDeckIcon.large(iconPath)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../tokens/index.dart';

/// Icon component for the SocialDeck design system
/// Provides consistent icon rendering with standardized sizes from spacing tokens
/// Theme switching is handled by the icon themes foundation
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
    this.width = SDeckSpacing.iconLarge,
    this.height = SDeckSpacing.iconLarge,
    this.color,
    this.semanticsLabel,
  });

  //*************************** Named Constructors ***************************//

  //------------------------------- Extra Small Size (12px) ---------------//
  const SDeckIcon.extraSmall(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = SDeckSpacing.iconXSmall,
       height = SDeckSpacing.iconXSmall;

  //------------------------------- Small Size (16px) ---------------------//
  const SDeckIcon.small(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = SDeckSpacing.iconSmall,
       height = SDeckSpacing.iconSmall;

  //------------------------------- Medium Size (20px) --------------------//
  const SDeckIcon.medium(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = SDeckSpacing.iconMedium,
       height = SDeckSpacing.iconMedium;

  //------------------------------- Large Size (24px) ---------------------//
  const SDeckIcon.large(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = SDeckSpacing.iconLarge,
       height = SDeckSpacing.iconLarge;

  //------------------------------- Extra Large Size (32px) ---------------//
  const SDeckIcon.extraLarge(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = SDeckSpacing.iconXLarge,
       height = SDeckSpacing.iconXLarge;

  //------------------------------- XXL Size (48px) -----------------------//
  const SDeckIcon.xxl(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = SDeckSpacing.iconXXLarge,
       height = SDeckSpacing.iconXXLarge;

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      width: width,
      height: height,
      // Only apply ColorFilter if a custom color is explicitly provided
      // This preserves the original Figma colors when no color override is needed
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      semanticsLabel: semanticsLabel,
    );
  }
}
