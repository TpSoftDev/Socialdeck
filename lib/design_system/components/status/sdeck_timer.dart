/*---------------------------- sdeck_timer.dart -----------------------------*/
// Figma Timer. A clock icon beside a value.
//   small       — 36px icon, gap 6, H4
//   smallAlert  — same size, alert color
//   default_    — 36px icon, gap 6, H2
//   enlarged    — 48px icon, gap 12, H1
//   alert       — same size as enlarged, alert color
//
// The value and icon use primary: #1F1F1F in light, #F5F5F5 in dark.
// Alert uses error: #FE6F61 in light, #FF8A80 in dark.
//
// Usage:
//   SDeckTimer(value: '20')
//   SDeckTimer(value: '20', type: SDeckTimerType.alert)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../themes/text_theme.dart';
import '../../tokens/index.dart';

//======================== SDeckTimerType ====================================//
enum SDeckTimerType { small, smallAlert, default_, enlarged, alert }

//======================== SDeckTimer ========================================//
class SDeckTimer extends StatelessWidget {
  final SDeckTimerType type;
  final String value;

  const SDeckTimer({
    super.key,
    this.type = SDeckTimerType.small,
    this.value = '20',
  });

  bool get _alert =>
      type == SDeckTimerType.smallAlert || type == SDeckTimerType.alert;

  bool get _large =>
      type == SDeckTimerType.enlarged || type == SDeckTimerType.alert;

  @override
  Widget build(BuildContext context) {
    final Color color =
        _alert ? context.semantic.error : context.semantic.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SDeckIcons(
          SDeckIcon.clock,
          size: _large ? SDeckSize.size48 : SDeckSize.size36,
          color: color,
        ),
        SizedBox(width: _large ? SDeckSpace.gap12 : SDeckSpace.gap6),
        Text(value, style: _textStyle(context, color)),
      ],
    );
  }

  TextStyle _textStyle(BuildContext context, Color color) {
    final TextTheme text = Theme.of(context).textTheme;
    final TextStyle style = switch (type) {
      SDeckTimerType.small || SDeckTimerType.smallAlert => text.h4,
      SDeckTimerType.default_ => text.h2,
      SDeckTimerType.enlarged || SDeckTimerType.alert => text.h1,
    };
    return style.copyWith(color: color);
  }
}
