/*-------------------- dev_hub_page.dart -----------------------*/
// Central hub for all dev/test pages
// Accessible from the Profile page via the "Dev Tools" button
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- DevHubPage -----------------------------//
class DevHubPage extends ConsumerWidget {
  const DevHubPage({super.key});

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
              title: "Dev Hub",
            ),

            //------------------------ Test Buttons --------------------------//
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SDeckSolidButton(
                      text: 'Test Empty Decks State',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/decks/empty'),
                    ),
                    SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Create Deck',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/decks/create'),
                    ),
                    SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Deck List View',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/decks/list'),
                    ),
                    SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Create Deck Bottom Sheet',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/decks/bottom-sheet'),
                    ),
                    SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Add Cards Page',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/decks/add-cards'),
                    ),
                    SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Review Cards Page',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/decks/review-cards'),
                    ),
                    SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Deck Persistence (Save/Load)',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/decks/persistence'),
                    ),
                    SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Toast Test',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/toast'),
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
