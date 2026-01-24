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
                padding: EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //------------------------ Graphic Placeholder ------------------------//
                    Container(
                      width: double.infinity,
                      height: 96,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(SDeckIcon.checkeredBackground),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    //------------------------ Heading ------------------------//
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SDeckSpace.padding8,
                      ),
                      child: Text(
                        "All Decks",
                        style: Theme.of(context).textTheme.h6.copyWith(
                          color: context.component.textPrimary,
                        ),
                      ),
                    ),

                    //------------------------ Grid ------------------------//
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // For iPhone SE width, use 3 columns per Figma mock
                        const int crossAxisCount = 3;
                        final double spacing = SDeckSpace.gap8;
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
                                    SDeckRadius.borderRadius2,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: context.semantic.secondaryVariant,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      SDeckRadius.borderRadius2,
                                    ),
                                  ),
                                  child: Center(
                                    child: SDeckIcons(
                                      SDeckIcon
                                          .placeholder, // TODO: vector35Alt missing - using placeholder
                                      size: SDeckSize.size24,
                                      color: context.semantic.secondaryVariant,
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
                                    color: context.semantic.surface,
                                    borderRadius: BorderRadius.circular(
                                      SDeckRadius.borderRadius4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: context.semantic.primary
                                            .withOpacity(0.25),
                                        blurRadius: 4,
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: AssetImage(
                                        SDeckIcon.checkeredBackground,
                                      ),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        context.semantic.primary.withOpacity(
                                          0.35,
                                        ),
                                        BlendMode.srcATop,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      SDeckSpace.padding16,
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Deck Title",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.copyWith(
                                          color: context.semantic.onPrimary,
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
                      height: SDeckSpace.gap32,
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
