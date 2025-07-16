/*-------------------- decks_page.dart -----------------------*/
// Decks Page for the main app
// Displays a placeholder "Coming Soon!" message
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- DecksPage -----------------------------//
/// DecksPage: Main page for the Decks tab
/// Shows a top navigation bar and a placeholder message
class DecksPage extends ConsumerStatefulWidget {
  const DecksPage({super.key});

  @override
  ConsumerState<DecksPage> createState() => _DecksPageState();
}

class _DecksPageState extends ConsumerState<DecksPage> {
  //*************************** State Variables ******************************//
  int _currentIndex = 2; // Decks tab is index 2

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar.logoWithTitle(title: "Decks"),

            //------------------------ Main Content Area ---------------------//
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SDeckSolidButton.medium(
                      text: 'Go to Create Deck',
                      onPressed: () => context.push('/decks/create'),
                    ),
                    SizedBox(height: 16),
                    SDeckSolidButton.medium(
                      text: 'Go to Deck Details (deckId: 123)',
                      onPressed: () => context.push('/decks/123'),
                    ),
                    SizedBox(height: 32),
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
