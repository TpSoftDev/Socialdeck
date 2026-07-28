/*------------------------- sdeck_deck_target.dart ---------------------------*/
// deckTarget component for the SocialDeck design system.
// Colored deck card with optional favorite star, card count, title, and
// Enabled / Selected / Disabled / Move (Hold) states. Color set matches
// SDeckColorPickerColor so create-deck preview can stay in sync with the picker.
//
// Usage:
//   SDeckDeckTarget(
//     color: SDeckColorPickerColor.brightCoral,
//     shadow: SDeckDeckTargetShadow.medium,
//     state: SDeckDeckTargetState.enabled,
//     deckTitle: 'Your Deck',
//     showFavoriteIcon: false,
//     showCardCount: false,
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';

import '../../helpers/index.dart';
import '../../themes/text_theme.dart';
import '../../tokens/index.dart';
import '../../tokens/effects/index.dart';
import '../color_picker/color_picker_enums.dart';
import '../placeholders/sdeck_visual_placeholder.dart';
import 'deck_target_enums.dart';

//------------------------------- SDeckDeckTarget ----------------------------//
class SDeckDeckTarget extends StatelessWidget {
  //*************************** Properties ******************************//

  final SDeckColorPickerColor color;
  final SDeckDeckTargetShadow shadow;
  final bool favorited;
  final SDeckDeckTargetState state;
  final String deckTitle;
  final String cardCount;
  final bool showFavoriteIcon;
  final bool showCardCount;
  final VoidCallback? onTap;

  //*************************** Constructor ******************************//
  const SDeckDeckTarget({
    super.key,
    this.color = SDeckColorPickerColor.brightCoral,
    this.shadow = SDeckDeckTargetShadow.none,
    this.favorited = false,
    this.state = SDeckDeckTargetState.enabled,
    this.deckTitle = 'Deck Title',
    this.cardCount = '#',
    this.showFavoriteIcon = true,
    this.showCardCount = true,
    this.onTap,
  });

  // Base Figma size. Move (Hold) is exactly 1.5x.
  static const double _baseWidth = 116;
  static const double _baseHeight = 156;

  //*************************** Build Method ******************************//
  @override
  Widget build(BuildContext context) {
    final component = context.component;
    final scale = state == SDeckDeckTargetState.moveHeld ? 1.5 : 1.0;
    final width = _baseWidth * scale;
    final height = _baseHeight * scale;
    final borderWidth = SDeckSize.size4 * scale;
    final radius = SDeckRadius.borderRadius12 * scale;
    final surface = _surfaceFor(component);

    final decoration = BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: _borderColor(component),
        width: borderWidth,
      ),
      // Selected / Move use glow only (same pattern as playing card).
      // Enabled / Disabled use the elevation shadow prop.
      boxShadow: _resolveBoxShadow(context, component),
    );

    Widget card = SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            children: [
              //------------------------ Card Visual ------------------------//
              Positioned(
                left: -2 * scale,
                top: 42 * scale,
                width: 120 * scale,
                height: 120 * scale,
                child: SDeckVisualPlaceholder(
                  width: 120 * scale,
                  height: 120 * scale,
                  borderRadius: BorderRadius.circular(
                    SDeckRadius.borderRadius16 * scale,
                  ),
                ),
              ),

              //------------------------ Top Selections ---------------------//
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 48 * scale,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: SDeckSpace.padding12 * scale,
                    right: SDeckSpace.padding16 * scale,
                    top: SDeckSpace.padding12 * scale,
                    bottom: SDeckSpace.padding12 * scale,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (showFavoriteIcon)
                        _buildStar(component, 24 * scale)
                      else
                        const SizedBox.shrink(),
                      if (showCardCount)
                        Text(
                          cardCount,
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: component.deckTargetText,
                                fontSize: 14 * scale,
                                height: 18 / 14,
                              ),
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),

              //------------------------ Bottom Info ------------------------//
              // Figma: fixed 80px band at y=76. Gradient top→bottom from
              // surface@0% to solid surface at 69.712% (then holds to bottom).
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 80 * scale,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(radius),
                      bottomRight: Radius.circular(radius),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        surface.withValues(alpha: 0),
                        surface,
                      ],
                      stops: const [0.0, 0.69712],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      SDeckSpace.padding12 * scale,
                      0,
                      SDeckSpace.padding12 * scale,
                      SDeckSpace.padding12 * scale,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        deckTitle,
                        style:
                            Theme.of(context).textTheme.bodySmallFigma.copyWith(
                                  color: component.deckTargetText,
                                  fontSize: 16 * scale,
                                  height: 20 / 16,
                                ),
                      ),
                    ),
                  ),
                ),
              ),

              //------------------------ Disabled dim -----------------------//
              if (state == SDeckDeckTargetState.disabled)
                Positioned.fill(
                  child: ColoredBox(color: component.deckTargetDim),
                ),
            ],
          ),
        ),
      ),
    );

    if (onTap == null) return card;

    return GestureDetector(
      onTap: onTap,
      child: card,
    );
  }

  //*************************** Helpers **********************************//
  Widget _buildStar(SDeckComponentColors component, double size) {
    if (favorited) {
      // Figma favorited star is a filled yellow glyph. Stroke asset is outline-only.
      return Icon(
        Icons.star_rounded,
        size: size,
        color: component.deckTargetFavoriteFill,
      );
    }

    return SDeckIcons(
      SDeckIcon.star,
      size: size,
      color: component.deckTargetIcon,
    );
  }

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

  Color _borderColor(SDeckComponentColors component) {
    switch (state) {
      case SDeckDeckTargetState.selected:
        return component.deckTargetBorderSelected;
      case SDeckDeckTargetState.moveHeld:
        return component.deckTargetBorderMove;
      case SDeckDeckTargetState.enabled:
      case SDeckDeckTargetState.disabled:
        return component.deckTargetBorder;
    }
  }

  List<BoxShadow>? _resolveBoxShadow(
    BuildContext context,
    SDeckComponentColors component,
  ) {
    switch (state) {
      case SDeckDeckTargetState.selected:
        return SDeckOuterGlows.outerGlowLowSkyBlue(
          component.deckTargetBorderSelected,
        );
      case SDeckDeckTargetState.moveHeld:
        return SDeckOuterGlows.outerGlowHighVibrantYellow(
          component.deckTargetBorderMove,
        );
      case SDeckDeckTargetState.enabled:
      case SDeckDeckTargetState.disabled:
        return _resolveElevationShadow(context);
    }
  }

  List<BoxShadow>? _resolveElevationShadow(BuildContext context) {
    final shadowColor = context.semantic.shadow;
    switch (shadow) {
      case SDeckDeckTargetShadow.none:
        return null;
      case SDeckDeckTargetShadow.low:
        return SDeckBoxShadows.boxShadowLow(shadowColor);
      case SDeckDeckTargetShadow.medium:
        return SDeckBoxShadows.boxShadow(shadowColor);
      case SDeckDeckTargetShadow.high:
        return SDeckBoxShadows.boxShadowHigh(shadowColor);
    }
  }
}
