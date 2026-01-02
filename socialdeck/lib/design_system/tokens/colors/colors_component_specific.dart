/*----------------------------- colors_component_specific.dart -----------------*/
// Component-Specific Color Palette - ThemeExtension
// These tokens map semantic colors to specific component parts (surfaces, icons,
// text, borders) for UI components like buttons, inputs, dialogs, toasts, and
// navigation. They ensure consistent color usage across component states and
// interaction modes within light and dark themes.
//
// Usage:
//   context.component.solidButtonPrimarySurface
//   Theme.of(context).extension<SDeckComponentColors>()?.solidButtonPrimarySurface
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';
import 'colors_main_semantic.dart';

//------------------------------- SDeckComponentColors -----------------------//
class SDeckComponentColors extends ThemeExtension<SDeckComponentColors> {
  //*************************** Button Component ****************************//
  //-------------------------------- Solid Button ------------------------------//
  final Color solidButtonPrimarySurface;
  final Color solidButtonPrimarySurfaceHover;
  final Color solidButtonPrimarySurfacePressed;
  final Color solidButtonSurfaceDisabled;
  final Color solidButtonIcon;
  final Color solidButtonText;
  final Color solidButtonBorder;

  //-------------------------------- Outline Button -----------------------------//
  final Color outlineButtonPrimarySurface;
  final Color outlineButtonIcon;
  final Color outlineButtonIconDisabled;
  final Color outlineButtonText;
  final Color outlineButtonTextDisabled;
  final Color outlineButtonBorder;
  final Color outlineButtonBorderHover;
  final Color outlineButtonBorderPressed;
  final Color outlineButtonBorderDisabled;

  //-------------------------------- Text Button --------------------------------//
  final Color textButtonIcon;
  final Color textButtonIconHover;
  final Color textButtonIconPressed;
  final Color textButtonIconDisabled;
  final Color textButtonText;
  final Color textButtonTextHover;
  final Color textButtonTextPressed;
  final Color textButtonTextDisabled;

  //-------------------------------- Dialog ------------------------------------//
  final Color dialogSurface;
  final Color dialogIcon;
  final Color dialogTitleText;
  final Color dialogDescriptionText;

  //-------------------------------- Navigation ---------------------------------//
  final Color navigationSurface;
  final Color navigationIcon;
  final Color navigationText;

  //-------------------------------- Icon (Standalone) --------------------------//
  final Color iconPrimary;
  final Color iconSecondary;
  final Color iconTertiary;
  final Color iconDisabled;
  final Color iconError;

  //-------------------------------- Text (Standalone) --------------------------//
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;
  final Color textLink;

  //-------------------------------- Toast --------------------------------------//
  final Color toastSurfaceError;
  final Color toastSurfaceSuccess;
  final Color toastSurfaceWarning;
  final Color toastSurfaceInfo;
  final Color toastSurfaceLink;
  final Color toastSurfaceNote;
  final Color toastIconError;
  final Color toastIconSuccess;
  final Color toastIconWarning;
  final Color toastIconInfo;
  final Color toastIconLink;
  final Color toastIconNote;
  final Color toastTitleText;
  final Color toastDescriptionText;
  final Color toastBorderError;
  final Color toastBorderSuccess;
  final Color toastBorderWarning;
  final Color toastBorderInfo;
  final Color toastBorderLink;
  final Color toastBorderNote;

  //-------------------------------- Input --------------------------------------//
  final Color inputSurface;
  final Color inputSurfaceDisabled;
  final Color inputSurfaceError;
  final Color inputIcon;
  final Color inputIconDisabled;
  final Color inputIconError;
  final Color inputText;
  final Color inputTextHint;
  final Color inputTextDisabled;
  final Color inputLabel;
  final Color inputSupportingText;
  final Color inputSupportingTextDisabled;
  final Color inputSupportingTextError;
  final Color inputBorder;
  final Color inputBorderFocused;
  final Color inputBorderDisabled;
  final Color inputBorderError;

