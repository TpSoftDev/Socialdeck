/*----------------------- sdeck_dot_indicator.dart --------------------------*/
// A small 12×12 filled circle used to signal a status or unread notification.
//
// Usage:
//   SDeckDotIndicator()
//   SDeckDotIndicator(color: SDeckDotIndicatorColor.green)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../helpers/index.dart';

//======================== SDeckDotIndicatorColor ============================//
enum SDeckDotIndicatorColor { blue, green, red }

//======================== SDeckDotIndicator =================================//
class SDeckDotIndicator extends StatelessWidget {
  final SDeckDotIndicatorColor color;

  const SDeckDotIndicator({
    super.key,
    this.color = SDeckDotIndicatorColor.blue,
  });

  //*************************** Build *****************************************//
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: _resolveColor(context),
        shape: BoxShape.circle,
      ),
    );
  }

  Color _resolveColor(BuildContext context) {
    return switch (color) {
      SDeckDotIndicatorColor.blue  => context.semantic.info,
      SDeckDotIndicatorColor.green => context.semantic.success,
      SDeckDotIndicatorColor.red   => context.semantic.error,
    };
  }
}
