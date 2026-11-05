/*------------------------ sdeck_card_list_sheet.dart -----------------------*/
// Figma cardListSheet. A timer sits above a horizontal strip of medium
// playing cards. The strip is wider than the sheet, centered, and clipped,
// and it can be scrolled.
//
// The timer is primary: #1F1F1F in light, #F5F5F5 in dark.
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
  final VoidCallback? onTap;

  const SDeckCardListEntry({
    this.imagePath,
    this.rotationDegrees = 0,
    this.scale = 1,
    this.panX = 0,
    this.panY = 0,
    this.onTap,
  });
}

//======================== SDeckCardListSheet ================================//
class SDeckCardListSheet extends StatefulWidget {
  final String timerValue;
  final bool showTimer;
  final List<SDeckCardListEntry> cards;

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
    this.showTimer = true,
    this.cards = designCards,
  });

  @override
  State<SDeckCardListSheet> createState() => _SDeckCardListSheetState();
}

class _SDeckCardListSheetState extends State<SDeckCardListSheet> {
  // Medium card is 234 tall. The steepest tilt in the design (1.98°)
  // grows the row to 240.
  static const double _stripHeight = 240;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerStrip());
  }

  @override
  void didUpdateWidget(SDeckCardListSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cards.length != widget.cards.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _centerStrip());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _centerStrip() {
    if (!_controller.hasClients) return;
    final double max = _controller.position.maxScrollExtent;
    if (max <= 0) return;
    _controller.jumpTo(max / 2);
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
                    type: SDeckTimerType.default_,
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
