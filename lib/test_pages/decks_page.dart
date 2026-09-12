/*-------------------- decks_page.dart -----------------------*/
// Decks Page for the main app
// Displays a placeholder "Coming Soon!" message
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
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
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.logo,
              type: SDeckTopBarType.page,
              right: SDeckTopBarRight.icon,
              title: "Decks",
            ),

            //------------------------ Main Content Area ---------------------//
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SDeckSpace.padding16,
                      vertical: SDeckSpace.padding16,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SDeckSolidButton(
                            text: 'Test Empty Decks State',
                            size: SDeckButtonSize.medium,
                            fullWidth: false,
                            onPressed: () => context.push('/decks/Empty'),
                          ),
                          SizedBox(height: SDeckSpace.gap16),
                          SDeckSolidButton(
                            text: 'Test Create Deck',
                            size: SDeckButtonSize.medium,
                            fullWidth: false,
                            onPressed: () => context.push('/decks/Create'),
                          ),
                          SizedBox(height: SDeckSpace.gap16),
                          SDeckSolidButton(
                            text: 'Test Deck List View',
                            size: SDeckButtonSize.medium,
                            fullWidth: false,
                            onPressed: () => context.push('/decks/List'),
                          ),
                          SizedBox(height: SDeckSpace.gap16),
                          SDeckSolidButton(
                            text: 'Test Create Deck Bottom Sheet',
                            size: SDeckButtonSize.medium,
                            fullWidth: false,
                            onPressed: () => context.push('/decks/BottomSheet'),
                          ),
                          SizedBox(height: SDeckSpace.gap16),
                          SDeckSolidButton(
                            text: 'Test Add Cards Page',
                            size: SDeckButtonSize.medium,
                            fullWidth: false,
                            onPressed: () => context.push('/decks/AddCards'),
                          ),
                          SizedBox(height: SDeckSpace.gap16),
                          SDeckSolidButton(
                            text: 'Test Review Cards Page',
                            size: SDeckButtonSize.medium,
                            fullWidth: false,
                            onPressed: () => context.push('/decks/ReviewCards'),
                          ),
                          SizedBox(height: SDeckSpace.gap16),
                          SDeckSolidButton(
                            text: 'Test Deck Persistence (Save/Load)',
                            size: SDeckButtonSize.medium,
                            fullWidth: true,
                            onPressed: () => context.push('/decks/TestPersistence'),
                          ),
                          SizedBox(height: SDeckSpace.gap16),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: SDeckSpace.gap8,
                            runSpacing: SDeckSpace.gap8,
                            children: [
                              SDeckSolidButton(
                                text: 'Input Dialog',
                                size: SDeckButtonSize.medium,
                                fullWidth: false,
                                onPressed: () =>
                                    context.push(AppPaths.inputDialogTest),
                              ),
                              SDeckSolidButton(
                                text: 'Dialog',
                                size: SDeckButtonSize.medium,
                                fullWidth: false,
                                onPressed: () =>
                                    context.push(AppPaths.dialogTest),
                              ),
                              SDeckSolidButton(
                                text: 'Step dialog',
                                size: SDeckButtonSize.medium,
                                fullWidth: false,
                                onPressed: () =>
                                    context.push(AppPaths.stepDialogTest),
                              ),
                              SDeckSolidButton(
                                text: 'Home tutorial dialog',
                                size: SDeckButtonSize.medium,
                                fullWidth: false,
                                onPressed: () => context.push(
                                  AppPaths.homeTutorialStepDialogTest,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
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