  //------------------------------- Constructor ---------------------------------//
  const SDeckComponentColors({
    required this.solidButtonPrimarySurface,
    required this.solidButtonPrimarySurfaceHover,
    required this.solidButtonPrimarySurfacePressed,
    required this.solidButtonSurfaceDisabled,
    required this.solidButtonIcon,
    required this.solidButtonText,
    required this.solidButtonBorder,
    required this.outlineButtonPrimarySurface,
    required this.outlineButtonIcon,
    required this.outlineButtonIconDisabled,
    required this.outlineButtonText,
    required this.outlineButtonTextDisabled,
    required this.outlineButtonBorder,
    required this.outlineButtonBorderHover,
    required this.outlineButtonBorderPressed,
    required this.outlineButtonBorderDisabled,
    required this.textButtonIcon,
    required this.textButtonIconHover,
    required this.textButtonIconPressed,
    required this.textButtonIconDisabled,
    required this.textButtonText,
    required this.textButtonTextHover,
    required this.textButtonTextPressed,
    required this.textButtonTextDisabled,
    required this.dialogSurface,
    required this.dialogIcon,
    required this.dialogTitleText,
    required this.dialogDescriptionText,
    required this.navigationSurface,
    required this.navigationIcon,
    required this.navigationText,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconTertiary,
    required this.iconDisabled,
    required this.iconError,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.textLink,
    required this.toastSurfaceError,
    required this.toastSurfaceSuccess,
    required this.toastSurfaceWarning,
    required this.toastSurfaceInfo,
    required this.toastSurfaceLink,
    required this.toastSurfaceNote,
    required this.toastIconError,
    required this.toastIconSuccess,
    required this.toastIconWarning,
    required this.toastIconInfo,
    required this.toastIconLink,
    required this.toastIconNote,
    required this.toastTitleText,
    required this.toastDescriptionText,
    required this.toastBorderError,
    required this.toastBorderSuccess,
    required this.toastBorderWarning,
    required this.toastBorderInfo,
    required this.toastBorderLink,
    required this.toastBorderNote,
    required this.inputSurface,
    required this.inputSurfaceDisabled,
    required this.inputSurfaceError,
    required this.inputIcon,
    required this.inputIconDisabled,
    required this.inputIconError,
    required this.inputText,
    required this.inputTextHint,
    required this.inputTextDisabled,
    required this.inputLabel,
    required this.inputSupportingText,
    required this.inputSupportingTextDisabled,
    required this.inputSupportingTextError,
    required this.inputBorder,
    required this.inputBorderFocused,
    required this.inputBorderDisabled,
    required this.inputBorderError,
  });

