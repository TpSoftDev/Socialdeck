/*------------------------ camera_roll_page.dart -----------------------------*/
// Camera Roll page for Quick Pics.
// Allows the user to select photos from their device to save as Quick Pics cards.
// No bottom nav — navigated to from Quick Pics via context.push().
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- CameraRollPage ----------------------------//
class CameraRollPage extends StatelessWidget {
  const CameraRollPage({super.key});

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
              title: "Camera Roll",
            ),

            //------------------------ Photo Grid (TODO) ---------------------//
            const Expanded(
              child: Center(
                child: SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
