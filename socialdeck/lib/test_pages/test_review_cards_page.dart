/*-------------------- test_review_cards_page.dart -----------------------*/
// Test Review Cards Page for the Decks feature
// Shows selected photos in a deck management interface with action buttons
//
// User Journey: User taps 'Save' in Add Cards → Sees this page to review/manage cards
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class TestReviewCardsPage extends StatefulWidget {
  const TestReviewCardsPage({super.key, required this.selectedPhotos});

  final List<String> selectedPhotos;

  @override
  State<TestReviewCardsPage> createState() => _TestReviewCardsPageState();
}

class _TestReviewCardsPageState extends State<TestReviewCardsPage> {
  //*************************** Button Handlers ******************************//
  /// Handles Edit Cards button press
  void _onEditCardsPressed() {
    // TODO: Navigate to edit cards page
    print('Edit Cards pressed');
  }

  /// Handles Edit button press
  void _onEditPressed() {
    // TODO: Implement edit functionality
    print('Edit pressed');
  }

  /// Handles Delete button press
  void _onDeletePressed() {
    // TODO: Implement delete functionality
    print('Delete pressed');
  }

  /// Handles Settings button press
  void _onSettingsPressed() {
    // TODO: Implement settings functionality
    print('Settings pressed');
  }

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar.backWithTitleAndIcon(
              title: "supercooldeckname",
              onBackPressed: () => Navigator.pop(context),
              onActionPressed: _onSettingsPressed,
            ),

            //------------------------ Manage Deck Bar -----------------------//
            _buildManageDeckBar(context),

            //------------------------ Heading Section -----------------------//
            _buildHeadingSection(context),

            //------------------------ Main Content Area ---------------------//
            Expanded(child: _buildCardGrid(context)),
          ],
        ),
      ),
    );
  }

  //*************************** Helper Methods **********************************//

  //------------------------------- Heading Section --------------------------//
  /// Builds the heading section with "Cards" title
  Widget _buildHeadingSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Cards",
          style: Theme.of(
            context,
          ).textTheme.h6.copyWith(color: context.component.textPrimary),
        ),
      ),
    );
  }

  //------------------------------- Card Grid --------------------------------//
  /// Builds the card grid with add card button first, then selected photos
  Widget _buildCardGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 cards per row (from Figma)
          crossAxisSpacing: 16, // 16px spacing between cards (from Figma)
          mainAxisSpacing: 16,
          childAspectRatio: 0.7, // 112/160 = 0.7 aspect ratio
        ),
        itemCount: widget.selectedPhotos.length + 1, // +1 for add card button
        itemBuilder: (context, index) {
          if (index == 0) {
            // Add card button (first position)
            return _buildAddCardButton(context);
          } else {
            // Display selected photo (index - 1 because add card is at 0)
            return SDeckPlayingCard.small(
              imagePath: widget.selectedPhotos[index - 1],
              onTap: () => _onCardTapped(index - 1),
            );
          }
        },
      ),
    );
  }

  //------------------------------- Add Card Button --------------------------//
  /// Builds the add card button (first item in grid)
  Widget _buildAddCardButton(BuildContext context) {
    return GestureDetector(
      onTap: _onAddCardPressed,
      child: Container(
        width: 112,
        height: 160,
        padding: const EdgeInsets.all(10), // 10px padding as per Figma
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius2),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: context.semantic.secondaryVariant,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius2),
          ),
          child: Center(
            child: SDeckIcon(
              SDeckIcons
                  .placeholder, // TODO: vector35Alt missing - using placeholder
              width: 24,
              height: 24,
              color: context.semantic.secondaryVariant,
            ),
          ),
        ),
      ),
    );
  }

  //------------------------------- Card Tap Handler -------------------------//
  /// Handles card tap (for future functionality)
  void _onCardTapped(int index) {
    // TODO: Handle card tap (preview, edit, etc.)
    print('Card $index tapped');
  }

  //------------------------------- Add Card Handler -------------------------//
  /// Handles add card button press (for future functionality)
  void _onAddCardPressed() {
    // TODO: Navigate back to add cards page or show add card options
    print('Add card pressed');
  }

  //------------------------------- Manage Deck Bar --------------------------//
  /// Builds the manage deck bar with three action buttons
  Widget _buildManageDeckBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Edit Cards Button (Solid black with icon + text)
          Expanded(
            child: SDeckSolidButton(
              text: "Edit Cards",
              size: SDeckButtonSize.medium,
              shape: SDeckButtonShape.round,
              iconLocation: SDeckButtonIconLocation.left,
              icon: SDeckIcon.medium(
                SDeckIcons.cards,
                color: context.component.solidButtonIcon,
              ),
              onPressed: _onEditCardsPressed,
            ),
          ),

          const SizedBox(width: 8),

          // Edit Button (Hollow black with icon only)
          SDeckOutlineButton(
            iconLocation: SDeckButtonIconLocation.only,
            size: SDeckButtonSize.medium,
            shape: SDeckButtonShape.round,
            icon: SDeckIcon.medium(
              SDeckIcons.edit,
              color: context.component.iconPrimary,
            ),
            onPressed: _onEditPressed,
          ),

          const SizedBox(width: 8),

          // Delete Button (Hollow red with icon only)
          SDeckOutlineButton(
            iconLocation: SDeckButtonIconLocation.only,
            size: SDeckButtonSize.medium,
            shape: SDeckButtonShape.round,
            icon: SDeckIcon.medium(
              SDeckIcons.trash,
              color: context.semantic.error,
            ),
            onPressed: _onDeletePressed,
          ),
        ],
      ),
    );
  }
}
