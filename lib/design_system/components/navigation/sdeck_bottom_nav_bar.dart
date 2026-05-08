//--------------------------- sdeck_bottom_nav_bar.dart ----------------------//
// SDeckBottomNavBar — pixel-faithful port of Figma `bottomNavBar` (node
// 314:2819). Builds a row of evenly-spaced 36px icons inside a fade-gradient
// surface that dissolves softly into scrolling content above it.
//
// Public API kept stable for existing callers (e.g. `routes.dart`):
//   SDeckBottomNavBar(
//     currentIndex: int,
//     onTap: (int) => ...,
//     items: SDeckBottomNavBar.defaultItems,
//   )
//----------------------------------------------------------------------------//

//-------------------------------- imports -----------------------------------//
import 'package:flutter/material.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/spacing/index.dart';
import 'sdeck_nav_icon.dart';

//------------------------------- Navigation Item Model ---------------------//
/// Data model for a single navigation destination in [SDeckBottomNavBar].
/// [iconName] is matched (case-insensitive) by [SDeckNavIcon] to choose the
/// stroke/fill SVG pair (e.g. `home`, `players`, `cards`, `store`,
/// `settings`).
class SDeckNavItem {
  final String iconName;
  final String label;

  const SDeckNavItem({required this.iconName, required this.label});
}

//------------------------------- SDeckBottomNavBar -------------------------//
/// A theme-aware bottom navigation bar matching Figma `bottomNavBar` exactly:
/// 24px top / 16px bottom padding, no horizontal padding, five 36px icons
/// distributed via `space-around`, and a 12% fade-in gradient at the top edge
/// so content scrolling underneath dissolves softly into the bar.
class SDeckBottomNavBar extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  /// Currently selected item, zero-indexed. The matching item renders with
  /// its filled icon variant; all others render their stroke variant.
  final int currentIndex;

  /// Called with the tapped item's index. When null the bar is non-interactive.
  final ValueChanged<int>? onTap;

  /// Items to render, left-to-right. Use [defaultItems] for the canonical
  /// home-screen layout.
  final List<SDeckNavItem> items;

  /// When true (default) paints the Figma top-edge fade gradient. Disable on
  /// screens where the surface should be flat.
  final bool showTopFade;

  //------------------------------- Constructor ----------------------------//
  const SDeckBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.showTopFade = true,
  });

  //*************************** Default Items *******************************//

  /// Default navigation items matching Figma `bottomNavBar` (node 314:2819):
  /// Home, Players (friends icon), Cards (deck icon), Store, Settings.
  static const List<SDeckNavItem> defaultItems = <SDeckNavItem>[
    SDeckNavItem(iconName: 'home', label: 'Home'),
    SDeckNavItem(iconName: 'players', label: 'Players'),
    SDeckNavItem(iconName: 'cards', label: 'Cards'),
    SDeckNavItem(iconName: 'store', label: 'Store'),
    SDeckNavItem(iconName: 'settings', label: 'Settings'),
  ];

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    final Color surface = context.component.navigationSurface;

    // Vertical fade-in gradient: transparent at the top edge → solid by 12%
    // → solid at the bottom. Matches Figma `bg-gradient-to-b … via-12%`.
    final BoxDecoration decoration = showTopFade
        ? BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const <double>[0.0, 0.12, 1.0],
              colors: <Color>[
                surface.withValues(alpha: 0),
                surface,
                surface,
              ],
            ),
          )
        : BoxDecoration(color: surface);

    return DecoratedBox(
      decoration: decoration,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            SDeckSpace.paddingZero,
            SDeckSpace.padding24, // top 24
            SDeckSpace.paddingZero,
            SDeckSpace.padding16, // bottom 16
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              for (int i = 0; i < items.length; i++)
                _NavBarItem(
                  item: items[i],
                  isSelected: i == currentIndex,
                  onTap: onTap == null ? null : () => onTap!(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

//============================ _NavBarItem ===================================//
/// A single tappable bottom-nav destination: a 36px icon centered inside a
/// 48×48 tap target so the touch surface remains comfortable on mobile.
class _NavBarItem extends StatelessWidget {
  final SDeckNavItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius8),
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll<Color?>(Colors.transparent),
          child: SizedBox(
            width: SDeckSize.size48,
            height: SDeckSize.size48,
            child: Center(
              child: SDeckNavIcon.large(
                item.iconName,
                isSelected: isSelected,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
