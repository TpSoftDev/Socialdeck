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
                    SDeckSolidButton(
                      text: 'Test Empty Decks State',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/decks/Empty'),
                    ),
                    SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Create Deck',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/decks/Create'),
                    ),
                    SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Deck List View',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/decks/List'),
                    ),
                    SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Create Deck Bottom Sheet',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/decks/BottomSheet'),
                    ),
                    SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Add Cards Page',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/decks/AddCards'),
                    ),
                    SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Review Cards Page',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/decks/ReviewCards'),
                    ),
                    SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Test Deck Persistence (Save/Load)',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.push('/decks/TestPersistence'),
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

//Todo:
// - Decks Landing Page 
//- Create New Deck Bottom Sheet
//- Landing page inside deck 
// - bottom sheet inside deck
// - Edit Deck Bottom Sheet
// - Add Cards (Deck Creation)


