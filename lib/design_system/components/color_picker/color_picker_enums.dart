/*-------------------------- color_picker_enums.dart -------------------------*/
// Shared enums for SDeckSwatch and SDeckColorPicker in the SocialDeck design
// system: Color and State.
//
// Usage:
//   SDeckColorPickerColor.brightCoral
//   SDeckSwatchState.selected
/*--------------------------------------------------------------------------*/

//*************************** Enums **********************************//

// The closed set of deck colors shown in the color picker.
// Order matches Figma left to right. Add a value here when the set grows.
enum SDeckColorPickerColor {
  brightCoral,
  tangerine,
  vibrantYellow,
  mintGreen,
  skyBlue,
  lavender,
  coolGray,
  inverse,
}

// Controls the swatch interaction state.
//
// - enabled   is the default look: faint border, no glow.
// - selected  adds a sky-blue border and a soft blue glow.
enum SDeckSwatchState { enabled, selected }
