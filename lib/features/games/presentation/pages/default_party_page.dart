/*-------------------- default_party_page.dart -----------------------*/
// Isolated Default Party sandbox.
// Opened from Party Dev so party UI can be built without changing
// Home or In-Party Home.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- DefaultPartyPage -----------------------------//
class DefaultPartyPage extends StatelessWidget {
  const DefaultPartyPage({super.key});

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
              title: 'Default Party',
            ),
          ],
        ),
      ),
    );
  }
}
