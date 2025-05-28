/*----------------------------- colors_palette.dart --------------------------*/
// A collection of color constants used throughout the application.
// These colors are derived from the Figma design system and provide
// consistent theming across the app.
/*----------------------------------------------------------------------------*/

//------------------------------- Imports ------------------------------------//
import 'package:flutter/material.dart';

class SDeckColorPalette {
//***************************** Neutral Colors *******************************//
//----------------------------- Warm Off-White -------------------------------//
//(Light Theme)
  static const MaterialColor warmOffWhite = MaterialColor(
    0xFFFDF9F3, // 500 as primary color
    <int, Color>{
      50: Color(0xFFFFFFFF), // FFFFFF
      100: Color(0xFFFEFDFB), // FEFDFB
      200: Color(0xFFFEFDFB), // FEFDFB
      300: Color(0xFFFDFBF5), // FDFBF5
      400: Color(0xFFFDFBF5), // FDFBF5
      500: Color(0xFFFDF9F3), // FDF9F3
      600: Color(0xFFF4DDBA), // F4DDBA
      700: Color(0xFFE8B86F), // E8B86F
      800: Color(0xFFBF8833), // BF8833
      900: Color(0xFF775117), // 775117
      950: Color(0xFF2C1D07), // 2C1D07
    },
  );
//----------------------------- Cool Gray ------------------------------------//
  //(Text)
  static const MaterialColor coolGray = MaterialColor(
    0xFF9E9E9E, // 500 as primary color
    <int, Color>{
      50: Color(0xFFF5F5F5), // F5F5F5
      100: Color(0xFFEBEBEB), // EBEBEB
      200: Color(0xFFD9D9D9), // D9D9D9
      300: Color(0xFFC4C4C4), // C4C4C4
      400: Color(0xFFB3B3B3), // B3B3B3
      500: Color(0xFF9E9E9E), // 9E9E9E
      600: Color(0xFF808080), // 808080
      700: Color(0xFF5E5E5E), // 5E5E5E
      800: Color(0xFF404040), // 404040
      900: Color(0xFF1F1F1F), // 1F1F1F
      950: Color(0xFF0F0F0F), // 0F0F0F
    },
  );
//----------------------------- Slate Gray -----------------------------------//
//(Dark Theme)
  static const MaterialColor slateGray = MaterialColor(
    0xFF1B2838, // 500 as primary color
    <int, Color>{
      50: Color(0xFFE4EAF1), // E4EAF1
      100: Color(0xFFC4D2E2), // C4D2E2
      200: Color(0xFF90A7C7), // 90A7C7
      300: Color(0xFF557AAA), // 557AAA
      400: Color(0xFF385070), // 385070
      500: Color(0xFF1B2838), // 1B2838
      600: Color(0xFF16202C), // 16202C
      700: Color(0xFF101822), // 101822
      800: Color(0xFF0C1118), // 0C1118
      900: Color(0xFF05070A), // 05070A
      950: Color(0xFF030507), // 030507
    },
  );
//*****************************************************************************/

//**************************** Primary Colors ********************************//
//----------------------------- Bright Coral ---------------------------------//
//(Error)
  static const MaterialColor brightCoral = MaterialColor(
    0xFFFE6F61, // 500 as primary color
    <int, Color>{
      50: Color(0xFFFFF0F0), // FFF0F0
      100: Color(0xFFFFE3E0), // FFE3E0
      200: Color(0xFFFFC7C2), // FFC7C2
      300: Color(0xFFFFA69E), // FFA69E
      400: Color(0xFFFF8A80), // FF8A80
      500: Color(0xFFFE6F61), // FE6F61
      600: Color(0xFFFF2C1A), // FF2C1A
      700: Color(0xFFD11001), // D11001
      800: Color(0xFF8F0D00), // 8F0D00
      900: Color(0xFF470600), // 470600
      950: Color(0xFF240300), // 240300
    },
  );

//---------------------------- Vibrant Yellow --------------------------------//
//(Warning)
  static const MaterialColor vibrantYellow = MaterialColor(
    0xFFFFC008, // 500 as primary color
    <int, Color>{
      50: Color(0xFFFFF9E5), // FFF9E5
      100: Color(0xFFFFF2CC), // FFF2CC
      200: Color(0xFFFFE79E), // FFE79E
      300: Color(0xFFFFDA6B), // FFDA6B
      400: Color(0xFFFFCD38), // FFCD38
      500: Color(0xFFFFC008), // FFC008
      600: Color(0xFFD19D01), // D19D01
      700: Color(0xFF9E7700), // 9E7700
      800: Color(0xFF6B5001), // 6B5001
      900: Color(0xFF332700), // 332700
      950: Color(0xFF191300), // 191300
    },
  );

//---------------------------- Sky Blue --------------------------------------//
//(Info)
  static const MaterialColor skyBlue = MaterialColor(
    0xFF57CCF2, // 500 as primary color
    <int, Color>{
      50: Color(0xFFEBF9FE), // EBF9FE
      100: Color(0xFFDEF5FC), // DEF5FC
      200: Color(0xFFBDEBFA), // BDEBFA
      300: Color(0xFF9CE0F7), // 9CE0F7
      400: Color(0xFF76D5F4), // 76D5F4
      500: Color(0xFF57CCF2), // 57CCF2
      600: Color(0xFF1AB8ED), // 1AB8ED
      700: Color(0xFF0C8EB9), // 0C8EB9
      800: Color(0xFF07607B), // 07607B
      900: Color(0xFF062F3F), // 062F3F
      950: Color(0xFF01161C), // 01161C
    },
  );
//******************************************************************************/

//************************* Secondary Colors **********************************//
//---------------------------- Tangerine -------------------------------------//
  static const MaterialColor tangerine = MaterialColor(
    0xFFFFA44D, // 500 as primary color
    <int, Color>{
      50: Color(0xFFFFF8F0), // FFF8F0
      100: Color(0xFFFEEDBB), // FEEDBB
      200: Color(0xFFFDCB88), // FDCB88
      300: Color(0xFFFCB933), // FCB933
      400: Color(0xFFFBA700), // FBA700
      500: Color(0xFFFFA44D), // FFA44D
      600: Color(0xFFFE890B), // FE890B
      700: Color(0xFFC66700), // C66700
      800: Color(0xFF864501), // 864501
      900: Color(0xFF422200), // 422200
      950: Color(0xFF231200), // 231200
    },
  );
//----------------------------  Mint Green -----------------------------------//
//(Success)
  static const MaterialColor mintGreen = MaterialColor(
    0xFF6FCF97, // 500 as primary color
    <int, Color>{
      50: Color(0xFFF0FAF4), // F0FAF4
      100: Color(0xFFE0F5E9), // E0F5E9
      200: Color(0xFFC5ECD6), // C5ECD6
      300: Color(0xFFA7E2BF), // A7E2BF
      400: Color(0xFF8BD9AC), // 8BD9AC
      500: Color(0xFF6FCF97), // 6FCF97
      600: Color(0xFF41BF75), // 41BF75
      700: Color(0xFF308E56), // 308E56
      800: Color(0xFF206039), // 206039
      900: Color(0xFF0F2E1D), // 0F2E1D
      950: Color(0xFF08170E), // 08170E
    },
  );
//---------------------------- Lavender --------------------------------------//
//(Links)
  static const MaterialColor lavender = MaterialColor(
    0xFFCBA6F7, // 500 as primary color
    <int, Color>{
      50: Color(0xFFF8F6FE), // F8F6FE
      100: Color(0xFFF5ECFD), // F5ECFD
      200: Color(0xFFE9D9FC), // E9D9FC
      300: Color(0xFFE0CCFA), // E0CCFA
      400: Color(0xFFD6B9FA), // D6B9FA
      500: Color(0xFFCBA6F7), // CBA6F7
      600: Color(0xFF9E5BF0), // 9E5BF0
      700: Color(0xFF7315E5), // 7315E5
      800: Color(0xFF4B0D96), // 4B0D96
      900: Color(0xFF26074B), // 26074B
      950: Color(0xFF130325), // 130325
    },
  );
//******************************************************************************/
}
