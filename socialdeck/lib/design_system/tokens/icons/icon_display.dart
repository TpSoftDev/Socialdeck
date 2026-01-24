/*------------------------------- icon_display.dart ---------------------------*/
// Icon display widget for the SocialDeck design system
// Theme-aware icon widget that preserves original Figma colors
// Uses standardized spacing tokens for consistent sizing
//
// Usage: SDeckIcons(SDeckIcon.home, size: SDeckSize.size24, color: context.component.iconPrimary)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SDeckIcons extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  final String iconPath;
  final double size;
  final Color? color;
  final String? semanticsLabel;

  //------------------------------- Constructor ----------------------------//
  const SDeckIcons(
    this.iconPath, {
    super.key,
    required this.size,
    this.color,
    this.semanticsLabel,
  });

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      // Only apply ColorFilter if a custom color is explicitly provided
      // This preserves the original Figma colors when no color override is needed
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      semanticsLabel: semanticsLabel,
    );
  }
}
