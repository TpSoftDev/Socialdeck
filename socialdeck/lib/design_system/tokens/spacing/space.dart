/*----------------------------- space.dart ---------------------------------*/
// Space tokens define the system's spacing scale, used for padding, margins,
// and gaps. They create consistent rhythm, alignment, and visual balance
// across components and layouts.
//
// These tokens reference Size tokens as semantic aliases, providing
// context-specific naming for spacing values.
//
// Usage:
//   SDeckSpace.margin16
//   SDeckSpace.padding16
//   SDeckSpace.gap16
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'size.dart';

//------------------------------- SDeckSpace ------------------------------//
class SDeckSpace {
  SDeckSpace._();

  //*************************** Margin **************************************//
  static const double marginZero = SDeckSize.sizeZero;
  static const double margin4 = SDeckSize.size4;
  static const double margin8 = SDeckSize.size8;
  static const double margin12 = SDeckSize.size12;
  static const double margin16 = SDeckSize.size16;
  static const double margin24 = SDeckSize.size24;
  static const double margin32 = SDeckSize.size32;
  static const double margin48 = SDeckSize.size48;

  //*************************** Padding *************************************//
  static const double paddingZero = SDeckSize.sizeZero;
  static const double padding4 = SDeckSize.size4;
  static const double padding8 = SDeckSize.size8;
  static const double padding12 = SDeckSize.size12;
  static const double padding16 = SDeckSize.size16;
  static const double padding24 = SDeckSize.size24;
  static const double padding32 = SDeckSize.size32;
  static const double padding48 = SDeckSize.size48;

  //*************************** Gap *****************************************//
  static const double gapZero = SDeckSize.sizeZero;
  static const double gap4 = SDeckSize.size4;
  static const double gap8 = SDeckSize.size8;
  static const double gap12 = SDeckSize.size12;
  static const double gap16 = SDeckSize.size16;
  static const double gap24 = SDeckSize.size24;
  static const double gap32 = SDeckSize.size32;
  static const double gap48 = SDeckSize.size48;
}
