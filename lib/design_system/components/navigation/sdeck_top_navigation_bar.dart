/*---------------------- sdeck_top_navigation_bar.dart ----------------------*/
// Top navigation bar component for the SocialDeck design system.
// Single constructor mirrors Figma topBar playground properties exactly.
// Theme-aware, tokens-based, covers all screen patterns in the app.
//
// Usage: SDeckTopNavigationBar(left: SDeckTopBarLeft.back, title: 'Inbox')
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../themes/text_theme.dart';
import '../buttons/sdeck_solid_button.dart';
import '../buttons/button_enums.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'top_bar_enums.dart';
import '../avatar/sdeck_profile_card_placeholder.dart';

class SDeckTopNavigationBar extends StatelessWidget {
  //------------------------------- Properties -----------------------------//

  final SDeckTopBarType type;
  final SDeckTopBarLeft left;
  final SDeckTopBarRight right;
  final String? title;
  final bool showTitle;
  final bool showRightIcon;
  final Widget? rightIcon;
  final String? rightButtonLabel;
  final Widget? profileWidget;

  final VoidCallback? onLeftPressed;
  final VoidCallback? onRightPressed;

  //------------------------------- Constructor ----------------------------//
  const SDeckTopNavigationBar({
    super.key,
    this.type = SDeckTopBarType.page,
    this.left = SDeckTopBarLeft.back,
    this.right = SDeckTopBarRight.none,
    this.title,
    this.showTitle = true,
    this.showRightIcon = true,
    this.rightIcon,
    this.rightButtonLabel,
    this.profileWidget,
    this.onLeftPressed,
    this.onRightPressed,
  });

  //------------------------------- Build ---------------------------------//
  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.fromLTRB(
      SDeckSpace.padding16,
      SDeckSpace.padding16,
      SDeckSpace.padding16,
      SDeckSpace.padding12,
    );
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: const [0.0, 0.12, 1.0],
          colors: [
            context.component.navigationSurface.withValues(alpha: 0),
            context.component.navigationSurface,
            context.component.navigationSurface,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildLeftSection(context), _buildRightSection(context)],
      ),
    );
  }

  //------------------------------- Left Section ---------------------------//
  Widget _buildLeftSection(BuildContext context) {
    final bool hasTitle = showTitle && title != null;

    switch (left) {
      case SDeckTopBarLeft.back:
        if (hasTitle) {
          return Expanded(
            child: SizedBox(
              height: SDeckSize.size48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildChevron(context),
                  const SizedBox(width: SDeckSpace.gap12),
                  Flexible(child: _buildTitleText(context)),
                ],
              ),
            ),
          );
        }
        return _buildChevron(context);

      case SDeckTopBarLeft.logo:
        if (hasTitle) {
          return Row(
            children: [
              _buildLogoWidget(context),
              const SizedBox(width: SDeckSpace.gap8),
              _buildTitleText(context),
            ],
          );
        }
        return _buildLogoWidget(context);

      case SDeckTopBarLeft.none:
        if (hasTitle) {
          return Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildTitleText(context),
            ),
          );
        }
        return const SizedBox.shrink();
    }
  }

  //------------------------------- Right Section --------------------------//
  Widget _buildRightSection(BuildContext context) {
    switch (right) {
      case SDeckTopBarRight.icon:
        if (!showRightIcon) return const SizedBox.shrink();
        return _buildIconSlot(context);
      case SDeckTopBarRight.profile:
        return _buildProfileSlot(context);
      case SDeckTopBarRight.button:
        return _buildButtonSlot(context);
      case SDeckTopBarRight.skip:
        return _buildSkipSlot(context);
      case SDeckTopBarRight.logo:
        return _buildLogoWidget(context);
      case SDeckTopBarRight.none:
        return const SizedBox.shrink();
    }
  }

  //------------------------------- Title Text -----------------------------//
  /// page → H4 + navigationText, subpage → H5 + navigationText
  Widget _buildTitleText(BuildContext context) {
    final style =
        type == SDeckTopBarType.page
            ? Theme.of(context).textTheme.h4
            : Theme.of(context).textTheme.h5;
    return Text(
      title!,
      style: style.copyWith(color: context.component.navigationText),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  //------------------------------- Chevron --------------------------------//
  /// Figma spec: 20×48 visible frame, 48×48 tap target via horizontal overspill
  Widget _buildChevron(BuildContext context) {
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
                  onTap: onLeftPressed ?? () => Navigator.maybePop(context),
                  borderRadius: BorderRadius.circular(
                    SDeckRadius.borderRadius8,
                  ),
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

  //------------------------------- Logo -----------------------------------//
  Widget _buildLogoWidget(BuildContext context) {
    return Container(
      width: SDeckSize.size48,
      height: SDeckSize.size48,
      alignment: Alignment.center,
      child: SDeckIcons(
        SDeckIcon.socialdeckLogo,
        size: SDeckSize.size48,
        color: context.component.navigationIcon,
      ),
    );
  }

  //------------------------------- Right: Icon slot -----------------------//
  /// Figma spec: 36×36
  Widget _buildIconSlot(BuildContext context) {
    return InkWell(
      onTap: onRightPressed,
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
      child: SizedBox(
        width: SDeckSize.size36,
        height: SDeckSize.size36,
        child:
            rightIcon ??
            SDeckIcons(
              SDeckIcon.leave,
              size: SDeckSize.size36,
              color: context.component.navigationIcon,
            ),
      ),
    );
  }

  //------------------------------- Right: Profile slot --------------------//
  /// Figma `Right Component=Profile`: 48×48, borderRadius24.
  Widget _buildProfileSlot(BuildContext context) {
    return GestureDetector(
      onTap: onRightPressed,
      child: SizedBox(
        width: SDeckSize.size48,
        height: SDeckSize.size48,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius24),
          child: profileWidget ?? const SDeckProfileCardPlaceholder(),
        ),
      ),
    );
  }

  //------------------------------- Right: Button slot ---------------------//
  Widget _buildButtonSlot(BuildContext context) {
    return SDeckSolidButton(
      text: rightButtonLabel ?? 'Button',
      size: SDeckButtonSize.medium,
      shape: SDeckButtonShape.round,
      onPressed: onRightPressed,
      enabled: onRightPressed != null,
    );
  }

  //------------------------------- Right: Skip slot -----------------------//
  Widget _buildSkipSlot(BuildContext context) {
    return InkWell(
      onTap: onRightPressed,
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding12),
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
            const SizedBox(width: SDeckSpace.gap4),
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
