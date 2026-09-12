/*-------------------------- sdeck_add_target.dart ---------------------------*/
// addTarget component — matches Figma addTarget in the Design System.
// A fixed-size card with a centered plus icon. Used as the entry point
// for creating a new deck.
//
// Usage:
//   SDeckAddTarget(onTap: () => context.push('/decks/create'))
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../helpers/index.dart';

//============================= SDeckAddTarget ================================//
class SDeckAddTarget extends StatelessWidget {
  //------------------------------- Properties --------------------------------//

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  //------------------------------- Constructor -------------------------------//
  const SDeckAddTarget({
    super.key,
    this.onTap,
  });

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius12),
        splashFactory: NoSplash.splashFactory,
        overlayColor: const WidgetStatePropertyAll<Color?>(Colors.transparent),
        child: Container(
          width: 116,
          height: 156,
          decoration: BoxDecoration(
            color: context.semantic.tertiary,
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius12),
          ),
          child: Center(
            child: SizedBox(
              width: 72,
              height: 72,
              child: Center(
                child: SDeckIcons(
                  SDeckIcon.plus,
                  size: 72,
                  color: context.component.iconTertiary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