  //----------------------------- Light Theme Factory ---------------------------//
  static SDeckComponentColors light(SDeckSemanticColors semantic) {
    return SDeckComponentColors(
      solidButtonPrimarySurface: semantic.primary,
      solidButtonPrimarySurfaceHover: semantic.secondary,
      solidButtonPrimarySurfacePressed: semantic.secondary,
      solidButtonSurfaceDisabled: semantic.secondaryVariant,
      solidButtonIcon: semantic.onPrimary,
      solidButtonText: semantic.onPrimary,
      solidButtonBorder: semantic.outlineVariant,
      outlineButtonPrimarySurface: semantic.surface,
      outlineButtonIcon: semantic.primary,
      outlineButtonIconDisabled: semantic.secondaryVariant,
      outlineButtonText: semantic.primary,
      outlineButtonTextDisabled: semantic.secondaryVariant,
      outlineButtonBorder: semantic.outline,
      outlineButtonBorderHover: semantic.secondaryVariant,
      outlineButtonBorderPressed: semantic.secondaryVariant,
      outlineButtonBorderDisabled: semantic.tertiaryVariant,
      textButtonIcon: semantic.primary,
      textButtonIconHover: semantic.secondary,
      textButtonIconPressed: semantic.secondary,
      textButtonIconDisabled: semantic.secondaryVariant,
      textButtonText: semantic.primary,
      textButtonTextHover: semantic.secondary,
      textButtonTextPressed: semantic.secondary,
      textButtonTextDisabled: semantic.secondaryVariant,
      dialogSurface: semantic.surface,
      dialogIcon: semantic.primary,
      dialogTitleText: semantic.primary,
      dialogDescriptionText: semantic.secondary,
      navigationSurface: semantic.surface,
      navigationIcon: semantic.primary,
      navigationText: semantic.primary,
      iconPrimary: semantic.primary,
      iconSecondary: semantic.secondary,
      iconTertiary: semantic.tertiaryVariant,
      iconDisabled: semantic.secondaryVariant,
      iconError: semantic.error,
      textPrimary: semantic.primary,
      textSecondary: semantic.secondary,
      textTertiary: semantic.tertiaryVariant,
      textDisabled: semantic.secondaryVariant,
      textLink: semantic.link,
      toastSurfaceError: semantic.surfaceError,
      toastSurfaceSuccess: semantic.surfaceSuccess,
      toastSurfaceWarning: semantic.surfaceWarning,
      toastSurfaceInfo: semantic.surfaceInfo,
      toastSurfaceLink: semantic.surfaceLink,
      toastSurfaceNote: semantic.surfaceNote,
      toastIconError: semantic.error,
      toastIconSuccess: semantic.success,
      toastIconWarning: semantic.warning,
      toastIconInfo: semantic.info,
      toastIconLink: semantic.link,
      toastIconNote: semantic.note,
      toastTitleText: semantic.primary,
      toastDescriptionText: semantic.secondary,
      toastBorderError: semantic.error,
      toastBorderSuccess: semantic.success,
      toastBorderWarning: semantic.warning,
      toastBorderInfo: semantic.info,
      toastBorderLink: semantic.link,
      toastBorderNote: semantic.note,
      inputSurface: semantic.surface,
      inputSurfaceDisabled: semantic.surfaceVariant,
      inputSurfaceError: semantic.surfaceError,
      inputIcon: semantic.primary,
      inputIconDisabled: semantic.secondaryVariant,
      inputIconError: semantic.error,
      inputText: semantic.primary,
      inputTextHint: semantic.secondaryVariant,
      inputTextDisabled: semantic.secondaryVariant,
      inputLabel: semantic.primary,
      inputSupportingText: semantic.secondary,
      inputSupportingTextDisabled: semantic.secondaryVariant,
      inputSupportingTextError: semantic.error,
      inputBorder: semantic.outline,
      inputBorderFocused: semantic.info,
      inputBorderDisabled: semantic.secondaryVariant,
      inputBorderError: semantic.error,
    );
  }

