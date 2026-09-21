/*-------------------- invite_sheet_page.dart -----------------------*/
// Isolated Invite Sheet sandbox.
// Opened from Party Dev so the invite sheet can be built without
// changing the live party or social flows.
//
// Assembled from existing design system components. Player avatars and the
// cards target use SDeckVisualPlaceholder until the Rive PlayerCard lands.
/*--------------------------------------------------------------------------*/

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- InviteSheetPage -----------------------------//
class InviteSheetPage extends StatelessWidget {
  const InviteSheetPage({super.key});

  /// Party capacity. The grid always renders this many slots.
  static const int _maxPlayers = 8;

  /// Slots per grid row, matching the Figma 4×2 layout.
  static const int _slotsPerRow = 4;

  /// Figma largeImageTarget height.
  static const double _cardsTargetHeight = 128.0;

  /// Figma topBar sticker slot height. Width follows the artwork's aspect ratio.
  static const double _stickerHeight = SDeckSize.size48;

  /// Figma lobbyHelper inner content width — keeps the chip row wrapping
  /// tightly instead of spanning the full screen.
  static const double _lobbyHelperWidth = 280.0;

  // TODO(backend): replace with the live party roster from the lobby provider.
  static const List<String> _players = <String>['ethan'];

  // TODO(backend): replace with the play styles chosen during party setup.
  static const List<(String, SDeckChipColor)> _playStyles =
      <(String, SDeckChipColor)>[
    ('Coworkers', SDeckChipColor.tangerine),
    ('Dark Humor', SDeckChipColor.mintGreen),
    ('Brainrot', SDeckChipColor.vibrantYellow),
  ];

