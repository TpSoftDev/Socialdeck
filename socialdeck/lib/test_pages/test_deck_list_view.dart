/*-------------------- test_deck_list_view.dart -----------------------*/
// Test Deck List View Page for the Decks feature
// Template for testing the deck list UI (to be implemented)
//
// User Journey: User sees list of their decks in Decks tab → Can interact with deck cards
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class TestDeckListViewPage extends StatelessWidget {
  const TestDeckListViewPage({super.key});

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
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: SDeckSpacing.x16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //------------------------ Graphic Placeholder ------------------------//
                    Container(
                      width: double.infinity,
                      height: 96,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(context.icons.checkeredBackground),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    //------------------------ Heading ------------------------//
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: SDeckSpacing.x8),
                      child: Text(
                        "All Decks",
                        style: Theme.of(context).textTheme.h6,
                      ),
                    ),

                    //------------------------ Grid ------------------------//
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // For iPhone SE width, use 3 columns per Figma mock
                        const int crossAxisCount = 3;
                        final double spacing = SDeckSpacing.x8.toDouble();
                        final double tileWidth =
                            (constraints.maxWidth -
                                (spacing * (crossAxisCount - 1))) /
                            crossAxisCount;
                        final double tileHeight =
                            tileWidth * 1.6; // match card aspect

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            // Add Deck tile
                            SizedBox(
                              width: tileWidth,
                              height: tileHeight,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    SDeckRadius.xxs,
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

                            // Placeholder deck cards (5)
                            for (int i = 0; i < 10; i++)
                              SizedBox(
                                width: tileWidth,
                                height: tileHeight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(
                                      SDeckRadius.xs,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.25),
                                        blurRadius: 4,
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: AssetImage(
                                        context.icons.checkeredBackground,
                                      ),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.35),
                                        BlendMode.srcATop,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(SDeckSpacing.x16),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Deck Title",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.copyWith(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimaryFixed,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: SDeckSpacing.x32,
                    ), // space for home indicator
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