  //----------------------------- Dark Theme Factory ----------------------------//
  static SDeckComponentColors dark(SDeckSemanticColors semantic) {
    return SDeckComponentColors(
      solidButtonPrimarySurface: semantic.primary,
      solidButtonPrimarySurfaceHover: semantic.secondary,
      solidButtonPrimarySurfacePressed: semantic.secondary,
      solidButtonSurfaceDisabled: semantic.secondaryVariant,
      solidButtonIcon: semantic.onPrimary,
      solidButtonText: semantic.onPrimary,
      solidButtonBorder: semantic.outlineVariant,
      outlineButtonPrimarySurface: semantic.surface,
      outlineButtonIcon: semantic.primary,
      outlineButtonIconDisabled: semantic.secondaryVariant,
      outlineButtonText: semantic.primary,
      outlineButtonTextDisabled: semantic.secondaryVariant,
      outlineButtonBorder: semantic.outline,
      outlineButtonBorderHover: semantic.secondaryVariant,
      outlineButtonBorderPressed: semantic.secondaryVariant,
      outlineButtonBorderDisabled: semantic.tertiaryVariant,
      textButtonIcon: semantic.primary,
      textButtonIconHover: semantic.secondary,
      textButtonIconPressed: semantic.secondary,
      textButtonIconDisabled: semantic.secondaryVariant,
      textButtonText: semantic.primary,
      textButtonTextHover: semantic.secondary,
      textButtonTextPressed: semantic.secondary,
      textButtonTextDisabled: semantic.secondaryVariant,
      dialogSurface: semantic.surface,
      dialogIcon: semantic.primary,
      dialogTitleText: semantic.primary,
      dialogDescriptionText: semantic.secondary,
      navigationSurface: semantic.surface,
      navigationIcon: semantic.primary,
      navigationText: semantic.primary,
      iconPrimary: semantic.primary,
      iconSecondary: semantic.secondary,
      iconTertiary: semantic.tertiaryVariant,
      iconDisabled: semantic.secondaryVariant,
      iconError: semantic.error,
      textPrimary: semantic.primary,
      textSecondary: semantic.secondary,
      textTertiary: semantic.tertiaryVariant,
      textDisabled: semantic.secondaryVariant,
      textLink: semantic.link,
      toastSurfaceError: semantic.surfaceError,
      toastSurfaceSuccess: semantic.surfaceSuccess,
      toastSurfaceWarning: semantic.surfaceWarning,
      toastSurfaceInfo: semantic.surfaceInfo,
      toastSurfaceLink: semantic.surfaceLink,
      toastSurfaceNote: semantic.surfaceNote,
      toastIconError: semantic.error,
      toastIconSuccess: semantic.success,
      toastIconWarning: semantic.warning,
      toastIconInfo: semantic.info,
      toastIconLink: semantic.link,
      toastIconNote: semantic.note,
      toastTitleText: semantic.primary,
      toastDescriptionText: semantic.secondary,
      toastBorderError: semantic.error,
      toastBorderSuccess: semantic.success,
      toastBorderWarning: semantic.warning,
      toastBorderInfo: semantic.info,
      toastBorderLink: semantic.link,
      toastBorderNote: semantic.note,
      inputSurface: semantic.surface,
      inputSurfaceDisabled: semantic.surfaceVariant,
      inputSurfaceError: semantic.surfaceError,
      inputIcon: semantic.primary,
      inputIconDisabled: semantic.secondaryVariant,
      inputIconError: semantic.error,
      inputText: semantic.primary,
      inputTextHint: semantic.secondaryVariant,
      inputTextDisabled: semantic.secondaryVariant,
      inputLabel: semantic.primary,
      inputSupportingText: semantic.secondary,
      inputSupportingTextDisabled: semantic.secondaryVariant,
      inputSupportingTextError: semantic.error,
      inputBorder: semantic.outline,
      inputBorderFocused: semantic.info,
      inputBorderDisabled: semantic.secondaryVariant,
      inputBorderError: semantic.error,
    );
  }

