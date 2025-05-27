//-------------------------------- icons.dart --------------------------------//
// This file defines the icon themes for the app.
// It automatically selects the correct icon file for light/dark themes.
// Light theme uses defaultStroke icons (dark colors on light backgrounds).
// Dark theme uses invertedStroke icons where available (light colors on dark backgrounds).
// Brand icons maintain their original colors in both themes.
//----------------------------------------------------------------------------//

//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';
import '../../constants/image_strings.dart';

//------------------------------- SDeckIcons ---------------------------------//
/// A theme extension that provides theme-aware icons for the app.
/// Icons automatically switch between light and dark file variants based on the current theme.
/// This preserves the original Figma colors and ensures proper contrast.

class SDeckIcons extends ThemeExtension<SDeckIcons> {
  //------------------------------- Icon Properties ------------------------//
  // Navigation Icons (Stroke)
  final String home;
  final String profile;
  final String settings;
  final String deck;
  final String friends;
  final String store;

  // Navigation Icons (Fill)
  final String homeFill;
  final String profileFill;
  final String settingsFill;
  final String deckFill;
  final String friendsFill;
  final String storeFill;

  // Action Icons
  final String more;
  final String help;
  final String leftArrow;
  final String rightArrow;
  final String megaphone;
  final String zoomIn;
  final String zoomOut;

  // Brand Icons
  final String socialdeckLogo;
  final String apple;
  final String google;
  final String google1;

  // Utility Icons
  final String addProfileCard;
  final String circleCheck;
  final String circleX;

  // Media & Interaction Icons
  final String placeholder;
  final String play;
  final String pinchAdjust;

  //------------------------------- Constructor ----------------------------//
  const SDeckIcons({
    // Navigation Icons (Stroke)
    required this.home,
    required this.profile,
    required this.settings,
    required this.deck,
    required this.friends,
    required this.store,

    // Navigation Icons (Fill)
    required this.homeFill,
    required this.profileFill,
    required this.settingsFill,
    required this.deckFill,
    required this.friendsFill,
    required this.storeFill,

    // Action Icons
    required this.more,
    required this.help,
    required this.leftArrow,
    required this.rightArrow,
    required this.megaphone,
    required this.zoomIn,
    required this.zoomOut,

    // Brand Icons
    required this.socialdeckLogo,
    required this.apple,
    required this.google,
    required this.google1,

    // Utility Icons
    required this.addProfileCard,
    required this.circleCheck,
    required this.circleX,

    // Media & Interaction Icons
    required this.placeholder,
    required this.play,
    required this.pinchAdjust,
  });

  //*************************** Light Theme Icons *******************************/
  /// Light theme uses defaultStroke icons (dark colors for light backgrounds)
  static const lightTheme = SDeckIcons(
    //------------------------------- Navigation Icons (Stroke) -------------//
    home: SDeckImages.homeStroke,
    profile: SDeckImages.profileStroke,
    settings: SDeckImages.settingsStroke,
    deck: SDeckImages.deckStroke,
    friends: SDeckImages.friendsStroke,
    store: SDeckImages.storeStroke,

    //------------------------------- Navigation Icons (Fill) ---------------//
    homeFill: SDeckImages.homeFill,
    profileFill: SDeckImages.profileFill,
    settingsFill: SDeckImages.settingsFill,
    deckFill: SDeckImages.deckFill,
    friendsFill: SDeckImages.friendsFill,
    storeFill: SDeckImages.storeFill,

    //------------------------------- Action Icons ---------------------------//
    more: SDeckImages.more,
    help: SDeckImages.helpStroke,
    leftArrow: SDeckImages.leftArrowhead,
    rightArrow: SDeckImages.rightArrowhead,
    megaphone: SDeckImages.megaphone,
    zoomIn: SDeckImages.zoomIn,
    zoomOut: SDeckImages.zoomOut,

    //------------------------------- Brand Icons (Original Colors) ---------//
    socialdeckLogo: SDeckImages.socialdeckLogo,
    apple: SDeckImages.apple,
    google: SDeckImages.google,
    google1: SDeckImages.google1,

    //------------------------------- Utility Icons -------------------------//
    addProfileCard: SDeckImages.addProfileCard,
    circleCheck: SDeckImages.circleCheck,
    circleX: SDeckImages.circleX,

    //------------------------------- Media & Interaction Icons --------------//
    placeholder: SDeckImages.placeholder, 
    play: SDeckImages.play, 
    pinchAdjust: SDeckImages.pinchAdjust, 
  );

