/*-------------------- promptd_dev_tools_page.dart -----------------------*/
// Nested Dev Tools page for Prompt'd game screens.
// Opened from Dev Tools via the "Prompt'd Dev" button.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- PromptDevToolsPage ---------------------------//
class PromptDevToolsPage extends StatelessWidget {
  const PromptDevToolsPage({super.key});

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
              title: "Prompt'd Dev",
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SDeckSolidButton(
                      text: 'Leaderboards',
                      size: SDeckButtonSize.medium,
                      fullWidth: true,
                      onPressed:
                          () =>
                              context.push(AppPaths.leaderboardsTournamentDev),
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

//------------------------- LeaderboardsTournamentDevPage --------------------//
/// Sandbox for leaderboard, tournament, and end-game components.
class LeaderboardsTournamentDevPage extends StatelessWidget {
  const LeaderboardsTournamentDevPage({super.key});

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
              title: 'Leaderboards',
            ),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
