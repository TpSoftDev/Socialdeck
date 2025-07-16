/*-------------------- deck_details_page.dart -----------------------*/
// Deck Details Page for the Decks feature
// Placeholder for viewing a specific deck (to be implemented)
//
// User Journey: User taps a deck in Decks tab → Sees this page
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class DeckDetailsPage extends StatelessWidget {
  final String deckId;
  const DeckDetailsPage({required this.deckId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.logoWithTitle(title: "Deck Details"),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Deck ID: $deckId",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Coming Soon!",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
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
