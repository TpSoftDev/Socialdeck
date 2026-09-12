/*--------------------------- sdeck_swatch.dart ------------------------------*/
// Color swatch for the SocialDeck design system. Building block of
// SDeckColorPicker. Fixed square fill with Enabled and Selected border states.
//
// Parent should constrain width (SizedBox or Expanded). Aspect ratio is always 1.
//
// Usage:
//   SizedBox(
//     width: SDeckSize.size36,
//     child: SDeckSwatch(
//       color: SDeckColorPickerColor.brightCoral,
//       state: SDeckSwatchState.selected,
//       onTap: () {},
//     ),
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../helpers/index.dart';
import '../../tokens/index.dart';
import '../../tokens/effects/index.dart';
import 'color_picker_enums.dart';

//------------------------------- SDeckSwatch --------------------------------//
class SDeckSwatch extends StatelessWidget {
  //*************************** Properties ******************************//

  final SDeckColorPickerColor color;
  final SDeckSwatchState state;
  final VoidCallback? onTap;

  //*************************** Constructor ******************************//
  const SDeckSwatch({
    super.key,
    required this.color,
    this.state = SDeckSwatchState.enabled,
    this.onTap,
  });

  //*************************** Build Method ******************************//
  @override
  Widget build(BuildContext context) {
    final component = context.component;
    final isSelected = state == SDeckSwatchState.selected;

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _surfaceFor(component),
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius12),
            border: Border.all(
              color: isSelected
                  ? component.colorPickerBorderSelected
                  : component.colorPickerBorderEnabled,
              width: SDeckSize.size4,
            ),
            boxShadow: isSelected
                ? SDeckOuterGlows.outerGlowLowSkyBlue(
                    component.colorPickerBorderSelected,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  //*************************** Helpers **********************************//
  Color _surfaceFor(SDeckComponentColors component) {
    switch (color) {
      case SDeckColorPickerColor.brightCoral:
        return component.colorPickerSurfaceBrightCoral;
      case SDeckColorPickerColor.tangerine:
        return component.colorPickerSurfaceTangerine;
      case SDeckColorPickerColor.vibrantYellow:
        return component.colorPickerSurfaceVibrantYellow;
      case SDeckColorPickerColor.mintGreen:
        return component.colorPickerSurfaceMintGreen;
      case SDeckColorPickerColor.skyBlue:
        return component.colorPickerSurfaceSkyBlue;
      case SDeckColorPickerColor.lavender:
        return component.colorPickerSurfaceLavender;
      case SDeckColorPickerColor.coolGray:
        return component.colorPickerSurfaceCoolGray;
      case SDeckColorPickerColor.inverse:
        return component.colorPickerSurfaceInverse;
    }
  }
}