  //----------------------------- Copy With -----------------------------------//
  /// Creates a new instance with optionally updated properties.
  /// If a parameter is provided (not null), it replaces the current value.
  /// If a parameter is null, the current value is kept unchanged.
  /// Example: componentColors.copyWith(solidButtonPrimarySurface: Colors.red)
  ///          creates a copy with only that property changed.
  @override
  ThemeExtension<SDeckComponentColors> copyWith({
    Color? solidButtonPrimarySurface,
    Color? solidButtonPrimarySurfaceHover,
    Color? solidButtonPrimarySurfacePressed,
    Color? solidButtonSurfaceDisabled,
    Color? solidButtonIcon,
    Color? solidButtonText,
    Color? solidButtonBorder,
    Color? outlineButtonPrimarySurface,
    Color? outlineButtonIcon,
    Color? outlineButtonIconDisabled,
    Color? outlineButtonText,
    Color? outlineButtonTextDisabled,
    Color? outlineButtonBorder,
    Color? outlineButtonBorderHover,
    Color? outlineButtonBorderPressed,
    Color? outlineButtonBorderDisabled,
    Color? textButtonIcon,
    Color? textButtonIconHover,
    Color? textButtonIconPressed,
    Color? textButtonIconDisabled,
    Color? textButtonText,
    Color? textButtonTextHover,
    Color? textButtonTextPressed,
    Color? textButtonTextDisabled,
    Color? dialogSurface,
    Color? dialogIcon,
    Color? dialogTitleText,
    Color? dialogDescriptionText,
    Color? navigationSurface,
    Color? navigationIcon,
    Color? navigationText,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? iconTertiary,
    Color? iconDisabled,
    Color? iconError,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? textLink,
    Color? toastSurfaceError,
    Color? toastSurfaceSuccess,
    Color? toastSurfaceWarning,
    Color? toastSurfaceInfo,
    Color? toastSurfaceLink,
    Color? toastSurfaceNote,
    Color? toastIconError,
    Color? toastIconSuccess,
    Color? toastIconWarning,
    Color? toastIconInfo,
    Color? toastIconLink,
    Color? toastIconNote,
    Color? toastTitleText,
    Color? toastDescriptionText,
    Color? toastBorderError,
    Color? toastBorderSuccess,
    Color? toastBorderWarning,
    Color? toastBorderInfo,
    Color? toastBorderLink,
    Color? toastBorderNote,
    Color? inputSurface,
    Color? inputSurfaceDisabled,
    Color? inputSurfaceError,
    Color? inputIcon,
    Color? inputIconDisabled,
    Color? inputIconError,
    Color? inputText,
    Color? inputTextHint,
    Color? inputTextDisabled,
    Color? inputLabel,
    Color? inputSupportingText,
    Color? inputSupportingTextDisabled,
    Color? inputSupportingTextError,
    Color? inputBorder,
    Color? inputBorderFocused,
    Color? inputBorderDisabled,
    Color? inputBorderError,
  }) {
    return SDeckComponentColors(
      solidButtonPrimarySurface: solidButtonPrimarySurface ?? this.solidButtonPrimarySurface,
      solidButtonPrimarySurfaceHover:solidButtonPrimarySurfaceHover ?? this.solidButtonPrimarySurfaceHover,
      solidButtonPrimarySurfacePressed: solidButtonPrimarySurfacePressed ?? this.solidButtonPrimarySurfacePressed,
      solidButtonSurfaceDisabled: solidButtonSurfaceDisabled ?? this.solidButtonSurfaceDisabled,
      solidButtonIcon: solidButtonIcon ?? this.solidButtonIcon,
      solidButtonText: solidButtonText ?? this.solidButtonText,
      solidButtonBorder: solidButtonBorder ?? this.solidButtonBorder,
      outlineButtonPrimarySurface: outlineButtonPrimarySurface ?? this.outlineButtonPrimarySurface,
      outlineButtonIcon: outlineButtonIcon ?? this.outlineButtonIcon,
      outlineButtonIconDisabled: outlineButtonIconDisabled ?? this.outlineButtonIconDisabled,
      outlineButtonText: outlineButtonText ?? this.outlineButtonText,
      outlineButtonTextDisabled: outlineButtonTextDisabled ?? this.outlineButtonTextDisabled,
      outlineButtonBorder: outlineButtonBorder ?? this.outlineButtonBorder,
      outlineButtonBorderHover: outlineButtonBorderHover ?? this.outlineButtonBorderHover,
      outlineButtonBorderPressed: outlineButtonBorderPressed ?? this.outlineButtonBorderPressed,
      outlineButtonBorderDisabled:outlineButtonBorderDisabled ?? this.outlineButtonBorderDisabled,
      textButtonIcon: textButtonIcon ?? this.textButtonIcon,
      textButtonIconHover: textButtonIconHover ?? this.textButtonIconHover,
      textButtonIconPressed: textButtonIconPressed ?? this.textButtonIconPressed,
      textButtonIconDisabled: textButtonIconDisabled ?? this.textButtonIconDisabled,
      textButtonText: textButtonText ?? this.textButtonText,
      textButtonTextHover: textButtonTextHover ?? this.textButtonTextHover,
      textButtonTextPressed: textButtonTextPressed ?? this.textButtonTextPressed,
      textButtonTextDisabled:textButtonTextDisabled ?? this.textButtonTextDisabled,
      dialogSurface: dialogSurface ?? this.dialogSurface,
      dialogIcon: dialogIcon ?? this.dialogIcon,
      dialogTitleText: dialogTitleText ?? this.dialogTitleText,
      dialogDescriptionText: dialogDescriptionText ?? this.dialogDescriptionText,
      navigationSurface: navigationSurface ?? this.navigationSurface,
      navigationIcon: navigationIcon ?? this.navigationIcon,
      navigationText: navigationText ?? this.navigationText,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      iconTertiary: iconTertiary ?? this.iconTertiary,
      iconDisabled: iconDisabled ?? this.iconDisabled,
      iconError: iconError ?? this.iconError,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      textLink: textLink ?? this.textLink,
      toastSurfaceError: toastSurfaceError ?? this.toastSurfaceError,
      toastSurfaceSuccess: toastSurfaceSuccess ?? this.toastSurfaceSuccess,
      toastSurfaceWarning: toastSurfaceWarning ?? this.toastSurfaceWarning,
      toastSurfaceInfo: toastSurfaceInfo ?? this.toastSurfaceInfo,
      toastSurfaceLink: toastSurfaceLink ?? this.toastSurfaceLink,
      toastSurfaceNote: toastSurfaceNote ?? this.toastSurfaceNote,
      toastIconError: toastIconError ?? this.toastIconError,
      toastIconSuccess: toastIconSuccess ?? this.toastIconSuccess,
      toastIconWarning: toastIconWarning ?? this.toastIconWarning,
      toastIconInfo: toastIconInfo ?? this.toastIconInfo,
      toastIconLink: toastIconLink ?? this.toastIconLink,
      toastIconNote: toastIconNote ?? this.toastIconNote,
      toastTitleText: toastTitleText ?? this.toastTitleText,
      toastDescriptionText: toastDescriptionText ?? this.toastDescriptionText,
      toastBorderError: toastBorderError ?? this.toastBorderError,
      toastBorderSuccess: toastBorderSuccess ?? this.toastBorderSuccess,
      toastBorderWarning: toastBorderWarning ?? this.toastBorderWarning,
      toastBorderInfo: toastBorderInfo ?? this.toastBorderInfo,
      toastBorderLink: toastBorderLink ?? this.toastBorderLink,
      toastBorderNote: toastBorderNote ?? this.toastBorderNote,
      inputSurface: inputSurface ?? this.inputSurface,
      inputSurfaceDisabled: inputSurfaceDisabled ?? this.inputSurfaceDisabled,
      inputSurfaceError: inputSurfaceError ?? this.inputSurfaceError,
      inputIcon: inputIcon ?? this.inputIcon,
      inputIconDisabled: inputIconDisabled ?? this.inputIconDisabled,
      inputIconError: inputIconError ?? this.inputIconError,
      inputText: inputText ?? this.inputText,
      inputTextHint: inputTextHint ?? this.inputTextHint,
      inputTextDisabled: inputTextDisabled ?? this.inputTextDisabled,
      inputLabel: inputLabel ?? this.inputLabel,
      inputSupportingText: inputSupportingText ?? this.inputSupportingText,
      inputSupportingTextDisabled: inputSupportingTextDisabled ?? this.inputSupportingTextDisabled,
      inputSupportingTextError: inputSupportingTextError ?? this.inputSupportingTextError,
      inputBorder: inputBorder ?? this.inputBorder,
      inputBorderFocused: inputBorderFocused ?? this.inputBorderFocused,
      inputBorderDisabled: inputBorderDisabled ?? this.inputBorderDisabled,
      inputBorderError: inputBorderError ?? this.inputBorderError,
    );
  }

