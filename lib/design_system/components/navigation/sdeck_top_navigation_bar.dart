/*---------------------- sdeck_top_navigation_bar.dart ----------------------*/
// Top navigation bar component for the SocialDeck design system
// Provides consistent navigation patterns across onboarding and app screens
// Theme-aware component that matches Figma designs
//
// Usage: SDeckTopNavigationBar.backWithLogo() or with custom back logic
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/icons/index.dart';
import '../../themes/text_theme.dart';
import '../buttons/sdeck_solid_button.dart';
import '../buttons/button_enums.dart';
import 'package:flutter_svg/flutter_svg.dart';

//------------------------------- Enums -------------------------------------//
/// Defines the different variants of the top navigation bar
enum SDeckTopNavVariant {
  backWithLogo, // Back arrow + Socialdeck logo (for onboarding)
  logoWithTitle, // Logo + title + action button (for main pages)
  logoWithSkip, // Logo + Skip button (for onboarding flows)
  logoWithoutBack, // Only logo on the right, nothing on the left
  backWithTitle, // Back arrow + title + save button (for main pages)
  backWithTitleAndIcon, // Back arrow + title + simple icon (for settings/options)
  titleOnly, // Title only 
  // TODO: add more variants later: logoWithIndicator, backWithTitle, etc.
  backWithTitleOnly,
  titleWithAvatar, // H4 title + 48px circular avatar (Home/Returning user)
}

