/*------------------------ sdeck_toggle_switch.dart --------------------------*/
// Figma toggleSwitch. A 56×32 track with a 24×24 head.
//   false — gray track, head on the left
//   true  — mint green track, head on the right
//
// Semantic Dark keeps the mint track at #6FCF97 and swaps the off track to
// #5E5E5E and the head to #0C1118. Those steps differ from the shifted
// semantic.success and semantic.surface tokens.
//
// Usage:
//   SDeckToggleSwitch()
//   SDeckToggleSwitch(value: true, onChanged: (value) {})
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/index.dart';

//========================== SDeckToggleSwitch ================================//
class SDeckToggleSwitch extends StatelessWidget {
  // Figma track size. 56 is not a spacing token.
  static const double _width = 56;

  /// Figma toggleSwitch > State. True parks the head on the right.
  final bool value;

  /// Called with the next state. Null leaves the switch visible and inert.
  final ValueChanged<bool>? onChanged;

  const SDeckToggleSwitch({
    super.key,
    this.value = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: value,
      enabled: onChanged != null,
      child: GestureDetector(
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: AnimatedContainer(
          duration: SDeckMotionDuration.normal,
          curve: SDeckMotionCurve.easeInOut,
          width: _width,
          height: SDeckSize.size32,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: _trackColor(context),
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24),
            border: Border.all(
              color: context.semantic.outlineVariant,
              width: SDeckSize.size4,
            ),
          ),
          child: Container(
            width: SDeckSize.size24,
            height: SDeckSize.size24,
            decoration: BoxDecoration(
              color: _headColor(context),
              borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24),
            ),
          ),
        ),
      ),
    );
  }

  //----------------------------- Colors --------------------------------------//
  Color _trackColor(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    if (value) {
      // toggleSwitchTrackSurfaceTrue — #6FCF97 in light and dark.
      return SDeckBaseColors.mintGreen[500]!;
    }
    // toggleSwitchTrackSurfaceFalse — light #C4C4C4, dark #5E5E5E.
    return dark ? SDeckBaseColors.coolGray[700]! : SDeckBaseColors.coolGray[300]!;
  }

  Color _headColor(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    // toggleSwitchHeadSurface — light #FDFBF5, dark #0C1118.
    return dark
        ? SDeckBaseColors.slateGray[800]!
        : SDeckBrandColors.warmOffWhite(Brightness.light);
  }
}
