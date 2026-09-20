/*-------------------- prompt_setup_host_page.dart -----------------------*/
// Isolated Prompt Setup Host sandbox.
// Opened from Party Dev so the host flow can be built without changing
// Home or In-Party Home. Wire into the party card tap when it is ready.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- PromptSetupHostPage -----------------------------//
class PromptSetupHostPage extends StatelessWidget {
  const PromptSetupHostPage({super.key});

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
              title: 'Prompt Setup Host',
            ),
          ],
        ),
      ),
    );
  }
}
