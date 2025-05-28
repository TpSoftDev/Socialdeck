//-------------------------------- icons.dart --------------------------------//
// This file defines the icon themes for the app.
// It automatically selects the correct icon file for light/dark themes.
// Light theme uses light-themed icons (dark colors on light backgrounds).
// Dark theme uses dark-themed icons (light colors on dark backgrounds).
// All icons have perfect symmetry between light and dark themes.
//
// Usage: context.icons.iconName (automatically theme-aware)
// Total Properties: 26 core + 13 additional = 39 icon properties
//----------------------------------------------------------------------------//

//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';
import '../../constants/image_strings.dart';

//------------------------------- SDeckIcons ---------------------------------//
/// A theme extension that provides theme-aware icons for the app.
/// Icons automatically switch between light and dark file variants based on the current theme.
/// This preserves the original Figma colors and ensures proper contrast.

class SDeckIcons extends ThemeExtension<SDeckIcons> {
  //------------------------------- Properties -----------------------------//
  //======================== NAVIGATION ICONS (STROKE) ====================//
  final String home;
  final String profile;
  final String settings;
  final String deck;
  final String friends;
  final String store;

  //======================== NAVIGATION ICONS (FILL) ======================//
  final String homeFill;
  final String profileFill;
  final String settingsFill;
  final String deckFill;
  final String friendsFill;
  final String storeFill;

  //========================== CORE ACTION ICONS ===========================//
  final String more;
  final String help;
  final String leftArrow;
  final String rightArrow;
  final String megaphone;
  final String zoomIn;
  final String zoomOut;

  //========================== NEW UTILITY ICONS ===========================//
  final String clock;
  final String playHollow;
  final String socialdeckLogo;

  //============================== BRAND ICONS =============================//
  final String apple;
  final String google;
  final String googleAlt;

  //========================= ACTION & STATUS ICONS ========================//
  final String addProfileCard;
  final String circleCheck;
  final String circleX;
  final String playBox;

  //======================== MEDIA & INTERACTION ICONS =====================//
  final String placeholder;
  final String placeholderAlt;
  final String pinchAdjust;

  //========================== SHAPE & VECTOR ICONS ========================//
  final String ellipse10;
  final String ellipse10Alt;
  final String vector23;
  final String vector30;
  final String vector33;
  final String vector35;
  final String vector35Alt;

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

    // Core Action Icons
    required this.more,
    required this.help,
    required this.leftArrow,
    required this.rightArrow,
    required this.megaphone,
    required this.zoomIn,
    required this.zoomOut,

    // New Utility Icons
    required this.clock,
    required this.playHollow,
    required this.socialdeckLogo,

    // Brand Icons
    required this.apple,
    required this.google,
    required this.googleAlt,

    // Action & Status Icons
    required this.addProfileCard,
    required this.circleCheck,
    required this.circleX,
    required this.playBox,

    // Media & Interaction Icons
    required this.placeholder,
    required this.placeholderAlt,
    required this.pinchAdjust,

