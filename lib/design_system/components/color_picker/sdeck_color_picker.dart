/*------------------------ sdeck_color_picker.dart ---------------------------*/
// Horizontal color picker for the SocialDeck design system. Row of eight
// SDeckSwatch instances with a single selected color. Controlled: the parent
// owns selection and updates preview or form state from onChanged.
//
// Usage:
//   SDeckColorPicker(
//     selected: SDeckColorPickerColor.brightCoral,
//     onChanged: (color) {},
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../tokens/index.dart';
import 'color_picker_enums.dart';
import 'sdeck_swatch.dart';

//------------------------------- SDeckColorPicker ---------------------------//
class SDeckColorPicker extends StatelessWidget {
  //*************************** Properties ******************************//

  final SDeckColorPickerColor selected;
  final ValueChanged<SDeckColorPickerColor>? onChanged;

  //*************************** Constructor ******************************//
  const SDeckColorPicker({
    super.key,
    required this.selected,
    this.onChanged,
  });

  //*************************** Build Method ******************************//
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < SDeckColorPickerColor.values.length; i++) ...[
          if (i > 0) const SizedBox(width: SDeckSpace.gap6),
          Expanded(
            child: SDeckSwatch(
              color: SDeckColorPickerColor.values[i],
              state: SDeckColorPickerColor.values[i] == selected
                  ? SDeckSwatchState.selected
                  : SDeckSwatchState.enabled,
              onTap: onChanged == null
                  ? null
                  : () => onChanged!(SDeckColorPickerColor.values[i]),
            ),
          ),
        ],
      ],
    );
  }
}
