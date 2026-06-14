/*--------------------- sdeck_section_header.dart ---------------------------*/
// A full-width section header with an optional dot indicator on the title
// and an optional inline nav link on the right side.
//
// Usage:
//   SDeckSectionHeader(title: 'Friends')
//   SDeckSectionHeader(
//     title: 'Inbox',
//     showDotIndicator: true,
//     navLinkTitle: 'View All',
//     onNavLinkTap: () => context.go('/social/inbox'),
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../themes/text_theme.dart';
import '../../helpers/index.dart';
import '../status/sdeck_dot_indicator.dart';
import '../navigation/sdeck_inline_nav_link.dart';

//======================== SDeckSectionHeader =================================//
class SDeckSectionHeader extends StatelessWidget {
  final String title;

  /// Shows a colored dot next to the title — useful for signaling unread activity.
  final bool showDotIndicator;

  final SDeckDotIndicatorColor dotIndicatorColor;

  /// When provided, shows a tappable link on the right side of the header.
  /// Maps to Figma rightSelection1: "NavLink".
  final String? navLinkTitle;

  final VoidCallback? onNavLinkTap;

  /// When provided, shows plain supporting text on the right side of the header.
  /// Maps to Figma rightSelection1: "Supporting Text" — e.g. "0/2".
  /// Ignored when navLinkTitle is also set (navLinkTitle takes priority).
  final String? supportingText;

  //-------------------------- Constructor -----------------------------------//
  const SDeckSectionHeader({
    super.key,
    required this.title,
    this.showDotIndicator = false,
    this.dotIndicatorColor = SDeckDotIndicatorColor.blue,
    this.navLinkTitle,
    this.onNavLinkTap,
    this.supportingText,
  });

  //*************************** Build *****************************************//
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: SDeckSpace.padding16,
        vertical: SDeckSpace.padding12,
      ),
      decoration: BoxDecoration(
        color: context.semantic.tertiary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(SDeckRadius.borderRadius16),
          topRight: Radius.circular(SDeckRadius.borderRadius16),
          bottomLeft: Radius.circular(SDeckRadius.borderRadius8),
          bottomRight: Radius.circular(SDeckRadius.borderRadius8),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.h6.copyWith(
                  color: context.component.navigationText,
                ),
          ),
          if (showDotIndicator) ...[
            const SizedBox(width: SDeckSpace.gap8),
            SDeckDotIndicator(color: dotIndicatorColor),
          ],
          const Spacer(),
          if (navLinkTitle != null)
            SDeckInlineNavLink(
              title: navLinkTitle!,
              onTap: onNavLinkTap,
            )
          else if (supportingText != null)
            Text(
              supportingText!,
              style: Theme.of(context).textTheme.caption.copyWith(
                color: context.component.navigationSupportingText,
              ),
            ),
        ],
      ),
    );
  }
}
