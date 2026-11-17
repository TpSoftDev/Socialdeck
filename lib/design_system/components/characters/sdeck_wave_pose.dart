/*-------------------------- sdeck_wave_pose.dart ----------------------------*/
// Wave Pose from the SocialDeck design system (Figma node 8014:340).
// A player card with a profile image, plus the waving arm, hanging arm, and
// two legs. Limb artwork is the Figma SVG export of each instance, placed on
// the pose's painted bounds. The card is drawn in Flutter so the face can
// take a different image per player.
//
// Usage:
//   const SDeckWavePose()
//   SDeckWavePose(image: Image.asset(path, fit: BoxFit.cover))
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../tokens/colors/index.dart';

//------------------------------- Assets -----------------------------------//
class _WavePoseAssets {
  static const String armPose2 = 'assets/characters/wave_pose/arm_pose_2.svg';
  static const String group10 = 'assets/characters/wave_pose/group_10.svg';
  static const String group5 = 'assets/characters/wave_pose/group_5.svg';
  static const String group6 = 'assets/characters/wave_pose/group_6.svg';
}

//------------------------------- SDeckWavePose ----------------------------//
class SDeckWavePose extends StatelessWidget {
  // Painted size of Figma component "Wave Pose", including the stroke that
  // hangs outside the 101.145 x 99.577 frame.
  static const double width = 102.519;
  static const double height = 102.077;

  // Face of playerCard. Null uses the warm off-white empty face.
  // Pass a widget that expands, such as an Image with BoxFit.cover.
  final Widget? image;

  const SDeckWavePose({super.key, this.image});

  //*************************** Build Method ******************************//
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Figma paint order: Group 6, Group 5, Arm Pose 2, Group 10, card.
          _limb(_WavePoseAssets.group6, 46.999, 63.5, 26.592, 38.577),
          _limb(_WavePoseAssets.group5, 18.989, 62.5, 22.592, 39.5),
          _limb(_WavePoseAssets.armPose2, 62.227, 10.403, 40.292, 41.194),
          _limb(_WavePoseAssets.group10, 0, 28.057, 26.489, 52.118),
          Positioned(
            left: 18,
            top: 0,
            width: 53.538,
            height: 72,
            child: _WavePosePlayerCard(image: image),
          ),
        ],
      ),
    );
  }

  Widget _limb(
    String asset,
    double left,
    double top,
    double width,
    double height,
  ) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: SvgPicture.asset(
        asset,
        width: width,
        height: height,
        fit: BoxFit.fill,
      ),
    );
  }
}

//------------------------------- Player card ------------------------------//
class _WavePosePlayerCard extends StatelessWidget {
  final Widget? image;

  const _WavePosePlayerCard({required this.image});

  // Figma "playingCard (Rive)": 53.538 x 72, padding 3.692,
  // outer radius 7.385, inner radius 3.692.
  static const double _padding = 3.692;
  static const double _outerRadius = 7.385;
  static const double _innerRadius = 3.692;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.component.playingCardTrim,
        borderRadius: BorderRadius.circular(_outerRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_innerRadius),
          child:
              image ??
              ColoredBox(
                color: SDeckBrandColors.warmOffWhite(
                  Theme.of(context).brightness,
                ),
              ),
        ),
      ),
    );
  }
}
