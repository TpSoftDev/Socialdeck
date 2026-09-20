/*-------------------- party_dev_tools_page.dart -----------------------*/
// Nested Dev Tools page for party-related sandboxes.
// Opened from Dev Tools via the "Party Dev" button so Prompt Setup Host,
// Default Party, and Invite Sheet can be built without changing Home.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- PartyDevToolsPage -----------------------------//
class PartyDevToolsPage extends StatelessWidget {
  const PartyDevToolsPage({super.key});

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
              title: 'Party Dev',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SDeckSolidButton(
                      text: 'Prompt Setup Host',
                      size: SDeckButtonSize.medium,
                      onPressed: () =>
                          context.push(AppPaths.promptSetupHostDev),
                    ),
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Default Party',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push(AppPaths.defaultPartyDev),
                    ),
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Invite Sheet',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push(AppPaths.inviteSheetDev),
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
}