class SDeckTopNavigationBar extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  final SDeckTopNavVariant _variant;
  final VoidCallback? onBackPressed;
  final String? title;
  final VoidCallback? onActionPressed;

  /// Avatar widget rendered on the right of [titleWithAvatar]. Painted inside
  /// a 48×48 frame clipped to a 24px radius. Tapped via [onActionPressed].
  final Widget? avatar;

  /// When true, the navigation bar paints a short fade gradient at its bottom
  /// edge so it dissolves softly into the content scrolling below it.
  /// Matches the Figma `topBar` (node 314:2814) gradient.
  final bool showBottomFade;

  //*************************** Named Constructors ***************************//
  //------------------------------- Back with Logo ------------------------//
  const SDeckTopNavigationBar.backWithLogo({super.key, this.onBackPressed})
    : _variant = SDeckTopNavVariant.backWithLogo,
      title = null,
      onActionPressed = null,
      avatar = null,
      showBottomFade = false;

  //------------------------------- Logo with Title -----------------------//
  const SDeckTopNavigationBar.logoWithTitle({
    super.key,
    required this.title,
    this.onActionPressed,
  }) : _variant = SDeckTopNavVariant.logoWithTitle,
       onBackPressed = null,
       avatar = null,
       showBottomFade = false;

  //------------------------------- Logo with Skip ------------------------//
  const SDeckTopNavigationBar.logoWithSkip({super.key, this.onActionPressed})
    : _variant = SDeckTopNavVariant.logoWithSkip,
      title = null,
      onBackPressed = null,
      avatar = null,
      showBottomFade = false;

  //------------------------------- Logo Without Back ---------------------//
  const SDeckTopNavigationBar.logoWithoutBack({super.key})
    : _variant = SDeckTopNavVariant.logoWithoutBack,
      title = null,
      onBackPressed = null,
      onActionPressed = null,
      avatar = null,
      showBottomFade = false;

  //------------------------------- Back with Title -----------------------//
  const SDeckTopNavigationBar.backWithTitle({
    super.key,
    required this.title,
    this.onActionPressed,
    this.onBackPressed,
  }) : _variant = SDeckTopNavVariant.backWithTitle,
       avatar = null,
       showBottomFade = false;

  //------------------------------- Back with Title and Icon --------------//
  const SDeckTopNavigationBar.backWithTitleAndIcon({
    super.key,
    required this.title,
    this.onActionPressed,
    this.onBackPressed,
  }) : _variant = SDeckTopNavVariant.backWithTitleAndIcon,
       avatar = null,
       showBottomFade = false;

  //------------------------------- Title Only ------------------------------//
  const SDeckTopNavigationBar.titleOnly({
    super.key,
    required this.title,
  }) : _variant = SDeckTopNavVariant.titleOnly,
       onBackPressed = null,
       onActionPressed = null,
       avatar = null,
       showBottomFade = false;

  //--------------------------- Back with Title Only (no action) -------------//
  const SDeckTopNavigationBar.backWithTitleOnly({
    super.key,
    required this.title,
    this.onBackPressed,
  }) : _variant = SDeckTopNavVariant.backWithTitleOnly,
      onActionPressed = null,
      avatar = null,
      showBottomFade = false;

  //------------------------------- Title with Avatar ---------------------//
  /// Home/returning-user header: H4 title on the left, 48×48 circular avatar
  /// on the right. The avatar reacts to [onActionPressed]. Optionally paints
  /// a short fade gradient at its bottom edge (matches Figma node 314:2814).
  const SDeckTopNavigationBar.titleWithAvatar({
    super.key,
    required this.title,
    this.avatar,
    this.onActionPressed,
    this.showBottomFade = true,
  }) : _variant = SDeckTopNavVariant.titleWithAvatar,
       onBackPressed = null;

  //*************************** Build Method ********************************//

  @override
  Widget build(BuildContext context) {
    // Figma page header frame: L/T/R padding16, bottom padding12; 4px bottom
    // border (inside); fill width; navigationSurface background.
    const padding = EdgeInsets.fromLTRB(
      SDeckSpace.padding16,
      SDeckSpace.padding16,
      SDeckSpace.padding16,
      SDeckSpace.padding12,
    );

    final Color surface = context.component.navigationSurface;

    // Use a vertical fade-in gradient (transparent at the bottom edge,
    // opaque at the top) when [showBottomFade] is true; otherwise paint a
    // flat surface. Figma `topBar` (314:2814) reaches solid by ~12% height.
    final BoxDecoration decoration = showBottomFade
        ? BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const <double>[0.0, 0.12, 1.0],
              colors: <Color>[
                surface.withValues(alpha: 0),
                surface,
                surface,
              ],
            ),
          )
        : BoxDecoration(color: surface);

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildLeftSection(context), _buildRightSection(context)],
      ),
    );
  }

  //*************************** Helper Methods ********************************//

  //------------------------------- Left Section ---------------------------//
  /// Builds the left section of the navigation bar based on variant
  Widget _buildLeftSection(BuildContext context) {
    switch (_variant) {
      case SDeckTopNavVariant.backWithLogo:
        return _buildBackButton(context);
      case SDeckTopNavVariant.logoWithTitle:
        return _buildLogoWithTitle(context);
      case SDeckTopNavVariant.logoWithSkip:
        return _buildLogo(context);
      case SDeckTopNavVariant.logoWithoutBack:
        return const SizedBox(width: 48); // Empty space for alignment
      case SDeckTopNavVariant.backWithTitle:
        return _buildBackWithTitle(context);
      case SDeckTopNavVariant.backWithTitleAndIcon:
        return _buildBackWithTitle(context);
      case SDeckTopNavVariant.titleOnly:
        return _buildTitle(context);
      case SDeckTopNavVariant.backWithTitleOnly:
        return _buildBackWithTitleOnly(context);
      case SDeckTopNavVariant.titleWithAvatar:
        return _buildTitleH4(context);
    }
  }

  //------------------------------- Right Section --------------------------//
  /// Builds the right section of the navigation bar based on variant
  Widget _buildRightSection(BuildContext context) {
    switch (_variant) {
      case SDeckTopNavVariant.backWithLogo:
        return _buildLogo(context);
      case SDeckTopNavVariant.logoWithTitle:
        return _buildActionButton(context);
      case SDeckTopNavVariant.logoWithSkip:
        return _buildSkipButton(context);
      case SDeckTopNavVariant.logoWithoutBack:
        return _buildLogo(context);
      case SDeckTopNavVariant.backWithTitle:
        return _buildSaveButton(context);
      case SDeckTopNavVariant.backWithTitleAndIcon:
        return _buildActionButton(context);
      case SDeckTopNavVariant.titleOnly:
        return const SizedBox(width: 48);
      case SDeckTopNavVariant.backWithTitleOnly:
        return const SizedBox(width: 48); // No right widget; keep layout balanced
      case SDeckTopNavVariant.titleWithAvatar:
        return _buildAvatarTrailing(context);
    }
  }

  //------------------------------- Title Only --------------------------------//
  /// Title only, no back or right widget 
  Widget _buildTitle(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title!,
          style: Theme.of(context).textTheme.h5.copyWith(
            color: context.component.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  //------------------------------- Back with Title --------------------------//
  /// Builds the back button with title layout (matching Figma design)
  Widget _buildBackWithTitle(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          _buildBackButton(context),
          const SizedBox(width: SDeckSpace.gap4), // 4px gap to match Figma
          // Flexible title that takes available space but doesn't overflow
          Flexible(
            child: Text(
              title!,
              style: Theme.of(
                context,
              ).textTheme.h5.copyWith(color: context.component.textPrimary),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
  //----------------------------- Back with Title Only -----------------------//
  Widget _buildBackWithTitleOnly(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: SDeckSize.size48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildFigmaTopBarBackChevron(context),
            const SizedBox(width: SDeckSpace.gap12),
            Flexible(
              child: Text(
                title!,
                style: Theme.of(context).textTheme.h4.copyWith(
                  color: context.component.navigationText,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Figma `Chevron Left`: **20×48** frame, 48×48 min tap (horizontal overspill).
  Widget _buildFigmaTopBarBackChevron(BuildContext context) {
    const chevronFrameWidth = 20.0;
    const tapSize = 48.0;
    final overshoot = (tapSize - chevronFrameWidth) / 2;
    return SizedBox(
      width: chevronFrameWidth,
      height: tapSize,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            left: -overshoot,
            child: Semantics(
              button: true,
              label: 'Back',
              child: Material(
                type: MaterialType.transparency,
                color: Colors.transparent,
                child: InkWell(
                  onTap: onBackPressed ?? () => Navigator.maybePop(context),
                  borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: const WidgetStatePropertyAll<Color?>(
                    Colors.transparent,
                  ),
                  child: SizedBox(
                    width: tapSize,
                    height: tapSize,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: overshoot),
                        child: SvgPicture.asset(
                          SDeckIcon.leftChevron,
                          width: chevronFrameWidth,
                          height: tapSize,
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft,
                          colorFilter: ColorFilter.mode(
                            context.component.navigationIcon,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //------------------------------- Back Button ----------------------------//
  /// 48×48 tap target; transparent [Material] so [InkWell] does not show a theme surface tint.
  Widget _buildBackButton(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      color: Colors.transparent,
      child: InkWell(
        onTap: onBackPressed ?? () => Navigator.maybePop(context),
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
        splashFactory: NoSplash.splashFactory,
        overlayColor: const WidgetStatePropertyAll<Color?>(Colors.transparent),
        child: SizedBox(
          width: SDeckSize.size48,
          height: SDeckSize.size48,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SDeckIcons(
              SDeckIcon.leftChevron,
              size: SDeckSize.size48,
              color: context.component.navigationIcon,
              semanticsLabel: 'Back',
            ),
          ),
        ),
      ),
    );
  }

  //------------------------------- Logo -----------------------------------//
  /// Builds the Socialdeck logo
  Widget _buildLogo(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      child: SDeckIcons(
        SDeckIcon.socialdeckLogo,
        size: SDeckSize.size48,
        color: context.component.navigationIcon,
      ),
    );
  }

  //------------------------------- Logo with Title --------------------------//
  /// Builds the logo with title layout
  Widget _buildLogoWithTitle(BuildContext context) {
    return Row(
      children: [
        SDeckIcons(
          SDeckIcon.socialdeckLogo,
          size: SDeckSize.size48,
          color: context.component.navigationIcon,
        ),
        const SizedBox(width: SDeckSpace.gap8), // Using design system token
        Text(
          title!,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: context.component.navigationText,
          ),
        ),
      ],
    );
  }

  //------------------------------- Action Button ----------------------------//
  /// Builds the action button (typically Settings icon)
  Widget _buildActionButton(BuildContext context) {
    return InkWell(
      onTap: onActionPressed,
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: SDeckIcons(
          SDeckIcon.leave,
          size: SDeckSize.size48,
          color: context.component.navigationIcon,
        ),
      ),
    );
  }

  //------------------------------- Save Button ------------------------------//
  /// Builds the save button for Add Cards page
  Widget _buildSaveButton(BuildContext context) {
    return SDeckSolidButton(
      text: "Save",
      size: SDeckButtonSize.medium,
      shape: SDeckButtonShape.round,
      onPressed: onActionPressed,
      enabled: onActionPressed != null,
    );
  }

  //------------------------------- Title (H4) ----------------------------//
  /// Builds an H4 title pinned to a 48px-tall row so its baseline aligns with
  /// the trailing avatar. Used by [SDeckTopNavVariant.titleWithAvatar].
  Widget _buildTitleH4(BuildContext context) {
    return SizedBox(
      height: SDeckSize.size48,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title!,
            style: Theme.of(context).textTheme.h4.copyWith(
              color: context.component.navigationText,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  //------------------------------- Trailing Avatar -----------------------//
  /// Builds a 48×48 circular-ish avatar (24px radius) on the right side of
  /// the navigation bar. Tapping triggers [onActionPressed]. When no [avatar]
  /// is supplied a placeholder circle with the surfaceVariant fill is used.
  Widget _buildAvatarTrailing(BuildContext context) {
    final BorderRadius avatarRadius = BorderRadius.circular(
      SDeckRadius.borderRadius24,
    );
    final Widget avatarChild = avatar ??
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.semantic.surfaceVariant,
            borderRadius: avatarRadius,
          ),
        );

    return Semantics(
      button: onActionPressed != null,
      label: 'Profile',
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: InkWell(
          onTap: onActionPressed,
          borderRadius: avatarRadius,
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll<Color?>(Colors.transparent),
          child: SizedBox(
            width: SDeckSize.size48,
            height: SDeckSize.size48,
            child: ClipRRect(
              borderRadius: avatarRadius,
              child: avatarChild,
            ),
          ),
        ),
      ),
    );
  }

  //------------------------------- Skip Button ----------------------------//
  /// Builds the skip button with right arrow (matching Figma design)
  Widget _buildSkipButton(BuildContext context) {
    return InkWell(
      onTap: onActionPressed,
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(
          horizontal: SDeckSpace.padding12,
        ), // Using design system token
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Skip',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: context.component.textPrimary,
              ),
            ),
            const SizedBox(
              width: SDeckSpace.gap4,
            ), // Using design system token
            SDeckIcons(
              SDeckIcon.rightChevron,
              size: SDeckSize.size16,
              color: context.component.navigationIcon,
            ),
          ],
        ),
      ),
    );
  }

}