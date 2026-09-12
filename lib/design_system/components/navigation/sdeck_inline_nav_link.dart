/*--------------------- sdeck_inline_nav_link.dart --------------------------*/
// A compact text link with a right chevron. Typically used inside section
// headers to let the user navigate to a full list screen.
//
// Usage:
//   SDeckInlineNavLink(title: 'View All', onTap: () => context.go('/inbox'))
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../themes/text_theme.dart';
import '../../helpers/index.dart';

//======================== SDeckInlineNavLink =================================//
class SDeckInlineNavLink extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SDeckInlineNavLink({
    super.key,
    required this.title,
    this.onTap,
  });

  //*************************** Build *****************************************//
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmallFigma.copyWith(
                  color: context.component.inlineNavLinkText,
                ),
          ),
          const SizedBox(width: SDeckSpace.gap4),
          SDeckIcons(
            SDeckIcon.rightChevron,
            size: SDeckSize.size16,
            color: context.component.inlineNavLinkText,
          ),
        ],
      ),
    );
  }
}
