/*------------------------- quick_pics_page.dart -----------------------------*/
// Quick Pics page for the Decks feature.
// Displays the user's saved Quick Pics cards.
// No bottom nav — navigated to from the Decks page via context.push().
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- QuickPicsPage -----------------------------//
class QuickPicsPage extends StatelessWidget {
  const QuickPicsPage({super.key});

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
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
                      supportingText: "0/100",
                    ),

                    const SizedBox(height: SDeckSpace.gap12),

                    //------------------------ Add Target ---------------------//
                    SDeckAddTarget(
                      onTap: () => _showAddCardsSheet(context),
                    ),

                    const SizedBox(height: SDeckSpace.gap12),

                    //------------------- Call To Action ----------------------//
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
                ),
              ),
            ),
          ],
        ),
      ),
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
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            context.push(AppPaths.cameraRoll);
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
