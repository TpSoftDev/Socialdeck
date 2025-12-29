/*-------------------- test_create_deck_bottom_sheet.dart -----------------------*/
// Test Create Deck Bottom Sheet Page for the Decks feature
// Placeholder for testing the bottom sheet functionality
//
// User Journey: User taps 'Test Create Deck Bottom Sheet' in Decks tab → Sees this page
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class TestCreateDeckBottomSheetPage extends StatefulWidget {
  const TestCreateDeckBottomSheetPage({super.key});

  @override
  State<TestCreateDeckBottomSheetPage> createState() =>
      _TestCreateDeckBottomSheetPageState();
}

class _TestCreateDeckBottomSheetPageState
    extends State<TestCreateDeckBottomSheetPage> {
  final TextEditingController _deckNameController = TextEditingController();

  @override
  void dispose() {
    _deckNameController.dispose();
    super.dispose();
  }

  //------------------------ Bottom Sheet Method ------------------------//
  /// Shows the create deck bottom sheet with form inputs
  void _showCreateDeckBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => SDeckBottomSheet(
            title: "Create New Deck",
            onClosePressed: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(SDeckSpace.paddingM),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //------------------------ Name Label ------------------------//
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Name",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(height: SDeckSpace.gapXS),

                  //------------------------ Text Field ------------------------//
                  SDeckTextField.large(
                    placeholder: "Enter new deck name",
                    controller: _deckNameController,
                  ),

                  SizedBox(height: SDeckSpace.gapXS),

                  //------------------------ Continue Button ------------------------//
                  Center(
                    child: SDeckSolidButton.large(
                      fullWidth: true,
                      text: "Continue",
                      onPressed: () {
                        // TODO: Handle continue action
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.logoWithTitle(title: "Decks"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SDeckSpace.paddingM),
                child: Column(
                  children: [
                    //------------------------ Graphic Placeholder ------------------------//
                    Container(
                      width: 370,
                      height: 96,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(SDeckIcons.checkeredBackground),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    //------------------------ Heading Section ------------------------//
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SDeckSpace.paddingXS,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "All Decks",
                            style: Theme.of(context).textTheme.h6.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //------------------------ Add Deck Card ------------------------//
                    Center(
                      child: GestureDetector(
                        onTap: _showCreateDeckBottomSheet,
                        child: Container(
                          width: 112,
                          height: 160,
                          padding: const EdgeInsets.all(
                            10,
                          ), // 10px padding as per Figma
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              SDeckRadius.borderRadiusXXS,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.secondaryFixedDim,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(
                                SDeckRadius.borderRadiusXXS,
                              ),
                            ),
                            child: Center(
                              child: SDeckIcon(
                                SDeckIcons
                                    .placeholder, // TODO: vector35Alt missing - using placeholder
                                width: 24,
                                height: 24,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.secondaryFixedDim,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SDeckSpace.gapM),

                    //------------------------ Empty State Text ------------------------//
                    Column(
                      children: [
                        Text(
                          "You have no decks.",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Create a new deck above.",
                          style: Theme.of(context).textTheme.caption.copyWith(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryFixedVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
