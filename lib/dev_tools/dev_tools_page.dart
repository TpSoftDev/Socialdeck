/*-------------------- dev_tools_page.dart -----------------------*/
// Central page for all dev/test tools
// Accessible from the Profile page via the "Dev Tools" button
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- DevToolsPage -----------------------------//
class DevToolsPage extends ConsumerWidget {
  const DevToolsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.page,
              right: SDeckTopBarRight.none,
              title: 'Dev Tools',
            ),

            //------------------------ Test Buttons --------------------------//
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SDeckSolidButton(
                      text: 'Home Dev',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push(AppPaths.homeDevTools),
                    ),
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Decks Dev',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push(AppPaths.decksDevTools),
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
