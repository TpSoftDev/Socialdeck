/*-------------------- deck_details_page.dart -----------------------*/
// Deck Details Page for the Decks feature
// Placeholder for viewing a specific deck (to be implemented)
//
// User Journey: User taps a deck in Decks tab → Sees this page
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class TestCreateDeckPage extends StatelessWidget {
  const TestCreateDeckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.logoWithTitle(title: "Decks"),

            //------------------------ Main Content Area ---------------------//
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
