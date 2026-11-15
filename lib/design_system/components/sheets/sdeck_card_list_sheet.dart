/*------------------------ sdeck_card_list_sheet.dart -----------------------*/
// Figma cardListSheet. A timer sits above a horizontal strip of medium
// playing cards. The strip is wider than the sheet and clipped.
// [scrollFraction] 0 pins the first card, 0.5 centers the strip, and
// 1 pins the last card. [SDeckCardListEntry.state] draws the selected
// border on one card.
//
// The default timer is primary: #1F1F1F in light, #F5F5F5 in dark.
// The alert timer is error: #FE6F61 in light, #FF8A80 in dark.
// Card trim is #EBEBEB in light and #F5F5F5 in dark.
// The 4px card shadow stays #1F1F1F at 20% in both modes.
//
// Usage:
//   SDeckCardListSheet(timerValue: '20')
//   SDeckCardListSheet(
//     cards: [
//       SDeckCardListEntry(imagePath: path, rotationDegrees: -1.37),
//     ],
//   )
/*--------------------------------------------------------------------------*/

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../cards/playing_card_enums.dart';
import '../cards/sdeck_playing_card.dart';
import '../status/sdeck_timer.dart';
import '../../tokens/index.dart';

//======================== SDeckCardListEntry ================================//
class SDeckCardListEntry {
  final String? imagePath;
  final double rotationDegrees;
  final double scale;
  final double panX;
  final double panY;
  final SDeckPlayingCardState state;
  final VoidCallback? onTap;

  const SDeckCardListEntry({
    this.imagePath,
    this.rotationDegrees = 0,
    this.scale = 1,
    this.panX = 0,
    this.panY = 0,
    this.state = SDeckPlayingCardState.default_,
    this.onTap,
  });
}

//======================== SDeckCardListSheet ================================//
class SDeckCardListSheet extends StatefulWidget {
  final String timerValue;
  final SDeckTimerType timerType;
  final bool showTimer;
  final List<SDeckCardListEntry> cards;

  /// 0 shows the start of the strip, 0.5 centers it, 1 shows the end.
  final double scrollFraction;

  /// Tilts from the Figma strip, in source order.
  static const List<SDeckCardListEntry> designCards = [
    SDeckCardListEntry(rotationDegrees: -1.37),
    SDeckCardListEntry(rotationDegrees: 0.84),
    SDeckCardListEntry(rotationDegrees: -1.92),
    SDeckCardListEntry(rotationDegrees: 1.56),
    SDeckCardListEntry(rotationDegrees: 0.07),
    SDeckCardListEntry(rotationDegrees: -1.14),
    SDeckCardListEntry(rotationDegrees: 1.98),
  ];

  const SDeckCardListSheet({
    super.key,
    this.timerValue = '20',
    this.timerType = SDeckTimerType.default_,
    this.showTimer = true,
    this.cards = designCards,
    this.scrollFraction = 0.5,
  });

  @override
  State<SDeckCardListSheet> createState() => _SDeckCardListSheetState();
}

class _SDeckCardListSheetState extends State<SDeckCardListSheet> {
  // Medium card is 234 tall. The steepest tilt in the design (1.98°)
  // grows the row to 240.
  static const double _stripHeight = 240;

  final ScrollController _controller = ScrollController();
  double? _appliedFraction;

  @override
  void initState() {
    super.initState();
    _scheduleScroll(animate: false);
  }

  @override
  void didUpdateWidget(SDeckCardListSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool lengthChanged = oldWidget.cards.length != widget.cards.length;
    final bool fractionChanged =
        oldWidget.scrollFraction != widget.scrollFraction;
    if (lengthChanged || fractionChanged) {
      _scheduleScroll(animate: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scheduleScroll({required bool animate}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _applyScroll(animate: animate);
    });
  }

  void _applyScroll({required bool animate}) {
    if (!_controller.hasClients) return;
    final double max = _controller.position.maxScrollExtent;
    if (max <= 0) return;
    final double fraction = widget.scrollFraction.clamp(0, 1);
    final double target = max * fraction;
    if (!animate || _appliedFraction == null) {
      _controller.jumpTo(target);
    } else if (_appliedFraction != fraction) {
      _controller.animateTo(
        target,
        duration: SDeckMotionDuration.normal,
        curve: SDeckMotionCurve.easeIn,
      );
    }
    _appliedFraction = fraction;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Padding(
        padding: const EdgeInsets.only(
          top: SDeckSpace.margin24,
          bottom: SDeckSpace.margin48,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.showTimer) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SDeckSpace.margin16,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SDeckTimer(
                    value: widget.timerValue,
                    type: widget.timerType,
                  ),
                ),
              ),
              const SizedBox(height: SDeckSpace.gap4),
            ],
            SizedBox(
              height: _stripHeight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                        minHeight: _stripHeight,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _cardChildren(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _cardChildren() {
    final List<Widget> children = [];
    for (var i = 0; i < widget.cards.length; i++) {
      if (i > 0) children.add(const SizedBox(width: SDeckSpace.gap12));
      final SDeckCardListEntry entry = widget.cards[i];
      children.add(
        Transform.rotate(
          angle: entry.rotationDegrees * math.pi / 180,
          child: SDeckPlayingCard(
            size: SDeckPlayingCardSize.medium,
            shadow: SDeckPlayingCardShadow.medium,
            state: entry.state,
            imagePath: entry.imagePath,
            scale: entry.scale,
            panX: entry.panX,
            panY: entry.panY,
            onTap: entry.onTap,
          ),
        ),
      );
    }
    return children;
  }
}
