/*--------------------------- icon_themes.dart ------------------------------*/
// Foundation icon themes built from design tokens
// These create theme-aware icon systems using asset tokens
// Icons automatically switch between light and dark variants
//
// Usage: Import in themes and access via context.icons.iconName
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../tokens/index.dart';

/// Foundation icon themes for the SocialDeck design system
/// Icons automatically switch between light and dark file variants based on theme
/// This preserves the original Figma colors and ensures proper contrast
class SDeckIconThemes extends ThemeExtension<SDeckIconThemes> {
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
  final String wordmark;

  //------------------------------- Constructor ----------------------------//
  const SDeckIconThemes({
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
    required this.wordmark,

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

  //*************************** Light Theme Icons ****************************//
  static const light = SDeckIconThemes(
    //======================== NAVIGATION ICONS (STROKE) ====================//
    home: SDeckAssets.lightHomeStroke,
    profile: SDeckAssets.lightProfileStroke,
    settings: SDeckAssets.lightSettingsStroke,
    deck: SDeckAssets.lightDeckStroke,
    friends: SDeckAssets.lightFriendsStroke,
    store: SDeckAssets.lightStoreStroke,

    //======================== NAVIGATION ICONS (FILL) ======================//
    homeFill: SDeckAssets.lightHomeFill,
    profileFill: SDeckAssets.lightProfileFill,
    settingsFill: SDeckAssets.lightSettingsFill,
    deckFill: SDeckAssets.lightDeckFill,
    friendsFill: SDeckAssets.lightFriendsFill,
    storeFill: SDeckAssets.lightStoreFill,

    //========================== CORE ACTION ICONS ===========================//
    more: SDeckAssets.lightMore,
    help: SDeckAssets.lightHelpStroke,
    leftArrow: SDeckAssets.lightLeftArrowhead,
    rightArrow: SDeckAssets.lightRightArrowhead,
    megaphone: SDeckAssets.lightMegaphone,
    zoomIn: SDeckAssets.lightZoomIn,
    zoomOut: SDeckAssets.lightZoomOut,

    //========================== NEW UTILITY ICONS ===========================//
    clock: SDeckAssets.lightClockStroke,
    playHollow: SDeckAssets.lightPlayHollow,
    socialdeckLogo: SDeckAssets.lightSocialdeckLogo,
    wordmark: SDeckAssets.lightWordmark,

    //============================== BRAND ICONS =============================//
    apple: SDeckAssets.lightApple,
    google: SDeckAssets.lightGoogle,
    googleAlt: SDeckAssets.lightGoogleAlt,

    //========================= ACTION & STATUS ICONS ========================//
    addProfileCard: SDeckAssets.lightAddProfileCard,
    circleCheck: SDeckAssets.lightCircleCheck,
    circleX: SDeckAssets.lightCircleX,
    playBox: SDeckAssets.lightPlayBox,

    //======================== MEDIA & INTERACTION ICONS =====================//
    placeholder: SDeckAssets.lightPlaceholder,
    placeholderAlt: SDeckAssets.lightPlaceholderAlt,
    pinchAdjust: SDeckAssets.lightPinchAdjust,

    //========================== SHAPE & VECTOR ICONS ========================//
    ellipse10: SDeckAssets.lightEllipse10,
    ellipse10Alt: SDeckAssets.lightEllipse10Alt,
    vector23: SDeckAssets.lightVector23,
    vector30: SDeckAssets.lightVector30,
    vector33: SDeckAssets.lightVector33,
    vector35: SDeckAssets.lightVector35,
    vector35Alt: SDeckAssets.lightVector35Alt,
  );

  //*************************** Dark Theme Icons *****************************//
  static const dark = SDeckIconThemes(
    //======================== NAVIGATION ICONS (STROKE) ====================//
    home: SDeckAssets.darkHomeStroke,
    profile: SDeckAssets.darkProfileStroke,
    settings: SDeckAssets.darkSettingsStroke,
    deck: SDeckAssets.darkDeckStroke,
    friends: SDeckAssets.darkFriendsStroke,
    store: SDeckAssets.darkStoreStroke,

    //======================== NAVIGATION ICONS (FILL) ======================//
    homeFill: SDeckAssets.darkHomeFill,
    profileFill: SDeckAssets.darkProfileFill,
    settingsFill: SDeckAssets.darkSettingsFill,
    deckFill: SDeckAssets.darkDeckFill,
    friendsFill: SDeckAssets.darkFriendsFill,
    storeFill: SDeckAssets.darkStoreFill,

    //========================== CORE ACTION ICONS ===========================//
    more: SDeckAssets.darkMore,
    help: SDeckAssets.darkHelpStroke,
    leftArrow: SDeckAssets.darkLeftArrowhead,
    rightArrow: SDeckAssets.darkRightArrowhead,
    megaphone: SDeckAssets.darkMegaphone,
    zoomIn: SDeckAssets.darkZoomIn,
    zoomOut: SDeckAssets.darkZoomOut,

    //========================== NEW UTILITY ICONS ===========================//
    clock: SDeckAssets.darkClockStroke,
    playHollow: SDeckAssets.darkPlayHollow,
    socialdeckLogo: SDeckAssets.darkSocialdeckLogo,
    wordmark: SDeckAssets.darkWordmark,

    //============================== BRAND ICONS =============================//
    apple: SDeckAssets.darkApple,
    google: SDeckAssets.darkGoogle,
    googleAlt: SDeckAssets.darkGoogleAlt,

    //========================= ACTION & STATUS ICONS ========================//
    addProfileCard: SDeckAssets.darkAddProfileCard,
    circleCheck: SDeckAssets.darkCircleCheck,
    circleX: SDeckAssets.darkCircleX,
    playBox: SDeckAssets.darkPlayBox,

    //======================== MEDIA & INTERACTION ICONS =====================//
    placeholder: SDeckAssets.darkPlaceholder,
    placeholderAlt: SDeckAssets.darkPlaceholderAlt,
    pinchAdjust: SDeckAssets.darkPinchAdjust,

    //========================== SHAPE & VECTOR ICONS ========================//
    ellipse10: SDeckAssets.darkEllipse10,
    ellipse10Alt: SDeckAssets.darkEllipse10Alt,
    vector23: SDeckAssets.darkVector23,
    vector30: SDeckAssets.darkVector30,
    vector33: SDeckAssets.darkVector33,
    vector35: SDeckAssets.darkVector35,
    vector35Alt: SDeckAssets.darkVector35Alt,
  );

  //*************************** Theme Extension Methods *******************//
  @override
  ThemeExtension<SDeckIconThemes> copyWith() => this;

  @override
  ThemeExtension<SDeckIconThemes> lerp(
    ThemeExtension<SDeckIconThemes>? other,
    double t,
  ) => this;
}

/// Extension to access icons from BuildContext
extension BuildContextIconTheme on BuildContext {
  SDeckIconThemes get icons => Theme.of(this).extension<SDeckIconThemes>()!;
}

/// Extension to provide easy navigation icon switching between stroke and fill
/// Usage: context.icons.homeNav(isSelected), context.icons.friendsNav(isSelected)
extension SDeckNavIconsExtension on SDeckIconThemes {
  //------------------------------- Navigation Icons ----------------------//

  /// Returns home icon - fill if selected, stroke if not
  String homeNav(bool isSelected) => isSelected ? homeFill : home;

  /// Returns friends icon - fill if selected, stroke if not
  String friendsNav(bool isSelected) => isSelected ? friendsFill : friends;

  /// Returns deck icon - fill if selected, stroke if not
  String deckNav(bool isSelected) => isSelected ? deckFill : deck;

  /// Returns store icon - fill if selected, stroke if not
  String storeNav(bool isSelected) => isSelected ? storeFill : store;

  /// Returns profile icon - fill if selected, stroke if not
  String profileNav(bool isSelected) => isSelected ? profileFill : profile;

  /// Returns settings icon - fill if selected, stroke if not
  String settingsNav(bool isSelected) => isSelected ? settingsFill : settings;
}
