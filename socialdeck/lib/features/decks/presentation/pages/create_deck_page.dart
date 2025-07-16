/*-------------------- create_deck_page.dart -----------------------*/
// Create Deck Page for the Decks feature
// Placeholder for the deck creation flow (to be implemented)
//
// User Journey: User taps 'Create New Deck' in Decks tab → Sees this page
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class CreateDeckPage extends StatelessWidget {
  const CreateDeckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.logoWithTitle(title: "Create New Deck"),
            Expanded(
              child: Center(
                child: Text(
                  "Coming Soon!",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
