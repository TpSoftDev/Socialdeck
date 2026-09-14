/*-------------------- decks_dev_tools_page.dart -----------------------*/
// Nested Dev Tools page for decks-related test routes.
// Opened from Dev Tools via the "Decks Dev" button.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- DecksDevToolsPage -----------------------------//
class DecksDevToolsPage extends StatelessWidget {
  const DecksDevToolsPage({super.key});

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
              title: 'Decks Dev',
            ),
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
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Create Deck',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/decks/create'),
                    ),
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Deck List View',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/decks/list'),
                    ),
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Create Deck Bottom Sheet',
                      size: SDeckButtonSize.medium,
                      onPressed: () =>
                          context.push('/test/decks/bottom-sheet'),
                    ),
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Add Cards Page',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/decks/add-cards'),
                    ),
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Review Cards Page',
                      size: SDeckButtonSize.medium,
                      onPressed: () =>
                          context.push('/test/decks/review-cards'),
                    ),
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Deck Persistence',
                      size: SDeckButtonSize.medium,
                      onPressed: () =>
                          context.push('/test/decks/persistence'),
                    ),
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Toast Test',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/toast'),
                    ),
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Playing Card Test',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/playing-card'),
                    ),
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Color Picker Test',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/color-picker'),
                    ),
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Deck Target Test',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/test/deck-target'),
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
