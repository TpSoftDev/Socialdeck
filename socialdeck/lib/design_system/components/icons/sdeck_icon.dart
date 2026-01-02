/*------------------------------- sdeck_icon.dart ---------------------------*/
// Icon component for the SocialDeck design system
// Theme-aware icon widget that preserves original Figma colors
// Uses standardized spacing tokens for consistent sizing
//
// Usage: SDeckIcon(SDeckIcons.home, color: context.component.iconPrimary) or SDeckIcon.large(iconPath, color: ...)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../tokens/spacing/index.dart';

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
    this.width = SDeckSize.size24, // 24px - Medium icon size
    this.height = SDeckSize.size24, // 24px - Medium icon size
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
  }) : width = SDeckSize.size16, // 16px
       height = SDeckSize.size16; // 16px

  //------------------------------- Medium Size (24px) --------------------//
  const SDeckIcon.medium(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = SDeckSize.size24, // 24px
       height = SDeckSize.size24; // 24px

  //------------------------------- Large Size (48px) ---------------------//
  // TODO: Verify if this should be 36px or 48px in Figma
  const SDeckIcon.large(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = SDeckSize.size48, // 48px (hardcoded for now, verify in Figma)
       height = SDeckSize.size48; // 48px (hardcoded for now, verify in Figma)

  //------------------------------- Extra Large Size (48px) ---------------//
  const SDeckIcon.extraLarge(
    this.iconPath, {
    super.key,
    this.color,
    this.semanticsLabel,
  }) : width = SDeckSize.size48, // 48px
       height = SDeckSize.size48; // 48px

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