    // Shape & Vector Icons
    required this.ellipse10,
    required this.ellipse10Alt,
    required this.vector23,
    required this.vector30,
    required this.vector33,
    required this.vector35,
    required this.vector35Alt,
  });

  //████████████████████████████████████████████████████████████████████████//
  //                           🌅 LIGHT THEME ICONS                         //
  //████████████████████████████████████████████████████████████████████████//

  static const lightTheme = SDeckIcons(
    //======================== NAVIGATION ICONS (STROKE) ====================//
    home: SDeckImages.lightHomeStroke,
    profile: SDeckImages.lightProfileStroke,
    settings: SDeckImages.lightSettingsStroke,
    deck: SDeckImages.lightDeckStroke,
    friends: SDeckImages.lightFriendsStroke,
    store: SDeckImages.lightStoreStroke,

    //======================== NAVIGATION ICONS (FILL) ======================//
    homeFill: SDeckImages.lightHomeFill,
    profileFill: SDeckImages.lightProfileFill,
    settingsFill: SDeckImages.lightSettingsFill,
    deckFill: SDeckImages.lightDeckFill,
    friendsFill: SDeckImages.lightFriendsFill,
    storeFill: SDeckImages.lightStoreFill,

    //========================== CORE ACTION ICONS ===========================//
    more: SDeckImages.lightMore,
    help: SDeckImages.lightHelpStroke,
    leftArrow: SDeckImages.lightLeftArrowhead,
    rightArrow: SDeckImages.lightRightArrowhead,
    megaphone: SDeckImages.lightMegaphone,
    zoomIn: SDeckImages.lightZoomIn,
    zoomOut: SDeckImages.lightZoomOut,

    //========================== NEW UTILITY ICONS ===========================//
    clock: SDeckImages.lightClockStroke,
    playHollow: SDeckImages.lightPlayHollow,
    socialdeckLogo: SDeckImages.lightSocialdeckLogo,

    //============================== BRAND ICONS =============================//
    apple: SDeckImages.lightApple,
    google: SDeckImages.lightGoogle,
    googleAlt: SDeckImages.lightGoogleAlt,

    //========================= ACTION & STATUS ICONS ========================//
    addProfileCard: SDeckImages.lightAddProfileCard,
    circleCheck: SDeckImages.lightCircleCheck,
    circleX: SDeckImages.lightCircleX,
    playBox: SDeckImages.lightPlayBox,

    //======================== MEDIA & INTERACTION ICONS =====================//
    placeholder: SDeckImages.lightPlaceholder,
    placeholderAlt: SDeckImages.lightPlaceholderAlt,
    pinchAdjust: SDeckImages.lightPinchAdjust,

    //========================== SHAPE & VECTOR ICONS ========================//
    ellipse10: SDeckImages.lightEllipse10,
    ellipse10Alt: SDeckImages.lightEllipse10Alt,
    vector23: SDeckImages.lightVector23,
    vector30: SDeckImages.lightVector30,
    vector33: SDeckImages.lightVector33,
    vector35: SDeckImages.lightVector35,
    vector35Alt: SDeckImages.lightVector35Alt,
  );

  //████████████████████████████████████████████████████████████████████████//
  //                            🌙 DARK THEME ICONS                         //
  //████████████████████████████████████████████████████████████████████████//
  
  static const darkTheme = SDeckIcons(
    //======================== NAVIGATION ICONS (STROKE) ====================//
    home: SDeckImages.darkHomeStroke,
    profile: SDeckImages.darkProfileStroke,
    settings: SDeckImages.darkSettingsStroke,
    deck: SDeckImages.darkDeckStroke,
    friends: SDeckImages.darkFriendsStroke,
    store: SDeckImages.darkStoreStroke,

    //======================== NAVIGATION ICONS (FILL) ======================//
    homeFill: SDeckImages.darkHomeFill,
    profileFill: SDeckImages.darkProfileFill,
    settingsFill: SDeckImages.darkSettingsFill,
    deckFill: SDeckImages.darkDeckFill,
    friendsFill: SDeckImages.darkFriendsFill,
    storeFill: SDeckImages.darkStoreFill,

    //========================== CORE ACTION ICONS ===========================//
    more: SDeckImages.darkMore,
    help: SDeckImages.darkHelpStroke,
    leftArrow: SDeckImages.darkLeftArrowhead,
    rightArrow: SDeckImages.darkRightArrowhead,
    megaphone: SDeckImages.darkMegaphone,
    zoomIn: SDeckImages.darkZoomIn,
    zoomOut: SDeckImages.darkZoomOut,

    //========================== NEW UTILITY ICONS ===========================//
    clock: SDeckImages.darkClockStroke,
    playHollow: SDeckImages.darkPlayHollow,
    socialdeckLogo: SDeckImages.darkSocialdeckLogo,

    //============================== BRAND ICONS =============================//
    apple: SDeckImages.darkApple,
    google: SDeckImages.darkGoogle,
    googleAlt: SDeckImages.darkGoogleAlt,

    //========================= ACTION & STATUS ICONS ========================//
    addProfileCard: SDeckImages.darkAddProfileCard,
    circleCheck: SDeckImages.darkCircleCheck,
    circleX: SDeckImages.darkCircleX,
    playBox: SDeckImages.darkPlayBox,

    //======================== MEDIA & INTERACTION ICONS =====================//
    placeholder: SDeckImages.darkPlaceholder,
    placeholderAlt: SDeckImages.darkPlaceholderAlt,
    pinchAdjust: SDeckImages.darkPinchAdjust,

    //========================== SHAPE & VECTOR ICONS ========================//
    ellipse10: SDeckImages.darkEllipse10,
    ellipse10Alt: SDeckImages.darkEllipse10Alt,
    vector23: SDeckImages.darkVector23,
    vector30: SDeckImages.darkVector30,
    vector33: SDeckImages.darkVector33,
    vector35: SDeckImages.darkVector35,
    vector35Alt: SDeckImages.darkVector35Alt,
  );

  //████████████████████████████████████████████████████████████████████████//
  //                          ⚙️ THEME EXTENSION METHODS                    //
  //████████████████████████████████████████████████████████████████████████//

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
    // Core Action Icons
    String? more,
    String? help,
    String? leftArrow,
    String? rightArrow,
    String? megaphone,
    String? zoomIn,
    String? zoomOut,
    // New Utility Icons
    String? clock,
    String? playHollow,
    String? socialdeckLogo,
    // Brand Icons
    String? apple,
    String? google,
    String? googleAlt,
    // Action & Status Icons
    String? addProfileCard,
    String? circleCheck,
    String? circleX,
    String? playBox,
    // Media & Interaction Icons
    String? placeholder,
    String? placeholderAlt,
    String? pinchAdjust,
    // Shape & Vector Icons
    String? ellipse10,
    String? ellipse10Alt,
    String? vector23,
    String? vector30,
    String? vector33,
    String? vector35,
    String? vector35Alt,
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
      // Core Action Icons
      more: more ?? this.more,
      help: help ?? this.help,
      leftArrow: leftArrow ?? this.leftArrow,
      rightArrow: rightArrow ?? this.rightArrow,
      megaphone: megaphone ?? this.megaphone,
      zoomIn: zoomIn ?? this.zoomIn,
      zoomOut: zoomOut ?? this.zoomOut,
      // New Utility Icons
      clock: clock ?? this.clock,
      playHollow: playHollow ?? this.playHollow,
      socialdeckLogo: socialdeckLogo ?? this.socialdeckLogo,
      // Brand Icons
      apple: apple ?? this.apple,
      google: google ?? this.google,
      googleAlt: googleAlt ?? this.googleAlt,
      // Action & Status Icons
      addProfileCard: addProfileCard ?? this.addProfileCard,
      circleCheck: circleCheck ?? this.circleCheck,
      circleX: circleX ?? this.circleX,
      playBox: playBox ?? this.playBox,
      // Media & Interaction Icons
      placeholder: placeholder ?? this.placeholder,
      placeholderAlt: placeholderAlt ?? this.placeholderAlt,
      pinchAdjust: pinchAdjust ?? this.pinchAdjust,
      // Shape & Vector Icons
      ellipse10: ellipse10 ?? this.ellipse10,
      ellipse10Alt: ellipse10Alt ?? this.ellipse10Alt,
      vector23: vector23 ?? this.vector23,
      vector30: vector30 ?? this.vector30,
      vector33: vector33 ?? this.vector33,
      vector35: vector35 ?? this.vector35,
      vector35Alt: vector35Alt ?? this.vector35Alt,
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

//████████████████████████████████████████████████████████████████████████//
//                         🎯 THEME-AWARE EXTENSIONS                       //
//████████████████████████████████████████████████████████████████████████//

/// Extension to make icon access cleaner and more convenient
extension SDeckIconsExtension on BuildContext {
  /// Get the current theme's icon set
  /// Usage: context.icons.home, context.icons.clock, context.icons.playHollow
  SDeckIcons get icons => Theme.of(this).extension<SDeckIcons>()!;
}