  //----------------------------- Lerp ---------------------------------------//
  /// Linearly interpolates (blends) between this instance and another.
  /// The `t` parameter controls the blend: 0.0 = this instance, 1.0 = other instance.
  /// Used by Flutter to smoothly transition between themes during animations.
  /// Example: lerp(lightTheme, darkTheme, 0.5) returns a theme halfway between them.
  @override
  ThemeExtension<SDeckComponentColors> lerp(
    ThemeExtension<SDeckComponentColors>? other,double t,) {
    if (other is! SDeckComponentColors) return this;

    return SDeckComponentColors(
      solidButtonPrimarySurface:Color.lerp(solidButtonPrimarySurface, other.solidButtonPrimarySurface, t)!,
      solidButtonPrimarySurfaceHover:Color.lerp(solidButtonPrimarySurfaceHover, other.solidButtonPrimarySurfaceHover, t)!,
      solidButtonPrimarySurfacePressed:Color.lerp(solidButtonPrimarySurfacePressed, other.solidButtonPrimarySurfacePressed, t)!,
      solidButtonSurfaceDisabled:Color.lerp(solidButtonSurfaceDisabled, other.solidButtonSurfaceDisabled, t)!,
      solidButtonIcon: Color.lerp(solidButtonIcon, other.solidButtonIcon, t)!,
      solidButtonText: Color.lerp(solidButtonText, other.solidButtonText, t)!,
      solidButtonBorder:Color.lerp(solidButtonBorder, other.solidButtonBorder, t)!,
      outlineButtonPrimarySurface:Color.lerp(outlineButtonPrimarySurface, other.outlineButtonPrimarySurface, t)!,
      outlineButtonIcon:Color.lerp(outlineButtonIcon, other.outlineButtonIcon, t)!,
      outlineButtonIconDisabled:Color.lerp(outlineButtonIconDisabled, other.outlineButtonIconDisabled, t)!,
      outlineButtonText:Color.lerp(outlineButtonText, other.outlineButtonText, t)!,
      outlineButtonTextDisabled:Color.lerp(outlineButtonTextDisabled, other.outlineButtonTextDisabled, t)!,
      outlineButtonBorder:Color.lerp(outlineButtonBorder, other.outlineButtonBorder, t)!,
      outlineButtonBorderHover:Color.lerp(outlineButtonBorderHover, other.outlineButtonBorderHover, t)!,
      outlineButtonBorderPressed:Color.lerp(outlineButtonBorderPressed, other.outlineButtonBorderPressed, t)!,
      outlineButtonBorderDisabled:Color.lerp(outlineButtonBorderDisabled, other.outlineButtonBorderDisabled, t)!,
      textButtonIcon: Color.lerp(textButtonIcon, other.textButtonIcon, t)!,
      textButtonIconHover: Color.lerp(textButtonIconHover, other.textButtonIconHover, t)!,
      textButtonIconPressed: Color.lerp(textButtonIconPressed, other.textButtonIconPressed, t)!,
      textButtonIconDisabled: Color.lerp(textButtonIconDisabled, other.textButtonIconDisabled, t)!,
      textButtonText: Color.lerp(textButtonText, other.textButtonText, t)!,
      textButtonTextHover: Color.lerp(textButtonTextHover, other.textButtonTextHover, t)!,
      textButtonTextPressed: Color.lerp(textButtonTextPressed, other.textButtonTextPressed, t)!,
      textButtonTextDisabled:Color.lerp(textButtonTextDisabled, other.textButtonTextDisabled, t)!,
      dialogSurface: Color.lerp(dialogSurface, other.dialogSurface, t)!,
      dialogIcon: Color.lerp(dialogIcon, other.dialogIcon, t)!,
      dialogTitleText: Color.lerp(dialogTitleText, other.dialogTitleText, t)!,
      dialogDescriptionText: Color.lerp(dialogDescriptionText, other.dialogDescriptionText, t)!,
      navigationSurface:Color.lerp(navigationSurface, other.navigationSurface, t)!,
      navigationIcon: Color.lerp(navigationIcon, other.navigationIcon, t)!,
      navigationText: Color.lerp(navigationText, other.navigationText, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      iconTertiary: Color.lerp(iconTertiary, other.iconTertiary, t)!,
      iconDisabled: Color.lerp(iconDisabled, other.iconDisabled, t)!,
      iconError: Color.lerp(iconError, other.iconError, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textLink: Color.lerp(textLink, other.textLink, t)!,
      toastSurfaceError: Color.lerp(toastSurfaceError, other.toastSurfaceError, t)!,
      toastSurfaceSuccess: Color.lerp(toastSurfaceSuccess, other.toastSurfaceSuccess, t)!,
      toastSurfaceWarning: Color.lerp(toastSurfaceWarning, other.toastSurfaceWarning, t)!,
      toastSurfaceInfo: Color.lerp(toastSurfaceInfo, other.toastSurfaceInfo, t)!,
      toastSurfaceLink: Color.lerp(toastSurfaceLink, other.toastSurfaceLink, t)!,
      toastSurfaceNote: Color.lerp(toastSurfaceNote, other.toastSurfaceNote, t)!,
      toastIconError: Color.lerp(toastIconError, other.toastIconError, t)!,
      toastIconSuccess: Color.lerp(toastIconSuccess, other.toastIconSuccess, t)!,
      toastIconWarning: Color.lerp(toastIconWarning, other.toastIconWarning, t)!,
      toastIconInfo: Color.lerp(toastIconInfo, other.toastIconInfo, t)!,
      toastIconLink: Color.lerp(toastIconLink, other.toastIconLink, t)!,
      toastIconNote: Color.lerp(toastIconNote, other.toastIconNote, t)!,
      toastTitleText: Color.lerp(toastTitleText, other.toastTitleText, t)!,
      toastDescriptionText: Color.lerp(toastDescriptionText, other.toastDescriptionText, t)!,
      toastBorderError: Color.lerp(toastBorderError, other.toastBorderError, t)!,
      toastBorderSuccess: Color.lerp(toastBorderSuccess, other.toastBorderSuccess, t)!,
      toastBorderWarning:Color.lerp(toastBorderWarning, other.toastBorderWarning, t)!,
      toastBorderInfo: Color.lerp(toastBorderInfo, other.toastBorderInfo, t)!,
      toastBorderLink: Color.lerp(toastBorderLink, other.toastBorderLink, t)!,
      toastBorderNote: Color.lerp(toastBorderNote, other.toastBorderNote, t)!,
      inputSurface: Color.lerp(inputSurface, other.inputSurface, t)!,
      inputSurfaceDisabled:Color.lerp(inputSurfaceDisabled, other.inputSurfaceDisabled, t)!,
      inputSurfaceError:Color.lerp(inputSurfaceError, other.inputSurfaceError, t)!,
      inputIcon: Color.lerp(inputIcon, other.inputIcon, t)!,
      inputIconDisabled:Color.lerp(inputIconDisabled, other.inputIconDisabled, t)!,
      inputIconError: Color.lerp(inputIconError, other.inputIconError, t)!,
      inputText: Color.lerp(inputText, other.inputText, t)!,
      inputTextHint: Color.lerp(inputTextHint, other.inputTextHint, t)!,
      inputTextDisabled:Color.lerp(inputTextDisabled, other.inputTextDisabled, t)!,
      inputLabel: Color.lerp(inputLabel, other.inputLabel, t)!,
      inputSupportingText:Color.lerp(inputSupportingText, other.inputSupportingText, t)!,
      inputSupportingTextDisabled:Color.lerp(inputSupportingTextDisabled, other.inputSupportingTextDisabled, t)!,
      inputSupportingTextError:Color.lerp(inputSupportingTextError, other.inputSupportingTextError, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      inputBorderFocused: Color.lerp(inputBorderFocused, other.inputBorderFocused, t)!,
      inputBorderDisabled: Color.lerp(inputBorderDisabled, other.inputBorderDisabled, t)!,
      inputBorderError:Color.lerp(inputBorderError, other.inputBorderError, t)!,
    );
  }
}
