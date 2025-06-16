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
    this.width = SDeckSpacing.iconMedium,
    this.height = SDeckSpacing.iconMedium,
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
  }) : width = SDeckSpacing.iconSmall,
       height = SDeckSpacing.iconSmall;

  //------------------------------- Medium Size (24px) --------------------//
  const SDeckIcon.medium(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = SDeckSpacing.iconMedium,
       height = SDeckSpacing.iconMedium;

  //------------------------------- Large Size (36px) ---------------------//
  const SDeckIcon.large(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = SDeckSpacing.iconLarge,
       height = SDeckSpacing.iconLarge;

  //------------------------------- Extra Large Size (48px) ---------------//
  const SDeckIcon.extraLarge(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = SDeckSpacing.iconXLarge,
       height = SDeckSpacing.iconXLarge;

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
