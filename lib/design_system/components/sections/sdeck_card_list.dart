/*--------------------------- sdeck_card_list.dart ---------------------------*/
// cardList is the dark shelf under the Camera Roll album tabs.
// Empty, it reads "No photos selected." With photos, it shows the count and
// a horizontal row of extra-small playing cards in the remove state.
// The extra-small card is 117px. 89px stay visible and 28px are clipped by
// the shelf edge, so more of the photo shows than Figma's 128px tray allows.
//
// Usage:
//   SDeckCardList(
//     items: [
//       SDeckCardListItem(imagePath: path, onRemove: () {}),
//     ],
//   )
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'package:flutter/material.dart';

import '../../helpers/index.dart';
import '../../themes/text_theme.dart';
import '../../tokens/index.dart';
import '../cards/playing_card_enums.dart';
import '../cards/sdeck_playing_card.dart';

//------------------------------- SDeckCardListItem -------------------------//
class SDeckCardListItem {
  /// File, asset, or network path consumed by SDeckPlayingCard.
  final String? imagePath;

  /// Called when the delete badge on that card is tapped.
  final VoidCallback? onRemove;

  const SDeckCardListItem({this.imagePath, this.onRemove});
}

//------------------------------- SDeckCardList -----------------------------//
class SDeckCardList extends StatelessWidget {
  // 117px card. 28px stay under the shelf edge. The tray grows past
  // Figma's 128px so the photo is easier to see.
  static const double _cardHeight = 117;
  static const double _visibleCardHeight = 89;

  //------------------------------- Properties --------------------------------//

  final List<SDeckCardListItem> items;

  //------------------------------- Constructor -------------------------------//
  const SDeckCardList({super.key, this.items = const []});

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.caption.copyWith(
      color: SDeckBaseColors.coolGray[100],
    );

    return Container(
      height: items.isEmpty ? 128 : null,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.fromLTRB(
        SDeckSpace.padding16,
        SDeckSpace.padding16,
        SDeckSpace.padding16,
        items.isEmpty ? SDeckSpace.padding16 : 0,
      ),
      decoration: BoxDecoration(
        color: SDeckBaseColors.slateGray[800],
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        border: Border.all(
          color: context.semantic.outlineVariant,
          width: SDeckSize.size4,
        ),
      ),
      child: items.isEmpty
          ? Center(
              child: Text(
                'No photos selected.',
                style: labelStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${items.length} Selected',
                  style: labelStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: SDeckSpace.gap12),
                _SelectedCardRow(items: items),
              ],
            ),
    );
  }
}

//------------------------------- Selected Row ------------------------------//
// Scrolls to the newest card when one is added, so it is on screen immediately.
class _SelectedCardRow extends StatefulWidget {
  final List<SDeckCardListItem> items;

  const _SelectedCardRow({required this.items});

  @override
  State<_SelectedCardRow> createState() => _SelectedCardRowState();
}

class _SelectedCardRowState extends State<_SelectedCardRow> {
  final ScrollController _controller = ScrollController();
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _previousCount = widget.items.length;
  }

  @override
  void didUpdateWidget(covariant _SelectedCardRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    final added = widget.items.length > _previousCount;
    _previousCount = widget.items.length;
    if (!added) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controller.hasClients) return;
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: SDeckMotionDuration.quick,
        curve: SDeckMotionCurve.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SDeckCardList._visibleCardHeight,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.hardEdge,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < widget.items.length; index++) ...[
              if (index > 0) const SizedBox(width: SDeckSpace.gap8),
              _ShelfCard(item: widget.items[index]),
            ],
          ],
        ),
      ),
    );
  }
}

//------------------------------- Shelf Card --------------------------------//
// Slides up from under the shelf into its slot once, when it is first added.
// Later updates, such as the photo path arriving, do not replay the slide.
class _ShelfCard extends StatefulWidget {
  static const double _cardWidth = 87;

  final SDeckCardListItem item;

  const _ShelfCard({required this.item});

  @override
  State<_ShelfCard> createState() => _ShelfCardState();
}

class _ShelfCardState extends State<_ShelfCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: SDeckMotionDuration.normal,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: SDeckMotionCurve.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _ShelfCard._cardWidth,
      height: SDeckCardList._visibleCardHeight,
      child: OverflowBox(
        alignment: Alignment.topCenter,
        minWidth: _ShelfCard._cardWidth,
        maxWidth: _ShelfCard._cardWidth,
        minHeight: SDeckCardList._cardHeight,
        maxHeight: SDeckCardList._cardHeight,
        child: SlideTransition(
          position: _slide,
          child: SDeckPlayingCard(
            size: SDeckPlayingCardSize.extraSmall,
            shadow: SDeckPlayingCardShadow.none,
            state: SDeckPlayingCardState.remove,
            imagePath: widget.item.imagePath,
            onRemove: widget.item.onRemove,
          ),
        ),
      ),
    );
  }
}
