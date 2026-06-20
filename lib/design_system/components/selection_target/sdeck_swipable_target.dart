/*-------------------- sdeck_swipable_target.dart ----------------------------*/
// A wrapper that adds swipe-to-delete behavior to any selection target card.
// Swipe left to reveal the delete action; swipe right or tap X to close it.
// The red background animates in behind the card when the action is revealed.
//
// Usage:
//   SDeckSwipableTarget(
//     onDelete: () {},
//     child: SDeckBasicTarget(
//       cardType: SDeckBasicTargetCardType.button,
//       title: 'tpsoftdev',
//       description: 'invited you to Prompt\'d',
//       buttonLabel: 'Join',
//       onButtonPressed: () {},
//     ),
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../helpers/index.dart';

//========================= SDeckSwipableTarget ===============================//
class SDeckSwipableTarget extends StatefulWidget {
  //------------------------------- Properties --------------------------------//

  /// The card to display — typically an SDeckBasicTarget.
  final Widget child;

  /// Called when the user taps the X delete button after swiping.
  final VoidCallback? onDelete;

  //------------------------------- Constructor -------------------------------//
  const SDeckSwipableTarget({super.key, required this.child, this.onDelete});

  @override
  State<SDeckSwipableTarget> createState() => _SDeckSwipableTargetState();
}

class _SDeckSwipableTargetState extends State<SDeckSwipableTarget> {
  bool _isOpen = false;

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedContainer(
        duration: SDeckMotionDuration.normal,
        curve: SDeckMotionCurve.easeOut,
        decoration: BoxDecoration(
          color:
              _isOpen
                  ? context.component.selectionTargetSurfaceError
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        ),
        child: Row(
          children: [
            //------------------------ Card --------------------------------//
            Expanded(child: widget.child),

            //------------------------ Delete Action -----------------------//
            AnimatedSize(
              duration: SDeckMotionDuration.normal,
              curve: SDeckMotionCurve.easeOut,
              child:
                  _isOpen
                      ? _buildDeleteButton(context)
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  //*************************** Helper Methods ********************************//

  //------------------------------- Drag Handler ----------------------------//
  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -300) setState(() => _isOpen = true);
    if (velocity > 300) setState(() => _isOpen = false);
  }

  //------------------------------- Delete Button ---------------------------//
  Widget _buildDeleteButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: SDeckSpace.gap16,
        right: SDeckSpace.padding16,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() => _isOpen = false);
          widget.onDelete?.call();
        },
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: SDeckIcons(
              SDeckIcon.x,
              size: SDeckSize.size24,
              color: context.semantic.error,
            ),
          ),
        ),
      ),
    );
  }
}
