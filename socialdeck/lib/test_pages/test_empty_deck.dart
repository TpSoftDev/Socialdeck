/*-------------------- create_deck_page.dart -----------------------*/
// Create Deck Page for the Decks feature
// Placeholder for the deck creation flow (to be implemented)
//
// User Journey: User taps 'Create New Deck' in Decks tab → Sees this page
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

/*----------------------------- Test Empty Deck Page -------------------------*/
class TestEmptyDeckPage extends StatelessWidget {
  const TestEmptyDeckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.logoWithTitle(title: "Decks"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SDeckSpacing.x16),
                child: Column(
                  children: [
                    //------------------------ Graphic Placeholder ------------------------//
                    Container(
                      width: 370,
                      height: 96,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(context.icons.checkeredBackground),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    //------------------------ Heading Section ------------------------//
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: SDeckSpacing.x8),
                      child: Row(
                        children: [
                          Text(
                            "All Decks",
                            style: Theme.of(context).textTheme.h6,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: SDeckSpacing.x8),

                    //------------------------ Add Deck Card ------------------------//
                    Center(
                      child: Container(
                        width: 112,
                        height: 160,
                        padding: const EdgeInsets.all(
                          10,
                        ), // 10px padding as per Figma
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(SDeckRadius.xxs),
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
                              SDeckRadius.xxs,
                            ),
                          ),
                          child: Center(
                            child: SDeckIcon(
                              context.icons.vector35Alt,
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

                    SizedBox(height: SDeckSpacing.x16),

                    //------------------------ Empty State Text ------------------------//
                    Column(
                      children: [
                        Text(
                          "You have no decks.",
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Create a new deck above.",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                            color:Theme.of(context).colorScheme.onPrimaryFixedVariant,
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
