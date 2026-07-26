/*-------------------- decks_page.dart -----------------------*/
// Decks Page for the main app
// Main landing page for the Decks feature
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- DecksPage -----------------------------//
class DecksPage extends StatelessWidget {
  const DecksPage({super.key});

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.none,
              type: SDeckTopBarType.page,
              right: SDeckTopBarRight.profile,
              title: "Decks",
            ),

            //------------------------ Main Content Area ---------------------//
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: SDeckSpace.margin16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //------------------------ Quick Pics Banner --------------//
                    SDeckImageTarget(
                      title: 'Quick Pics',
                      description: 'Save cards to revisit or replay',
                      onTap: () => context.push(AppPaths.quickPics),
                    ),

                    const SizedBox(height: SDeckSpace.gap16),

                    //------------------------ All Decks Section --------------//
                    SDeckSectionHeader(
                      title: "All Decks",
                      supportingText: "0/2",
                    ),

                    const SizedBox(height: SDeckSpace.gap12),

                    //------------------------ Add Target ---------------------//
                    SDeckAddTarget(
                      onTap: () => context.push(AppPaths.newDeckColor),
                    ),

                    const SizedBox(height: SDeckSpace.gap12),

                    //------------------- Call TO Action ----------------------//
                    AspectRatio(
                      aspectRatio: 370 / 185,
                      child: SDeckVisualPlaceholder(
                        borderRadius: BorderRadius.circular(
                          SDeckRadius.borderRadius16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: Text(
                        "Create your first deck!",
                        style: Theme.of(context).textTheme.body.copyWith(
                          color: context.component.textSecondary,
                        ),
                      ),
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
