/*-------------------------- sdeck_move_grid.dart ----------------------------*/
// Press-and-hold reorder for a three-column wrap.
// move_deck and move_card both call this. The page draws each cell,
// including the held look.
//
// Usage:
//   SDeckMoveGrid<SavedDeck>(
//     items: decks,
//     leading: SDeckAddTarget(onTap: onAdd),
//     itemBuilder: (deck) => SDeckDeckTarget(...),
//     heldItemBuilder: (deck) => SDeckDeckTarget(..., state: moveHeld),
//     onItemTap: openDeck,
//     onReorder: saveOrder,
//   )
/*--------------------------------------------------------------------------*/

//-------------------------------- Imports --------------------------------//
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//----------------------------- SDeckMoveGrid -------------------------------//
class SDeckMoveGrid<T> extends StatefulWidget {
  const SDeckMoveGrid({
    super.key,
    required this.items,
    required this.leading,
    required this.itemBuilder,
    required this.heldItemBuilder,
    required this.onReorder,
    this.onItemTap,
    this.tiltDegrees,
    this.heldWidth = 116 * 1.5,
    this.heldHeight = 156 * 1.5,
  });

  // Stable objects. The slide tracks each item by identity.
  final List<T> items;

  // Stays in the first slot. It is not part of the reorder.
  final Widget leading;

  final Widget Function(T item) itemBuilder;
  final Widget Function(T item) heldItemBuilder;
  final ValueChanged<List<T>> onReorder;
  final ValueChanged<T>? onItemTap;

  // Resting tilt in degrees. The lifted item stays straight.
  final double Function(T item)? tiltDegrees;

  // Size of the lifted item. Deck and the small playing card both grow to
  // 1.5 times 116 by 156 while held.
  final double heldWidth;
  final double heldHeight;

  @override
  State<SDeckMoveGrid<T>> createState() => _SDeckMoveGridState<T>();
}

class _SDeckMoveGridState<T> extends State<SDeckMoveGrid<T>> {
  //*************************** Move ******************************************//
  final GlobalKey _gridKey = GlobalKey();
  int? _dragFrom;
  int? _dragHover;
  Offset? _dragLocal;
  double _cellWidth = 116;
  double _cellHeight = 156;

  bool get _isDragging => _dragFrom != null;

  T? get _draggedItem {
    final from = _dragFrom;
    if (from == null || from < 0 || from >= widget.items.length) return null;
    return widget.items[from];
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    const columns = 3;
    const gap = SDeckSpace.gap12;
    const aspect = 116 / 156;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        final cellHeight = cellWidth / aspect;
        _cellWidth = cellWidth;
        _cellHeight = cellHeight;

        final visual = _visualItems();
        final slotCount = 1 + visual.length;
        final rows = (slotCount / columns).ceil();
        final height = rows * cellHeight + (rows - 1) * gap;

        Widget fitted(Widget child) {
          return FittedBox(fit: BoxFit.fill, child: child);
        }

        return GestureDetector(
          onTapUp: (details) => _onGridTap(details.globalPosition),
          onLongPressStart: (details) => _startDrag(details.globalPosition),
          onLongPressMoveUpdate: (details) => _moveDrag(details.globalPosition),
          onLongPressEnd: (_) => _endDrag(),
          onLongPressCancel: _endDrag,
          child: SizedBox(
            key: _gridKey,
            height: height,
            width: constraints.maxWidth,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _cellAt(
                  0,
                  cellWidth,
                  cellHeight,
                  gap,
                  IgnorePointer(
                    ignoring: _isDragging,
                    child: fitted(widget.leading),
                  ),
                ),
                for (var i = 0; i < visual.length; i++)
                  _cellAt(
                    i + 1,
                    cellWidth,
                    cellHeight,
                    gap,
                    identical(visual[i], _draggedItem)
                        ? const SizedBox.expand()
                        : _restingItem(visual[i]),
                    key: ObjectKey(visual[i]),
                  ),
                if (_draggedItem != null && _dragLocal != null)
                  Positioned(
                    left: _dragLocal!.dx - widget.heldWidth / 2,
                    top: _dragLocal!.dy - widget.heldHeight / 2,
                    child: IgnorePointer(
                      child: widget.heldItemBuilder(_draggedItem as T),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _restingItem(T item) {
    final child = FittedBox(
      fit: BoxFit.fill,
      child: widget.itemBuilder(item),
    );
    final tilt = widget.tiltDegrees?.call(item) ?? 0;
    if (tilt == 0) return child;
    return Transform.rotate(
      angle: tilt * math.pi / 180,
      child: child,
    );
  }

  Widget _cellAt(
    int slot,
    double cellWidth,
    double cellHeight,
    double gap,
    Widget child, {
    Key? key,
  }) {
    const columns = 3;
    final col = slot % columns;
    final row = slot ~/ columns;
    final held = _isDragging && key != null && key == ObjectKey(_draggedItem);

    return AnimatedPositioned(
      key: key,
      duration: held ? Duration.zero : SDeckMotionDuration.quick,
      curve: SDeckMotionCurve.easeOut,
      left: col * (cellWidth + gap),
      top: row * (cellHeight + gap),
      width: cellWidth,
      height: cellHeight,
      child: child,
    );
  }

  // Order while an item is held. The caller's list changes only on drop.
  List<T> _visualItems() {
    final list = List<T>.of(widget.items);
    final from = _dragFrom;
    final hover = _dragHover;
    if (from == null || hover == null || from == hover) return list;
    final item = list.removeAt(from);
    list.insert(hover.clamp(0, list.length), item);
    return list;
  }

  Offset? _localInGrid(Offset global) {
    final box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.globalToLocal(global);
  }

  // Slot 0 is the leading widget. Item slots start at 1.
  int? _itemIndexAt(Offset local) {
    const gap = SDeckSpace.gap12;
    final strideX = _cellWidth + gap;
    final strideY = _cellHeight + gap;
    if (strideX <= 0 || strideY <= 0 || local.dx < 0 || local.dy < 0) {
      return null;
    }
    final col = (local.dx / strideX).floor();
    final row = (local.dy / strideY).floor();
    if (col < 0 || col > 2 || row < 0) return null;
    final index = row * 3 + col - 1;
    if (index < 0 || index >= widget.items.length) return null;
    return index;
  }

  void _onGridTap(Offset global) {
    if (_isDragging) return;
    final local = _localInGrid(global);
    if (local == null) return;
    final index = _itemIndexAt(local);
    if (index == null) return;
    widget.onItemTap?.call(widget.items[index]);
  }

  void _startDrag(Offset global) {
    final local = _localInGrid(global);
    if (local == null) return;
    final index = _itemIndexAt(local);
    if (index == null) return;
    setState(() {
      _dragFrom = index;
      _dragHover = index;
      _dragLocal = local;
    });
  }

  void _moveDrag(Offset global) {
    if (!_isDragging) return;
    final local = _localInGrid(global);
    if (local == null) return;
    setState(() {
      _dragLocal = local;
      _dragHover = _itemIndexAt(local) ?? _dragHover;
    });
  }

  void _endDrag() {
    if (_isDragging) {
      final next = _visualItems();
      setState(() {
        _dragFrom = null;
        _dragHover = null;
        _dragLocal = null;
      });
      widget.onReorder(next);
      return;
    }
    setState(() {
      _dragFrom = null;
      _dragHover = null;
      _dragLocal = null;
    });
  }
}
