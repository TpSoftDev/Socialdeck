/*-------------------- invite_sheet_page.dart -----------------------*/
// Isolated Invite Sheet sandbox.
// Opened from Party Dev so the invite sheet can be built without
// changing the live party or social flows.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- InviteSheetPage -----------------------------//
class InviteSheetPage extends StatelessWidget {
  const InviteSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.page,
              right: SDeckTopBarRight.none,
              title: 'Invite Sheet',
            ),
          ],
        ),
      ),
    );
  }
}