  //*************************** Build ****************************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: context.semantic.surface,
      bottomNavigationBar: SDeckBottomNavBar(
        currentIndex: 0,
        // Sandbox only — tab switching stays disabled while this lives in Party Dev.
        onTap: (int _) {},
        items: SDeckBottomNavBar.defaultItems,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.page,
              right: SDeckTopBarRight.icon,
              centerWidget: Image.asset(
                SDeckIcon.promptdSticker,
                height: _stickerHeight,
                fit: BoxFit.contain,
              ),
              rightIcon: SDeckIcons(
                SDeckIcon.more,
                size: SDeckSize.size36,
                color: context.component.navigationIcon,
              ),
              // TODO(party): open the host party options menu.
              onRightPressed: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  SDeckSpace.margin16,
                  SDeckSpace.paddingZero,
                  SDeckSpace.margin16,
                  SDeckSpace.padding16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLobbyHelper(context),
                    const SizedBox(height: SDeckSpace.gap16),

                    //------------------- Players ------------------//
                    SDeckSectionHeader(
                      title: 'Players',
                      supportingText: '${_players.length}/$_maxPlayers',
                      padded: false,
                    ),
                    const SizedBox(height: SDeckSpace.gap12),
                    _buildPlayerGrid(context),
                    const SizedBox(height: SDeckSpace.gap16),

                    //------------------- Cards --------------------//
                    const SDeckSectionHeader(title: 'Cards', padded: false),
                    const SizedBox(height: SDeckSpace.gap12),
                    SDeckImageTarget(
                      title: 'Pick 7 Cards',
                      description: 'Choose from one or many decks.',
                      height: _cardsTargetHeight,
                      centerContent: true,
                      // TODO(party): push the deck / card selection flow.
                      onTap: () {},
                    ),
                    const SizedBox(height: SDeckSpace.gap16),

                    //------------------- Ready --------------------//
                    // Stays disabled until the host has picked their cards.
                    SDeckSolidButton(
                      text: 'Ready',
                      size: SDeckButtonSize.large,
                      fullWidth: true,
                      enabled: false,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //*************************** Lobby Helper *********************************//
  /// Figma lobbyHelper: caption over a centered, wrapping chip list.
  Widget _buildLobbyHelper(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _lobbyHelperWidth,
        child: Column(
          children: [
            Text(
              'You chose to play based on:',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: context.semantic.secondary,
                  ),
            ),
            const SizedBox(height: SDeckSpace.gap12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: SDeckSpace.gap4,
              runSpacing: SDeckSpace.gap4,
              children: <Widget>[
                for (final (String label, SDeckChipColor color) in _playStyles)
                  SDeckChip(label: label, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //*************************** Player Grid **********************************//
  /// Renders [_maxPlayers] slots: joined players first, then a single invite
  /// target in the next free slot, then empty placeholders for the remainder.
  /// The invite target disappears once the party is full.
  Widget _buildPlayerGrid(BuildContext context) {
    final List<Widget> slots = <Widget>[];
    for (int i = 0; i < _maxPlayers; i++) {
      if (i < _players.length) {
        slots.add(_PlayerSlot(username: _players[i]));
      } else if (i == _players.length) {
        // TODO(party): open invite by code or direct invite via Social.
        slots.add(_InviteSlot(onTap: () {}));
      } else {
        slots.add(const _EmptySlot());
      }
    }

    final List<Widget> rows = <Widget>[];
    for (int start = 0; start < slots.length; start += _slotsPerRow) {
      if (rows.isNotEmpty) {
        rows.add(const SizedBox(height: SDeckSpace.gap8));
      }
      rows.add(
        _buildSlotRow(
          slots.sublist(start, (start + _slotsPerRow).clamp(0, slots.length)),
        ),
      );
    }
    return Column(children: rows);
  }

  /// Equal-width slots aligned to the top so avatar rows line up even though
  /// only the player slot carries a username beneath it.
  Widget _buildSlotRow(List<Widget> slots) {
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < slots.length; i++) {
      if (i > 0) {
        children.add(const SizedBox(width: SDeckSpace.gap12));
      }
      children.add(Expanded(child: slots[i]));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

//=============================== _PlayerSlot =================================//
/// Figma playerBlockTarget, Player state: circular avatar + in-game name.
class _PlayerSlot extends StatelessWidget {
  const _PlayerSlot({required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TODO(party): swap for the Rive PlayerCard once rive is a dependency.
        AspectRatio(
          aspectRatio: 1,
          child: SDeckVisualPlaceholder(
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius999),
          ),
        ),
        const SizedBox(height: SDeckSpace.gap4),
        Text(
          username,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.footer.copyWith(
                color: context.component.selectionTargetTitleText,
              ),
        ),
      ],
    );
  }
}

//=============================== _InviteSlot =================================//
/// Figma addTarget: square plus target sized to one grid slot.
/// SDeckAddTarget is fixed at 116×156 for deck creation, so it cannot be
/// reused inside this grid.
class _InviteSlot extends StatelessWidget {
  const _InviteSlot({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(
      SDeckRadius.borderRadius48,
    );
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll<Color?>(
            Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: context.semantic.tertiary,
              borderRadius: radius,
              border: Border.all(
                color: context.component.selectionTargetBorder,
                width: SDeckSize.size4,
              ),
            ),
            child: Center(
              child: SDeckIcons(
                SDeckIcon.plus,
                size: SDeckSize.size48,
                color: context.component.iconTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//=============================== _EmptySlot ==================================//
/// Figma playerBlockTarget, Empty state: a dashed ring for an unclaimed seat.
class _EmptySlot extends StatelessWidget {
  const _EmptySlot();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _DashedRingPainter(
          color: context.semantic.tertiary,
          strokeWidth: SDeckSize.size4,
        ),
      ),
    );
  }
}

//============================ _DashedRingPainter =============================//
/// Paints a dashed circle inscribed in the given size. Painted rather than
/// shipped as an asset so the dashes stay evenly spaced at any cell width and
/// the ring picks up the theme color.
class _DashedRingPainter extends CustomPainter {
  const _DashedRingPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  /// Target arc lengths in logical pixels, before rounding to a whole number of
  /// dashes. Tuned against the Figma empty seat.
  static const double _dashLength = 12.0;
  static const double _gapLength = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Inset by half the stroke so the ring is not clipped by the bounds.
    final double radius =
        (math.min(size.width, size.height) - strokeWidth) / 2;
    if (radius <= 0) return;

    final Rect bounds = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );

    // Round to a whole number of dash+gap pairs so the ring closes evenly
    // instead of leaving a short dash where the sweep wraps around.
    const double pairLength = _dashLength + _gapLength;
    final int dashCount = math.max(
      1,
      (2 * math.pi * radius / pairLength).round(),
    );
    final double pairSweep = 2 * math.pi / dashCount;
    final double dashSweep = pairSweep * (_dashLength / pairLength);

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(bounds, i * pairSweep, dashSweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedRingPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