  //*************************** Dark Theme Icons ********************************/
  /// Dark theme uses invertedStroke icons where available, falls back to defaultStroke
  static const darkTheme = SDeckIcons(
    //------------------------------- Navigation Icons (Stroke) -------------//
    // Using defaultStroke as fallback since most inverted versions don't exist yet
    home: SDeckImages.homeStroke, // Fallback: no inverted version yet
    profile: SDeckImages.profileStroke, // Fallback: no inverted version yet
    settings: SDeckImages.settingsStroke, // Fallback: no inverted version yet
    deck: SDeckImages.deckStroke, // Fallback: no inverted version yet
    friends: SDeckImages.friendsStroke, // Fallback: no inverted version yet
    store: SDeckImages.storeStroke, // Fallback: no inverted version yet
    //------------------------------- Navigation Icons (Fill) ---------------//
    homeFill: SDeckImages.homeFill, // Fallback: no inverted version yet
    profileFill: SDeckImages.profileFill, // Fallback: no inverted version yet
    settingsFill: SDeckImages.settingsFill, // Fallback: no inverted version yet
    deckFill: SDeckImages.deckFill, // Fallback: no inverted version yet
    friendsFill: SDeckImages.friendsFill, // Fallback: no inverted version yet
    storeFill: SDeckImages.storeFill, // Fallback: no inverted version yet
    //------------------------------- Action Icons ---------------------------//
    more: SDeckImages.more, // Fallback: no inverted version yet
    help: SDeckImages.helpStroke, // Fallback: no inverted version yet
    leftArrow: SDeckImages.leftArrowhead, // Fallback: no inverted version yet
    rightArrow: SDeckImages.rightArrowhead, // Fallback: no inverted version yet
    megaphone: SDeckImages.megaphone, // Fallback: no inverted version yet
    zoomIn: SDeckImages.zoomIn, // Fallback: no inverted version yet
    zoomOut: SDeckImages.zoomOut, // Fallback: no inverted version yet
    //------------------------------- Brand Icons (Same as Light) -----------//
    socialdeckLogo: SDeckImages.socialdeckLogo, // Keep original colors
    apple: SDeckImages.apple, // Keep original colors
    google: SDeckImages.google, // Keep original colors
    google1: SDeckImages.google1, // Keep original colors
    //------------------------------- Utility Icons -------------------------//
    addProfileCard: SDeckImages.addProfileCard, // Keep original colors
    circleCheck: SDeckImages.circleCheck, // Keep original colors
    circleX: SDeckImages.circleX, // Keep original colors
    //------------------------------- Media & Interaction Icons (Dark Theme) //
    placeholder: SDeckImages.placeholderInverted, // Light version for dark theme
    play: SDeckImages.play, // Light version (same as light theme - no dark version)
    pinchAdjust: SDeckImages.pinchAdjust, // Light version (same as light theme - no dark version)
  );

  //************************ ThemeExtension Methods ***************************//
  @override
  ThemeExtension<SDeckIcons> copyWith({
    // Navigation Icons (Stroke)
    String? home,
    String? profile,
    String? settings,
    String? deck,
    String? friends,
    String? store,
    // Navigation Icons (Fill)
    String? homeFill,
    String? profileFill,
    String? settingsFill,
    String? deckFill,
    String? friendsFill,
    String? storeFill,
    // Action Icons
    String? more,
    String? help,
    String? leftArrow,
    String? rightArrow,
    String? megaphone,
    String? zoomIn,
    String? zoomOut,
    // Brand Icons
    String? socialdeckLogo,
    String? apple,
    String? google,
    String? google1,
    // Utility Icons
    String? addProfileCard,
    String? circleCheck,
    String? circleX,
    // Media & Interaction Icons
    String? placeholder,
    String? play,
    String? pinchAdjust,
  }) {
    return SDeckIcons(
      // Navigation Icons (Stroke)
      home: home ?? this.home,
      profile: profile ?? this.profile,
      settings: settings ?? this.settings,
      deck: deck ?? this.deck,
      friends: friends ?? this.friends,
      store: store ?? this.store,
      // Navigation Icons (Fill)
      homeFill: homeFill ?? this.homeFill,
      profileFill: profileFill ?? this.profileFill,
      settingsFill: settingsFill ?? this.settingsFill,
      deckFill: deckFill ?? this.deckFill,
      friendsFill: friendsFill ?? this.friendsFill,
      storeFill: storeFill ?? this.storeFill,
      // Action Icons
      more: more ?? this.more,
      help: help ?? this.help,
      leftArrow: leftArrow ?? this.leftArrow,
      rightArrow: rightArrow ?? this.rightArrow,
      megaphone: megaphone ?? this.megaphone,
      zoomIn: zoomIn ?? this.zoomIn,
      zoomOut: zoomOut ?? this.zoomOut,
      // Brand Icons
      socialdeckLogo: socialdeckLogo ?? this.socialdeckLogo,
      apple: apple ?? this.apple,
      google: google ?? this.google,
      google1: google1 ?? this.google1,
      // Utility Icons
      addProfileCard: addProfileCard ?? this.addProfileCard,
      circleCheck: circleCheck ?? this.circleCheck,
      circleX: circleX ?? this.circleX,
      // Media & Interaction Icons
      placeholder: placeholder ?? this.placeholder,
      play: play ?? this.play,
      pinchAdjust: pinchAdjust ?? this.pinchAdjust,
    );
  }

  @override
  ThemeExtension<SDeckIcons> lerp(
    covariant ThemeExtension<SDeckIcons>? other,
    double t,
  ) {
    if (other is! SDeckIcons) {
      return this;
    }
    // For discrete values like strings, we don't interpolate
    return t < 0.5 ? this : other;
  }
}

//*************** Theme-Aware Icon Helper Extension ************************//
/// Extension to make icon access cleaner and more convenient
extension SDeckIconsExtension on BuildContext {
  /// Get the current theme's icon set
  /// Usage: context.icons.home
  SDeckIcons get icons => Theme.of(this).extension<SDeckIcons>()!;
}
