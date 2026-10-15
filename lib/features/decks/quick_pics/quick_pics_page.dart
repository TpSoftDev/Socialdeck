/*------------------------- quick_pics_page.dart -----------------------------*/
// Quick Pics page for the Decks feature.
// Empty until Camera Roll returns photos. Those paths stay on this page
// until a backend exists.
// No bottom nav — navigated to from the Decks page via context.push().
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- QuickPicsPage -----------------------------//
class QuickPicsPage extends StatefulWidget {
  const QuickPicsPage({super.key});

  @override
  State<QuickPicsPage> createState() => _QuickPicsPageState();
}

class _QuickPicsPageState extends State<QuickPicsPage> {
  // File paths handed back by Camera Roll. Order is the order they were saved.
  final List<String> _photoPaths = [];

  static const int _maxCards = 100;

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    final hasPhotos = _photoPaths.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.none,
              title: "Quick Pics",
            ),

            //------------------------ Main Content Area ---------------------//
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: SDeckSpace.margin16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //------------------------ All Cards Section --------------//
                    SDeckSectionHeader(
                      title: "All Cards",
                      supportingText: "${_photoPaths.length}/$_maxCards",
                    ),

                    const SizedBox(height: SDeckSpace.gap12),

                    //------------------------ Cards ---------------------------//
                    if (hasPhotos)
                      _buildPhotoGrid()
                    else ...[
                      SDeckAddTarget(
                        onTap: () => _showAddCardsSheet(context),
                      ),
                      const SizedBox(height: SDeckSpace.gap12),
                      _buildEmptyState(context),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Three slots per row, left to right. A fixed small card is just too wide
  // for three to fit on this phone, so each slot shares the row width.
  Widget _buildPhotoGrid() {
    const columns = 3;
    const gap = SDeckSpace.gap12;
    // Small playing card and addTarget share this shape: 116 by 156.
    const aspect = 116 / 156;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
        final cellHeight = cellWidth / aspect;

        Widget slot(Widget child) {
          return SizedBox(
            width: cellWidth,
            height: cellHeight,
            child: FittedBox(fit: BoxFit.fill, child: child),
          );
        }

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            slot(
              SDeckAddTarget(
                onTap: () => _showAddCardsSheet(context),
              ),
            ),
            for (final path in _photoPaths)
              slot(
                SDeckPlayingCard(
                  size: SDeckPlayingCardSize.small,
                  shadow: SDeckPlayingCardShadow.none,
                  imagePath: path,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 370 / 185,
          child: SDeckVisualPlaceholder(
            borderRadius: BorderRadius.circular(
              SDeckRadius.borderRadius16,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            "Save some cards for later!",
            style: Theme.of(context).textTheme.body.copyWith(
              color: context.component.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  //*************************** Private Methods *******************************//
  void _showAddCardsSheet(BuildContext context) {
    showSDeckBottomSheet(
      context: context,
      title: "Add Cards",
      buttons: [
        //-------------------- Shuffle Search Target -------------------------//
        SDeckImageTarget(
          title: 'Shuffle Search',
          description: 'Select from 16 random photos',
          onTap: () {},
        ),

        //-------------------- Camera Roll Button ---------------------------//
        SDeckSolidButton(
          text: 'Camera Roll',
          size: SDeckButtonSize.large,
          iconLocation: SDeckButtonIconLocation.left,
          iconTextGap: SDeckSpace.gap6,
          icon: SDeckIcons(
            SDeckIcon.grid,
            size: SDeckSize.size24,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            final picked = await context.push<List<String>>(AppPaths.cameraRoll);
            if (!mounted || picked == null || picked.isEmpty) return;
            setState(() => _photoPaths.addAll(picked));
          },
        ),

        //-------------------- Take a Photo Button --------------------------//
        SDeckOutlineButton(
          text: 'Take a Photo',
          size: SDeckButtonSize.large,
          iconLocation: SDeckButtonIconLocation.left,
          iconTextGap: SDeckSpace.gap6,
          icon: SDeckIcons(
            SDeckIcon.camera,
            size: SDeckSize.size24,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
