/*-------------------- party_dev_tools_page.dart -----------------------*/
// Nested Dev Tools page for party-related sandboxes.
// Opened from Dev Tools via the "Party Dev" button so Prompt Setup Host,
// Default Party, and Invite Sheet can be built without changing Home.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/presentation/party_home_controls.dart';

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
                      text: 'Live Party',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/dev/tools/party/live'),
                    ),
                    const SizedBox(height: 16),
                    const Text('Frontend previews'),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Invite Sheet (Player)',
                      size: SDeckButtonSize.medium,
                      onPressed: () =>
                          context.push(AppPaths.inviteSheetPlayerDev),
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

/// Reuse Home's real session and actions so tests exercise the same backend.
class LivePartyDevPage extends StatelessWidget {
  const LivePartyDevPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Live Party')),
    body: const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: PartyHomeControls(),
      ),
    ),
  );
}
