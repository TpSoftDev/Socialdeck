/*------------------------ sdeck_game_ad_popup.dart ------------------------*/
// Figma gameAdPopup. An enlarged timer is centered above a square visual.
//
// The timer is primary: #1F1F1F in light, #F5F5F5 in dark.
// The square is 1:1 with a 16px radius. With no image, it is the visual
// placeholder.
//
// Usage:
//   SDeckGameAdPopup(timerValue: '20')
//   SDeckGameAdPopup(timerValue: '20', imagePath: 'assets/ads/game.png')
/*--------------------------------------------------------------------------*/

import 'dart:io';

import 'package:flutter/material.dart';

import '../placeholders/sdeck_visual_placeholder.dart';
import '../status/sdeck_timer.dart';
import '../../tokens/index.dart';

//======================== SDeckGameAdPopup ==================================//
class SDeckGameAdPopup extends StatelessWidget {
  final String timerValue;
  final String? imagePath;

  const SDeckGameAdPopup({super.key, this.timerValue = '20', this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.center,
          child: SDeckTimer(value: timerValue, type: SDeckTimerType.enlarged),
        ),
        const SizedBox(height: SDeckSpace.gap8),
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
            child:
                imagePath == null
                    ? const SDeckVisualPlaceholder(
                      borderRadius: BorderRadius.zero,
                    )
                    : _AdImage(imagePath: imagePath!),
          ),
        ),
      ],
    );
  }
}

class _AdImage extends StatelessWidget {
  final String imagePath;

  const _AdImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final bool isNetwork =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');
    final bool isAsset = imagePath.startsWith('assets/');
    if (isNetwork) {
      return Image.network(imagePath, fit: BoxFit.cover);
    }
    if (isAsset) {
      return Image.asset(imagePath, fit: BoxFit.cover);
    }
    return Image.file(File(imagePath), fit: BoxFit.cover);
  }
}
