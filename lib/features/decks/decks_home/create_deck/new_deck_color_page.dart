/*----------------------- new_deck_color_page.dart ---------------------------*/
// New Deck Color page — first step of the Create a Deck flow.
// User picks a color for their new deck, then continues to the next step.
// No bottom nav — navigated to from the Decks page via context.push().
//
// Preview uses SDeckPlayingCard until deckTarget is built.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//---------------------------- NewDeckColorPage -----------------------------//
class NewDeckColorPage extends StatefulWidget {
  const NewDeckColorPage({super.key});

  @override
  State<NewDeckColorPage> createState() => _NewDeckColorPageState();
}

class _NewDeckColorPageState extends State<NewDeckColorPage> {
  SDeckColorPickerColor _selected = SDeckColorPickerColor.brightCoral;

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.subpage,
              right: SDeckTopBarRight.none,
              title: 'New Deck',
            ),

            //------------------------ Main Content Area ---------------------//
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: SDeckSpace.margin16,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: SDeckSpace.gap16),

                    //------------------------ Deck Preview -------------------//
                    // Placeholder until deckTarget ships.
                    const SDeckPlayingCard(
                      size: SDeckPlayingCardSize.small,
                      shadow: SDeckPlayingCardShadow.medium,
                      state: SDeckPlayingCardState.default_,
                    ),
                    const SizedBox(height: SDeckSpace.gap6),
                    Text(
                      'Preview',
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: context.component.textTertiary,
                          ),
                    ),

                    const SizedBox(height: SDeckSpace.gap24),

                    //------------------------ Color Picker -------------------//
                    SDeckColorPicker(
                      selected: _selected,
                      onChanged: (color) {
                        setState(() => _selected = color);
                      },
                    ),
                    const SizedBox(height: SDeckSpace.gap8),
                    Text(
                      'Choose a color for your new deck.',
                      style:
                          Theme.of(context).textTheme.bodyMediumFigma.copyWith(
                                color: context.component.textSecondary,
                              ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: SDeckSpace.gap24),

                    //------------------------ Next Button --------------------//
                    SDeckSolidButton(
                      text: 'Next',
                      size: SDeckButtonSize.large,
                      fullWidth: true,
                      onPressed: () {
                        // Next step not wired yet.
                      },
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
